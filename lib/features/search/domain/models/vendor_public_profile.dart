/// Full public profile returned by GET /search/vendors/:vendorId.
/// Includes UPI ID (for payment initiation) unlike the search list result.
class VendorPublicProfile {
  final String userId;
  final String name;
  final String? email;
  final String? profilePhotoUrl;
  final String? upiId;
  final String? businessName;
  final String? businessCategory;
  final String? businessAddress;

  const VendorPublicProfile({
    required this.userId,
    required this.name,
    this.email,
    this.profilePhotoUrl,
    this.upiId,
    this.businessName,
    this.businessCategory,
    this.businessAddress,
  });

  factory VendorPublicProfile.fromJson(Map<String, dynamic> json) {
    return VendorPublicProfile(
      userId: json['userId'] as String,
      name: json['name'] as String,
      email: json['email'] as String?,
      profilePhotoUrl: json['profilePhotoUrl'] as String?,
      upiId: json['upiId'] as String?,
      businessName: json['businessName'] as String?,
      businessCategory: json['businessCategory'] as String?,
      businessAddress: json['businessAddress'] as String?,
    );
  }

  String get displayName =>
      businessName?.isNotEmpty == true ? businessName! : name;

  String get avatarInitial =>
      displayName.isNotEmpty ? displayName[0].toUpperCase() : '?';
}
