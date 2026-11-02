import 'package:equatable/equatable.dart';

// ---------------------------------------------------------------------------
// Enums
// ---------------------------------------------------------------------------

enum ServiceType { product, session }

extension ServiceTypeX on ServiceType {
  String toJson() => name; // 'product' | 'session'

  String get label => switch (this) {
    ServiceType.product => 'Product',
    ServiceType.session => 'Session',
  };
}

ServiceType _serviceTypeFromJson(String v) => ServiceType.values.firstWhere(
  (e) => e.name == v,
  orElse: () => ServiceType.product,
);

enum ScheduleType { daily, weekly, customDays }

extension ScheduleTypeX on ScheduleType {
  String toJson() => switch (this) {
    ScheduleType.daily => 'daily',
    ScheduleType.weekly => 'weekly',
    ScheduleType.customDays => 'custom_days',
  };

  String get label => switch (this) {
    ScheduleType.daily => 'Daily',
    ScheduleType.weekly => 'Weekly',
    ScheduleType.customDays => 'Custom Days',
  };
}

ScheduleType _scheduleTypeFromJson(String v) => switch (v) {
  'weekly' => ScheduleType.weekly,
  'custom_days' => ScheduleType.customDays,
  _ => ScheduleType.daily,
};

enum DeliveryStatus { scheduled, delivered, skipped, failed }

extension DeliveryStatusX on DeliveryStatus {
  String toJson() => name; // 'scheduled' | 'delivered' | 'skipped' | 'failed'

  String get label => switch (this) {
    DeliveryStatus.scheduled => 'Scheduled',
    DeliveryStatus.delivered => 'Delivered',
    DeliveryStatus.skipped => 'Skipped',
    DeliveryStatus.failed => 'Failed',
  };
}

DeliveryStatus _deliveryStatusFromJson(String v) => DeliveryStatus.values
    .firstWhere((e) => e.name == v, orElse: () => DeliveryStatus.scheduled);

// ---------------------------------------------------------------------------
// Day-of-week names (0 = Sun … 6 = Sat)
// ---------------------------------------------------------------------------
const _dayNames = ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'];

// ---------------------------------------------------------------------------
// ScheduledServiceItem — one line item within a bundled service
// ---------------------------------------------------------------------------

class ScheduledServiceItem extends Equatable {
  final String id;
  final String name;
  final String unit;
  final double defaultPricePerUnit;
  final bool isActive;

  const ScheduledServiceItem({
    required this.id,
    required this.name,
    required this.unit,
    required this.defaultPricePerUnit,
    required this.isActive,
  });

  factory ScheduledServiceItem.fromJson(Map<String, dynamic> json) =>
      ScheduledServiceItem(
        id: json['id'] as String,
        name: json['name'] as String,
        unit: json['unit'] as String,
        defaultPricePerUnit: (json['defaultPricePerUnit'] as num).toDouble(),
        isActive: json['isActive'] as bool? ?? true,
      );

  @override
  List<Object?> get props => [id, name, unit, defaultPricePerUnit, isActive];
}

// ---------------------------------------------------------------------------
// ScheduledService
// ---------------------------------------------------------------------------

class ScheduledService extends Equatable {
  final String id;
  final String name;
  final String? description;
  final ServiceType serviceType;
  final ScheduleType scheduleType;
  final List<int>? deliveryDays;
  final String? deliveryTime;
  final bool autoCreateLedgerEntry;
  final bool isActive;
  final int subscriberCount;
  final List<ScheduledServiceItem> items;
  final DateTime createdAt;

  const ScheduledService({
    required this.id,
    required this.name,
    this.description,
    required this.serviceType,
    required this.scheduleType,
    this.deliveryDays,
    this.deliveryTime,
    required this.autoCreateLedgerEntry,
    required this.isActive,
    required this.subscriberCount,
    required this.items,
    required this.createdAt,
  });

  /// Human-readable delivery schedule label.
  /// - Daily → "Daily"
  /// - Weekly → "Mon, Wed, Fri" (from deliveryDays)
  /// - Custom days → "Custom"
  String get scheduleLabel {
    switch (scheduleType) {
      case ScheduleType.daily:
        return 'Daily';
      case ScheduleType.weekly:
        if (deliveryDays != null && deliveryDays!.isNotEmpty) {
          return deliveryDays!
              .map((d) => d >= 0 && d < _dayNames.length ? _dayNames[d] : '$d')
              .join(', ');
        }
        return 'Weekly';
      case ScheduleType.customDays:
        if (deliveryDays != null && deliveryDays!.isNotEmpty) {
          return deliveryDays!
              .map((d) => d >= 0 && d < _dayNames.length ? _dayNames[d] : '$d')
              .join(', ');
        }
        return 'Custom';
    }
  }

  /// Comma-joined item names, e.g. "Milk, Curd, Eggs" — for compact display.
  String get itemsSummary => items.map((i) => i.name).join(', ');

