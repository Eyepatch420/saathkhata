import 'package:equatable/equatable.dart';
import 'membership_plan.dart';

class MemberRow extends Equatable {
  final String membershipId;
  final String linkId;
  final String customerId;
  final String customerName;
  final String? customerPhotoUrl;
  final String planId;
  final String planName;
  final String status;
  final DateTime startedAt;
  final DateTime expiresAt;
  final int daysLeft;
  final int totalQuota;
  final int totalUsed;

  const MemberRow({
    required this.membershipId,
    required this.linkId,
    required this.customerId,
    required this.customerName,
    this.customerPhotoUrl,
    required this.planId,
    required this.planName,
    required this.status,
    required this.startedAt,
    required this.expiresAt,
    required this.daysLeft,
    this.totalQuota = 0,
    this.totalUsed = 0,
  });

  bool get hasQuota => totalQuota > 0;

  factory MemberRow.fromJson(Map<String, dynamic> json) {
    final c = json['customer'] as Map<String, dynamic>;
    return MemberRow(
      membershipId: json['membershipId'] as String,
      linkId: json['linkId'] as String,
      customerId: c['id'] as String,
      customerName: c['name'] as String,
      customerPhotoUrl: c['profilePhotoUrl'] as String?,
      planId: json['planId'] as String,
      planName: json['planName'] as String,
      status: json['status'] as String,
      startedAt: DateTime.parse(json['startedAt'] as String),
      expiresAt: DateTime.parse(json['expiresAt'] as String),
      daysLeft: (json['daysLeft'] as num).toInt(),
      totalQuota: (json['totalQuota'] as num?)?.toInt() ?? 0,
      totalUsed: (json['totalUsed'] as num?)?.toInt() ?? 0,
    );
  }

  @override
  List<Object?> get props => [
        membershipId,
        linkId,
        customerId,
        customerName,
        planId,
        planName,
        status,
        startedAt,
        expiresAt,
        daysLeft,
        totalQuota,
        totalUsed,
      ];
}

class MembersDashboard extends Equatable {
  final int activeCount;
  final int mrr;
  final int expiringSoon;
  final List<MembershipPlan> plans;
  final List<MemberRow> members;

  const MembersDashboard({
    required this.activeCount,
    required this.mrr,
    required this.expiringSoon,
    required this.plans,
    required this.members,
  });

  factory MembersDashboard.fromJson(Map<String, dynamic> json) => MembersDashboard(
        activeCount: (json['activeCount'] as num).toInt(),
        mrr: (json['mrr'] as num).toInt(),
        expiringSoon: (json['expiringSoon'] as num).toInt(),
        plans: ((json['plans'] as List?) ?? const [])
            .map((e) => MembershipPlan.fromJson(e as Map<String, dynamic>))
            .toList(),
        members: ((json['members'] as List?) ?? const [])
            .map((e) => MemberRow.fromJson(e as Map<String, dynamic>))
            .toList(),
      );

  @override
  List<Object?> get props => [activeCount, mrr, expiringSoon, plans, members];
}
