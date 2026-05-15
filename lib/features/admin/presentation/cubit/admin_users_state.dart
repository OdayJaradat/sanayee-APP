part of 'admin_users_cubit.dart';

sealed class AdminUsersState extends Equatable {
  const AdminUsersState();

  const factory AdminUsersState.initial() = _UsersInitial;
  const factory AdminUsersState.loading() = _UsersLoading;
  const factory AdminUsersState.loaded({
    required AdminUsersPage page,
    required String searchQuery,
    required String roleFilter,
  }) = _UsersLoaded;
  const factory AdminUsersState.error(String message) = _UsersError;

  @override
  List<Object?> get props => [];

  bool get isInitial => this is _UsersInitial;
  bool get isLoading => this is _UsersLoading;
  bool get hasError => this is _UsersError;
  bool get hasData => this is _UsersLoaded;

  String? get errorMessage => this is _UsersError ? (this as _UsersError).message : null;
  AdminUsersPage? get pageOrNull => this is _UsersLoaded ? (this as _UsersLoaded).page : null;
  
  String get currentSearchQuery => this is _UsersLoaded ? (this as _UsersLoaded).searchQuery : '';
  String get currentRoleFilter => this is _UsersLoaded ? (this as _UsersLoaded).roleFilter : 'all';
}

class _UsersInitial extends AdminUsersState {
  const _UsersInitial();
}

class _UsersLoading extends AdminUsersState {
  const _UsersLoading();
}

class _UsersLoaded extends AdminUsersState {
  final AdminUsersPage page;
  final String searchQuery;
  final String roleFilter;

  const _UsersLoaded({
    required this.page,
    required this.searchQuery,
    required this.roleFilter,
  });

  @override
  List<Object?> get props => [page, searchQuery, roleFilter];
}

class _UsersError extends AdminUsersState {
  final String message;

  const _UsersError(this.message);

  @override
  List<Object?> get props => [message];
}
