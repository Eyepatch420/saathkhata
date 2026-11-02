import '../../../../shared/models/schedule_model.dart';

/// One item to create on a new service (name/unit/price required).
class ServiceItemInput {
  final String name;
  final String unit;
  final double defaultPricePerUnit;

  const ServiceItemInput({
    required this.name,
    required this.unit,
    required this.defaultPricePerUnit,
  });
}

/// Diff-style item update: [id] present means "update this existing item"
/// (or deactivate it via [isActive]: false); no [id] means "add a new item".
class ServiceItemUpdateInput {
  final String? id;
  final String? name;
  final String? unit;
  final double? defaultPricePerUnit;
  final bool? isActive;

  const ServiceItemUpdateInput({
    this.id,
    this.name,
    this.unit,
    this.defaultPricePerUnit,
    this.isActive,
  });
}

/// A subscriber's quantity for one service item.
class SubscriptionItemInput {
  final String serviceItemId;
  final double quantity;
  final double? customPricePerUnit;

  const SubscriptionItemInput({
    required this.serviceItemId,
    required this.quantity,
    this.customPricePerUnit,
  });
}

abstract class ScheduleRepository {
  // -------------------------------------------------------------------------
  // Services (vendor)
  // -------------------------------------------------------------------------

  Future<List<ScheduledService>> getServices();

  Future<ScheduledService> createService({
    required String name,
    required ServiceType serviceType,
    required ScheduleType scheduleType,
    required List<ServiceItemInput> items,
    String? description,
    List<int>? deliveryDays,
    String? deliveryTime,
    bool autoCreateLedgerEntry = true,
  });

  Future<ScheduledService> updateService(
    String id, {
    String? name,
    String? description,
    List<ServiceItemUpdateInput>? items,
    ScheduleType? scheduleType,
    List<int>? deliveryDays,
    String? deliveryTime,
    bool? autoCreateLedgerEntry,
  });

  Future<void> deactivateService(String id);

  // -------------------------------------------------------------------------
  // Subscriptions (vendor view)
  // -------------------------------------------------------------------------

  Future<List<ServiceSubscription>> getSubscriptionsForService(
    String serviceId,
  );

  Future<List<ServiceSubscription>> getAllSubscriptions();

  Future<ServiceSubscription> subscribe({
    required String serviceId,
    required String linkId,
    required List<SubscriptionItemInput> items,
    required String startDate,
    String? endDate,
  });

  Future<void> removeSubscription(String id);

  Future<ServiceSubscription> pauseSubscription(
    String id, {
    String? pausedUntil,
  });

  Future<ServiceSubscription> resumeSubscription(String id);

  // -------------------------------------------------------------------------
  // Subscriptions (customer / my view)
  // -------------------------------------------------------------------------

  Future<List<ServiceSubscription>> getMySubscriptions();

  // -------------------------------------------------------------------------
  // Deliveries (vendor view)
  // -------------------------------------------------------------------------

  Future<({List<ScheduledDelivery> deliveries, int total, int page})>
  getVendorDeliveries({
    String? date,
    String? startDate,
    String? endDate,
    String? serviceId,
    String? status,
    String? linkId,
    int page = 1,
    int limit = 50,
  });

  Future<ScheduledDelivery> markDelivered(
    String id, {
    required String photoUrl,
  });

  Future<ScheduledDelivery> skipDelivery(String id, {String? notes});

  // -------------------------------------------------------------------------
  // Deliveries (customer / my view)
  // -------------------------------------------------------------------------

  Future<({List<ScheduledDelivery> deliveries, int total, int page})>
  getMyDeliveries({
    String? date,
    String? startDate,
    String? endDate,
    int page = 1,
    int limit = 50,
  });
}
