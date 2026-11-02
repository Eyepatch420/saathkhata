import 'package:dio/dio.dart';
import '../../../../core/network/api_client.dart';
import '../../../../core/network/api_endpoints.dart';
import '../../../../core/utils/phone_utils.dart';
import '../../domain/auth_api_exception.dart';
import '../../domain/delete_account_blocked_exception.dart';
import '../../domain/otp_send_result.dart';
import '../../domain/repositories/auth_repository.dart';
import '../models/auth_response_model.dart';
import '../models/upi_id_model.dart';
import '../models/user_model.dart';

class AuthRepositoryImpl implements AuthRepository {
  final ApiClient _api;

  AuthRepositoryImpl(this._api);

  // ─── OTP ──────────────────────────────────────────────────────────────────

  @override
  Future<OtpSendResult> sendOtp({required String phone, String? deviceId}) async {
    // The backend accepts exactly 10 digits: never a `+91` prefix, a space or a
    // trunk zero. Normalising here makes every path (keyboard, deep link,
    // stored profile) produce the same request body.
    final normalized = normalizeIndianPhone(phone);
    try {
      final response = await _api.post(
        ApiEndpoints.sendOtp,
        data: {
          'phone': normalized,
          // Omitted entirely when unknown, so the payload stays identical to the
          // pre-challenge contract for a client that cannot supply one.
          if (deviceId != null && deviceId.isNotEmpty) 'deviceId': deviceId,
        },
      );
      return OtpSendResult.fromJson(ApiClient.extractData(response));
    } on DioException catch (e) {
      throw _mapDioError(e);
    }
  }

  @override
  Future<OtpVerifyResponseModel> verifyOtp({
    required String phone,
    required String otp,
    String? challengeId,
    String? deviceId,
  }) async {
    try {
      final response = await _api.post(
        ApiEndpoints.verifyOtp,
        data: {
          'phone': normalizeIndianPhone(phone),
          'otp': otp.trim(),
          if (challengeId != null && challengeId.isNotEmpty) 'challengeId': challengeId,
          if (deviceId != null && deviceId.isNotEmpty) 'deviceId': deviceId,
        },
      );
      return OtpVerifyResponseModel.fromJson(ApiClient.extractData(response));
    } on DioException catch (e) {
      throw _mapDioError(e);
    }
  }

  // ─── Email signup ─────────────────────────────────────────────────────────

  @override
  Future<AuthResponseModel> emailSignup({
    required String email,
    required String password,
    required String name,
    required String role,
    String? upiId,
    String? businessName,
    String? businessCategory,
    List<String>? businessCategories,
    String? businessAddress,
    double? customerLatitude,
    double? customerLongitude,
    String? customerAddress,
  }) async {
    final body = <String, dynamic>{
      'email': email,
      'password': password,
      'name': name,
      'role': role,
    };
    if (upiId != null && upiId.isNotEmpty) body['upiId'] = upiId;
    if (businessName != null && businessName.isNotEmpty) body['businessName'] = businessName;
    if (businessCategory != null) body['businessCategory'] = businessCategory;
    if (businessCategories != null) body['businessCategories'] = businessCategories;
    if (businessAddress != null && businessAddress.isNotEmpty) body['businessAddress'] = businessAddress;
    if (customerLatitude != null) body['customerLatitude'] = customerLatitude;
    if (customerLongitude != null) body['customerLongitude'] = customerLongitude;
    if (customerAddress != null) body['customerAddress'] = customerAddress;

    try {
      final response = await _api.post(ApiEndpoints.emailSignup, data: body);
      return AuthResponseModel.fromJson(ApiClient.extractData(response));
    } on DioException catch (e) {
      throw _mapDioError(e);
    }
  }

  // ─── Email + password login ───────────────────────────────────────────────

  @override
  Future<AuthResponseModel> emailLogin({
    required String email,
    required String password,
    required String role,
  }) async {
    try {
      final response = await _api.post(
        ApiEndpoints.emailLogin,
        data: {'email': email, 'password': password, 'role': role},
      );
      return AuthResponseModel.fromJson(ApiClient.extractData(response));
    } on DioException catch (e) {
      throw _mapDioError(e);
    }
  }

  // ─── Signup ───────────────────────────────────────────────────────────────

