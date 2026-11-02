import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/utils/app_logger.dart';
import '../../domain/models/membership_plan.dart';
import '../../domain/repositories/membership_repository.dart';

sealed class PlansState {
  const PlansState();
}

class PlansLoading extends PlansState {
  const PlansLoading();
}

class PlansLoaded extends PlansState {
  final List<MembershipPlan> plans;
  final bool saving;
  const PlansLoaded(this.plans, {this.saving = false});
  PlansLoaded copyWith({List<MembershipPlan>? plans, bool? saving}) =>
      PlansLoaded(plans ?? this.plans, saving: saving ?? this.saving);
}

class PlansError extends PlansState {
  final String message;
  const PlansError(this.message);
}

class PlansCubit extends Cubit<PlansState> {
  final MembershipRepository _repo;
  static const _m = 'Plans';

  PlansCubit(this._repo) : super(const PlansLoading());

  Future<void> load() async {
    emit(const PlansLoading());
    try {
      emit(PlansLoaded(await _repo.getPlans()));
    } catch (e) {
      AppLogger.e(_m, 'Load plans failed', e);
      emit(PlansError(_clean(e)));
    }
  }

  Future<bool> createPlan({
    required String name,
    required int durationDays,
    required double price,
    required double advanceRequired,
    required List<PlanBenefit> benefits,
  }) async {
    _setSaving(true);
    try {
      await _repo.createPlan(
        name: name,
        durationDays: durationDays,
        price: price,
        advanceRequired: advanceRequired,
        benefits: benefits,
      );
      emit(PlansLoaded(await _repo.getPlans()));
      return true;
    } catch (e) {
      AppLogger.e(_m, 'Create plan failed', e);
      emit(PlansError(_clean(e)));
      emit(PlansLoaded(await _safePlans()));
      return false;
    }
  }

  Future<bool> updatePlan(
    String planId, {
    String? name,
    int? durationDays,
    double? price,
    double? advanceRequired,
    bool? isActive,
    List<PlanBenefit>? benefits,
  }) async {
    _setSaving(true);
    try {
      await _repo.updatePlan(
        planId,
        name: name,
        durationDays: durationDays,
        price: price,
        advanceRequired: advanceRequired,
        isActive: isActive,
        benefits: benefits,
      );
      emit(PlansLoaded(await _repo.getPlans()));
      return true;
    } catch (e) {
      AppLogger.e(_m, 'Update plan failed', e);
      emit(PlansError(_clean(e)));
      emit(PlansLoaded(await _safePlans()));
      return false;
    }
  }

  Future<bool> deletePlan(String planId) async {
    _setSaving(true);
    try {
      await _repo.deletePlan(planId);
      emit(PlansLoaded(await _repo.getPlans()));
      return true;
    } catch (e) {
      AppLogger.e(_m, 'Delete plan failed', e);
      emit(PlansError(_clean(e)));
      emit(PlansLoaded(await _safePlans()));
      return false;
    }
  }

  void _setSaving(bool v) {
    final s = state;
    if (s is PlansLoaded) emit(s.copyWith(saving: v));
  }

  Future<List<MembershipPlan>> _safePlans() async {
    try {
      return await _repo.getPlans();
    } catch (_) {
      return const [];
    }
  }

  String _clean(Object e) => e.toString().replaceFirst('Exception: ', '');
}