  factory ScheduledService.fromJson(Map<String, dynamic> json) =>
      ScheduledService(
        id: json['id'] as String,
        name: json['name'] as String,
        description: json['description'] as String?,
        serviceType: _serviceTypeFromJson(json['serviceType'] as String),
        scheduleType: _scheduleTypeFromJson(json['scheduleType'] as String),
        deliveryDays: (json['deliveryDays'] as List<dynamic>?)
            ?.map((e) => e as int)
            .toList(),
        deliveryTime: json['deliveryTime'] as String?,
        autoCreateLedgerEntry: json['autoCreateLedgerEntry'] as bool? ?? true,
        isActive: json['isActive'] as bool? ?? true,
        subscriberCount: json['subscriberCount'] as int? ?? 0,
        items: (json['items'] as List<dynamic>? ?? [])
            .map((e) => ScheduledServiceItem.fromJson(e as Map<String, dynamic>))
            .toList(),
        createdAt: DateTime.parse(json['createdAt'] as String),
      );

  @override
  List<Object?> get props => [
    id,
    name,
    description,
    serviceType,
    scheduleType,
    deliveryDays,
    deliveryTime,
    autoCreateLedgerEntry,
    isActive,
    subscriberCount,
    items,
    createdAt,
  ];
}

// ---------------------------------------------------------------------------
// SubscriptionItemQuantity — a subscriber's quantity for one service item
// ---------------------------------------------------------------------------

class SubscriptionItemQuantity extends Equatable {
  final String serviceItemId;
  final String name;
  final String unit;
  final double quantity;
  final double effectivePrice;
  final double lineAmount;

  const SubscriptionItemQuantity({
    required this.serviceItemId,
    required this.name,
    required this.unit,
    required this.quantity,
    required this.effectivePrice,
    required this.lineAmount,
  });

  factory SubscriptionItemQuantity.fromJson(Map<String, dynamic> json) =>
      SubscriptionItemQuantity(
        serviceItemId: json['serviceItemId'] as String,
        name: json['name'] as String,
        unit: json['unit'] as String,
        quantity: (json['quantity'] as num).toDouble(),
        effectivePrice: (json['effectivePrice'] as num).toDouble(),
        lineAmount: (json['lineAmount'] as num).toDouble(),
      );

  @override
  List<Object?> get props => [
    serviceItemId,
    name,
    unit,
    quantity,
    effectivePrice,
    lineAmount,
  ];
}

/// Builds a compact "Milk 2litre, Curd 1pack" style summary from a list of
/// item quantities, skipping items with quantity 0 (opted out).
String itemQuantitiesSummary(List<SubscriptionItemQuantity> items) {
  final active = items.where((i) => i.quantity > 0);
  if (active.isEmpty) return 'No items';
  return active
      .map((i) => '${i.quantity.toStringAsFixed(i.quantity % 1 == 0 ? 0 : 1)} ${i.unit} ${i.name}')
      .join(', ');
}

// ---------------------------------------------------------------------------
// ServiceSubscription
// ---------------------------------------------------------------------------

class ServiceSubscription extends Equatable {
  final String id;
  final String serviceId;
  final String serviceName;
  final ServiceType serviceType;
  final String vendorName;
  final List<SubscriptionItemQuantity> items;
  final double totalAmount;
  final DateTime? nextDeliveryDate;
  final DateTime startDate;
  final DateTime? endDate;
  final bool isActive;
  final bool isPaused;
  final DateTime? pausedUntil;
  final String linkId;
  final String customerId;
  final String customerName;
  final String vendorId;

  const ServiceSubscription({
    required this.id,
    required this.serviceId,
    required this.serviceName,
    required this.serviceType,
    required this.vendorName,
    required this.items,
    required this.totalAmount,
    this.nextDeliveryDate,
    required this.startDate,
    this.endDate,
    required this.isActive,
    required this.isPaused,
    this.pausedUntil,
    required this.linkId,
    required this.customerId,
    required this.customerName,
    required this.vendorId,
  });

  /// Compact "Milk 2litre, Curd 1pack" summary, omitting skipped (qty 0) items.
  String get itemsSummary => itemQuantitiesSummary(items);

  factory ServiceSubscription.fromJson(Map<String, dynamic> json) =>
      ServiceSubscription(
        id: json['id'] as String,
        serviceId: json['serviceId'] as String,
        serviceName: json['serviceName'] as String,
        serviceType: _serviceTypeFromJson(json['serviceType'] as String),
        vendorName: json['vendorName'] as String,
        items: (json['items'] as List<dynamic>? ?? [])
            .map((e) => SubscriptionItemQuantity.fromJson(e as Map<String, dynamic>))
            .toList(),
        totalAmount: (json['totalAmount'] as num?)?.toDouble() ?? 0,
        nextDeliveryDate: json['nextDeliveryDate'] != null
            ? DateTime.tryParse(json['nextDeliveryDate'] as String)
            : null,
        startDate: DateTime.parse(json['startDate'] as String),
        endDate: json['endDate'] != null
            ? DateTime.tryParse(json['endDate'] as String)
            : null,
        isActive: json['isActive'] as bool? ?? true,
        isPaused: json['isPaused'] as bool? ?? false,
        pausedUntil: json['pausedUntil'] != null
            ? DateTime.tryParse(json['pausedUntil'] as String)
            : null,
        linkId: json['linkId'] as String,
        customerId: json['customerId'] as String,
        customerName: json['customerName'] as String? ?? '',
        vendorId: json['vendorId'] as String,
      );

