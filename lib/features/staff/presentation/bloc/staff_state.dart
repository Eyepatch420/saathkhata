import 'package:equatable/equatable.dart';
import '../../../../shared/models/staff_model.dart';

abstract class StaffState extends Equatable {
  const StaffState();
  @override
  List<Object?> get props => [];
}

class StaffInitial extends StaffState {}

class StaffLoading extends StaffState {}

class StaffLoaded extends StaffState {
  final List<StaffModel> staffList;
  final int presentCount;
  final double totalUnpaidSalary;

  const StaffLoaded({
    required this.staffList,
    required this.presentCount,
    required this.totalUnpaidSalary,
  });

  @override
  List<Object?> get props => [staffList, presentCount, totalUnpaidSalary];
}

class StaffDetailLoaded extends StaffState {
  final StaffModel staff;
  final Map<String, AttendanceStatus> attendance;
  final int year;
  final int month;

  const StaffDetailLoaded({
    required this.staff,
    required this.attendance,
    required this.year,
    required this.month,
  });

  @override
  List<Object?> get props => [staff, attendance, year, month];
}

class StaffActionLoading extends StaffState {}

class StaffError extends StaffState {
  final String message;
  const StaffError(this.message);
  @override
  List<Object?> get props => [message];
}

class StaffDeleted extends StaffState {
  final String staffName;
  const StaffDeleted(this.staffName);
  @override
  List<Object?> get props => [staffName];
}
