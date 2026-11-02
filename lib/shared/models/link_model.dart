import 'package:equatable/equatable.dart';

/// Compact user info embedded in link responses (backend: UserSummary)
class UserSummary extends Equatable {
  final String id;
  final String name;
  final String? mobile;
  final String? profilePhotoUrl;
  final String? upiId;

  const UserSummary({
    required this.id,
    required this.name,
    this.mobile,
    this.profilePhotoUrl,
    this.upiId,
  });

  factory UserSummary.fromJson(Map<String, dynamic> json) => UserSummary(
        id: json['id'] as String,
        name: json['name'] as String,
        mobile: json['mobile'] as String?,
        profilePhotoUrl: json['profilePhotoUrl'] as String?,
        upiId: json['upiId'] as String?,
      );

  @override
  List<Object?> get props => [id, name, mobile, profilePhotoUrl, upiId];
}

/// Vendor summary adds business fields on top of UserSummary
class VendorSummary extends UserSummary {
  final String? businessName;
  final String? businessCategory;
  final List<String>? businessCategories;

  const VendorSummary({
    required super.id,
    required super.name,
    super.mobile,
    super.profilePhotoUrl,
    super.upiId,
    this.businessName,
    this.businessCategory,
    this.businessCategories,
  });

  String? get primaryCategory =>
      businessCategories?.isNotEmpty == true ? businessCategories!.first : businessCategory;

  factory VendorSummary.fromJson(Map<String, dynamic> json) => VendorSummary(
        id: json['id'] as String,
        name: json['name'] as String,
        mobile: json['mobile'] as String?,
        profilePhotoUrl: json['profilePhotoUrl'] as String?,
        upiId: json['upiId'] as String?,
        businessName: json['businessName'] as String?,
        businessCategory: json['businessCategory'] as String?,
        businessCategories: (json['businessCategories'] as List<dynamic>?)
            ?.map((e) => e as String)
            .toList(),
      );

  @override
  List<Object?> get props => [
        ...super.props,
        businessName,
        businessCategory,
        businessCategories,
      ];
}

/// What a vendor sees in GET /api/v1/links/customers
class CustomerLinkItem extends Equatable {
  final String linkId;
  final double balance;

  /// Vendor's nickname for this customer. Null means use customer.name.
  final String? nickname;

  final UserSummary customer;
  final String createdAt;

  /// Membership tier this customer holds with the vendor, null if none.
  final int? tierLevel;
  final String? tierName;

  final String? defaultProduct;
  final String? defaultUnit;
  final double? defaultQty;
  final double? defaultPricePerUnit;

  const CustomerLinkItem({
    required this.linkId,
    required this.balance,
    this.nickname,
    required this.customer,
    required this.createdAt,
    this.tierLevel,
    this.tierName,
    this.defaultProduct,
    this.defaultUnit,
    this.defaultQty,
    this.defaultPricePerUnit,
  });

  /// The display name: nickname if set, otherwise the actual login name.
  String get displayName => nickname?.isNotEmpty == true ? nickname! : customer.name;

  /// The sub-label shown below the display name. Null if nickname is not set.
  String? get subName => nickname?.isNotEmpty == true ? customer.name : null;

  CustomerLinkItem copyWith({
    double? balance,
    String? nickname,
    int? tierLevel,
    String? tierName,
    String? defaultProduct,
    String? defaultUnit,
    double? defaultQty,
    double? defaultPricePerUnit,
    bool clearDefaultProduct = false,
    bool clearDefaultUnit = false,
    bool clearDefaultQty = false,
    bool clearDefaultPrice = false,
  }) =>
      CustomerLinkItem(
        linkId: linkId,
        balance: balance ?? this.balance,
        nickname: nickname ?? this.nickname,
        customer: customer,
        createdAt: createdAt,
        tierLevel: tierLevel ?? this.tierLevel,
        tierName: tierName ?? this.tierName,
        defaultProduct:
            clearDefaultProduct ? null : (defaultProduct ?? this.defaultProduct),
        defaultUnit: clearDefaultUnit ? null : (defaultUnit ?? this.defaultUnit),
        defaultQty: clearDefaultQty ? null : (defaultQty ?? this.defaultQty),
        defaultPricePerUnit: clearDefaultPrice
            ? null
            : (defaultPricePerUnit ?? this.defaultPricePerUnit),
      );

