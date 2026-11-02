import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/utils/app_logger.dart';
import '../../domain/models/membership_request.dart';
import '../../domain/repositories/membership_repository.dart';

// ── State ─────────────────────────────────────────────────────────────────────

sealed class MembershipRequestsState {
  const MembershipRequestsState();
}

class MembershipRequestsLoading extends MembershipRequestsState {
  const MembershipRequestsLoading();
}

class MembershipRequestsLoaded extends MembershipRequestsState {
  final List<MembershipRequest> requests;
  final Set<String> busyIds; // request IDs currently being approved/declined

  const MembershipRequestsLoaded(this.requests, {this.busyIds = const {}});

  MembershipRequestsLoaded copyWith({
    List<MembershipRequest>? requests,
    Set<String>? busyIds,
  }) =>
      MembershipRequestsLoaded(
        requests ?? this.requests,
        busyIds: busyIds ?? this.busyIds,
      );
}

class MembershipRequestsError extends MembershipRequestsState {
  final String message;
  const MembershipRequestsError(this.message);
}

// ── Cubit ─────────────────────────────────────────────────────────────────────

class MembershipRequestsCubit extends Cubit<MembershipRequestsState> {
  final MembershipRepository _repo;
  static const _m = 'MembershipRequests';

  MembershipRequestsCubit(this._repo) : super(const MembershipRequestsLoading());

  Future<void> load() async {
    emit(const MembershipRequestsLoading());
    try {
      final requests = await _repo.getPendingRequests();
      emit(MembershipRequestsLoaded(requests));
    } catch (e) {
      AppLogger.e(_m, 'Load requests failed', e);
      emit(MembershipRequestsError(_clean(e)));
    }
  }

  Future<void> approve(String requestId) async {
    final current = state;
    if (current is! MembershipRequestsLoaded) return;
    emit(current.copyWith(busyIds: {...current.busyIds, requestId}));
    try {
      await _repo.approveRequest(requestId);
      final updated = current.requests
          .where((r) => r.id != requestId)
          .toList();
      emit(MembershipRequestsLoaded(updated));
    } catch (e) {
      AppLogger.e(_m, 'Approve failed', e);
      emit(current.copyWith(busyIds: current.busyIds.difference({requestId})));
      emit(MembershipRequestsError(_clean(e)));
    }
  }

  Future<void> decline(String requestId) async {
    final current = state;
    if (current is! MembershipRequestsLoaded) return;
    emit(current.copyWith(busyIds: {...current.busyIds, requestId}));
    try {
      await _repo.declineRequest(requestId);
      final updated = current.requests
          .where((r) => r.id != requestId)
          .toList();
      emit(MembershipRequestsLoaded(updated));
    } catch (e) {
      AppLogger.e(_m, 'Decline failed', e);
      emit(current.copyWith(busyIds: current.busyIds.difference({requestId})));
      emit(MembershipRequestsError(_clean(e)));
    }
  }

  String _clean(Object e) => e.toString().replaceFirst('Exception: ', '');
}
