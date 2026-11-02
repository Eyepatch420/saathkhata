import 'package:dio/dio.dart';
import '../../../../core/network/api_client.dart';
import '../../../../core/network/api_endpoints.dart';
import '../../domain/repositories/customer_repository.dart';
import '../../../../shared/models/link_model.dart';

class CustomerRepositoryImpl implements CustomerRepository {
  final ApiClient _api;

  CustomerRepositoryImpl(this._api);

  @override
  Future<List<VendorLinkItem>> getLinkedVendors() async {
    try {
      final response = await _api.get(ApiEndpoints.myVendors);
      final list = (response.data as Map<String, dynamic>)['data'] as List;
      return list
          .map((e) => VendorLinkItem.fromJson(e as Map<String, dynamic>))
          .toList();
    } on DioException catch (e) {
      throw Exception(ApiClient.extractErrorMessage(e));
    }
  }

  @override
  Future<void> deactivateLink(String linkId) async {
    try {
      await _api.delete(ApiEndpoints.linkById(linkId));
    } on DioException catch (e) {
      throw Exception(ApiClient.extractErrorMessage(e));
    }
  }

  @override
  Future<void> updateLinkNickname(String linkId, String? nickname) async {
    try {
      await _api.patch(
        ApiEndpoints.linkNickname(linkId),
        data: {'nickname': nickname},
      );
    } on DioException catch (e) {
      throw Exception(ApiClient.extractErrorMessage(e));
    }
  }

  @override
  Future<void> updateAutoConfirm(String linkId, {required bool enabled}) async {
    try {
      await _api.patch(
        ApiEndpoints.linkAutoConfirm(linkId),
        data: {'enabled': enabled},
      );
    } on DioException catch (e) {
      throw Exception(ApiClient.extractErrorMessage(e));
    }
  }
}
