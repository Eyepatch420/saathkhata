import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/repositories/staff_repository.dart';
import '../../../../shared/models/staff_model.dart';
import 'staff_event.dart';
import 'staff_state.dart';
import '../../../../core/utils/app_logger.dart';

class StaffBloc extends Bloc<StaffEvent, StaffState> {
  final StaffRepository _repository;

  static const _m = 'Staff';

  StaffBloc(this._repository) : super(StaffInitial()) {
    on<LoadStaff>(_onLoad);
    on<RefreshStaff>(_onRefresh);
    on<AddStaff>(_onAddStaff);
    on<MarkAttendance>(_onMarkAttendance);
    on<LoadAttendance>(_onLoadAttendance);
    on<PaySalary>(_onPaySalary);
    on<AddAdvance>(_onAddAdvance);
    on<AccrueSalary>(_onAccrueSalary);
    on<DeleteStaff>(_onDeleteStaff);
  }

  Future<void> _onLoad(LoadStaff event, Emitter<StaffState> emit) async {
    AppLogger.i(_m, 'Loading staff list...');
    emit(StaffLoading());
    try {
      final staff = await _repository.getStaffList();
      AppLogger.i(_m, 'Staff loaded — ${staff.length} members, ${staff.where((s) => s.presentToday).length} present today');
      emit(StaffLoaded(
        staffList: staff,
        presentCount: staff.where((s) => s.presentToday).length,
        totalUnpaidSalary: staff.fold(0, (sum, s) => sum + s.unpaidSalary),
      ));
    } catch (e) {
      AppLogger.e(_m, 'Staff load failed', e);
      emit(const StaffError('Failed to load staff'));
    }
  }

  Future<void> _onRefresh(RefreshStaff event, Emitter<StaffState> emit) async {
    AppLogger.i(_m, 'Refreshing staff list (silent)...');
    try {
      final staff = await _repository.getStaffList();
      emit(StaffLoaded(
        staffList: staff,
        presentCount: staff.where((s) => s.presentToday).length,
        totalUnpaidSalary: staff.fold(0, (sum, s) => sum + s.unpaidSalary),
      ));
    } catch (e) {
      AppLogger.e(_m, 'Staff refresh failed', e);
      // Keep the current state on failure — don't blank the list.
    }
  }

  Future<void> _onAddStaff(AddStaff event, Emitter<StaffState> emit) async {
    AppLogger.i(_m, 'Adding staff member: ${event.staff.name}');
    emit(StaffActionLoading());
    try {
      final newStaff = await _repository.addStaff(event.staff);
      AppLogger.i(_m, 'Staff added — id:${newStaff.id} name:${newStaff.name}');
      // Refetch the full list from the server instead of an optimistic append.
      // The optimistic emit was not reliably reflecting on screen (the new member
      // only appeared after a tab switch, which forces a fresh load). A refetch
      // guarantees the list — and the derived present/unpaid totals — are correct.
      add(LoadStaff());
    } catch (e) {
      AppLogger.e(_m, 'Add staff failed', e);
      emit(const StaffError('Failed to add staff'));
    }
  }

  Future<void> _onMarkAttendance(MarkAttendance event, Emitter<StaffState> emit) async {
    final current = state;
    AppLogger.i(_m, 'Marking attendance — staffId:${event.staffId} date:${event.date} status:${event.status.name}');
    try {
      await _repository.markAttendance(event.staffId, event.date, event.status);
      AppLogger.i(_m, 'Attendance marked');

      if (current is StaffDetailLoaded) {
        // Optimistic in-place update on the calendar
        final key =
            '${event.date.year}-${event.date.month.toString().padLeft(2, '0')}-${event.date.day.toString().padLeft(2, '0')}';
        final updated = Map<String, AttendanceStatus>.from(current.attendance)
          ..[key] = event.status;
        emit(StaffDetailLoaded(
          staff: current.staff,
          attendance: updated,
          year: current.year,
          month: current.month,
        ));
      } else if (current is StaffLoaded) {
        // Reload list so both presentToday and unpaidSalary (affected for daily staff) are fresh
        add(LoadStaff());
      }
    } catch (e) {
      AppLogger.e(_m, 'Mark attendance failed', e);
    }
  }

