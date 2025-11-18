part of 'requests_cubit.dart';

sealed class RequestsState extends Equatable {
  const RequestsState();

  const factory RequestsState.initial() = _Initial;
  const factory RequestsState.loading() = _Loading;
  const factory RequestsState.loaded(List<ServiceRequest> requests) = _Loaded;
  const factory RequestsState.error(String message) = _Error;

  @override
  List<Object?> get props => [];

  bool get isInitial => this is _Initial;
  bool get isLoading => this is _Loading;
  bool get hasError => this is _Error;
  bool get hasData => this is _Loaded;

  String? get errorMessage => this is _Error ? (this as _Error).message : null;

  List<ServiceRequest>? get dataOrNull =>
      this is _Loaded ? (this as _Loaded).requests : null;
}

class _Initial extends RequestsState {
  const _Initial();
}

class _Loading extends RequestsState {
  const _Loading();
}

class _Loaded extends RequestsState {
  final List<ServiceRequest> requests;

  const _Loaded(this.requests);

  @override
  List<Object?> get props => [requests];
}

class _Error extends RequestsState {
  final String message;

  const _Error(this.message);

  @override
  List<Object?> get props => [message];
}
