import '../../../../shared/models/order_model.dart';

abstract class OrderRepository {
  Future<OrderListResult> getVendorOrders({String? status, String? linkId});
  Future<OrderListResult> getCustomerOrders();
  Future<OrderListResult> getStaffOrders();
  Future<Order> placeOrder({
    required String linkId,
    required List<Map<String, dynamic>> items,
    String? note,
  });
  /// Vendor or staff places an order on behalf of a customer who can't use
  /// the app themselves (e.g. iOS holdout).
  Future<Order> placeOrderForCustomer({
    required String linkId,
    required List<Map<String, dynamic>> items,
    String? note,
  });
  Future<Order> updateOrderStatus(
    String orderId,
    OrderStatus status, {
    String? deliveryNote,
    String? proofUrl,
  });
}
