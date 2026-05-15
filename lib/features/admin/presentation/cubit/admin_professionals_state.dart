part of 'admin_professionals_cubit.dart';

sealed class AdminProfessionalsState extends Equatable {
  const AdminProfessionalsState();

  const factory AdminProfessionalsState.initial() = _ProfessionalsInitial;
  const factory AdminProfessionalsState.loading() = _ProfessionalsLoading;
  const factory AdminProfessionalsState.loaded({
    required AdminProfessionalsPage page,
    required String searchQuery,
  }) = _ProfessionalsLoaded;
  const factory AdminProfessionalsState.error(String message) =
      _ProfessionalsError;

  @override
  List<Object?> get props => [];

  bool get isInitial => this is _ProfessionalsInitial;
  bool get isLoading => this is _ProfessionalsLoading;
  bool get hasError => this is _ProfessionalsError;
  bool get hasData => this is _ProfessionalsLoaded;

  String? get errorMessage =>
      this is _ProfessionalsError ? (this as _ProfessionalsError).message : null;
  AdminProfessionalsPage? get pageOrNull =>
      this is _ProfessionalsLoaded ? (this as _ProfessionalsLoaded).page : null;
  String get currentSearchQuery =>
      this is _ProfessionalsLoaded
          ? (this as _ProfessionalsLoaded).searchQuery
          : '';
}

class _ProfessionalsInitial extends AdminProfessionalsState {
  const _ProfessionalsInitial();
}

class _ProfessionalsLoading extends AdminProfessionalsState {
  const _ProfessionalsLoading();
}

class _ProfessionalsLoaded extends AdminProfessionalsState {
  final AdminProfessionalsPage page;
  final String searchQuery;

  const _ProfessionalsLoaded({
    required this.page,
    required this.searchQuery,
  });

  @override
  List<Object?> get props => [page, searchQuery];
}

class _ProfessionalsError extends AdminProfessionalsState {
  final String message;

  const _ProfessionalsError(this.message);

  @override
  List<Object?> get props => [message];
}
