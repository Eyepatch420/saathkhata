import 'dart:convert';
import 'dart:math';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../../features/auth/data/models/user_model.dart';
import '../../features/auth/data/models/upi_id_model.dart';

class StorageService {
  // Hive box for non-sensitive prefs (locale only)
  static const String _boxName = 'saath_khata_prefs';
  static const String _localeKey = 'app_locale';

  /// Stable, non-sensitive install identity for the OTP flow. It is *not* a
  /// credential: the server only uses it to tell one device from another when the
  /// same phone number is authenticating in two places at once.
  static const String _otpDeviceIdKey = 'otp_device_id';

  // Flutter Secure Storage keys
  static const String _accessTokenKey = 'access_token';
  static const String _refreshTokenKey = 'refresh_token';
  static const String _tokenExpiresAtKey = 'token_expires_at';
  static const String _onboardingSeenKey = 'has_seen_onboarding';

  // User profile keys
  static const String _userIdKey = 'user_id';
  static const String _userNameKey = 'user_name';
  static const String _userEmailKey = 'user_email';
  static const String _userRoleKey = 'user_role';
  static const String _userMobileKey = 'user_mobile';
  static const String _userUpiIdKey = 'user_upi_id';
  static const String _userProfilePhotoKey = 'user_profile_photo';
  // Vendor-only profile keys
  static const String _vendorBusinessNameKey = 'vendor_business_name';
  static const String _vendorBusinessCategoryKey = 'vendor_business_category';
  static const String _vendorBusinessAddressKey = 'vendor_business_address';
  static const String _vendorUpiIdsKey = 'vendor_upi_ids';
  static const String _staffProfileKey = 'staff_profile';

  late Box _box;
  final FlutterSecureStorage _secure = const FlutterSecureStorage(
    aOptions: AndroidOptions(encryptedSharedPreferences: true),
  );

  Future<void> init() async {
    await Hive.initFlutter();
    _box = await Hive.openBox(_boxName);
  }

  // ─── Locale (Hive) ─────────────────────────────────────────────────────────

  String? getLocale() => _box.get(_localeKey) as String?;
  Future<void> setLocale(String localeCode) => _box.put(_localeKey, localeCode);

  // ─── OTP device identity (Hive) ────────────────────────────────────────────

  /// Returns this install's OTP device id, creating it on first use.
  ///
  /// Generated with `Random.secure()` so two installs can never collide, and kept
  /// in Hive rather than secure storage because it is an identifier, not a secret.
  /// A failure here must never block authentication, so callers treat `null` as
  /// "unknown device" and the backend falls back to single-device behaviour.
  Future<String?> getOrCreateOtpDeviceId() async {
    final existing = _box.get(_otpDeviceIdKey) as String?;
    if (existing != null && existing.length >= 8) return existing;

    final random = Random.secure();
    final bytes = List<int>.generate(16, (_) => random.nextInt(256));
    final id = bytes.map((b) => b.toRadixString(16).padLeft(2, '0')).join();
    await _box.put(_otpDeviceIdKey, id);
    return id;
  }

  // ─── Onboarding flag ───────────────────────────────────────────────────────

  Future<bool> hasSeenOnboarding() async =>
      (await _secure.read(key: _onboardingSeenKey)) == 'true';

  Future<void> markOnboardingSeen() =>
      _secure.write(key: _onboardingSeenKey, value: 'true');

  // ─── JWT tokens ───────────────────────────────────────────────────────────

  Future<String?> getAccessToken() => _secure.read(key: _accessTokenKey);
  Future<String?> getRefreshToken() => _secure.read(key: _refreshTokenKey);

  Future<void> saveTokens({
    required String accessToken,
    required String refreshToken,
    required int expiresIn,
  }) async {
    final expiresAt =
        DateTime.now().millisecondsSinceEpoch + (expiresIn * 1000);
    await Future.wait([
      _secure.write(key: _accessTokenKey, value: accessToken),
      _secure.write(key: _refreshTokenKey, value: refreshToken),
      _secure.write(key: _tokenExpiresAtKey, value: expiresAt.toString()),
    ]);
  }

  Future<void> clearTokens() => Future.wait([
        _secure.delete(key: _accessTokenKey),
        _secure.delete(key: _refreshTokenKey),
        _secure.delete(key: _tokenExpiresAtKey),
      ]);

  // ─── User profile (full) ───────────────────────────────────────────────────

