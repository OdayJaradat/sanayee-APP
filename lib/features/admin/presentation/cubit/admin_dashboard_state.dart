part of 'admin_dashboard_cubit.dart';

sealed class AdminDashboardState extends Equatable {
  const AdminDashboardState();

  const factory AdminDashboardState.initial() = _Initial;
  const factory AdminDashboardState.loading() = _Loading;
  const factory AdminDashboardState.loaded(
    AdminDashboardStats stats,
    List<AdminReport> recentActivity,
  ) = _Loaded;
  const factory AdminDashboardState.error(String message) = _Error;

  @override
  List<Object?> get props => [];

  bool get isInitial => this is _Initial;
  bool get isLoading => this is _Loading;
  bool get hasError => this is _Error;
  bool get hasData => this is _Loaded;

  String? get errorMessage => this is _Error ? (this as _Error).message : null;
  AdminDashboardStats? get dataOrNull => this is _Loaded ? (this as _Loaded).stats : null;
  List<AdminReport> get recentActivityOrEmpty => 
      this is _Loaded ? (this as _Loaded).recentActivity : [];
}

class _Initial extends AdminDashboardState {
  const _Initial();
}

class _Loading extends AdminDashboardState {
  const _Loading();
}

class _Loaded extends AdminDashboardState {
  final AdminDashboardStats stats;
  final List<AdminReport> recentActivity;

  const _Loaded(this.stats, this.recentActivity);

  @override
  List<Object?> get props => [stats, recentActivity];
}

class _Error extends AdminDashboardState {
  final String message;

  const _Error(this.message);

  @override
  List<Object?> get props => [message];
}
