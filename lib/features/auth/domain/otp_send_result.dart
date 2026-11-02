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

  /// The challenge this request refers to. Echoing it back on verify is what
  /// keeps two devices (or a re-entered number) from settling each other's code.
  final String? challengeId;

  /// True when no new SMS was sent because a usable challenge already existed —
  /// the user pressed Back, or another device triggered the code. The UI must
  /// navigate to the OTP screen instead of showing a cool-down error.
  final bool resumed;

  /// True when this challenge reuses the SMS delivered to another device.
  final bool adopted;

  const OtpSendResult({
    required this.expiresInSeconds,
    required this.resendAfterSeconds,
    this.codeLength = 5,
    this.challengeId,
    this.resumed = false,
    this.adopted = false,
  });

  factory OtpSendResult.fromJson(Map<String, dynamic> json) => OtpSendResult(
        expiresInSeconds: (json['expiresInSeconds'] as num?)?.toInt() ?? 300,
        // A minute is the product default; the server's value always wins.
        resendAfterSeconds: (json['resendAfterSeconds'] as num?)?.toInt() ?? 60,
        // Backend sends `codeLength`; older builds answered without it.
        codeLength: (json['codeLength'] as num?)?.toInt() ?? 5,
        challengeId: json['challengeId'] as String?,
        resumed: json['resumed'] as bool? ?? false,
        adopted: json['adopted'] as bool? ?? false,
      );
}
