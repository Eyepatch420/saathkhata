import 'package:dio/dio.dart';
import '../../../../core/network/api_client.dart';
import '../../../../core/network/api_endpoints.dart';
import '../../domain/repositories/staff_repository.dart';
import '../../../../shared/models/staff_model.dart';
import '../../../staff_portal/domain/models/staff_self.dart';

class StaffRepositoryImpl implements StaffRepository {
  final ApiClient _api;

  StaffRepositoryImpl(this._api);

  // ─── Helpers ───────────────────────────────────────────────────────────────

  String _fmtDate(DateTime d) =>
      '${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';

  /// Normalises a date key from the backend to "YYYY-MM-DD".
  /// The backend may return an ISO string ("2026-05-01T00:00:00.000Z"),
  /// a plain date string ("2026-05-01"), or a JS Date toString like
  /// "Fri May 01 2026 00:00:00 GMT+0000" where split('T') breaks at 'GMT'.
  String _normalizeDateKey(String key) {
    // Already in YYYY-MM-DD
    if (RegExp(r'^\d{4}-\d{2}-\d{2}$').hasMatch(key)) return key;
    // ISO datetime: "2026-05-01T..."
    if (key.length >= 10 && key[4] == '-' && key[7] == '-') return key.substring(0, 10);
    // JS Date.toString(): "Fri May 01 2026 00:00:00 GMT..."
    try {
      final parts = key.split(' ');
      // parts: ["Fri", "May", "01", "2026", ...]
      if (parts.length >= 4) {
        const months = {
          'Jan': '01', 'Feb': '02', 'Mar': '03', 'Apr': '04',
          'May': '05', 'Jun': '06', 'Jul': '07', 'Aug': '08',
          'Sep': '09', 'Oct': '10', 'Nov': '11', 'Dec': '12',
        };
        final month = months[parts[1]];
        final day = parts[2].padLeft(2, '0');
        final year = parts[3];
        if (month != null) return '$year-$month-$day';
      }
    } catch (_) {}
    // Last resort: take first 10 chars
    return key.substring(0, 10);
  }

  // ─── Interface ─────────────────────────────────────────────────────────────

  @override
  Future<List<StaffModel>> getStaffList() async {
    try {
      final response = await _api.get(ApiEndpoints.staff);
      // data is a JSON array directly
      final list = (response.data as Map<String, dynamic>)['data'] as List;
      return list
          .map((e) => StaffModel.fromJson(e as Map<String, dynamic>))
          .toList();
    } on DioException catch (e) {
      throw Exception(ApiClient.extractErrorMessage(e));
    }
  }

  @override
  Future<StaffModel> addStaff(StaffModel staff) async {
    try {
      final body = <String, dynamic>{
        'name': staff.name,
        'phone': staff.phone,
        'role': staff.role,
        'salaryType': staff.salaryType.toJson(),
        'salaryAmount': staff.salaryAmount,
        'joinDate': _fmtDate(staff.joinDate),
      };
      if (staff.upiId != null && staff.upiId!.isNotEmpty) {
        body['upiId'] = staff.upiId;
      }

      final response = await _api.post(ApiEndpoints.staff, data: body);
      return StaffModel.fromJson(ApiClient.extractData(response));
    } on DioException catch (e) {
      throw Exception(ApiClient.extractErrorMessage(e));
    }
  }

  @override
  Future<StaffModel> updateStaff(StaffModel staff) async {
    try {
      final body = <String, dynamic>{
        'name': staff.name,
        'phone': staff.phone,
        'role': staff.role,
        'salaryType': staff.salaryType.toJson(),
        'salaryAmount': staff.salaryAmount,
      };
      if (staff.upiId != null) body['upiId'] = staff.upiId;

      final response =
          await _api.patch(ApiEndpoints.staffById(staff.id), data: body);
      return StaffModel.fromJson(ApiClient.extractData(response));
    } on DioException catch (e) {
      throw Exception(ApiClient.extractErrorMessage(e));
    }
  }

  @override
  Future<void> markAttendance(
      String staffId, DateTime date, AttendanceStatus status) async {
    try {
      await _api.put(
        ApiEndpoints.staffAttendance(staffId),
        data: {
          'date': _fmtDate(date),
          'status': status.toJson(),
        },
      );
    } on DioException catch (e) {
      throw Exception(ApiClient.extractErrorMessage(e));
    }
  }

  @override
  Future<Map<String, AttendanceStatus>> getAttendanceForMonth(
      String staffId, int year, int month) async {
    try {
      final response = await _api.get(
        ApiEndpoints.staffAttendance(staffId),
        queryParameters: {'year': year, 'month': month},
      );
      // data is a plain object: { "YYYY-MM-DD": "present"|"absent"|... }
      final raw = ApiClient.extractData(response);
      return raw.map(
        // Normalize keys: strip any accidental time component from DATE strings
        (key, value) => MapEntry(
          _normalizeDateKey(key),
          AttendanceStatusX.fromString(value as String),
        ),
      );
    } on DioException catch (e) {
      throw Exception(ApiClient.extractErrorMessage(e));
    }
  }

  @override
  Future<void> paySalary(
      String staffId, double amount, String? upiTransactionId) async {
    try {
      final body = <String, dynamic>{'amount': amount};
      if (upiTransactionId != null && upiTransactionId.isNotEmpty) {
        body['upiTransactionId'] = upiTransactionId;
      }
      await _api.post(ApiEndpoints.staffPay(staffId), data: body);
    } on DioException catch (e) {
      throw Exception(ApiClient.extractErrorMessage(e));
    }
  }

  @override
  Future<void> addAdvance(String staffId, double amount, String? note) async {
    try {
      final body = <String, dynamic>{'amount': amount};
      if (note != null && note.isNotEmpty) body['note'] = note;
      await _api.post(ApiEndpoints.staffAdvance(staffId), data: body);
    } on DioException catch (e) {
      throw Exception(ApiClient.extractErrorMessage(e));
    }
  }

  @override
  Future<StaffModel> accrueSalary(String staffId) async {
    try {
      final response = await _api.post(ApiEndpoints.staffAccrue(staffId));
      return StaffModel.fromJson(ApiClient.extractData(response));
    } on DioException catch (e) {
      throw Exception(ApiClient.extractErrorMessage(e));
    }
  }

  @override
  Future<List<StaffPayTransaction>> getSalaryHistory(String staffId) async {
    try {
      final response = await _api.get(ApiEndpoints.staffSalaryHistory(staffId));
      // `data` is a JSON array, so we can't use extractData (which casts to Map).
      final list = (response.data as Map<String, dynamic>)['data'] as List;
      return list
          .map((e) => StaffPayTransaction.fromJson(e as Map<String, dynamic>))
          .toList();
    } on DioException catch (e) {
      throw Exception(ApiClient.extractErrorMessage(e));
    }
  }

  @override
  Future<StaffModel> setAppAccess(String staffId, bool canLogin) async {
    try {
      final response = await _api.patch(
        ApiEndpoints.staffAccess(staffId),
        data: {'canLogin': canLogin},
      );
      return StaffModel.fromJson(ApiClient.extractData(response));
    } on DioException catch (e) {
      throw Exception(ApiClient.extractErrorMessage(e));
    }
  }

  @override
  Future<void> deleteStaff(String staffId) async {
    try {
      await _api.delete(ApiEndpoints.staffById(staffId));
    } on DioException catch (e) {
      throw Exception(ApiClient.extractErrorMessage(e));
    }
  }
}
