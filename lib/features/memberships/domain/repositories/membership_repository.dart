import '../models/members_dashboard.dart';
import '../models/membership_plan.dart';
import '../models/membership_request.dart';
import '../models/membership_status.dart';

abstract class MembershipRepository {
  // ── Plans (vendor) ──
  Future<List<MembershipPlan>> getPlans();
  Future<MembershipPlan> createPlan({
    required String name,
    required int durationDays,
    required double price,
    double advanceRequired,
    required List<PlanBenefit> benefits,
  });
  Future<MembershipPlan> updatePlan(
    String planId, {
    String? name,
    int? durationDays,
    double? price,
    double? advanceRequired,
    bool? isActive,
    List<PlanBenefit>? benefits,
  });
  Future<void> deletePlan(String planId);

  // ── Members dashboard (vendor) ──
  Future<MembersDashboard> getMembersDashboard();
  Future<CustomerMembership> useBenefit(String membershipId, String benefitId);
  /// Vendor-only correction — decrements usage by 1 (floors at 0).
  Future<CustomerMembership> decrementBenefit(String membershipId, String benefitId);

  // ── Per-link status (all roles) ──
  Future<MembershipStatus> getStatus(String linkId);
  Future<CustomerMembership> enroll(String linkId, String planId);

  // ── Customer applies for a plan ──
  Future<MembershipRequest> requestPlan(
    String linkId,
    String planId, {
    String? message,
  });

  // ── Requests (vendor) ──
  Future<List<MembershipRequest>> getPendingRequests();
  Future<MembershipRequest> approveRequest(String requestId);
  Future<MembershipRequest> declineRequest(String requestId);
}
