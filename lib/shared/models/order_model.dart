import 'package:equatable/equatable.dart';

enum OrderStatus { pending, confirmed, rejected, delivered, cancelled }

extension OrderStatusX on OrderStatus {
  String toJson() => name;

  String get label => switch (this) {
        OrderStatus.pending => 'Pending',
        OrderStatus.confirmed => 'Confirmed',
        OrderStatus.rejected => 'Rejected',
        OrderStatus.delivered => 'Delivered',
        OrderStatus.cancelled => 'Cancelled',
      };
}

OrderStatus _orderStatusFromJson(String v) =>
    OrderStatus.values.firstWhere((e) => e.name == v, orElse: () => OrderStatus.pending);

class OrderItem extends Equatable {
  final String id;
  final String name;
  final String? qty;
  final String? unit;
  final double? pricePerUnit;
  final double? subtotal;
  final String? note;
  final int sortOrder;

  const OrderItem({
    required this.id,
    required this.name,
    this.qty,
    this.unit,
    this.pricePerUnit,
    this.subtotal,
    this.note,
    required this.sortOrder,
  });

  factory OrderItem.fromJson(Map<String, dynamic> json) => OrderItem(
        id: json['id'] as String,
        name: json['name'] as String,
        qty: json['qty'] as String?,
        unit: json['unit'] as String?,
        pricePerUnit: (json['pricePerUnit'] as num?)?.toDouble(),
        subtotal: (json['subtotal'] as num?)?.toDouble(),
        note: json['note'] as String?,
        sortOrder: json['sortOrder'] as int? ?? 0,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        if (qty != null) 'qty': qty,
        if (unit != null) 'unit': unit,
        if (pricePerUnit != null) 'pricePerUnit': pricePerUnit,
        if (note != null) 'note': note,
        'sortOrder': sortOrder,
      };

  @override
  List<Object?> get props =>
      [id, name, qty, unit, pricePerUnit, subtotal, note, sortOrder];
}

class Order extends Equatable {
  final String id;
  final String linkId;
  final String vendorId;
  final String customerId;
  final String? customerName;
  final OrderStatus status;
  final String? note;
  final List<OrderItem> items;
  final double total;
  final String? deliveredBy;
  final String? deliveredByRole; // 'vendor' | 'staff'
  final DateTime? deliveredAt;
  final String? deliveryNote;
  final String? proofUrl;
  final String? ledgerEntryId;
  final DateTime createdAt;
  final DateTime updatedAt;

  const Order({
    required this.id,
    required this.linkId,
    required this.vendorId,
    required this.customerId,
    this.customerName,
    required this.status,
    this.note,
    required this.items,
    this.total = 0,
    this.deliveredBy,
    this.deliveredByRole,
    this.deliveredAt,
    this.deliveryNote,
    this.proofUrl,
    this.ledgerEntryId,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Order.fromJson(Map<String, dynamic> json) => Order(
        id: json['id'] as String,
        linkId: json['linkId'] as String,
        vendorId: json['vendorId'] as String,
        customerId: json['customerId'] as String,
        customerName: json['customerName'] as String?,
        status: _orderStatusFromJson(json['status'] as String),
        note: json['note'] as String?,
        items: (json['items'] as List<dynamic>)
            .map((e) => OrderItem.fromJson(e as Map<String, dynamic>))
            .toList(),
        total: (json['total'] as num?)?.toDouble() ?? 0,
        deliveredBy: json['deliveredBy'] as String?,
        deliveredByRole: json['deliveredByRole'] as String?,
        deliveredAt: json['deliveredAt'] != null
            ? DateTime.tryParse(json['deliveredAt'] as String)
            : null,
        deliveryNote: json['deliveryNote'] as String?,
        proofUrl: json['proofUrl'] as String?,
        ledgerEntryId: json['ledgerEntryId'] as String?,
        createdAt: DateTime.parse(json['createdAt'] as String),
        updatedAt: DateTime.parse(json['updatedAt'] as String),
      );

  Order copyWith({
    String? id,
    String? linkId,
    String? vendorId,
    String? customerId,
    String? customerName,
    OrderStatus? status,
    String? note,
    List<OrderItem>? items,
    double? total,
    String? deliveredBy,
    String? deliveredByRole,
    DateTime? deliveredAt,
    String? deliveryNote,
    String? proofUrl,
    String? ledgerEntryId,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) =>
      Order(
        id: id ?? this.id,
        linkId: linkId ?? this.linkId,
        vendorId: vendorId ?? this.vendorId,
        customerId: customerId ?? this.customerId,
        customerName: customerName ?? this.customerName,
        status: status ?? this.status,
        note: note ?? this.note,
        items: items ?? this.items,
        total: total ?? this.total,
        deliveredBy: deliveredBy ?? this.deliveredBy,
        deliveredByRole: deliveredByRole ?? this.deliveredByRole,
        deliveredAt: deliveredAt ?? this.deliveredAt,
        deliveryNote: deliveryNote ?? this.deliveryNote,
        proofUrl: proofUrl ?? this.proofUrl,
        ledgerEntryId: ledgerEntryId ?? this.ledgerEntryId,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
      );

  @override
  List<Object?> get props => [
        id,
        linkId,
        vendorId,
        customerId,
        customerName,
        status,
        note,
        items,
        total,
        deliveredBy,
        deliveredByRole,
        deliveredAt,
        deliveryNote,
        proofUrl,
        ledgerEntryId,
        createdAt,
        updatedAt,
      ];
}

class OrderListResult extends Equatable {
  final List<Order> orders;
  final int total;
  final int pending;

  const OrderListResult({
    required this.orders,
    required this.total,
    required this.pending,
  });

  factory OrderListResult.fromJson(Map<String, dynamic> json) => OrderListResult(
        orders: (json['orders'] as List<dynamic>)
            .map((e) => Order.fromJson(e as Map<String, dynamic>))
            .toList(),
        total: json['total'] as int,
        pending: json['pending'] as int,
      );

  @override
  List<Object?> get props => [orders, total, pending];
}
