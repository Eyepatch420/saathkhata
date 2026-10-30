import '../../data/models/auth_response_model.dart';
import '../../data/models/upi_id_model.dart';
import '../../data/models/user_model.dart';
import '../delete_account_blocked_exception.dart';
import '../otp_send_result.dart';

abstract class AuthRepository {
  // ─── OTP ──────────────────────────────────────────────────────────────────

  /// Requests an OTP. Returns the server-provided timing so the UI can drive a
  /// resend countdown that cannot be bypassed by changing the device clock.
  ///
  /// [deviceId] is an opaque per-install identity. When the same number is live on
  /// another device, it lets the server answer with a challenge for *this* device
  /// instead of replacing (or rejecting) the other one.
  Future<OtpSendResult> sendOtp({required String phone, String? deviceId});

  /// Verifies a code. [challengeId] identifies exactly which challenge is being
  /// settled, so concurrent sessions for one number cannot consume each other.
  Future<OtpVerifyResponseModel> verifyOtp({
    required String phone,
    required String otp,
    String? challengeId,
    String? deviceId,
  });

  // ─── Email signup (no OTP required) ──────────────────────────────────────

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
  });

  // ─── Email + password login ───────────────────────────────────────────────

  Future<AuthResponseModel> emailLogin({
    required String email,
    required String password,
    required String role,
  });

  // ─── Signup (OTP-based) ───────────────────────────────────────────────────

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
  });

  // ─── Session ──────────────────────────────────────────────────────────────

  Future<void> logout({required String refreshToken});

  /// Sends the delete-confirmation OTP to the account's own phone.
  /// Throws if the account has no phone on file (email-only accounts should
  /// prompt for their password instead and call [deleteAccount] directly).
  Future<void> sendDeleteAccountOtp();

  /// Permanently requests self-deletion. [confirmation] is the 6-digit OTP
  /// from [sendDeleteAccountOtp], or the account password for accounts with
  /// no phone on file. Throws [DeleteAccountBlockedException] if the account
  /// has unresolved obligations (outstanding balance, active staff, etc).
  Future<void> deleteAccount({required String confirmation});

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
  });
}
