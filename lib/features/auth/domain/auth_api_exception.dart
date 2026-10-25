/// A structured failure returned by the Saath Khata auth API.
///
/// The backend exposes stable machine-readable error codes, so the UI can react
/// to the *kind* of failure instead of matching English prose:
///
///   OTP_INVALID            wrong code            → keep the input, allow retry
///   OTP_EXPIRED            no usable challenge   → clear input, ask for a new code
///   OTP_LOCKED             attempt budget spent  → clear input, ask for a new code
///   OTP_COOLDOWN           resend too soon       → wait `retryAfterSeconds`
///   OTP_RATE_LIMITED       hourly/daily/IP cap   → wait `retryAfterSeconds`
///   OTP_PROVIDER_*         provider trouble      → temporary service error
///   OTP_DISABLED           kill switch           → temporary service error
///   PHONE_VERIFICATION_REQUIRED  phone change needs OTP
///   INVALID_CREDENTIALS    wrong password        → input error, NOT a logout
class AuthApiException implements Exception {
  final String message;
  final String? code;
  final int? retryAfterSeconds;

  const AuthApiException(this.message, {this.code, this.retryAfterSeconds});

  bool get isOtpInvalid => code == 'OTP_INVALID';
  bool get isOtpExpired => code == 'OTP_EXPIRED';
  bool get isOtpLocked => code == 'OTP_LOCKED';
  bool get isOtpCooldown => code == 'OTP_COOLDOWN';
  bool get isOtpRateLimited => code == 'OTP_RATE_LIMITED';
  bool get isOtpVerifyInProgress => code == 'OTP_VERIFY_IN_PROGRESS';
  bool get isProviderUnavailable =>
      code == 'OTP_PROVIDER_UNAVAILABLE' ||
      code == 'OTP_PROVIDER_MISCONFIGURED' ||
      code == 'OTP_DISABLED';
  bool get isPhoneVerificationRequired => code == 'PHONE_VERIFICATION_REQUIRED';

  /// True when the user must request a fresh code before trying again.
  bool get requiresNewOtp => isOtpExpired || isOtpLocked;

  @override
  String toString() => message;
}
