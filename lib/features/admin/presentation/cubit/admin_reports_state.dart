part of 'admin_reports_cubit.dart';

sealed class AdminReportsState extends Equatable {
  const AdminReportsState();

  const factory AdminReportsState.initial() = _ReportsInitial;
  const factory AdminReportsState.loading() = _ReportsLoading;
  const factory AdminReportsState.loaded({
    required AdminReportsPage page,
    required AdminReportsFilter filter,
  }) = _ReportsLoaded;
  const factory AdminReportsState.error(String message) = _ReportsError;

  @override
  List<Object?> get props => [];

  bool get isInitial => this is _ReportsInitial;
  bool get isLoading => this is _ReportsLoading;
  bool get hasError => this is _ReportsError;
  bool get hasData => this is _ReportsLoaded;

  String? get errorMessage =>
      this is _ReportsError ? (this as _ReportsError).message : null;
  AdminReportsPage? get pageOrNull =>
      this is _ReportsLoaded ? (this as _ReportsLoaded).page : null;
  AdminReportsFilter get currentFilter => this is _ReportsLoaded
      ? (this as _ReportsLoaded).filter
      : const AdminReportsFilter();
}

class _ReportsInitial extends AdminReportsState {
  const _ReportsInitial();
}

class _ReportsLoading extends AdminReportsState {
  const _ReportsLoading();
}

class _ReportsLoaded extends AdminReportsState {
  final AdminReportsPage page;
  final AdminReportsFilter filter;

  const _ReportsLoaded({
    required this.page,
    required this.filter,
  });

  @override
  List<Object?> get props => [page, filter];
}

class _ReportsError extends AdminReportsState {
  final String message;

  const _ReportsError(this.message);

  @override
  List<Object?> get props => [message];
}
