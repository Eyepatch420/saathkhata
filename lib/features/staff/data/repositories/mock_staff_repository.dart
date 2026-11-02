import '../../domain/repositories/staff_repository.dart';
import '../../../../shared/models/staff_model.dart';
import '../../../staff_portal/domain/models/staff_self.dart';

class MockStaffRepository implements StaffRepository {
  final List<StaffModel> _staff = [
    StaffModel(
      id: 's1',
      vendorId: 'v1',
      name: 'Mohan Lal',
      phone: '9876543001',
      role: 'Helper',
      salaryType: SalaryType.daily,
      salaryAmount: 500,
      upiId: 'mohan@upi',
      joinDate: DateTime(2025, 1, 15),
      presentToday: true,
      unpaidSalary: 4500,
      advanceTaken: 500,
    ),
    StaffModel(
      id: 's2',
      vendorId: 'v1',
      name: 'Sunita Devi',
      phone: '9876543002',
      role: 'Cook',
      salaryType: SalaryType.monthly,
      salaryAmount: 8000,
      joinDate: DateTime(2024, 6, 1),
      presentToday: true,
      unpaidSalary: 8000,
      advanceTaken: 0,
    ),
    StaffModel(
      id: 's3',
      vendorId: 'v1',
      name: 'Raju Verma',
      phone: '9876543003',
      role: 'Delivery',
      salaryType: SalaryType.daily,
      salaryAmount: 400,
      joinDate: DateTime(2025, 3, 10),
      presentToday: false,
      unpaidSalary: 3200,
      advanceTaken: 0,
    ),
  ];

  final Map<String, Map<String, AttendanceStatus>> _attendance = {};

  @override
  Future<List<StaffModel>> getStaffList() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return List.from(_staff);
  }

  @override
  Future<StaffModel> addStaff(StaffModel staff) async {
    await Future.delayed(const Duration(milliseconds: 400));
    final newStaff = StaffModel(
      id: 's${_staff.length + 1}',
      vendorId: staff.vendorId,
      name: staff.name,
      phone: staff.phone,
      role: staff.role,
      salaryType: staff.salaryType,
      salaryAmount: staff.salaryAmount,
      upiId: staff.upiId,
      joinDate: staff.joinDate,
    );
    _staff.add(newStaff);
    return newStaff;
  }

  @override
  Future<StaffModel> updateStaff(StaffModel staff) async {
    await Future.delayed(const Duration(milliseconds: 300));
    final index = _staff.indexWhere((s) => s.id == staff.id);
    if (index != -1) _staff[index] = staff;
    return staff;
  }

  @override
  Future<void> markAttendance(String staffId, DateTime date, AttendanceStatus status) async {
    await Future.delayed(const Duration(milliseconds: 300));
    _attendance[staffId] ??= {};
    final dateKey = '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
    _attendance[staffId]![dateKey] = status;

    final index = _staff.indexWhere((s) => s.id == staffId);
    if (index != -1 && date.day == DateTime.now().day) {
      _staff[index] = _staff[index].copyWith(presentToday: status == AttendanceStatus.present);
    }
  }

  @override
  Future<Map<String, AttendanceStatus>> getAttendanceForMonth(String staffId, int year, int month) async {
    await Future.delayed(const Duration(milliseconds: 400));
    final result = <String, AttendanceStatus>{};
    final daysInMonth = DateTime(year, month + 1, 0).day;
    for (int day = 1; day <= daysInMonth; day++) {
      final date = DateTime(year, month, day);
      if (date.isAfter(DateTime.now())) continue;
      final dateKey = '$year-${month.toString().padLeft(2, '0')}-${day.toString().padLeft(2, '0')}';
      final staffAttendance = _attendance[staffId];
      if (staffAttendance != null && staffAttendance.containsKey(dateKey)) {
        result[dateKey] = staffAttendance[dateKey]!;
      } else if (date.weekday != DateTime.sunday) {
        result[dateKey] = day % 7 == 0 ? AttendanceStatus.absent : AttendanceStatus.present;
      }
    }
    return result;
  }

  @override
  Future<void> paySalary(String staffId, double amount, String? upiTransactionId) async {
    await Future.delayed(const Duration(milliseconds: 500));
    final index = _staff.indexWhere((s) => s.id == staffId);
    if (index != -1) {
      _staff[index] = _staff[index].copyWith(unpaidSalary: 0);
    }
  }

  @override
  Future<void> addAdvance(String staffId, double amount, String? note) async {
    await Future.delayed(const Duration(milliseconds: 300));
    final index = _staff.indexWhere((s) => s.id == staffId);
    if (index != -1) {
      _staff[index] = _staff[index].copyWith(
        advanceTaken: _staff[index].advanceTaken + amount,
      );
    }
  }

  @override
  Future<StaffModel> accrueSalary(String staffId) async {
    await Future.delayed(const Duration(milliseconds: 400));
    final index = _staff.indexWhere((s) => s.id == staffId);
    if (index == -1) throw Exception('Staff not found');
    final s = _staff[index];
    _staff[index] = s.copyWith(unpaidSalary: s.unpaidSalary + s.salaryAmount);
    return _staff[index];
  }

  @override
  Future<StaffModel> setAppAccess(String staffId, bool canLogin) async {
    await Future.delayed(const Duration(milliseconds: 300));
    final index = _staff.indexWhere((s) => s.id == staffId);
    if (index == -1) throw Exception('Staff not found');
    _staff[index] = _staff[index]
        .copyWith(canLogin: canLogin, hasAppAccount: canLogin);
    return _staff[index];
  }

  @override
  Future<List<StaffPayTransaction>> getSalaryHistory(String staffId) async {
    await Future.delayed(const Duration(milliseconds: 300));
    return const [];
  }

  @override
  Future<void> deleteStaff(String staffId) async {
    await Future.delayed(const Duration(milliseconds: 300));
    _staff.removeWhere((s) => s.id == staffId);
  }
}
