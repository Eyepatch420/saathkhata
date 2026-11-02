import 'package:dio/dio.dart';
import '../../../../core/network/api_client.dart';
import '../../../../core/network/api_endpoints.dart';
import '../../domain/models/members_dashboard.dart';
import '../../domain/models/membership_plan.dart';
import '../../domain/models/membership_request.dart';
import '../../domain/models/membership_status.dart';
import '../../domain/repositories/membership_repository.dart';

class MembershipRepositoryImpl implements MembershipRepository {
  final ApiClient _api;

  MembershipRepositoryImpl(this._api);

  // ─── Plans ──────────────────────────────────────────────────────────────────

  @override
  Future<List<MembershipPlan>> getPlans() async {
    try {
      final response = await _api.get(ApiEndpoints.membershipPlans);
      final data = ApiClient.extractData(response);
      final list = (data['plans'] as List?) ?? [];
      return list
          .map((e) => MembershipPlan.fromJson(e as Map<String, dynamic>))
          .toList();
    } on DioException catch (e) {
      throw Exception(ApiClient.extractErrorMessage(e));
    }
  }

  @override
  Future<MembershipPlan> createPlan({
    required String name,
    required int durationDays,
    required double price,
    double advanceRequired = 0,
    required List<PlanBenefit> benefits,
  }) async {
    try {
      final response = await _api.post(
        ApiEndpoints.membershipPlans,
        data: {
          'name': name,
          'durationDays': durationDays,
          'price': price,
          'advanceRequired': advanceRequired,
          'benefits': benefits.map((b) => b.toJson()).toList(),
        },
      );
      return MembershipPlan.fromJson(ApiClient.extractData(response));
    } on DioException catch (e) {
      throw Exception(ApiClient.extractErrorMessage(e));
    }
  }

  @override
  Future<MembershipPlan> updatePlan(
    String planId, {
    String? name,
    int? durationDays,
    double? price,
    double? advanceRequired,
    bool? isActive,
    List<PlanBenefit>? benefits,
  }) async {
    try {
      final body = <String, dynamic>{};
      if (name != null) body['name'] = name;
      if (durationDays != null) body['durationDays'] = durationDays;
      if (price != null) body['price'] = price;
      if (advanceRequired != null) body['advanceRequired'] = advanceRequired;
      if (isActive != null) body['isActive'] = isActive;
      if (benefits != null) {
        body['benefits'] = benefits.map((b) => b.toJson()).toList();
      }
      final response = await _api.patch(
        ApiEndpoints.membershipPlanById(planId),
        data: body,
      );
      return MembershipPlan.fromJson(ApiClient.extractData(response));
    } on DioException catch (e) {
      throw Exception(ApiClient.extractErrorMessage(e));
    }
  }

  @override
  Future<void> deletePlan(String planId) async {
    try {
      await _api.delete(ApiEndpoints.membershipPlanById(planId));
    } on DioException catch (e) {
      throw Exception(ApiClient.extractErrorMessage(e));
    }
  }

  // ─── Members dashboard ──────────────────────────────────────────────────────

  @override
  Future<MembersDashboard> getMembersDashboard() async {
    try {
      final response = await _api.get(ApiEndpoints.membersDashboard);
      return MembersDashboard.fromJson(ApiClient.extractData(response));
    } on DioException catch (e) {
      throw Exception(ApiClient.extractErrorMessage(e));
    }
  }

  @override
  Future<CustomerMembership> useBenefit(
      String membershipId, String benefitId) async {
    try {
      final response = await _api.post(
        ApiEndpoints.useBenefit(membershipId),
        data: {'benefitId': benefitId},
      );
      return CustomerMembership.fromJson(ApiClient.extractData(response));
    } on DioException catch (e) {
      throw Exception(ApiClient.extractErrorMessage(e));
    }
  }

  @override
  Future<CustomerMembership> decrementBenefit(
      String membershipId, String benefitId) async {
    try {
      final response = await _api.post(
        ApiEndpoints.decrementBenefit(membershipId),
        data: {'benefitId': benefitId},
      );
      return CustomerMembership.fromJson(ApiClient.extractData(response));
    } on DioException catch (e) {
      throw Exception(ApiClient.extractErrorMessage(e));
    }
  }

  // ─── Per-link status ────────────────────────────────────────────────────────

  @override
  Future<MembershipStatus> getStatus(String linkId) async {
    try {
      final response = await _api.get(ApiEndpoints.membershipStatus(linkId));
      return MembershipStatus.fromJson(ApiClient.extractData(response));
    } on DioException catch (e) {
      throw Exception(ApiClient.extractErrorMessage(e));
    }
  }

  @override
  Future<CustomerMembership> enroll(String linkId, String planId) async {
    try {
      final response = await _api.post(
        ApiEndpoints.enrollMember(linkId),
        data: {'planId': planId},
      );
      return CustomerMembership.fromJson(ApiClient.extractData(response));
    } on DioException catch (e) {
      throw Exception(ApiClient.extractErrorMessage(e));
    }
  }

  // ─── Customer apply ─────────────────────────────────────────────────────────

  @override
  Future<MembershipRequest> requestPlan(
    String linkId,
    String planId, {
    String? message,
  }) async {
    try {
      final body = <String, dynamic>{'planId': planId};
      if (message != null && message.isNotEmpty) body['message'] = message;
      final response = await _api.post(
        ApiEndpoints.requestMembership(linkId),
        data: body,
      );
      return MembershipRequest.fromJson(ApiClient.extractData(response));
    } on DioException catch (e) {
      throw Exception(ApiClient.extractErrorMessage(e));
    }
  }

  // ─── Requests ───────────────────────────────────────────────────────────────

  @override
  Future<List<MembershipRequest>> getPendingRequests() async {
    try {
      final response = await _api.get(ApiEndpoints.pendingMembershipRequests);
      final data = ApiClient.extractData(response);
      final list = (data['requests'] as List?) ?? [];
      return list
          .map((e) => MembershipRequest.fromJson(e as Map<String, dynamic>))
          .toList();
    } on DioException catch (e) {
      throw Exception(ApiClient.extractErrorMessage(e));
    }
  }

  @override
  Future<MembershipRequest> approveRequest(String requestId) async {
    try {
      final response =
          await _api.patch(ApiEndpoints.approveMembershipRequest(requestId));
      return MembershipRequest.fromJson(ApiClient.extractData(response));
    } on DioException catch (e) {
      throw Exception(ApiClient.extractErrorMessage(e));
    }
  }

  @override
  Future<MembershipRequest> declineRequest(String requestId) async {
    try {
      final response =
          await _api.patch(ApiEndpoints.declineMembershipRequest(requestId));
      return MembershipRequest.fromJson(ApiClient.extractData(response));
    } on DioException catch (e) {
      throw Exception(ApiClient.extractErrorMessage(e));
    }
  }
}
