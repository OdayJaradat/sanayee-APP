import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../domain/entities/admin_dashboard_stats.dart';
import '../../domain/entities/admin_report.dart';
import '../../domain/repositories/admin_repository.dart';

part 'admin_dashboard_state.dart';

/// Note: Uses manual DI via AdminInjection (not Injectable)
class AdminDashboardCubit extends Cubit<AdminDashboardState> {
  final AdminRepository _repository;

  AdminDashboardCubit(this._repository) : super(const AdminDashboardState.initial());

  Future<void> load() async {
    emit(const AdminDashboardState.loading());

    // Load stats and recent activity in parallel
    final statsResult = await _repository.getDashboardStats();
    final activityResult = await _repository.getRecentActivity(limit: 10);

    statsResult.when(
      ok: (stats) {
        final recentActivity = activityResult.when(
          ok: (reports) => reports,
          err: (_) => <AdminReport>[],
        );
        emit(AdminDashboardState.loaded(stats, recentActivity));
      },
      err: (failure) => emit(AdminDashboardState.error(failure.message)),
    );
  }

  Future<void> refresh() async {
    await load();
  }
}
