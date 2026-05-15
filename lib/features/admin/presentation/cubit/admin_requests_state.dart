part of 'admin_requests_cubit.dart';

sealed class AdminRequestsState extends Equatable {
  const AdminRequestsState();

  const factory AdminRequestsState.initial() = _RequestsInitial;
  const factory AdminRequestsState.loading() = _RequestsLoading;
  const factory AdminRequestsState.loaded({
    required AdminRequestsPage page,
    required AdminRequestsFilter filter,
  }) = _RequestsLoaded;
  const factory AdminRequestsState.error(String message) = _RequestsError;

  @override
  List<Object?> get props => [];

  bool get isInitial => this is _RequestsInitial;
  bool get isLoading => this is _RequestsLoading;
  bool get hasError => this is _RequestsError;
  bool get hasData => this is _RequestsLoaded;

  String? get errorMessage => this is _RequestsError ? (this as _RequestsError).message : null;
  AdminRequestsPage? get pageOrNull => this is _RequestsLoaded ? (this as _RequestsLoaded).page : null;
  AdminRequestsFilter get currentFilter => 
      this is _RequestsLoaded ? (this as _RequestsLoaded).filter : const AdminRequestsFilter();
}

class _RequestsInitial extends AdminRequestsState {
  const _RequestsInitial();
}

class _RequestsLoading extends AdminRequestsState {
  const _RequestsLoading();
}

class _RequestsLoaded extends AdminRequestsState {
  final AdminRequestsPage page;
  final AdminRequestsFilter filter;

  const _RequestsLoaded({
    required this.page,
    required this.filter,
  });

  @override
  List<Object?> get props => [page, filter];
}

class _RequestsError extends AdminRequestsState {
  final String message;

  const _RequestsError(this.message);

  @override
  List<Object?> get props => [message];
}
