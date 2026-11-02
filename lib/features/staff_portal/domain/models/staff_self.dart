import 'package:equatable/equatable.dart';

/// The logged-in staff member's own info + pay (GET /staff/me).
class StaffSelfInfo extends Equatable {
  final String staffId;
  final String name;
  final String phone;
  final String role;
  final String salaryType;
  final double salaryAmount;
  final double unpaidSalary;
  final double advanceTaken;
  final String? qrCodeUrl;
  final String vendorId;

  const StaffSelfInfo({
    required this.staffId,
    required this.name,
    required this.phone,
    required this.role,
    required this.salaryType,
    required this.salaryAmount,
    required this.unpaidSalary,
    required this.advanceTaken,
    required this.qrCodeUrl,
    required this.vendorId,
  });

  factory StaffSelfInfo.fromJson(Map<String, dynamic> json) => StaffSelfInfo(
        staffId: json['staffId'] as String,
        name: json['name'] as String,
        phone: json['phone'] as String,
        role: json['role'] as String,
        salaryType: json['salaryType'] as String,
        salaryAmount: (json['salaryAmount'] as num?)?.toDouble() ?? 0,
        unpaidSalary: (json['unpaidSalary'] as num?)?.toDouble() ?? 0,
        advanceTaken: (json['advanceTaken'] as num?)?.toDouble() ?? 0,
        qrCodeUrl: json['qrCodeUrl'] as String?,
        vendorId: json['vendorId'] as String,
      );

  StaffSelfInfo copyWith({String? qrCodeUrl}) => StaffSelfInfo(
        staffId: staffId,
        name: name,
        phone: phone,
        role: role,
        salaryType: salaryType,
        salaryAmount: salaryAmount,
        unpaidSalary: unpaidSalary,
        advanceTaken: advanceTaken,
        qrCodeUrl: qrCodeUrl ?? this.qrCodeUrl,
        vendorId: vendorId,
      );

  @override
  List<Object?> get props => [
        staffId, name, phone, role, salaryType, salaryAmount,
        unpaidSalary, advanceTaken, qrCodeUrl, vendorId,
      ];
}

/// One salary/advance transaction in the staff member's own history.
class StaffPayTransaction extends Equatable {
  final String id;
  final double amount;
  final String type; // 'salary' | 'advance'
  final String? note;
  final DateTime createdAt;

  const StaffPayTransaction({
    required this.id,
    required this.amount,
    required this.type,
    required this.note,
    required this.createdAt,
  });

  factory StaffPayTransaction.fromJson(Map<String, dynamic> json) =>
      StaffPayTransaction(
        id: json['id'] as String,
        amount: (json['amount'] as num).toDouble(),
        type: json['type'] as String,
        note: json['note'] as String?,
        createdAt: DateTime.parse(json['createdAt'] as String),
      );

  @override
  List<Object?> get props => [id, amount, type, note, createdAt];
}
