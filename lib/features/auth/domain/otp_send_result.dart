/// Metadata returned by `POST /auth/otp/send`.
///
/// The response deliberately contains no OTP and no provider reference; only
/// the timing the UI needs to drive its resend countdown.
class OtpSendResult {
  /// How long the code stays valid.
  final int expiresInSeconds;

  /// Server-authoritative cool-down before another send is allowed.
  final int resendAfterSeconds;

  /// How many digits the provider issues (UDO issues 5). The OTP screen renders
  /// exactly this many boxes so a provider-side change needs no app release.
  final int codeLength;

  const OtpSendResult({
    required this.expiresInSeconds,
    required this.resendAfterSeconds,
    this.codeLength = 5,
  });

  factory OtpSendResult.fromJson(Map<String, dynamic> json) => OtpSendResult(
        expiresInSeconds: (json['expiresInSeconds'] as num?)?.toInt() ?? 300,
        resendAfterSeconds: (json['resendAfterSeconds'] as num?)?.toInt() ?? 30,
        // Backend sends `codeLength`; older builds answered without it.
        codeLength: (json['codeLength'] as num?)?.toInt() ?? 5,
      );
}
