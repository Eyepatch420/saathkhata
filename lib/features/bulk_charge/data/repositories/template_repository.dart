import 'package:dio/dio.dart';
import '../../../../core/network/api_client.dart';
import '../../../../core/network/api_endpoints.dart';
import '../../../../shared/models/product_template.dart';

class TemplateRepository {
  final ApiClient _api;
  TemplateRepository(this._api);

  Future<List<ProductTemplate>> getTemplates() async {
    try {
      final response = await _api.get(ApiEndpoints.productTemplates);
      final body = response.data as Map<String, dynamic>;
      final list = body['data'] as List;
      return list
          .map(
            (e) =>
                ProductTemplate.fromJson(Map<String, dynamic>.from(e as Map)),
          )
          .toList();
    } on DioException catch (e) {
      throw Exception(ApiClient.extractErrorMessage(e));
    }
  }

  Future<ProductTemplate> createTemplate({
    required String name,
    required String unit,
    required double pricePerUnit,
  }) async {
    try {
      final response = await _api.post(
        ApiEndpoints.productTemplates,
        data: {'name': name, 'unit': unit, 'pricePerUnit': pricePerUnit},
      );
      return ProductTemplate.fromJson(ApiClient.extractData(response));
    } on DioException catch (e) {
      throw Exception(ApiClient.extractErrorMessage(e));
    }
  }

  Future<ProductTemplate> updateTemplate({
    required String id,
    String? name,
    String? unit,
    double? pricePerUnit,
  }) async {
    try {
      final body = <String, dynamic>{};
      if (name != null) body['name'] = name;
      if (unit != null) body['unit'] = unit;
      if (pricePerUnit != null) body['pricePerUnit'] = pricePerUnit;
      final response = await _api.patch(
        ApiEndpoints.productTemplateById(id),
        data: body,
      );
      final raw = response.data as Map<String, dynamic>;
      return ProductTemplate.fromJson(
        Map<String, dynamic>.from(raw['data'] as Map),
      );
    } on DioException catch (e) {
      throw Exception(ApiClient.extractErrorMessage(e));
    }
  }

  Future<void> deleteTemplate(String id) async {
    try {
      await _api.delete(ApiEndpoints.productTemplateById(id));
    } on DioException catch (e) {
      throw Exception(ApiClient.extractErrorMessage(e));
    }
  }

  Future<BulkChargeResult> bulkCharge({
    required String templateId,
    required bool isScheduleService,
    required List<BulkChargeItem> items,
    DateTime? date,
  }) async {
    try {
      final body = <String, dynamic>{
        isScheduleService ? 'scheduleServiceItemId' : 'templateId': templateId,
        'items': items.map((i) => i.toJson()).toList(),
      };
      if (date != null) body['date'] = date.toUtc().toIso8601String();

      final response = await _api.post(ApiEndpoints.bulkCharge, data: body);
      final raw = ApiClient.extractData(response);
      return BulkChargeResult.fromJson(Map<String, dynamic>.from(raw as Map));
    } on DioException catch (e) {
      throw Exception(ApiClient.extractErrorMessage(e));
    }
  }
}
