import 'package:equatable/equatable.dart';

/// A chargeable item shown in the Bulk Charge picker. Backed either by a
/// saved bulk-charge template (`product_templates`) or a Schedule (F005)
/// service reused for a one-off bulk charge — [isScheduleService] tells the
/// submit call which id field the backend expects.
class ProductTemplate extends Equatable {
  final String id;
  final String vendorId;
  final String name;
  // Null for a schedule-service-backed entry whose service has no unit
  // and/or default price set yet — it still appears in the picker, but
  // must be priced (see [needsPricing]) before it can be charged.
  final String? unit;
  final double? pricePerUnit;
  final bool isActive;
  final DateTime createdAt;
  final bool isScheduleService;
  // Parent schedule service id/name, set only when isScheduleService is
  // true — lets the picker group a bundle's items (e.g. Milk, Curd) under
  // one "Daily Basket" card instead of listing each item as its own chip.
  final String? scheduleServiceId;
  final String? scheduleServiceName;

  const ProductTemplate({
    required this.id,
    required this.vendorId,
    required this.name,
    required this.unit,
    required this.pricePerUnit,
    required this.isActive,
    required this.createdAt,
    this.isScheduleService = false,
    this.scheduleServiceId,
    this.scheduleServiceName,
  });

  // pricePerUnit <= 0 catches never-priced legacy schedule-service items
  // (backfilled with a 0 sentinel before the multi-item migration), which
  // the backend also rejects with the same threshold.
  bool get needsPricing =>
      unit == null || pricePerUnit == null || pricePerUnit! <= 0;

  ProductTemplate copyWith({String? unit, double? pricePerUnit}) =>
      ProductTemplate(
        id: id,
        vendorId: vendorId,
        name: name,
        unit: unit ?? this.unit,
        pricePerUnit: pricePerUnit ?? this.pricePerUnit,
        isActive: isActive,
        createdAt: createdAt,
        isScheduleService: isScheduleService,
        scheduleServiceId: scheduleServiceId,
        scheduleServiceName: scheduleServiceName,
      );

  factory ProductTemplate.fromJson(Map<String, dynamic> json) =>
      ProductTemplate(
        id: json['id'] as String,
        vendorId: json['vendorId'] as String,
        name: json['name'] as String,
        unit: json['unit'] as String,
        pricePerUnit: (json['pricePerUnit'] as num).toDouble(),
        isActive: json['isActive'] as bool? ?? true,
        createdAt: DateTime.parse(json['createdAt'] as String),
      );

  @override
  List<Object?> get props => [
    id,
    vendorId,
    name,
    unit,
    pricePerUnit,
    isActive,
    createdAt,
    isScheduleService,
    scheduleServiceId,
    scheduleServiceName,
  ];
}

class BulkChargeItem extends Equatable {
  final String linkId;
  final double quantity;

  const BulkChargeItem({required this.linkId, required this.quantity});

  Map<String, dynamic> toJson() => {'linkId': linkId, 'quantity': quantity};

  @override
  List<Object?> get props => [linkId, quantity];
}

class BulkChargeResult extends Equatable {
  final List<BulkChargeSuccess> succeeded;
  final List<BulkChargeFailure> failed;

  const BulkChargeResult({required this.succeeded, required this.failed});

  factory BulkChargeResult.fromJson(Map<String, dynamic> json) {
    final raw = json;
    return BulkChargeResult(
      succeeded: (raw['succeeded'] as List<dynamic>? ?? [])
          .map((e) => BulkChargeSuccess.fromJson(e as Map<String, dynamic>))
          .toList(),
      failed: (raw['failed'] as List<dynamic>? ?? [])
          .map((e) => BulkChargeFailure.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  @override
  List<Object?> get props => [succeeded, failed];
}

class BulkChargeSuccess extends Equatable {
  final String linkId;
  final String entryId;
  final double amount;

  const BulkChargeSuccess({
    required this.linkId,
    required this.entryId,
    required this.amount,
  });

  factory BulkChargeSuccess.fromJson(Map<String, dynamic> json) =>
      BulkChargeSuccess(
        linkId: json['linkId'] as String,
        entryId: json['entryId'] as String,
        amount: (json['amount'] as num).toDouble(),
      );

  @override
  List<Object?> get props => [linkId, entryId, amount];
}

class BulkChargeFailure extends Equatable {
  final String linkId;
  final String reason;

  const BulkChargeFailure({required this.linkId, required this.reason});

  factory BulkChargeFailure.fromJson(Map<String, dynamic> json) =>
      BulkChargeFailure(
        linkId: json['linkId'] as String,
        reason: json['reason'] as String,
      );

  @override
  List<Object?> get props => [linkId, reason];
}
