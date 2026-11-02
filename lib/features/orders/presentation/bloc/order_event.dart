import 'package:equatable/equatable.dart';
import '../../../../shared/models/order_model.dart';

abstract class OrderEvent extends Equatable {
  const OrderEvent();
  @override
  List<Object?> get props => [];
}

class LoadVendorOrders extends OrderEvent {
  final String? statusFilter;
  final String? linkId;
  const LoadVendorOrders({this.statusFilter, this.linkId});
  @override
  List<Object?> get props => [statusFilter, linkId];
}

class LoadCustomerOrders extends OrderEvent {
  const LoadCustomerOrders();
}

class LoadStaffOrders extends OrderEvent {
  const LoadStaffOrders();
}

class PlaceOrder extends OrderEvent {
  final String linkId;
  final List<Map<String, dynamic>> items;
  final String? note;
  const PlaceOrder({required this.linkId, required this.items, this.note});
  @override
  List<Object?> get props => [linkId, items, note];
}

/// Vendor or staff places an order on behalf of a customer.
class PlaceOrderForCustomer extends OrderEvent {
  final String linkId;
  final List<Map<String, dynamic>> items;
  final String? note;
  const PlaceOrderForCustomer({required this.linkId, required this.items, this.note});
  @override
  List<Object?> get props => [linkId, items, note];
}

class UpdateOrderStatus extends OrderEvent {
  final String orderId;
  final OrderStatus status;
  final String? deliveryNote;
  final String? proofUrl;
  const UpdateOrderStatus({
    required this.orderId,
    required this.status,
    this.deliveryNote,
    this.proofUrl,
  });
  @override
  List<Object?> get props => [orderId, status, deliveryNote, proofUrl];
}
