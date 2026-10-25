import 'dart:async';
import 'package:dio/dio.dart';
import '../services/storage_service.dart';
import '../utils/app_logger.dart';
import '../router/auth_state_notifier.dart';
import 'api_endpoints.dart';

// Keys that must never appear in logs
const _redactedKeys = {
  'password',
  'currentPassword',
  'newPassword',
  'otp',
  'token',
  'refreshToken',
  'accessToken',
  'Authorization',
  'apikey',
};

class ApiClient {
  late final Dio _dio;
  final StorageService _storage;
  final AuthStateNotifier _authStateNotifier;

  // Serialises token refresh: only one POST /auth/refresh in flight at a time.
  // Concurrent 401s wait on this future and reuse the single new token.
  bool _isRefreshing = false;
  Completer<String?>? _refreshCompleter;

  ApiClient(this._storage, this._authStateNotifier) {
    _dio = Dio(BaseOptions(
      baseUrl: ApiEndpoints.baseUrl,
      connectTimeout: const Duration(seconds: 15),
      receiveTimeout: const Duration(seconds: 15),
      headers: {'Content-Type': 'application/json'},
    ));

    _dio.interceptors
      ..add(InterceptorsWrapper(
        onRequest: _onRequest,
        onError: _onError,
      ))
      ..add(_LoggingInterceptor());
  }

  Future<void> _onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final token = await _storage.getAccessToken();
    if (token != null) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    handler.next(options);
  }

  Future<void> _onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    if (err.response?.statusCode != 401) {
      handler.next(err);
      return;
    }

    // Prevent the refresh call itself from re-triggering refresh on failure.
    if (err.requestOptions.path == ApiEndpoints.refresh) {
      await _storage.clearAll();
      _authStateNotifier.forceUnauthenticated();
      handler.next(err);
      return;
    }

    AppLogger.w('API', '401 on ${err.requestOptions.path} — attempting token refresh');

    final refreshToken = await _storage.getRefreshToken();
    if (refreshToken == null) {
      AppLogger.w('API', 'No refresh token stored — clearing session');
      await _storage.clearAll();
      _authStateNotifier.forceUnauthenticated();
      handler.next(err);
      return;
    }

    // If a refresh is already in flight, wait for it instead of firing another.
    if (_isRefreshing) {
      final newToken = await _refreshCompleter!.future;
      if (newToken == null) {
        handler.next(err);
        return;
      }
      err.requestOptions.headers['Authorization'] = 'Bearer $newToken';
      try {
        handler.resolve(await _dio.fetch(err.requestOptions));
      } catch (e) {
        handler.next(err);
      }
      return;
    }

    _isRefreshing = true;
    _refreshCompleter = Completer<String?>();

    try {
      final response = await _dio.post(
        ApiEndpoints.refresh,
        data: {'refreshToken': refreshToken},
        options: Options(headers: {'Authorization': null}),
      );

      final data = response.data['data'];
      final tokens = data['tokens'] as Map<String, dynamic>;

      await _storage.saveTokens(
        accessToken: tokens['accessToken'] as String,
        refreshToken: tokens['refreshToken'] as String,
        expiresIn: tokens['expiresIn'] as int,
      );

      final newToken = tokens['accessToken'] as String;
      _refreshCompleter!.complete(newToken);

      AppLogger.i('API', 'Token refreshed — retrying ${err.requestOptions.method} ${err.requestOptions.path}');
      err.requestOptions.headers['Authorization'] = 'Bearer $newToken';
      handler.resolve(await _dio.fetch(err.requestOptions));
    } catch (e) {
      AppLogger.e('API', 'Token refresh failed — clearing session', e);
      await _storage.clearAll();
      _authStateNotifier.forceUnauthenticated();
      _refreshCompleter!.complete(null);
      handler.next(err);
    } finally {
      _isRefreshing = false;
      _refreshCompleter = null;
    }
  }

  Future<Response<T>> get<T>(
    String path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) =>
      _dio.get<T>(path, queryParameters: queryParameters, options: options);

  Future<Response<T>> post<T>(
    String path, {
    dynamic data,
    Options? options,
  }) =>
      _dio.post<T>(path, data: data, options: options);

  Future<Response<T>> patch<T>(
    String path, {
    dynamic data,
    Options? options,
  }) =>
      _dio.patch<T>(path, data: data, options: options);

  Future<Response<T>> postFormData<T>(
    String path, {
    required FormData formData,
  }) =>
      _dio.post<T>(path, data: formData);

  Future<Response<T>> put<T>(
    String path, {
    dynamic data,
    Options? options,
  }) =>
      _dio.put<T>(path, data: data, options: options);

  Future<Response<T>> delete<T>(
    String path, {
    dynamic data,
    Options? options,
  }) =>
      _dio.delete<T>(path, data: data, options: options);

  /// Extract the nested `data` field from a successful response.
  static Map<String, dynamic> extractData(Response response) {
    return (response.data as Map<String, dynamic>)['data']
        as Map<String, dynamic>;
  }

  /// Extract the error message from a Dio error response.
  static String extractErrorMessage(DioException e) {
    final body = e.response?.data;
    if (body is Map<String, dynamic>) {
      return body['message'] as String? ?? 'Something went wrong';
    }
    return e.message ?? 'Network error';
  }
}

// ─── Logging interceptor ─────────────────────────────────────────────────────

class _LoggingInterceptor extends Interceptor {
  // Store request start time keyed by request hash
  final _timers = <int, DateTime>{};

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    _timers[options.hashCode] = DateTime.now();

    final body = _safeBody(options.data);
    final query = options.queryParameters.isNotEmpty
        ? '  query: ${options.queryParameters}'
        : '';
    AppLogger.v(
      'API',
      '→ ${options.method.padRight(6)} ${options.path}$query'
      '${body.isNotEmpty ? '\n        body: $body' : ''}',
    );

    handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    final ms = _elapsed(response.requestOptions);
    final status = response.statusCode ?? 0;
    AppLogger.i(
      'API',
      '← ${status.toString().padRight(3)}  ${response.requestOptions.path}  (${ms}ms)',
    );
    handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    final ms = _elapsed(err.requestOptions);
    final status = err.response?.statusCode ?? 0;
    final msg = ApiClient.extractErrorMessage(err);
    AppLogger.e(
      'API',
      '✗ ${status.toString().padRight(3)}  ${err.requestOptions.method} ${err.requestOptions.path}  (${ms}ms)  "$msg"',
    );
    handler.next(err);
  }

  int _elapsed(RequestOptions options) {
    final start = _timers.remove(options.hashCode);
    if (start == null) return 0;
    return DateTime.now().difference(start).inMilliseconds;
  }

  /// Returns a sanitised body string — redacts sensitive keys.
  String _safeBody(dynamic data) {
    if (data == null) return '';
    if (data is FormData) return '[multipart/form-data]';
    if (data is Map) {
      final safe = <String, dynamic>{};
      data.forEach((k, v) {
        safe[k.toString()] =
            _redactedKeys.contains(k.toString()) ? '[REDACTED]' : v;
      });
      return safe.toString();
    }
    return data.toString();
  }
}
