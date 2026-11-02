import 'package:equatable/equatable.dart';
import 'upi_id_model.dart';

class StaffProfile extends Equatable {
  final String staffId;
  final String vendorId;
  final String? businessName;
  final String? businessCategory;
  final String? qrCodeUrl;

  const StaffProfile({
    required this.staffId,
    required this.vendorId,
    this.businessName,
    this.businessCategory,
    this.qrCodeUrl,
  });

  factory StaffProfile.fromJson(Map<String, dynamic> json) => StaffProfile(
        staffId: json['staffId'] as String,
        vendorId: json['vendorId'] as String,
        businessName: json['businessName'] as String?,
        businessCategory: json['businessCategory'] as String?,
        qrCodeUrl: json['qrCodeUrl'] as String?,
      );

  @override
  List<Object?> get props => [staffId, vendorId, businessName, businessCategory, qrCodeUrl];
}

class UserModel extends Equatable {
  final String id;
  final String name;
  final String email;
  final String role; // 'vendor' | 'customer'
  final String? mobile;
  final String? upiId; // customer single-UPI only; null for vendors
  final String? profilePhotoUrl;
  // Vendor-only fields (null for customers)
  final String? businessName;
  final String? businessCategory;
  final List<String> businessCategories;
  final String? businessAddress;
  final double? businessLatitude;
  final double? businessLongitude;
  final List<UpiIdModel>? upiIds; // vendor multi-UPI; null for customers
  // Customer-only fields (null for vendors)
  final double? customerLatitude;
  final double? customerLongitude;
  final String? customerAddress;
  // Staff-only fields (null for vendor/customer)
  final StaffProfile? staffProfile;

  const UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
    this.mobile,
    this.upiId,
    this.profilePhotoUrl,
    this.businessName,
    this.businessCategory,
    this.businessCategories = const [],
    this.businessAddress,
    this.businessLatitude,
    this.businessLongitude,
    this.upiIds,
    this.customerLatitude,
    this.customerLongitude,
    this.customerAddress,
    this.staffProfile,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    final vendorProfile = json['vendorProfile'] as Map<String, dynamic>?;
    final staffProfileRaw = json['staffProfile'] as Map<String, dynamic>?;
    final rawUpiIds = vendorProfile?['upiIds'] as List<dynamic>?;
    return UserModel(
      id: json['id'] as String,
      name: json['name'] as String,
      email: json['email'] as String? ?? '',
      role: json['role'] as String,
      mobile: json['mobile'] as String?,
      upiId: json['upiId'] as String?,
      profilePhotoUrl: json['profilePhotoUrl'] as String?,
      businessName: vendorProfile?['businessName'] as String?,
      businessCategory: vendorProfile?['businessCategory'] as String?,
      businessCategories: (vendorProfile?['businessCategories'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList() ?? const [],
      businessAddress: vendorProfile?['businessAddress'] as String?,
      businessLatitude: (vendorProfile?['businessLatitude'] as num?)?.toDouble(),
      businessLongitude: (vendorProfile?['businessLongitude'] as num?)?.toDouble(),
      upiIds: rawUpiIds
          ?.map((e) => UpiIdModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      customerLatitude: (json['customerLocation']?['latitude'] as num?)?.toDouble(),
      customerLongitude: (json['customerLocation']?['longitude'] as num?)?.toDouble(),
      customerAddress: json['customerLocation']?['address'] as String?,
      staffProfile: staffProfileRaw != null ? StaffProfile.fromJson(staffProfileRaw) : null,
    );
  }

  UserModel copyWith({
    String? name,
    String? mobile,
    String? upiId,
    String? profilePhotoUrl,
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
    StaffProfile? staffProfile,
  }) =>
      UserModel(
        id: id,
        email: email,
        role: role,
        name: name ?? this.name,
        mobile: mobile ?? this.mobile,
        upiId: upiId ?? this.upiId,
        profilePhotoUrl: profilePhotoUrl ?? this.profilePhotoUrl,
        businessName: businessName ?? this.businessName,
        businessCategory: businessCategory ?? this.businessCategory,
        businessCategories: businessCategories ?? this.businessCategories,
        businessAddress: businessAddress ?? this.businessAddress,
        businessLatitude: businessLatitude ?? this.businessLatitude,
        businessLongitude: businessLongitude ?? this.businessLongitude,
        upiIds: upiIds ?? this.upiIds,
        customerLatitude: customerLatitude ?? this.customerLatitude,
        customerLongitude: customerLongitude ?? this.customerLongitude,
        customerAddress: customerAddress ?? this.customerAddress,
        staffProfile: staffProfile ?? this.staffProfile,
      );

  bool get isVendor => role == 'vendor';
  bool get isStaff => role == 'staff';

  /// Business name for display — works for vendor (own) and staff (vendor they serve)
  String get effectiveBusinessName =>
      staffProfile?.businessName ?? businessName ?? name;

  UpiIdModel? get primaryUpiId =>
      upiIds?.firstWhere((u) => u.isPrimary, orElse: () => upiIds!.first);

  @override
  List<Object?> get props => [
        id, name, email, role, mobile, upiId, profilePhotoUrl,
        businessName, businessCategory, businessCategories, businessAddress,
        businessLatitude, businessLongitude, upiIds,
        customerLatitude, customerLongitude, customerAddress,
        staffProfile,
      ];
}
