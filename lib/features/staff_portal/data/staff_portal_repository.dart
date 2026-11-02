import 'dart:io';
import 'package:dio/dio.dart';
import '../../../core/network/api_client.dart';
import '../../../core/network/api_endpoints.dart';
import '../domain/models/staff_self.dart';

/// Data access for the logged-in staff member's own self-service endpoints.
class StaffPortalRepository {
  final ApiClient _api;
  StaffPortalRepository(this._api);

  /// GET /staff/me — the staff member's own info + pay.
  Future<StaffSelfInfo> getMyInfo() async {
    try {
      final response = await _api.get(ApiEndpoints.staffMe);
      return StaffSelfInfo.fromJson(ApiClient.extractData(response));
    } on DioException catch (e) {
      throw Exception(ApiClient.extractErrorMessage(e));
    }
  }

  /// GET /staff/me/salary-history — the staff member's own pay history.
  Future<List<StaffPayTransaction>> getMySalaryHistory() async {
    try {
      final response = await _api.get(ApiEndpoints.staffMeSalaryHistory);
      // `data` is a JSON array, so we can't use extractData (which casts to Map).
      final list = (response.data as Map<String, dynamic>)['data'] as List;
      return list
          .map((e) => StaffPayTransaction.fromJson(e as Map<String, dynamic>))
          .toList();
    } on DioException catch (e) {
      throw Exception(ApiClient.extractErrorMessage(e));
    }
  }

  /// POST /staff/me/qr — upload the staff member's own payment QR image.
  /// Returns the stored Cloudinary URL.
  Future<String> uploadMyQr(File image) async {
    try {
      final formData = FormData.fromMap({
        'image': await MultipartFile.fromFile(
          image.path,
          filename: 'staff_qr.jpg',
        ),
      });
      final response =
          await _api.postFormData(ApiEndpoints.staffMeQr, formData: formData);
      final data = ApiClient.extractData(response);
      return data['qrCodeUrl'] as String;
    } on DioException catch (e) {
      throw Exception(ApiClient.extractErrorMessage(e));
    }
  }
}
