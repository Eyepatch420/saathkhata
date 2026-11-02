import 'package:dio/dio.dart';
import '../../../../core/network/api_client.dart';
import '../../../../core/network/api_endpoints.dart';
import '../../domain/repositories/schedule_repository.dart';
import '../../../../shared/models/schedule_model.dart';

class ScheduleRepositoryImpl implements ScheduleRepository {
  final ApiClient _api;

  ScheduleRepositoryImpl(this._api);

  // ---------------------------------------------------------------------------
  // Helpers
  // ---------------------------------------------------------------------------

  /// Parses a standard `{ data: [...] }` list response.
  List<T> _list<T>(Response r, T Function(Map<String, dynamic>) fn) =>
      (r.data['data'] as List)
          .map((e) => fn(e as Map<String, dynamic>))
          .toList();

  /// Parses a standard `{ data: {...} }` single-item response.
  Map<String, dynamic> _item(Response r) =>
      r.data['data'] as Map<String, dynamic>;

  // ---------------------------------------------------------------------------
  // Services
  // ---------------------------------------------------------------------------

  @override
  Future<List<ScheduledService>> getServices() async {
    try {
      final r = await _api.get(ApiEndpoints.scheduleServices);
      return _list(r, ScheduledService.fromJson);
    } on DioException catch (e) {
      throw Exception(ApiClient.extractErrorMessage(e));
    }
  }

  @override
  Future<ScheduledService> createService({
    required String name,
    required ServiceType serviceType,
    required ScheduleType scheduleType,
    required List<ServiceItemInput> items,
    String? description,
    List<int>? deliveryDays,
    String? deliveryTime,
    bool autoCreateLedgerEntry = true,
  }) async {
    try {
      final r = await _api.post(
        ApiEndpoints.scheduleServices,
        data: {
          'name': name,
          'serviceType': serviceType.toJson(),
          'scheduleType': scheduleType.toJson(),
          'description': ?description,
          'items': items
              .map((i) => {
                    'name': i.name,
                    'unit': i.unit,
                    'defaultPricePerUnit': i.defaultPricePerUnit,
                  })
              .toList(),
          'deliveryDays': ?deliveryDays,
          'deliveryTime': ?deliveryTime,
          'autoCreateLedgerEntry': autoCreateLedgerEntry,
        },
      );
      return ScheduledService.fromJson(_item(r));
    } on DioException catch (e) {
      throw Exception(ApiClient.extractErrorMessage(e));
    }
  }

  @override
  Future<ScheduledService> updateService(
    String id, {
    String? name,
    String? description,
    List<ServiceItemUpdateInput>? items,
    ScheduleType? scheduleType,
    List<int>? deliveryDays,
    String? deliveryTime,
    bool? autoCreateLedgerEntry,
  }) async {
    try {
      final r = await _api.patch(
        ApiEndpoints.scheduleServiceById(id),
        data: {
          'name': ?name,
          'description': ?description,
          'items': items?.map((i) => {
                'id': ?i.id,
                'name': ?i.name,
                'unit': ?i.unit,
                'defaultPricePerUnit': ?i.defaultPricePerUnit,
                'isActive': ?i.isActive,
              }).toList(),
          'scheduleType': ?scheduleType?.toJson(),
          'deliveryDays': ?deliveryDays,
          'deliveryTime': ?deliveryTime,
          'autoCreateLedgerEntry': ?autoCreateLedgerEntry,
        },
      );
      return ScheduledService.fromJson(_item(r));
    } on DioException catch (e) {
      throw Exception(ApiClient.extractErrorMessage(e));
    }
  }

  @override
  Future<void> deactivateService(String id) async {
    try {
      await _api.delete(ApiEndpoints.scheduleServiceById(id));
    } on DioException catch (e) {
      throw Exception(ApiClient.extractErrorMessage(e));
    }
  }

  // ---------------------------------------------------------------------------
  // Subscriptions (vendor)
  // ---------------------------------------------------------------------------

  @override
  Future<List<ServiceSubscription>> getSubscriptionsForService(
    String serviceId,
  ) async {
    try {
      final r = await _api.get(
        ApiEndpoints.scheduleServiceSubscriptions(serviceId),
      );
      return _list(r, ServiceSubscription.fromJson);
    } on DioException catch (e) {
      throw Exception(ApiClient.extractErrorMessage(e));
    }
  }

  @override
  Future<List<ServiceSubscription>> getAllSubscriptions() async {
    try {
      final r = await _api.get(ApiEndpoints.scheduleSubscriptions);
      return _list(r, ServiceSubscription.fromJson);
    } on DioException catch (e) {
      throw Exception(ApiClient.extractErrorMessage(e));
    }
  }

