part of 'pro_profile_cubit.dart';

sealed class ProProfileState extends Equatable {
  const ProProfileState();

  const factory ProProfileState.initial() = _Initial;
  const factory ProProfileState.loading() = _Loading;
  const factory ProProfileState.loaded(Professional professional) = _Loaded;
  const factory ProProfileState.error(String message) = _Error;

  @override
  List<Object?> get props => [];
}

class _Initial extends ProProfileState {
  const _Initial();
}

class _Loading extends ProProfileState {
  const _Loading();
}

class _Loaded extends ProProfileState {
  final Professional professional;

  const _Loaded(this.professional);

  @override
  List<Object?> get props => [professional];
}

class _Error extends ProProfileState {
  final String message;

  const _Error(this.message);

  @override
  List<Object?> get props => [message];
}
