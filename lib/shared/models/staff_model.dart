import 'package:equatable/equatable.dart';

// Backend supports only 'daily' and 'monthly' — 'weekly' is not a valid value.
enum SalaryType { daily, monthly }

// JSON serialization: halfDay → "half_day", others are lowercase as-is.
enum AttendanceStatus { present, absent, halfDay, holiday }

extension SalaryTypeX on SalaryType {
  String toJson() => name;
}

extension AttendanceStatusX on AttendanceStatus {
  String toJson() => this == AttendanceStatus.halfDay ? 'half_day' : name;

  static AttendanceStatus fromString(String v) =>
      _attendanceStatusFromJson(v);
}

SalaryType _salaryTypeFromJson(String v) {
  if (v == 'weekly') return SalaryType.monthly; // backend has weekly; Flutter doesn't
  return SalaryType.values.firstWhere((e) => e.name == v,
      orElse: () => SalaryType.daily);
}

AttendanceStatus _attendanceStatusFromJson(String v) {
  if (v == 'half_day') return AttendanceStatus.halfDay;
  return AttendanceStatus.values.firstWhere((e) => e.name == v,
      orElse: () => AttendanceStatus.absent);
}

class StaffModel extends Equatable {
  final String id;
  final String vendorId;
  final String name;
  final String phone;
  final String role;
  final SalaryType salaryType;
  final double salaryAmount;
  final String? upiId;
  final DateTime joinDate;
  final bool isActive;
  final bool presentToday;
  final double unpaidSalary;
  final double advanceTaken;
  // App-access fields
  final bool canLogin;        // whether this staff can currently log into the app
  final bool hasAppAccount;   // whether a login account has been provisioned
  final String? qrCodeUrl;    // staff's own payment QR

  factory StaffModel.fromJson(Map<String, dynamic> json) => StaffModel(
        id: json['id'] as String,
        vendorId: json['vendorId'] as String,
        name: json['name'] as String,
        phone: json['phone'] as String,
        role: json['role'] as String,
        salaryType: _salaryTypeFromJson(json['salaryType'] as String),
        salaryAmount: (json['salaryAmount'] as num).toDouble(),
        upiId: json['upiId'] as String?,
        joinDate: DateTime.parse(json['joinDate'] as String),
        isActive: json['isActive'] as bool? ?? true,
        presentToday: json['presentToday'] as bool? ?? false,
        unpaidSalary: (json['unpaidSalary'] as num?)?.toDouble() ?? 0,
        advanceTaken: (json['advanceTaken'] as num?)?.toDouble() ?? 0,
        canLogin: json['canLogin'] as bool? ?? false,
        hasAppAccount: json['hasAppAccount'] as bool? ?? false,
        qrCodeUrl: json['qrCodeUrl'] as String?,
      );

  const StaffModel({
    required this.id,
    required this.vendorId,
    required this.name,
    required this.phone,
    required this.role,
    required this.salaryType,
    required this.salaryAmount,
    this.upiId,
    required this.joinDate,
    this.isActive = true,
    this.presentToday = false,
    this.unpaidSalary = 0,
    this.advanceTaken = 0,
    this.canLogin = false,
    this.hasAppAccount = false,
    this.qrCodeUrl,
  });

  StaffModel copyWith({
    bool? presentToday,
    double? unpaidSalary,
    double? advanceTaken,
    bool? isActive,
    bool? canLogin,
    bool? hasAppAccount,
    String? qrCodeUrl,
  }) {
    return StaffModel(
      id: id,
      vendorId: vendorId,
      name: name,
      phone: phone,
      role: role,
      salaryType: salaryType,
      salaryAmount: salaryAmount,
      upiId: upiId,
      joinDate: joinDate,
      isActive: isActive ?? this.isActive,
      presentToday: presentToday ?? this.presentToday,
      unpaidSalary: unpaidSalary ?? this.unpaidSalary,
      advanceTaken: advanceTaken ?? this.advanceTaken,
      canLogin: canLogin ?? this.canLogin,
      hasAppAccount: hasAppAccount ?? this.hasAppAccount,
      qrCodeUrl: qrCodeUrl ?? this.qrCodeUrl,
    );
  }

  @override
  List<Object?> get props => [
        id,
        vendorId,
        name,
        phone,
        role,
        salaryType,
        salaryAmount,
        upiId,
        joinDate,
        isActive,
        presentToday,
        unpaidSalary,
        advanceTaken,
        canLogin,
        hasAppAccount,
        qrCodeUrl,
      ];
}

class AttendanceRecord extends Equatable {
  final String staffId;
  final DateTime date;
  final AttendanceStatus status;

  const AttendanceRecord({
    required this.staffId,
    required this.date,
    required this.status,
  });

  factory AttendanceRecord.fromJson(Map<String, dynamic> json) =>
      AttendanceRecord(
        staffId: json['staffId'] as String,
        date: DateTime.parse(json['date'] as String),
        status: _attendanceStatusFromJson(json['status'] as String),
      );

  @override
  List<Object?> get props => [staffId, date, status];
}