  @override
  Future<ServiceSubscription> subscribe({
    required String serviceId,
    required String linkId,
    required List<SubscriptionItemInput> items,
    required String startDate,
    String? endDate,
  }) async {
    try {
      final r = await _api.post(
        ApiEndpoints.scheduleServiceSubscriptions(serviceId),
        data: {
          'linkId': linkId,
          'items': items
              .map((i) => {
                    'serviceItemId': i.serviceItemId,
                    'quantity': i.quantity,
                    'customPricePerUnit': ?i.customPricePerUnit,
                  })
              .toList(),
          'startDate': startDate,
          'endDate': ?endDate,
        },
      );
      return ServiceSubscription.fromJson(_item(r));
    } on DioException catch (e) {
      throw Exception(ApiClient.extractErrorMessage(e));
    }
  }

  @override
  Future<void> removeSubscription(String id) async {
    try {
      await _api.delete(ApiEndpoints.scheduleSubscriptionById(id));
    } on DioException catch (e) {
      throw Exception(ApiClient.extractErrorMessage(e));
    }
  }

  @override
  Future<ServiceSubscription> pauseSubscription(
    String id, {
    String? pausedUntil,
  }) async {
    try {
      final r = await _api.post(
        ApiEndpoints.scheduleSubscriptionPause(id),
        data: {'pausedUntil': ?pausedUntil},
      );
      return ServiceSubscription.fromJson(_item(r));
    } on DioException catch (e) {
      throw Exception(ApiClient.extractErrorMessage(e));
    }
  }

  @override
  Future<ServiceSubscription> resumeSubscription(String id) async {
    try {
      final r = await _api.post(ApiEndpoints.scheduleSubscriptionResume(id));
      return ServiceSubscription.fromJson(_item(r));
    } on DioException catch (e) {
      throw Exception(ApiClient.extractErrorMessage(e));
    }
  }

  // ---------------------------------------------------------------------------
  // Subscriptions (customer / my view)
  // ---------------------------------------------------------------------------

  @override
  Future<List<ServiceSubscription>> getMySubscriptions() async {
    try {
      final r = await _api.get(ApiEndpoints.scheduleMySubscriptions);
      return _list(r, ServiceSubscription.fromJson);
    } on DioException catch (e) {
      throw Exception(ApiClient.extractErrorMessage(e));
    }
  }

  // ---------------------------------------------------------------------------
  // Deliveries (vendor)
  // ---------------------------------------------------------------------------

  @override
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
  }) async {
    try {
      final r = await _api.get(
        ApiEndpoints.scheduleDeliveries,
        queryParameters: {
          'date': ?date,
          'startDate': ?startDate,
          'endDate': ?endDate,
          'serviceId': ?serviceId,
          'status': ?status,
          'linkId': ?linkId,
          'page': page,
          'limit': limit,
        },
      );
      final body = r.data as Map<String, dynamic>;
      final deliveries = (body['deliveries'] as List)
          .map((e) => ScheduledDelivery.fromJson(e as Map<String, dynamic>))
          .toList();
      final total = body['total'] as int;
      final pg = body['page'] as int;
      return (deliveries: deliveries, total: total, page: pg);
    } on DioException catch (e) {
      throw Exception(ApiClient.extractErrorMessage(e));
    }
  }

  @override
  Future<ScheduledDelivery> markDelivered(
    String id, {
    required String photoUrl,
  }) async {
    try {
      final r = await _api.patch(
        ApiEndpoints.scheduleDeliveryDeliver(id),
        data: {'photoUrl': photoUrl},
      );
      return ScheduledDelivery.fromJson(_item(r));
    } on DioException catch (e) {
      throw Exception(ApiClient.extractErrorMessage(e));
    }
  }

  @override
  Future<ScheduledDelivery> skipDelivery(String id, {String? notes}) async {
    try {
      final r = await _api.patch(
        ApiEndpoints.scheduleDeliverySkip(id),
        data: {'notes': ?notes},
      );
      return ScheduledDelivery.fromJson(_item(r));
    } on DioException catch (e) {
      throw Exception(ApiClient.extractErrorMessage(e));
    }
  }

  // ---------------------------------------------------------------------------
  // Deliveries (customer / my view)
  // ---------------------------------------------------------------------------

  @override
  Future<({List<ScheduledDelivery> deliveries, int total, int page})>
  getMyDeliveries({
    String? date,
    String? startDate,
    String? endDate,
    int page = 1,
    int limit = 50,
  }) async {
    try {
      final r = await _api.get(
        ApiEndpoints.scheduleMyDeliveries,
        queryParameters: {
          'date': ?date,
          'startDate': ?startDate,
          'endDate': ?endDate,
          'page': page,
          'limit': limit,
        },
      );
      final body = r.data as Map<String, dynamic>;
      final deliveries = (body['deliveries'] as List)
          .map((e) => ScheduledDelivery.fromJson(e as Map<String, dynamic>))
          .toList();
      final total = body['total'] as int;
      final pg = body['page'] as int;
      return (deliveries: deliveries, total: total, page: pg);
    } on DioException catch (e) {
      throw Exception(ApiClient.extractErrorMessage(e));
    }
  }
}
