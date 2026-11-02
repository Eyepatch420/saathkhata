enum LinkRequestStatus { pending, accepted, declined }
enum LinkRequestInitiator { customer, vendor }

LinkRequestStatus _statusFromJson(String s) {
  return switch (s) {
    'accepted' => LinkRequestStatus.accepted,
    'declined' => LinkRequestStatus.declined,
    _ => LinkRequestStatus.pending,
  };
}

LinkRequestInitiator _initiatorFromJson(String? s) {
  return s == 'vendor' ? LinkRequestInitiator.vendor : LinkRequestInitiator.customer;
}

class LinkRequestUserBrief {
  final String id;
  final String name;
  final String? email;
  final String? mobile;
  final String? profilePhotoUrl;
  final String? businessName;
  final String? businessCategory;

  const LinkRequestUserBrief({
    required this.id,
    required this.name,
    this.email,
    this.mobile,
    this.profilePhotoUrl,
    this.businessName,
    this.businessCategory,
  });

  factory LinkRequestUserBrief.fromJson(Map<String, dynamic> json) {
    return LinkRequestUserBrief(
      id: json['id'] as String,
      name: json['name'] as String,
      email: json['email'] as String?,
      mobile: json['mobile'] as String?,
      profilePhotoUrl: json['profilePhotoUrl'] as String?,
      businessName: json['businessName'] as String?,
      businessCategory: json['businessCategory'] as String?,
    );
  }

  String get displayName =>
      businessName?.isNotEmpty == true ? businessName! : name;

  String get avatarInitial =>
      displayName.isNotEmpty ? displayName[0].toUpperCase() : '?';
}

class LinkRequestModel {
  final String id;
  final LinkRequestStatus status;
  final LinkRequestInitiator initiatedBy;
  final String? message;
  final DateTime? respondedAt;
  final DateTime createdAt;
  final LinkRequestUserBrief customer;
  final LinkRequestUserBrief vendor;

  const LinkRequestModel({
    required this.id,
    required this.status,
    this.initiatedBy = LinkRequestInitiator.customer,
    this.message,
    this.respondedAt,
    required this.createdAt,
    required this.customer,
    required this.vendor,
  });

  factory LinkRequestModel.fromJson(Map<String, dynamic> json) {
    return LinkRequestModel(
      id: json['id'] as String,
      status: _statusFromJson(json['status'] as String),
      initiatedBy: _initiatorFromJson(json['initiatedBy'] as String?),
      message: json['message'] as String?,
      respondedAt: json['respondedAt'] != null
          ? DateTime.parse(json['respondedAt'] as String)
          : null,
      createdAt: DateTime.parse(json['createdAt'] as String),
      customer: LinkRequestUserBrief.fromJson(
          json['customer'] as Map<String, dynamic>),
      vendor: LinkRequestUserBrief.fromJson(
          json['vendor'] as Map<String, dynamic>),
    );
  }
}
