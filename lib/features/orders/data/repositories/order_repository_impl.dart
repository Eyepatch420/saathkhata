import 'package:dio/dio.dart';
import '../../../../core/network/api_client.dart';
import '../../../../core/network/api_endpoints.dart';
import '../../domain/repositories/order_repository.dart';
import '../../../../shared/models/order_model.dart';

class OrderRepositoryImpl implements OrderRepository {
  final ApiClient _api;

  OrderRepositoryImpl(this._api);

  Map<String, dynamic> _data(Response r) =>
      (r.data as Map<String, dynamic>)['data'] as Map<String, dynamic>;

  @override
  Future<OrderListResult> getVendorOrders({
    String? status,
    String? linkId,
  }) async {
    try {
      final query = <String, dynamic>{};
      if (status != null && status != 'all') query['status'] = status;
      if (linkId != null) query['linkId'] = linkId;
      final response = await _api.get(
        ApiEndpoints.vendorOrders,
        queryParameters: query.isEmpty ? null : query,
      );
      return OrderListResult.fromJson(_data(response));
    } on DioException catch (e) {
      throw Exception(ApiClient.extractErrorMessage(e));
    }
  }

  @override
  Future<OrderListResult> getCustomerOrders() async {
    try {
      final response = await _api.get(ApiEndpoints.customerOrders);
      return OrderListResult.fromJson(_data(response));
    } on DioException catch (e) {
      throw Exception(ApiClient.extractErrorMessage(e));
    }
  }

  @override
  Future<OrderListResult> getStaffOrders() async {
    try {
      final response = await _api.get(ApiEndpoints.staffOrders);
      return OrderListResult.fromJson(_data(response));
    } on DioException catch (e) {
      throw Exception(ApiClient.extractErrorMessage(e));
    }
  }

  @override
  Future<Order> placeOrder({
    required String linkId,
    required List<Map<String, dynamic>> items,
    String? note,
  }) async {
    try {
      final response = await _api.post(
        ApiEndpoints.placeOrder,
        data: {
          'linkId': linkId,
          'items': items,
          // ignore: use_null_aware_elements
          if (note != null) 'note': note,
        },
      );
      return Order.fromJson(_data(response));
    } on DioException catch (e) {
      throw Exception(ApiClient.extractErrorMessage(e));
    }
  }

  @override
  Future<Order> placeOrderForCustomer({
    required String linkId,
    required List<Map<String, dynamic>> items,
    String? note,
  }) async {
    try {
      final response = await _api.post(
        ApiEndpoints.placeOrderForCustomer,
        data: {
          'linkId': linkId,
          'items': items,
          // ignore: use_null_aware_elements
          if (note != null) 'note': note,
        },
      );
      return Order.fromJson(_data(response));
    } on DioException catch (e) {
      throw Exception(ApiClient.extractErrorMessage(e));
    }
  }

  @override
  Future<Order> updateOrderStatus(
    String orderId,
    OrderStatus status, {
    String? deliveryNote,
    String? proofUrl,
  }) async {
    try {
      final response = await _api.patch(
        ApiEndpoints.updateOrderStatus(orderId),
        data: {
          'status': status.toJson(),
          if (deliveryNote != null && deliveryNote.isNotEmpty)
            'deliveryNote': deliveryNote,
          if (proofUrl != null && proofUrl.isNotEmpty) 'proofUrl': proofUrl,
        },
      );
      return Order.fromJson(_data(response));
    } on DioException catch (e) {
      throw Exception(ApiClient.extractErrorMessage(e));
    }
  }
}
