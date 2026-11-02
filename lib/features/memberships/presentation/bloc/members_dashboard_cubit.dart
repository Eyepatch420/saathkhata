import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/utils/app_logger.dart';
import '../../domain/models/members_dashboard.dart';
import '../../domain/repositories/membership_repository.dart';

sealed class MembersDashboardState {
  const MembersDashboardState();
}

class MembersDashboardLoading extends MembersDashboardState {
  const MembersDashboardLoading();
}

class MembersDashboardLoaded extends MembersDashboardState {
  final MembersDashboard data;
  const MembersDashboardLoaded(this.data);
}

class MembersDashboardError extends MembersDashboardState {
  final String message;
  const MembersDashboardError(this.message);
}

class MembersDashboardCubit extends Cubit<MembersDashboardState> {
  final MembershipRepository _repo;
  static const _m = 'MembersDashboard';

  MembersDashboardCubit(this._repo) : super(const MembersDashboardLoading());

  Future<void> load() async {
    emit(const MembersDashboardLoading());
    try {
      emit(MembersDashboardLoaded(await _repo.getMembersDashboard()));
    } catch (e) {
      AppLogger.e(_m, 'Load members dashboard failed', e);
      emit(MembersDashboardError(_clean(e)));
    }
  }

  String _clean(Object e) => e.toString().replaceFirst('Exception: ', '');
}