  factory CustomerLinkItem.fromJson(Map<String, dynamic> json) {
    final tier = json['tier'] as Map<String, dynamic>?;
    return CustomerLinkItem(
      linkId: json['linkId'] as String,
      balance: (json['balance'] as num? ?? 0).toDouble(),
      nickname: json['nickname'] as String?,
      customer: UserSummary.fromJson(json['customer'] as Map<String, dynamic>),
      createdAt: json['createdAt'] as String,
      tierLevel: (tier?['level'] as num?)?.toInt(),
      tierName: tier?['name'] as String?,
      defaultProduct: json['defaultProduct'] as String?,
      defaultUnit: json['defaultUnit'] as String?,
      defaultQty: (json['defaultQty'] as num?)?.toDouble(),
      defaultPricePerUnit: (json['defaultPricePerUnit'] as num?)?.toDouble(),
    );
  }

  @override
  List<Object?> get props => [
        linkId,
        balance,
        nickname,
        customer,
        createdAt,
        tierLevel,
        tierName,
        defaultProduct,
        defaultUnit,
        defaultQty,
        defaultPricePerUnit,
      ];
}

/// Response from POST /api/v1/links/remind-all
class RemindAllResult extends Equatable {
  final int queued;
  final int customersCount;

  const RemindAllResult({required this.queued, required this.customersCount});

  factory RemindAllResult.fromJson(Map<String, dynamic> json) => RemindAllResult(
        queued: json['queued'] as int,
        customersCount: json['customersCount'] as int? ?? json['queued'] as int,
      );

  @override
  List<Object?> get props => [queued, customersCount];
}

/// What a customer sees in GET /api/v1/links/vendors
class VendorLinkItem extends Equatable {
  final String linkId;
  final double balance;

  /// Customer's nickname for this vendor. Null means use vendor.name.
  final String? nickname;

  final VendorSummary vendor;
  final String createdAt;

  /// True when the customer has sent a request that the vendor hasn't accepted yet.
  final bool isPending;

  /// Customer's preference: when true, vendor credit entries on this link are auto-confirmed.
  final bool customerAutoConfirm;

  const VendorLinkItem({
    required this.linkId,
    required this.balance,
    this.nickname,
    required this.vendor,
    required this.createdAt,
    this.isPending = false,
    this.customerAutoConfirm = true,
  });

  /// The display name: nickname if set, otherwise the business/login name.
  String get displayName =>
      nickname?.isNotEmpty == true ? nickname! : (vendor.businessName ?? vendor.name);

  /// The sub-label shown below the display name. Null if nickname is not set.
  String? get subName =>
      nickname?.isNotEmpty == true ? (vendor.businessName ?? vendor.name) : null;

  VendorLinkItem copyWith({bool? customerAutoConfirm}) => VendorLinkItem(
        linkId: linkId,
        balance: balance,
        nickname: nickname,
        vendor: vendor,
        createdAt: createdAt,
        isPending: isPending,
        customerAutoConfirm: customerAutoConfirm ?? this.customerAutoConfirm,
      );

  factory VendorLinkItem.fromJson(Map<String, dynamic> json) => VendorLinkItem(
        linkId: json['linkId'] as String,
        balance: (json['balance'] as num? ?? 0).toDouble(),
        nickname: json['nickname'] as String?,
        vendor: VendorSummary.fromJson(json['vendor'] as Map<String, dynamic>),
        createdAt: json['createdAt'] as String,
        isPending: json['isPending'] as bool? ?? false,
        customerAutoConfirm: json['customerAutoConfirm'] as bool? ?? true,
      );

  @override
  List<Object?> get props => [linkId, balance, nickname, vendor, createdAt, isPending, customerAutoConfirm];
}