  Future<void> _onLoadAttendance(LoadAttendance event, Emitter<StaffState> emit) async {
    AppLogger.i(_m, 'Loading attendance — staffId:${event.staffId} ${event.year}/${event.month}');
    // Keep existing staff data visible during month navigation if we already have it
    final existing = state is StaffDetailLoaded ? (state as StaffDetailLoaded).staff : null;
    try {
      // Use provided staff model if available — avoids an extra list fetch
      final StaffModel target;
      if (event.staff != null) {
        target = event.staff!;
      } else if (existing != null && existing.id == event.staffId) {
        target = existing;
      } else {
        final list = await _repository.getStaffList();
        target = list.firstWhere((s) => s.id == event.staffId);
      }
      final attendance = await _repository.getAttendanceForMonth(event.staffId, event.year, event.month);
      AppLogger.i(_m, 'Attendance loaded — ${attendance.length} records for ${target.name}');
      emit(StaffDetailLoaded(
        staff: target,
        attendance: attendance,
        year: event.year,
        month: event.month,
      ));
    } catch (e) {
      AppLogger.e(_m, 'Load attendance failed for staffId:${event.staffId}', e);
      emit(const StaffError('Failed to load attendance'));
    }
  }

  Future<void> _onPaySalary(PaySalary event, Emitter<StaffState> emit) async {
    AppLogger.i(_m, 'Paying salary — staffId:${event.staffId} amount:${event.amount}');
    final current = state;
    emit(StaffActionLoading());
    try {
      await _repository.paySalary(event.staffId, event.amount, event.upiTransactionId);
      AppLogger.i(_m, 'Salary paid — staffId:${event.staffId}');
      if (current is StaffDetailLoaded) {
        // StaffActionLoading was emitted above — existing will be null in LoadAttendance handler
        // which forces a full getStaffList() refetch to get the accurate unpaidSalary.
        add(LoadAttendance(staffId: event.staffId, year: current.year, month: current.month));
      } else if (current is StaffLoaded) {
        final updated = current.staffList.map((s) {
          if (s.id != event.staffId) return s;
          return s.copyWith(unpaidSalary: (s.unpaidSalary - event.amount).clamp(0, double.infinity));
        }).toList();
        emit(StaffLoaded(
          staffList: updated,
          presentCount: updated.where((s) => s.presentToday).length,
          totalUnpaidSalary: updated.fold(0, (sum, s) => sum + s.unpaidSalary),
        ));
      } else {
        add(LoadStaff());
      }
    } catch (e) {
      AppLogger.e(_m, 'Pay salary failed for staffId:${event.staffId}', e);
      emit(const StaffError('Failed to pay salary'));
    }
  }

  Future<void> _onAddAdvance(AddAdvance event, Emitter<StaffState> emit) async {
    AppLogger.i(_m, 'Adding advance — staffId:${event.staffId} amount:${event.amount}');
    final current = state;
    try {
      await _repository.addAdvance(event.staffId, event.amount, event.note);
      AppLogger.i(_m, 'Advance recorded');
      if (current is StaffDetailLoaded) {
        // Optimistically update advanceTaken so the UI reflects it immediately.
        // Attendance data is unchanged — no reload needed.
        emit(StaffDetailLoaded(
          staff: current.staff.copyWith(
            advanceTaken: current.staff.advanceTaken + event.amount,
          ),
          attendance: current.attendance,
          year: current.year,
          month: current.month,
        ));
      } else {
        add(LoadStaff());
      }
    } catch (e) {
      AppLogger.e(_m, 'Add advance failed', e);
    }
  }

  Future<void> _onDeleteStaff(DeleteStaff event, Emitter<StaffState> emit) async {
    final current = state;
    final staffName = current is StaffDetailLoaded ? current.staff.name : '';
    AppLogger.i(_m, 'Deleting staff — staffId:${event.staffId}');
    emit(StaffActionLoading());
    try {
      await _repository.deleteStaff(event.staffId);
      AppLogger.i(_m, 'Staff deleted — staffId:${event.staffId}');
      emit(StaffDeleted(staffName));
    } catch (e) {
      AppLogger.e(_m, 'Delete staff failed', e);
      emit(const StaffError('Failed to remove staff member'));
    }
  }

  Future<void> _onAccrueSalary(AccrueSalary event, Emitter<StaffState> emit) async {
    AppLogger.i(_m, 'Accruing salary — staffId:${event.staffId}');
    final current = state;
    emit(StaffActionLoading());
    try {
      final updated = await _repository.accrueSalary(event.staffId);
      AppLogger.i(_m, 'Salary accrued — unpaidSalary:${updated.unpaidSalary}');
      if (current is StaffDetailLoaded) {
        emit(StaffDetailLoaded(
          staff: updated,
          attendance: current.attendance,
          year: current.year,
          month: current.month,
        ));
      } else {
        add(LoadStaff());
      }
    } catch (e) {
      AppLogger.e(_m, 'Accrue salary failed', e);
      emit(const StaffError('Failed to accrue salary'));
    }
  }
}