  @override
  Future<AuthResponseModel> signup({
    required String signupToken,
    required String name,
    required String role,
    String? email,
    String? upiId,
    String? businessName,
    String? businessCategory,
    List<String>? businessCategories,
    String? businessAddress,
    double? customerLatitude,
    double? customerLongitude,
    String? customerAddress,
  }) async {
    final body = <String, dynamic>{
      'signupToken': signupToken,
      'name': name,
      'role': role,
    };
    if (email != null && email.isNotEmpty) body['email'] = email;
    if (upiId != null && upiId.isNotEmpty) body['upiId'] = upiId;
    if (businessName != null && businessName.isNotEmpty) body['businessName'] = businessName;
    if (businessCategory != null) body['businessCategory'] = businessCategory;
    if (businessCategories != null) body['businessCategories'] = businessCategories;
    if (businessAddress != null && businessAddress.isNotEmpty) body['businessAddress'] = businessAddress;
    if (customerLatitude != null) body['customerLatitude'] = customerLatitude;
    if (customerLongitude != null) body['customerLongitude'] = customerLongitude;
    if (customerAddress != null) body['customerAddress'] = customerAddress;

    try {
      final response = await _api.post(ApiEndpoints.signup, data: body);
      return AuthResponseModel.fromJson(ApiClient.extractData(response));
    } on DioException catch (e) {
      throw _mapDioError(e);
    }
  }

  // ─── Session ──────────────────────────────────────────────────────────────

  @override
  Future<void> logout({required String refreshToken}) async {
    try {
      await _api.post(ApiEndpoints.logout, data: {'refreshToken': refreshToken});
    } on DioException catch (e) {
      throw _mapDioError(e);
    }
  }

  @override
  Future<void> sendDeleteAccountOtp() async {
    try {
      await _api.post(ApiEndpoints.deleteAccountOtp);
    } on DioException catch (e) {
      throw _mapDioError(e);
    }
  }

  @override
  Future<void> deleteAccount({required String confirmation}) async {
    try {
      await _api.delete(ApiEndpoints.deleteAccount, data: {'otp': confirmation});
    } on DioException catch (e) {
      final body = e.response?.data;
      if (e.response?.statusCode == 409 &&
          body is Map<String, dynamic> &&
          body['error'] == 'DELETE_ACCOUNT_BLOCKED') {
        final blockers = (body['blockers'] as List<dynamic>? ?? [])
            .map((b) => DeleteAccountBlocker.fromJson(b as Map<String, dynamic>))
            .toList();
        throw DeleteAccountBlockedException(blockers);
      }
      throw _mapDioError(e);
    }
  }

  @override
  Future<UserModel> updateProfile({
    String? name,
    String? mobile,
    String? upiId,
    String? businessName,
    String? businessCategory,
    List<String>? businessCategories,
    String? businessAddress,
    double? businessLatitude,
    double? businessLongitude,
    List<UpiIdModel>? upiIds,
    double? customerLatitude,
    double? customerLongitude,
    String? customerAddress,
  }) async {
    final body = <String, dynamic>{};
    if (name != null) body['name'] = name;
    if (mobile != null) body['mobile'] = mobile;
    if (upiId != null) body['upiId'] = upiId;
    if (businessName != null) body['businessName'] = businessName;
    if (businessCategory != null) body['businessCategory'] = businessCategory;
    if (businessCategories != null) body['businessCategories'] = businessCategories;
    if (businessAddress != null) body['businessAddress'] = businessAddress;
    if (businessLatitude != null) body['businessLatitude'] = businessLatitude;
    if (businessLongitude != null) body['businessLongitude'] = businessLongitude;
    if (upiIds != null) body['upiIds'] = upiIds.map((u) => u.toJson()).toList();
    if (customerLatitude != null) body['customerLatitude'] = customerLatitude;
    if (customerLongitude != null) body['customerLongitude'] = customerLongitude;
    if (customerAddress != null) body['customerAddress'] = customerAddress;

    try {
      final response = await _api.patch(ApiEndpoints.updateProfile, data: body);
      return UserModel.fromJson(ApiClient.extractData(response));
    } on DioException catch (e) {
      throw _mapDioError(e);
    }
  }

  /// Turns a Dio failure into a structured [AuthApiException].
  ///
  /// The backend's `error` code and additive `retryAfterSeconds` are preserved so
  /// callers never have to match English message strings.
  AuthApiException _mapDioError(DioException e) {
    final body = e.response?.data;
    if (body is Map<String, dynamic>) {
      return AuthApiException(
        body['message'] as String? ?? 'Something went wrong',
        code: body['error'] as String?,
        retryAfterSeconds: (body['retryAfterSeconds'] as num?)?.toInt(),
      );
    }

    switch (e.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return const AuthApiException(
          'The request timed out. Check your connection and try again.',
        );
      default:
        return AuthApiException(e.message ?? 'Network error');
    }
  }
}
