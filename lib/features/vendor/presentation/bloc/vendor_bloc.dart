import 'package:flutter_bloc/flutter_bloc.dart';
import 'vendor_event.dart';
import 'vendor_state.dart';
import '../../domain/repositories/vendor_repository.dart';
import '../../../../core/utils/app_logger.dart';

class VendorBloc extends Bloc<VendorEvent, VendorState> {
  final VendorRepository _repository;

  static const _m = 'Vendor';

  VendorBloc(this._repository) : super(VendorInitial()) {
    on<LoadVendorDashboard>(_onLoadDashboard);
    on<RemindAllRequested>(_onRemindAll);
  }

  Future<void> _onLoadDashboard(
    LoadVendorDashboard event,
    Emitter<VendorState> emit,
  ) async {
    AppLogger.i(_m, 'Loading vendor dashboard...');
    emit(VendorLoading());
    try {
      final results = await Future.wait([
        _repository.getLinkedCustomers(),
        _repository.getVendorSummary(),
        _repository.getLinkedVendors(),
      ]);
      final customers = results[0] as List;
      final summary = results[1] as dynamic;
      final myVendors = results[2] as List;
      AppLogger.i(_m, 'Dashboard loaded — ${customers.length} customers, '
          '${myVendors.length} my-vendors, '
          'outstanding:${summary.totalOutstanding}');
      emit(VendorLoaded(
        customers: customers.cast(),
        myVendors: myVendors.cast(),
        totalOutstanding: summary.totalOutstanding as double,
        todayCollection: summary.totalCollectedToday as double,
      ));
    } catch (e) {
      AppLogger.e(_m, 'Dashboard load failed', e);
      emit(const VendorError('Failed to load dashboard'));
    }
  }

  Future<void> _onRemindAll(
    RemindAllRequested event,
    Emitter<VendorState> emit,
  ) async {
    final current = state;
    if (current is! VendorLoaded) return;
    if (current.remindAllStatus == RemindAllStatus.loading) return;

    AppLogger.i(_m, 'Remind-all requested');
    emit(current.copyWith(remindAllStatus: RemindAllStatus.loading));

    try {
      final result = await _repository.remindAll();
      AppLogger.i(_m, 'Remind-all done — queued:${result.queued}');
      emit(current.copyWith(
        remindAllStatus: RemindAllStatus.success,
        remindAllQueued: result.queued,
      ));
    } catch (e) {
      AppLogger.e(_m, 'Remind-all failed', e);
      emit(current.copyWith(remindAllStatus: RemindAllStatus.failure));
    }
  }
}
