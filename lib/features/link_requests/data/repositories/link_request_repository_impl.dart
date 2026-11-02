import 'package:dio/dio.dart';
import '../../../../core/network/api_client.dart';
import '../../../../core/network/api_endpoints.dart';
import '../../domain/models/link_request_model.dart';
import '../../domain/repositories/link_request_repository.dart';

class LinkRequestRepositoryImpl implements LinkRequestRepository {
  final ApiClient _api;

  LinkRequestRepositoryImpl(this._api);

  @override
  Future<LinkRequestModel> sendRequest({
    required String vendorId,
    String? message,
  }) async {
    try {
      final body = <String, dynamic>{'vendorId': vendorId};
      if (message != null && message.isNotEmpty) body['message'] = message;
      final response = await _api.post(ApiEndpoints.linkRequests, data: body);
      return LinkRequestModel.fromJson(
        Map<String, dynamic>.from(ApiClient.extractData(response) as Map),
      );
    } on DioException catch (e) {
      throw Exception(ApiClient.extractErrorMessage(e));
    }
  }

  @override
  Future<LinkRequestModel> customerSendByIdentifier({
    required String vendorIdentifier,
    String? nickname,
    String? message,
  }) async {
    try {
      final body = <String, dynamic>{'vendorIdentifier': vendorIdentifier};
      if (nickname != null && nickname.isNotEmpty) body['nickname'] = nickname;
      if (message != null && message.isNotEmpty) body['message'] = message;
      final response = await _api.post(ApiEndpoints.customerSendLinkRequest, data: body);
      return LinkRequestModel.fromJson(
        Map<String, dynamic>.from(ApiClient.extractData(response) as Map),
      );
    } on DioException catch (e) {
      throw Exception(ApiClient.extractErrorMessage(e));
    }
  }

  @override
  Future<LinkRequestModel> acceptRequest(String requestId) async {
    try {
      final response =
          await _api.patch(ApiEndpoints.acceptLinkRequest(requestId));
      return LinkRequestModel.fromJson(
        Map<String, dynamic>.from(ApiClient.extractData(response) as Map),
      );
    } on DioException catch (e) {
      throw Exception(ApiClient.extractErrorMessage(e));
    }
  }

  @override
  Future<LinkRequestModel> declineRequest(String requestId) async {
    try {
      final response =
          await _api.patch(ApiEndpoints.declineLinkRequest(requestId));
      return LinkRequestModel.fromJson(
        Map<String, dynamic>.from(ApiClient.extractData(response) as Map),
      );
    } on DioException catch (e) {
      throw Exception(ApiClient.extractErrorMessage(e));
    }
  }

  @override
  Future<LinkRequestModel> getRequestById(String requestId) async {
    try {
      final response =
          await _api.get(ApiEndpoints.linkRequestById(requestId));
      return LinkRequestModel.fromJson(
        Map<String, dynamic>.from(ApiClient.extractData(response) as Map),
      );
    } on DioException catch (e) {
      throw Exception(ApiClient.extractErrorMessage(e));
    }
  }

  @override
  Future<LinkRequestModel> vendorSendRequest({
    required String customerIdentifier,
    String? nickname,
    String? message,
  }) async {
    try {
      final body = <String, dynamic>{'customerIdentifier': customerIdentifier};
      if (nickname != null && nickname.isNotEmpty) body['nickname'] = nickname;
      if (message != null && message.isNotEmpty) body['message'] = message;
      final response = await _api.post(ApiEndpoints.vendorSendLinkRequest, data: body);
      return LinkRequestModel.fromJson(
        Map<String, dynamic>.from(ApiClient.extractData(response) as Map),
      );
    } on DioException catch (e) {
      throw Exception(ApiClient.extractErrorMessage(e));
    }
  }

  @override
  Future<List<LinkRequestModel>> getPendingRequests() async {
    try {
      final response = await _api.get(ApiEndpoints.pendingLinkRequests);
      return (ApiClient.extractData(response) as List<dynamic>)
          .map((e) => LinkRequestModel.fromJson(e as Map<String, dynamic>))
          .toList();
    } on DioException catch (e) {
      throw Exception(ApiClient.extractErrorMessage(e));
    }
  }

  @override
  Future<List<LinkRequestModel>> getVendorSentRequests() async {
    try {
      final response = await _api.get(ApiEndpoints.vendorSentLinkRequests);
      return (ApiClient.extractData(response) as List<dynamic>)
          .map((e) => LinkRequestModel.fromJson(e as Map<String, dynamic>))
          .toList();
    } on DioException catch (e) {
      throw Exception(ApiClient.extractErrorMessage(e));
    }
  }

  @override
  Future<List<LinkRequestModel>> getPendingForCustomer() async {
    try {
      final response = await _api.get(ApiEndpoints.pendingCustomerLinkRequests);
      return (ApiClient.extractData(response) as List<dynamic>)
          .map((e) => LinkRequestModel.fromJson(e as Map<String, dynamic>))
          .toList();
    } on DioException catch (e) {
      throw Exception(ApiClient.extractErrorMessage(e));
    }
  }

  @override
  Future<List<LinkRequestModel>> getSentRequests() async {
    try {
      final response = await _api.get(ApiEndpoints.sentLinkRequests);
      return (ApiClient.extractData(response) as List<dynamic>)
          .map((e) => LinkRequestModel.fromJson(e as Map<String, dynamic>))
          .toList();
    } on DioException catch (e) {
      throw Exception(ApiClient.extractErrorMessage(e));
    }
  }
}
