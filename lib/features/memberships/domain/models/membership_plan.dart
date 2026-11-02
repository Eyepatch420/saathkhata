import 'package:equatable/equatable.dart';

class PlanBenefit extends Equatable {
  final String id;
  final String label;
  final int? quota; // null = informational, no usage tracking
  final int sortOrder;

  const PlanBenefit({
    required this.id,
    required this.label,
    this.quota,
    this.sortOrder = 0,
  });

  bool get hasQuota => quota != null && quota! > 0;

  factory PlanBenefit.fromJson(Map<String, dynamic> json) => PlanBenefit(
        id: json['id'] as String? ?? '',
        label: json['label'] as String,
        quota: (json['quota'] as num?)?.toInt(),
        sortOrder: (json['sortOrder'] as num?)?.toInt() ?? 0,
      );

  Map<String, dynamic> toJson() => {
        'label': label,
        if (quota != null) 'quota': quota,
      };

  @override
  List<Object?> get props => [id, label, quota, sortOrder];
}

class MembershipPlan extends Equatable {
  final String id;
  final String name;
  final int durationDays;
  final double price;
  final double advanceRequired;
  final bool isActive;
  final int sortOrder;
  final List<PlanBenefit> benefits;
  final int activeMembers;

  const MembershipPlan({
    required this.id,
    required this.name,
    required this.durationDays,
    required this.price,
    this.advanceRequired = 0,
    this.isActive = true,
    this.sortOrder = 0,
    this.benefits = const [],
    this.activeMembers = 0,
  });

  factory MembershipPlan.fromJson(Map<String, dynamic> json) => MembershipPlan(
        id: json['id'] as String,
        name: json['name'] as String,
        durationDays: (json['durationDays'] as num).toInt(),
        price: (json['price'] as num).toDouble(),
        advanceRequired: (json['advanceRequired'] as num?)?.toDouble() ?? 0,
        isActive: json['isActive'] as bool? ?? true,
        sortOrder: (json['sortOrder'] as num?)?.toInt() ?? 0,
        benefits: ((json['benefits'] as List?) ?? const [])
            .map((e) => PlanBenefit.fromJson(e as Map<String, dynamic>))
            .toList(),
        activeMembers: (json['activeMembers'] as num?)?.toInt() ?? 0,
      );

  @override
  List<Object?> get props =>
      [id, name, durationDays, price, advanceRequired, isActive, sortOrder, benefits, activeMembers];
}

/// One benefit + how much of its quota the member has consumed.
class BenefitUsage extends Equatable {
  final String benefitId;
  final String label;
  final int? quota;
  final int used;

  const BenefitUsage({
    required this.benefitId,
    required this.label,
    this.quota,
    this.used = 0,
  });

  bool get hasQuota => quota != null && quota! > 0;
  int get remaining => hasQuota ? (quota! - used).clamp(0, quota!) : 0;

  factory BenefitUsage.fromJson(Map<String, dynamic> json) => BenefitUsage(
        benefitId: json['benefitId'] as String,
        label: json['label'] as String,
        quota: (json['quota'] as num?)?.toInt(),
        used: (json['used'] as num?)?.toInt() ?? 0,
      );

  @override
  List<Object?> get props => [benefitId, label, quota, used];
}

class CustomerMembership extends Equatable {
  final String id;
  final String linkId;
  final String status; // active | expired | cancelled
  final DateTime startedAt;
  final DateTime expiresAt;
  final double advancePaid;
  final MembershipPlan plan;
  final List<BenefitUsage> benefitUsage;

  const CustomerMembership({
    required this.id,
    required this.linkId,
    required this.status,
    required this.startedAt,
    required this.expiresAt,
    required this.advancePaid,
    required this.plan,
    this.benefitUsage = const [],
  });

  int get daysLeft {
    final d = expiresAt.difference(DateTime.now()).inDays;
    return d < 0 ? 0 : d;
  }

  factory CustomerMembership.fromJson(Map<String, dynamic> json) =>
      CustomerMembership(
        id: json['id'] as String,
        linkId: json['linkId'] as String,
        status: json['status'] as String,
        startedAt: DateTime.parse(json['startedAt'] as String),
        expiresAt: DateTime.parse(json['expiresAt'] as String),
        advancePaid: (json['advancePaid'] as num?)?.toDouble() ?? 0,
        plan: MembershipPlan.fromJson(json['plan'] as Map<String, dynamic>),
        benefitUsage: ((json['benefitUsage'] as List?) ?? const [])
            .map((e) => BenefitUsage.fromJson(e as Map<String, dynamic>))
            .toList(),
      );

  @override
  List<Object?> get props =>
      [id, linkId, status, startedAt, expiresAt, advancePaid, plan, benefitUsage];
}
