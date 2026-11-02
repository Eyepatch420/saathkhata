import 'package:equatable/equatable.dart';
import 'membership_plan.dart';

enum MembershipRequestStatus { pending, approved, declined }

MembershipRequestStatus _statusFromJson(String s) => switch (s) {
      'approved' => MembershipRequestStatus.approved,
      'declined' => MembershipRequestStatus.declined,
      _ => MembershipRequestStatus.pending,
    };

class MembershipRequestCustomer extends Equatable {
  final String id;
  final String name;
  final String? profilePhotoUrl;

  const MembershipRequestCustomer({
    required this.id,
    required this.name,
    this.profilePhotoUrl,
  });

  factory MembershipRequestCustomer.fromJson(Map<String, dynamic> json) =>
      MembershipRequestCustomer(
        id: json['id'] as String,
        name: json['name'] as String,
        profilePhotoUrl: json['profilePhotoUrl'] as String?,
      );

  @override
  List<Object?> get props => [id, name, profilePhotoUrl];
}

class MembershipRequest extends Equatable {
  final String id;
  final String linkId;
  final MembershipRequestStatus status;
  final String? message;
  final DateTime? respondedAt;
  final DateTime createdAt;
  final MembershipPlan? requestedPlan;
  final MembershipRequestCustomer customer;

  const MembershipRequest({
    required this.id,
    required this.linkId,
    required this.status,
    required this.createdAt,
    required this.customer,
    this.requestedPlan,
    this.message,
    this.respondedAt,
  });

  factory MembershipRequest.fromJson(Map<String, dynamic> json) =>
      MembershipRequest(
        id: json['id'] as String,
        linkId: json['linkId'] as String,
        status: _statusFromJson(json['status'] as String),
        message: json['message'] as String?,
        respondedAt: json['respondedAt'] != null
            ? DateTime.parse(json['respondedAt'] as String)
            : null,
        createdAt: DateTime.parse(json['createdAt'] as String),
        requestedPlan: json['requestedPlan'] != null
            ? MembershipPlan.fromJson(json['requestedPlan'] as Map<String, dynamic>)
            : null,
        customer: MembershipRequestCustomer.fromJson(
            json['customer'] as Map<String, dynamic>),
      );

  @override
  List<Object?> get props =>
      [id, linkId, status, message, respondedAt, createdAt, requestedPlan, customer];
}
