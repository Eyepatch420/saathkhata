import 'package:equatable/equatable.dart';
import '../../data/models/user_model.dart';

abstract class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object?> get props => [];
}

class AuthInitial extends AuthState {
  const AuthInitial();
}

class AuthLoading extends AuthState {
  const AuthLoading();
}

class AuthAuthenticated extends AuthState {
  final UserModel user;
  const AuthAuthenticated(this.user);

  @override
  List<Object?> get props => [user];
}

class AuthUnauthenticated extends AuthState {
  const AuthUnauthenticated();
}

class AuthError extends AuthState {
  final String message;

  /// Stable server error code (e.g. `OTP_INVALID`, `OTP_LOCKED`), when the
  /// failure came from the API. UI decisions should key off this, not [message].
  final String? code;

  /// Present on rate-limited responses so the UI can show the real wait.
  final int? retryAfterSeconds;

  const AuthError(this.message, {this.code, this.retryAfterSeconds});

  @override
  List<Object?> get props => [message, code, retryAfterSeconds];
}

// OTP send succeeded — navigate to OTP input screen
class AuthOtpSent extends AuthState {
  final String phone;

  /// Server-authoritative cool-down before another send is allowed.
  final int resendAfterSeconds;

  /// How many digits the provider issued (UDO = 5). Drives the OTP input boxes.
  final int codeLength;

  const AuthOtpSent({
    required this.phone,
    this.resendAfterSeconds = 30,
    this.codeLength = 5,
  });

  @override
  List<Object?> get props => [phone, resendAfterSeconds, codeLength];
}

// OTP verified for a NEW user — navigate to ProfileSetupScreen with signupToken
class AuthOtpVerifiedNewUser extends AuthState {
  final String phone;
  final String signupToken;
  const AuthOtpVerifiedNewUser({required this.phone, required this.signupToken});

  @override
  List<Object?> get props => [phone, signupToken];
}
