import 'dart:io';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../../shared/models/link_model.dart';
import '../../../vendor/domain/repositories/vendor_repository.dart';
import '../../data/staff_portal_repository.dart';
import '../../domain/models/staff_self.dart';

class StaffPortalState extends Equatable {
  final bool loading;
  final String? error;
  final List<CustomerLinkItem> customers;
  final StaffSelfInfo? me;

  const StaffPortalState({
    this.loading = true,
    this.error,
    this.customers = const [],
    this.me,
  });

  StaffPortalState copyWith({
    bool? loading,
    String? error,
    List<CustomerLinkItem>? customers,
    StaffSelfInfo? me,
  }) =>
      StaffPortalState(
        loading: loading ?? this.loading,
        error: error,
        customers: customers ?? this.customers,
        me: me ?? this.me,
      );

  @override
  List<Object?> get props => [loading, error, customers, me];
}

/// Loads the staff member's customer list (the owner vendor's customers) and
/// their own self info. Shared across the staff Home / Customers / My Pay tabs.
class StaffPortalCubit extends Cubit<StaffPortalState> {
  final VendorRepository _vendorRepo;
  final StaffPortalRepository _portalRepo;

  StaffPortalCubit(this._vendorRepo, this._portalRepo)
      : super(const StaffPortalState());

  Future<void> load() async {
    emit(state.copyWith(loading: true, error: null));
    try {
      final results = await Future.wait([
        _vendorRepo.getLinkedCustomers(),
        _portalRepo.getMyInfo(),
      ]);
      emit(state.copyWith(
        loading: false,
        customers: results[0] as List<CustomerLinkItem>,
        me: results[1] as StaffSelfInfo,
      ));
    } catch (e) {
      emit(state.copyWith(
        loading: false,
        error: e.toString().replaceFirst('Exception: ', ''),
      ));
    }
  }

  Future<String?> uploadQr(File image) async {
    try {
      final url = await _portalRepo.uploadMyQr(image);
      if (state.me != null) {
        emit(state.copyWith(me: state.me!.copyWith(qrCodeUrl: url)));
      }
      return null;
    } catch (e) {
      return e.toString().replaceFirst('Exception: ', '');
    }
  }
}
