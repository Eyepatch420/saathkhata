class VendorSearchResult {
  final String userId;
  final String name;
  final String? profilePhotoUrl;
  final String? upiId;
  final String? businessName;
  final String? businessCategory;
  final List<String> businessCategories;
  final String? businessAddress;

  const VendorSearchResult({
    required this.userId,
    required this.name,
    this.profilePhotoUrl,
    this.upiId,
    this.businessName,
    this.businessCategory,
    this.businessCategories = const [],
    this.businessAddress,
  });

  factory VendorSearchResult.fromJson(Map<String, dynamic> json) {
    return VendorSearchResult(
      userId: json['userId'] as String,
      name: json['name'] as String,
      profilePhotoUrl: json['profilePhotoUrl'] as String?,
      upiId: json['upiId'] as String?,
      businessName: json['businessName'] as String?,
      businessCategory: json['businessCategory'] as String?,
      businessCategories: (json['businessCategories'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList() ?? const [],
      businessAddress: json['businessAddress'] as String?,
    );
  }

  String get displayName =>
      businessName?.isNotEmpty == true ? businessName! : name;

  String get avatarInitial =>
      displayName.isNotEmpty ? displayName[0].toUpperCase() : '?';
}
