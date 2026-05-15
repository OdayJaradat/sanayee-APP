part of 'admin_request_details_cubit.dart';

sealed class AdminRequestDetailsState extends Equatable {
  const AdminRequestDetailsState();

  const factory AdminRequestDetailsState.initial() = _RequestDetailsInitial;
  const factory AdminRequestDetailsState.loading() = _RequestDetailsLoading;
  const factory AdminRequestDetailsState.loaded(AdminRequestDetails details) = _RequestDetailsLoaded;
  const factory AdminRequestDetailsState.error(String message) = _RequestDetailsError;

  @override
  List<Object?> get props => [];

  bool get isInitial => this is _RequestDetailsInitial;
  bool get isLoading => this is _RequestDetailsLoading;
  bool get hasError => this is _RequestDetailsError;
  bool get hasData => this is _RequestDetailsLoaded;

  String? get errorMessage => this is _RequestDetailsError ? (this as _RequestDetailsError).message : null;
  AdminRequestDetails? get dataOrNull => this is _RequestDetailsLoaded ? (this as _RequestDetailsLoaded).details : null;
}

class _RequestDetailsInitial extends AdminRequestDetailsState {
  const _RequestDetailsInitial();
}

class _RequestDetailsLoading extends AdminRequestDetailsState {
  const _RequestDetailsLoading();
}

class _RequestDetailsLoaded extends AdminRequestDetailsState {
  final AdminRequestDetails details;

  const _RequestDetailsLoaded(this.details);

  @override
  List<Object?> get props => [details];
}

class _RequestDetailsError extends AdminRequestDetailsState {
  final String message;

  const _RequestDetailsError(this.message);

  @override
  List<Object?> get props => [message];
}
