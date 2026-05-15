part of 'admin_user_details_cubit.dart';

sealed class AdminUserDetailsState extends Equatable {
  const AdminUserDetailsState();

  const factory AdminUserDetailsState.initial() = _UserDetailsInitial;
  const factory AdminUserDetailsState.loading() = _UserDetailsLoading;
  const factory AdminUserDetailsState.loaded(AdminUserDetails details) = _UserDetailsLoaded;
  const factory AdminUserDetailsState.error(String message) = _UserDetailsError;

  @override
  List<Object?> get props => [];

  bool get isInitial => this is _UserDetailsInitial;
  bool get isLoading => this is _UserDetailsLoading;
  bool get hasError => this is _UserDetailsError;
  bool get hasData => this is _UserDetailsLoaded;

  String? get errorMessage => this is _UserDetailsError ? (this as _UserDetailsError).message : null;
  AdminUserDetails? get dataOrNull => this is _UserDetailsLoaded ? (this as _UserDetailsLoaded).details : null;
}

class _UserDetailsInitial extends AdminUserDetailsState {
  const _UserDetailsInitial();
}

class _UserDetailsLoading extends AdminUserDetailsState {
  const _UserDetailsLoading();
}

class _UserDetailsLoaded extends AdminUserDetailsState {
  final AdminUserDetails details;

  const _UserDetailsLoaded(this.details);

  @override
  List<Object?> get props => [details];
}

class _UserDetailsError extends AdminUserDetailsState {
  final String message;

  const _UserDetailsError(this.message);

  @override
  List<Object?> get props => [message];
}