  @override
  List<Object?> get props => [
    id,
    serviceId,
    serviceName,
    serviceType,
    vendorName,
    items,
    totalAmount,
    nextDeliveryDate,
    startDate,
    endDate,
    isActive,
    isPaused,
    pausedUntil,
    linkId,
    customerId,
    customerName,
    vendorId,
  ];
}

// ---------------------------------------------------------------------------
// ScheduledDelivery
// ---------------------------------------------------------------------------

class ScheduledDelivery extends Equatable {
  final String id;
  final String subscriptionId;
  final String serviceId;
  final String serviceName;
  final String linkId;
  final String vendorId;
  final String customerId;
  final String customerName;
  final String? customerAddress;
  final String? customerPhone;
  final double? customerLatitude;
  final double? customerLongitude;
  final DateTime scheduledDate;
  final DeliveryStatus status;
  final String? ledgerEntryId;
  final DateTime? deliveredAt;
  final String? deliveredByUserId;
  final String? deliveredByName;
  final String? photoUrl;
  final String? notes;
  final String? deliveryTime;
  final List<SubscriptionItemQuantity> items;
  final double totalAmount;

  const ScheduledDelivery({
    required this.id,
    required this.subscriptionId,
    required this.serviceId,
    required this.serviceName,
    required this.linkId,
    required this.vendorId,
    required this.customerId,
    required this.customerName,
    this.customerAddress,
    this.customerPhone,
    this.customerLatitude,
    this.customerLongitude,
    required this.scheduledDate,
    required this.status,
    this.ledgerEntryId,
    this.deliveredAt,
    this.deliveredByUserId,
    this.deliveredByName,
    this.photoUrl,
    this.notes,
    this.deliveryTime,
    required this.items,
    required this.totalAmount,
  });

  /// Whether it's time to act on this delivery yet. A `scheduled` delivery
  /// with no [deliveryTime] set is due immediately (today's default); one
  /// with a delivery_time (e.g. "09:00") is only due once the current time
  /// passes that, so staff/vendor see it as "Upcoming" beforehand instead of
  /// an actionable item indistinguishable from ones that are actually due.
  bool get isDue {
    if (status != DeliveryStatus.scheduled) return true;
    final time = deliveryTime;
    if (time == null || time.isEmpty) return true;
    final parts = time.split(':');
    if (parts.length < 2) return true;
    final hour = int.tryParse(parts[0]);
    final minute = int.tryParse(parts[1]);
    if (hour == null || minute == null) return true;
    final now = DateTime.now();
    final due = DateTime(now.year, now.month, now.day, hour, minute);
    return !now.isBefore(due);
  }

  /// Compact "Milk 2litre, Curd 1pack" summary, omitting skipped (qty 0) items.
  String get itemsSummary => itemQuantitiesSummary(items);

  factory ScheduledDelivery.fromJson(Map<String, dynamic> json) =>
      ScheduledDelivery(
        id: json['id'] as String,
        subscriptionId: json['subscriptionId'] as String,
        serviceId: json['serviceId'] as String,
        serviceName: json['serviceName'] as String,
        linkId: json['linkId'] as String,
        vendorId: json['vendorId'] as String,
        customerId: json['customerId'] as String,
        customerName: json['customerName'] as String,
        customerAddress: json['customerAddress'] as String?,
        customerPhone: json['customerPhone'] as String?,
        customerLatitude: (json['customerLatitude'] as num?)?.toDouble(),
        customerLongitude: (json['customerLongitude'] as num?)?.toDouble(),
        scheduledDate: DateTime.parse(json['scheduledDate'] as String),
        status: _deliveryStatusFromJson(json['status'] as String),
        ledgerEntryId: json['ledgerEntryId'] as String?,
        deliveredAt: json['deliveredAt'] != null
            ? DateTime.tryParse(json['deliveredAt'] as String)
            : null,
        deliveredByUserId: json['deliveredByUserId'] as String?,
        deliveredByName: json['deliveredByName'] as String?,
        photoUrl: json['photoUrl'] as String?,
        notes: json['notes'] as String?,
        deliveryTime: json['deliveryTime'] as String?,
        items: (json['items'] as List<dynamic>? ?? [])
            .map((e) => SubscriptionItemQuantity.fromJson(e as Map<String, dynamic>))
            .toList(),
        totalAmount: (json['totalAmount'] as num?)?.toDouble() ?? 0,
      );

  @override
  List<Object?> get props => [
    id,
    subscriptionId,
    serviceId,
    serviceName,
    linkId,
    vendorId,
    customerId,
    customerName,
    customerAddress,
    customerPhone,
    customerLatitude,
    customerLongitude,
    scheduledDate,
    status,
    ledgerEntryId,
    deliveredAt,
    deliveredByUserId,
    deliveredByName,
    photoUrl,
    notes,
    deliveryTime,
    items,
    totalAmount,
  ];
}
