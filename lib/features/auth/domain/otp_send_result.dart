/// Metadata returned by `POST /auth/otp/send`.
///
/// The response deliberately contains no OTP and no provider reference; only
/// the timing the UI needs to drive its resend countdown.
class OtpSendResult {
  /// How long the code stays valid.
  final int expiresInSeconds;

  /// Server-authoritative cool-down before another send is allowed.
  final int resendAfterSeconds;

  const OtpSendResult({
    required this.expiresInSeconds,
    required this.resendAfterSeconds,
  });

  factory OtpSendResult.fromJson(Map<String, dynamic> json) => OtpSendResult(
        expiresInSeconds: (json['expiresInSeconds'] as num?)?.toInt() ?? 300,
        resendAfterSeconds: (json['resendAfterSeconds'] as num?)?.toInt() ?? 30,
      );
}
