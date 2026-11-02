import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/utils/app_logger.dart';
import '../../domain/repositories/membership_repository.dart';
import 'membership_state.dart';

/// Drives the membership banner on the shared ledger screen for a single link.
/// One per screen (factory in DI). Handles load + vendor/customer mutations and
/// reloads status after each so the banner always reflects the server.
class MembershipCubit extends Cubit<MembershipState> {
  final MembershipRepository _repo;
  final String linkId;

  static const _m = 'Membership';

  MembershipCubit(this._repo, this.linkId) : super(const MembershipInitial());

  Future<void> load() async {
    emit(const MembershipLoading());
    try {
      final status = await _repo.getStatus(linkId);
      emit(MembershipLoaded(status));
    } catch (e) {
      AppLogger.e(_m, 'Load failed for link:$linkId', e);
      emit(MembershipError(_clean(e)));
    }
  }

  /// Silent reload (e.g. triggered by a socket event) — keeps the banner visible.
  Future<void> reload() async {
    try {
      final status = await _repo.getStatus(linkId);
      emit(MembershipLoaded(status));
    } catch (e) {
      AppLogger.e(_m, 'Reload failed for link:$linkId', e);
      // Keep existing state on failure.
    }
  }

  /// Vendor: enroll the customer directly into a plan.
  Future<void> enroll(String planId) => _mutate(() async {
        await _repo.enroll(linkId, planId);
        await reload();
      });

  /// Customer: apply for a plan.
  Future<void> requestPlan(String planId, {String? message}) => _mutate(() async {
        await _repo.requestPlan(linkId, planId, message: message);
        await reload();
      });

  /// Vendor/staff: mark a quota benefit used on the active membership.
  Future<void> useBenefit(String membershipId, String benefitId) => _mutate(() async {
        await _repo.useBenefit(membershipId, benefitId);
        await reload();
      });

  /// Vendor-only correction: decrement a benefit's used count by 1 (floors at 0).
  Future<void> decrementBenefit(String membershipId, String benefitId) => _mutate(() async {
        await _repo.decrementBenefit(membershipId, benefitId);
        await reload();
      });

  /// Vendor: approve the pending request.
  Future<void> approve(String requestId) => _mutate(() async {
        await _repo.approveRequest(requestId);
        await reload();
      });

  /// Vendor: decline the pending request.
  Future<void> decline(String requestId) => _mutate(() async {
        await _repo.declineRequest(requestId);
        await reload();
      });

  Future<void> _mutate(Future<void> Function() action) async {
    final current = state;
    if (current is MembershipLoaded) {
      emit(current.copyWith(actionInProgress: true));
    }
    try {
      await action();
    } catch (e) {
      AppLogger.e(_m, 'Membership action failed for link:$linkId', e);
      // Surface the error then restore the last good banner so buttons re-enable.
      emit(MembershipError(_clean(e)));
      if (current is MembershipLoaded) {
        emit(current.copyWith(actionInProgress: false));
      }
    }
  }

  String _clean(Object e) => e.toString().replaceFirst('Exception: ', '');
}
