import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/di/injection.dart';
import '../../../../core/services/storage_service.dart';
import '../../../../core/services/ledger_socket_service.dart';
import '../../../../core/services/push_notification_service.dart';
import '../../../../core/utils/app_logger.dart';
import '../../../../core/utils/phone_utils.dart';
import '../../../notifications/presentation/bloc/notification_bloc.dart';
import '../../../notifications/presentation/bloc/notification_event.dart';
import '../../domain/auth_api_exception.dart';
import '../../domain/repositories/auth_repository.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository _authRepository;
  final StorageService _storage;

  static const _m = 'Auth';

  AuthBloc({
    required AuthRepository authRepository,
    required StorageService storage,
  })  : _authRepository = authRepository,
        _storage = storage,
        super(const AuthInitial()) {
    on<AuthCheckStatusRequested>(_onCheckStatus);
    on<AuthOtpSendRequested>(_onOtpSend);
    on<AuthOtpVerifyRequested>(_onOtpVerify);
    on<AuthEmailLoginRequested>(_onEmailLogin);
    on<AuthEmailSignupRequested>(_onEmailSignup);
    on<AuthSignupRequested>(_onSignup);
    on<AuthLogoutRequested>(_onLogout);
    on<AuthProfileUpdateRequested>(_onUpdateProfile);
    on<AuthUserUpdated>(_onUserUpdated);
    on<AuthDeleteAccountRequested>(_onDeleteAccount);
  }

  /// Builds a UI error state, preserving the server's stable error code so the
  /// screens can react to the kind of failure instead of matching prose.
  AuthError _errorState(Object error) {
    if (error is AuthApiException) {
      return AuthError(
        error.message,
        code: error.code,
        retryAfterSeconds: error.retryAfterSeconds,
      );
    }
    return AuthError(error.toString().replaceFirst('Exception: ', ''));
  }

  Future<void> _onCheckStatus(
    AuthCheckStatusRequested event,
    Emitter<AuthState> emit,
  ) async {
    AppLogger.i(_m, 'Checking stored session...');
    emit(const AuthLoading());
    try {
      final user = await _storage.getStoredUser();
      if (user != null) {
        AppLogger.i(_m, 'Session restored — ${user.mobile} (${user.role})');
        final accessToken = await _storage.getAccessToken();
        if (accessToken != null) {
          getIt<LedgerSocketService>().connect(accessToken);
          await getIt<PushNotificationService>().initialize();
          getIt<NotificationBloc>().add(LoadUnreadCount());
        }
        emit(AuthAuthenticated(user));
      } else {
        AppLogger.i(_m, 'No stored session — unauthenticated');
        emit(const AuthUnauthenticated());
      }
    } catch (e) {
      AppLogger.e(_m, 'Session check failed', e);
      emit(const AuthUnauthenticated());
    }
  }

  Future<void> _onEmailSignup(
    AuthEmailSignupRequested event,
    Emitter<AuthState> emit,
  ) async {
    AppLogger.i(_m, 'Email signup: ${event.email} as ${event.role}');
    emit(const AuthLoading());
    try {
      final result = await _authRepository.emailSignup(
        email: event.email,
        password: event.password,
        name: event.name,
        role: event.role,
        upiId: event.upiId,
        businessName: event.businessName,
        businessCategory: event.businessCategory,
        businessCategories: event.businessCategories,
        businessAddress: event.businessAddress,
        customerLatitude: event.customerLatitude,
        customerLongitude: event.customerLongitude,
        customerAddress: event.customerAddress,
      );
      await _storage.saveTokens(
        accessToken: result.tokens.accessToken,
        refreshToken: result.tokens.refreshToken,
        expiresIn: result.tokens.expiresIn,
      );
      await _storage.saveFullUser(result.user);
      AppLogger.i(_m, 'Email signup success — ${result.user.email} (${result.user.role})');
      getIt<LedgerSocketService>().connect(result.tokens.accessToken);
      await getIt<PushNotificationService>().initialize();
      getIt<NotificationBloc>().add(LoadUnreadCount());
      emit(AuthAuthenticated(result.user));
    } catch (e) {
      AppLogger.e(_m, 'Email signup failed', e);
      emit(_errorState(e));
    }
  }

  Future<void> _onEmailLogin(
    AuthEmailLoginRequested event,
    Emitter<AuthState> emit,
  ) async {
    AppLogger.i(_m, 'Email login: ${event.email}');
    emit(const AuthLoading());
    try {
      final result = await _authRepository.emailLogin(
        email: event.email,
        password: event.password,
        role: event.role,
      );
      final user = result.user;
      final isStaffLoggingInAsVendor =
          user.role == 'staff' && event.role == 'vendor';
      if (!isStaffLoggingInAsVendor && user.role != event.role) {
        AppLogger.w(_m, 'Role mismatch: expected ${event.role}, got ${user.role}');
        emit(AuthError(
          'This email is registered as a ${user.role}. '
          'Please go back and select the correct role.',
        ));
        return;
      }
      await _storage.saveTokens(
        accessToken: result.tokens.accessToken,
        refreshToken: result.tokens.refreshToken,
        expiresIn: result.tokens.expiresIn,
      );
      await _storage.saveFullUser(user);
      AppLogger.i(_m, 'Email login — ${user.mobile} (${user.role})');
      getIt<LedgerSocketService>().connect(result.tokens.accessToken);
      await getIt<PushNotificationService>().initialize();
      getIt<NotificationBloc>().add(LoadUnreadCount());
      emit(AuthAuthenticated(user));
    } catch (e) {
      AppLogger.e(_m, 'Email login failed', e);
      emit(_errorState(e));
    }
  }

  Future<void> _onOtpSend(
    AuthOtpSendRequested event,
    Emitter<AuthState> emit,
  ) async {
    // Defence in depth: no caller may put a country code, spaces or a trunk
    // zero on the wire — the backend only accepts the canonical 10 digits.
    final phone = normalizeIndianPhone(event.phone);
    AppLogger.i(_m, 'OTP send (${event.origin.name}) to $phone');
    emit(const AuthLoading());
    try {
      final result = await _authRepository.sendOtp(phone: phone);
      emit(AuthOtpSent(
        phone: phone,
        resendAfterSeconds: result.resendAfterSeconds,
        codeLength: result.codeLength,
        origin: event.origin,
      ));
    } catch (e) {
      AppLogger.e(_m, 'OTP send failed', e);
      emit(_errorState(e));
    }
  }

  Future<void> _onOtpVerify(
    AuthOtpVerifyRequested event,
    Emitter<AuthState> emit,
  ) async {
    AppLogger.i(_m, 'OTP verify: ${event.phone}');
    emit(const AuthLoading());
    try {
      final result = await _authRepository.verifyOtp(
        phone: event.phone,
        otp: event.otp,
      );

      if (result.existingUser) {
        final user = result.user!;
        // Staff accounts log in via the vendor role-selection path since there
        // is no dedicated staff option on the role screen. Skip the mismatch
        // check for them; the router will send them to staffHome automatically.
        final isStaffLoggingInAsVendor =
            user.role == 'staff' && event.role == 'vendor';
        if (!isStaffLoggingInAsVendor && user.role != event.role) {
          AppLogger.w(_m, 'Role mismatch: expected ${event.role}, got ${user.role}');
          emit(AuthError(
            'This number is registered as a ${user.role}. '
            'Please go back and select the correct role.',
          ));
          return;
        }
        await _storage.saveTokens(
          accessToken: result.tokens!.accessToken,
          refreshToken: result.tokens!.refreshToken,
          expiresIn: result.tokens!.expiresIn,
        );
        await _storage.saveFullUser(user);
        AppLogger.i(_m, 'OTP login — ${user.mobile} (${user.role})');
        getIt<LedgerSocketService>().connect(result.tokens!.accessToken);
        await getIt<PushNotificationService>().initialize();
        getIt<NotificationBloc>().add(LoadUnreadCount());
        emit(AuthAuthenticated(user));
      } else {
        AppLogger.i(_m, 'OTP verified — new user, go to signup');
        emit(AuthOtpVerifiedNewUser(
          phone: event.phone,
          signupToken: result.signupToken!,
        ));
      }
    } catch (e) {
      AppLogger.e(_m, 'OTP verify failed', e);
      emit(_errorState(e));
    }
  }

  Future<void> _onSignup(
    AuthSignupRequested event,
    Emitter<AuthState> emit,
  ) async {
    AppLogger.i(_m, 'Signup attempt as ${event.role}');
    emit(const AuthLoading());
    try {
      final result = await _authRepository.signup(
        signupToken: event.signupToken,
        name: event.name,
        role: event.role,
        email: event.email,
        upiId: event.upiId,
        businessName: event.businessName,
        businessCategory: event.businessCategory,
        businessCategories: event.businessCategories,
        businessAddress: event.businessAddress,
        customerLatitude: event.customerLatitude,
        customerLongitude: event.customerLongitude,
        customerAddress: event.customerAddress,
      );

      await _storage.saveTokens(
        accessToken: result.tokens.accessToken,
        refreshToken: result.tokens.refreshToken,
        expiresIn: result.tokens.expiresIn,
      );
      await _storage.saveFullUser(result.user);
      AppLogger.i(_m, 'Signup success — ${result.user.mobile} id:${result.user.id}');
      getIt<LedgerSocketService>().connect(result.tokens.accessToken);
      await getIt<PushNotificationService>().initialize();
      getIt<NotificationBloc>().add(LoadUnreadCount());
      emit(AuthAuthenticated(result.user));
    } catch (e) {
      AppLogger.e(_m, 'Signup failed', e);
      emit(_errorState(e));
    }
  }

  Future<void> _onLogout(
    AuthLogoutRequested event,
    Emitter<AuthState> emit,
  ) async {
    AppLogger.i(_m, 'Logout requested');
    try {
      final refreshToken = await _storage.getRefreshToken();
      if (refreshToken != null) {
        await _authRepository.logout(refreshToken: refreshToken);
        AppLogger.i(_m, 'Server session revoked');
      }
    } catch (e) {
      AppLogger.w(_m, 'Server logout failed (continuing anyway)',);
    } finally {
      await _storage.clearAll();
      getIt<LedgerSocketService>().disconnect();
      AppLogger.i(_m, 'Local session cleared — unauthenticated');
      emit(const AuthUnauthenticated());
    }
  }

  Future<void> _onUserUpdated(
    AuthUserUpdated event,
    Emitter<AuthState> emit,
  ) async {
    await _storage.saveFullUser(event.user);
    emit(AuthAuthenticated(event.user));
  }

  Future<void> _onDeleteAccount(
    AuthDeleteAccountRequested event,
    Emitter<AuthState> emit,
  ) async {
    // The server-side deletion already happened (see DeleteAccountFlow) —
    // this just clears the local session now that it's confirmed deleted.
    AppLogger.i(_m, 'Clearing local session after confirmed account deletion');
    await _storage.clearAll();
    getIt<LedgerSocketService>().disconnect();
    emit(const AuthUnauthenticated());
  }

  Future<void> _onUpdateProfile(
    AuthProfileUpdateRequested event,
    Emitter<AuthState> emit,
  ) async {
    AppLogger.i(_m, 'Profile update requested');
    emit(const AuthLoading());
    try {
      final updated = await _authRepository.updateProfile(
        name: event.name,
        mobile: event.mobile,
        upiId: event.upiId,
        businessName: event.businessName,
        businessCategory: event.businessCategory,
        businessCategories: event.businessCategories,
        businessAddress: event.businessAddress,
        customerLatitude: event.customerLatitude,
        customerLongitude: event.customerLongitude,
        customerAddress: event.customerAddress,
      );
      await _storage.saveFullUser(updated);
      AppLogger.i(_m, 'Profile updated — name:${updated.name}');
      emit(AuthAuthenticated(updated));
    } catch (e) {
      AppLogger.e(_m, 'Profile update failed', e);
      emit(_errorState(e));
    }
  }
}