  /// Saves all profile fields from a [UserModel] into secure storage.
  Future<void> saveFullUser(UserModel user) async {
    final upiIdsJson = jsonEncode(
      (user.upiIds ?? [])
          .map((u) => {'id': u.id, 'upiId': u.upiId, 'isPrimary': u.isPrimary})
          .toList(),
    );
    await Future.wait([
      _secure.write(key: _userIdKey, value: user.id),
      _secure.write(key: _userNameKey, value: user.name),
      _secure.write(key: _userEmailKey, value: user.email),
      _secure.write(key: _userRoleKey, value: user.role),
      _secure.write(key: _userMobileKey, value: user.mobile ?? ''),
      _secure.write(key: _userUpiIdKey, value: user.upiId ?? ''),
      _secure.write(key: _userProfilePhotoKey, value: user.profilePhotoUrl ?? ''),
      _secure.write(key: _vendorBusinessNameKey, value: user.businessName ?? ''),
      _secure.write(key: _vendorBusinessCategoryKey, value: user.businessCategory ?? ''),
      _secure.write(key: _vendorBusinessAddressKey, value: user.businessAddress ?? ''),
      _secure.write(key: _vendorUpiIdsKey, value: upiIdsJson),
      _secure.write(
        key: _staffProfileKey,
        value: user.staffProfile == null
            ? ''
            : jsonEncode({
                'staffId': user.staffProfile!.staffId,
                'vendorId': user.staffProfile!.vendorId,
                'businessName': user.staffProfile!.businessName,
                'businessCategory': user.staffProfile!.businessCategory,
                'qrCodeUrl': user.staffProfile!.qrCodeUrl,
              }),
      ),
    ]);
  }

  /// Returns the stored [UserModel], or null if not logged in.
  Future<UserModel?> getStoredUser() async {
    final id = await _secure.read(key: _userIdKey);
    final role = await _secure.read(key: _userRoleKey);
    if (id == null || role == null) return null;

    String? nz(String? v) => (v == null || v.isEmpty) ? null : v;

    List<UpiIdModel>? upiIds;
    final upiIdsRaw = await _secure.read(key: _vendorUpiIdsKey);
    if (upiIdsRaw != null && upiIdsRaw.isNotEmpty) {
      try {
        final decoded = jsonDecode(upiIdsRaw) as List<dynamic>;
        upiIds = decoded
            .map((e) => UpiIdModel.fromJson(e as Map<String, dynamic>))
            .toList();
      } catch (_) {
        upiIds = null;
      }
    }

    StaffProfile? staffProfile;
    final staffRaw = await _secure.read(key: _staffProfileKey);
    if (staffRaw != null && staffRaw.isNotEmpty) {
      try {
        staffProfile =
            StaffProfile.fromJson(jsonDecode(staffRaw) as Map<String, dynamic>);
      } catch (_) {
        staffProfile = null;
      }
    }

    return UserModel(
      id: id,
      name: await _secure.read(key: _userNameKey) ?? '',
      email: nz(await _secure.read(key: _userEmailKey)) ?? '',
      role: role,
      mobile: nz(await _secure.read(key: _userMobileKey)),
      upiId: nz(await _secure.read(key: _userUpiIdKey)),
      profilePhotoUrl: nz(await _secure.read(key: _userProfilePhotoKey)),
      businessName: nz(await _secure.read(key: _vendorBusinessNameKey)),
      businessCategory: nz(await _secure.read(key: _vendorBusinessCategoryKey)),
      businessAddress: nz(await _secure.read(key: _vendorBusinessAddressKey)),
      upiIds: upiIds,
      staffProfile: staffProfile,
    );
  }

  // Convenience getters kept for backwards compat
  Future<String?> getUserRole() => _secure.read(key: _userRoleKey);
  Future<String?> getUserId() => _secure.read(key: _userIdKey);
  Future<String?> getUserName() => _secure.read(key: _userNameKey);
  Future<String?> getUserEmail() => _secure.read(key: _userEmailKey);

  Future<void> saveProfilePhotoUrl(String url) =>
      _secure.write(key: _userProfilePhotoKey, value: url);

  Future<void> clearUser() => Future.wait([
        _secure.delete(key: _userIdKey),
        _secure.delete(key: _userNameKey),
        _secure.delete(key: _userEmailKey),
        _secure.delete(key: _userRoleKey),
        _secure.delete(key: _userMobileKey),
        _secure.delete(key: _userUpiIdKey),
        _secure.delete(key: _userProfilePhotoKey),
        _secure.delete(key: _vendorBusinessNameKey),
        _secure.delete(key: _vendorBusinessCategoryKey),
        _secure.delete(key: _vendorBusinessAddressKey),
        _secure.delete(key: _vendorUpiIdsKey),
        _secure.delete(key: _staffProfileKey),
      ]);

  Future<void> clearAll() => Future.wait([clearTokens(), clearUser()]);
}
