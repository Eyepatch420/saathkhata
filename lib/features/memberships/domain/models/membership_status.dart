import 'package:equatable/equatable.dart';
import 'membership_plan.dart';
import 'membership_request.dart';

/// Everything the shared-ledger membership banner/chip needs for one link.
class MembershipStatus extends Equatable {
  final String linkId;
  final CustomerMembership? current;
  final MembershipRequest? pendingRequest;
  final List<MembershipPlan> plans; // active plans the customer can apply for

  const MembershipStatus({
    required this.linkId,
    required this.plans,
    this.current,
    this.pendingRequest,
  });

  factory MembershipStatus.fromJson(Map<String, dynamic> json) =>
      MembershipStatus(
        linkId: json['linkId'] as String,
        current: json['current'] != null
            ? CustomerMembership.fromJson(json['current'] as Map<String, dynamic>)
            : null,
        pendingRequest: json['pendingRequest'] != null
            ? MembershipRequest.fromJson(
                json['pendingRequest'] as Map<String, dynamic>)
            : null,
        plans: ((json['plans'] as List?) ?? const [])
            .map((e) => MembershipPlan.fromJson(e as Map<String, dynamic>))
            .toList(),
      );

  @override
  List<Object?> get props => [linkId, current, pendingRequest, plans];
}
