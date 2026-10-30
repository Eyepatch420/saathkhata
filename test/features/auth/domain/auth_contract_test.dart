import 'package:flutter_test/flutter_test.dart';
import 'package:saath_khata/features/auth/domain/auth_api_exception.dart';
import 'package:saath_khata/features/auth/domain/otp_send_result.dart';

/// Contract tests for the auth error/timing model.
///
/// The Flutter client must branch on the backend's stable error codes rather
/// than on message text, and must never treat an OTP failure as a session
/// expiry. These tests pin that contract down.
///
/// (This replaces the untouched Flutter counter template test, which asserted on
/// a widget tree that was never built and had been failing for that reason.)
void main() {
  group('AuthApiException', () {
    test('wrong OTP is a retryable input error, not a session problem', () {
      const e = AuthApiException('Incorrect OTP.', code: 'OTP_INVALID');
      expect(e.isOtpInvalid, isTrue);
      expect(e.requiresNewOtp, isFalse);
      expect(e.isProviderUnavailable, isFalse);
    });

    test('expired and locked challenges require a fresh code', () {
      expect(
        const AuthApiException('gone', code: 'OTP_EXPIRED').requiresNewOtp,
        isTrue,
      );
      expect(
        const AuthApiException('too many', code: 'OTP_LOCKED').requiresNewOtp,
        isTrue,
      );
    });

    test('a code redeemed on another device asks for a new one, with the window', () {
      const e = AuthApiException(
        'This code was already used on another device. Request a new one shortly.',
        code: 'OTP_ALREADY_USED',
        retryAfterSeconds: 42,
      );
      expect(e.isOtpAlreadyUsed, isTrue);
      expect(e.requiresNewOtp, isTrue);
      // Not a wrong code: the input must be cleared, not retried as-is.
      expect(e.isOtpInvalid, isFalse);
      // The server's cool-down drives the resend countdown.
      expect(e.retryAfterSeconds, 42);
    });

    test('provider/disabled failures are distinguishable from a wrong code', () {
      for (final code in [
        'OTP_PROVIDER_UNAVAILABLE',
        'OTP_PROVIDER_MISCONFIGURED',
        'OTP_DISABLED',
      ]) {
        final e = AuthApiException('temporary', code: code);
        expect(e.isProviderUnavailable, isTrue, reason: code);
        expect(e.isOtpInvalid, isFalse, reason: code);
      }
    });

    test('carries the server retry window for rate limits', () {
      const e = AuthApiException('wait', code: 'OTP_COOLDOWN', retryAfterSeconds: 27);
      expect(e.isOtpCooldown, isTrue);
      expect(e.retryAfterSeconds, 27);
    });

    test('a wrong current password is an input error', () {
      const e = AuthApiException('nope', code: 'INVALID_CREDENTIALS');
      expect(e.isOtpInvalid, isFalse);
      expect(e.isPhoneVerificationRequired, isFalse);
    });

    test('phone changes that need proof of ownership are flagged', () {
      const e = AuthApiException('verify', code: 'PHONE_VERIFICATION_REQUIRED');
      expect(e.isPhoneVerificationRequired, isTrue);
    });
  });

  group('OtpSendResult', () {
    test('parses the server timing', () {
      final result = OtpSendResult.fromJson({
        'sent': true,
        'expiresInSeconds': 300,
        'resendAfterSeconds': 30,
      });
      expect(result.expiresInSeconds, 300);
      expect(result.resendAfterSeconds, 30);
    });

    test('falls back to safe defaults when timing is omitted', () {
      final result = OtpSendResult.fromJson({'sent': true});
      expect(result.expiresInSeconds, 300);
      // A minute is the product resend cool-down when the server omits it.
      expect(result.resendAfterSeconds, 60);
    });

    test('carries the challenge identity and the resume flag', () {
      final result = OtpSendResult.fromJson({
        'sent': true,
        'expiresInSeconds': 240,
        'resendAfterSeconds': 31,
        'codeLength': 5,
        'challengeId': 'a3f1c2d4-0000-4000-8000-000000000001',
        'resumed': true,
        'adopted': true,
      });
      expect(result.challengeId, 'a3f1c2d4-0000-4000-8000-000000000001');
      expect(result.resumed, isTrue);
      expect(result.adopted, isTrue);
      // A resumed challenge keeps the *remaining* TTL, not a fresh one.
      expect(result.expiresInSeconds, 240);
    });

    test('a pre-challenge server response still yields a usable result', () {
      final result = OtpSendResult.fromJson({'sent': true, 'resendAfterSeconds': 60});
      expect(result.challengeId, isNull);
      expect(result.resumed, isFalse);
    });
  });
}
