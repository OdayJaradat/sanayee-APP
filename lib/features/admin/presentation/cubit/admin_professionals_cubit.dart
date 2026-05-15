import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../domain/entities/admin_professional_row.dart';
import '../../domain/repositories/admin_repository.dart';

part 'admin_professionals_state.dart';

/// Note: Uses manual DI via AdminInjection (not Injectable)
class AdminProfessionalsCubit extends Cubit<AdminProfessionalsState> {
  final AdminRepository _repository;

  static const int defaultPageSize = 20;

  String _searchQuery = '';
  int _currentPage = 0;

  AdminProfessionalsCubit(this._repository)
      : super(const AdminProfessionalsState.initial());

  Future<void> load() async {
    emit(const AdminProfessionalsState.loading());
    await _fetchProfessionals();
  }

  Future<void> search(String query) async {
    _searchQuery = query;
    _currentPage = 0;
    await _fetchProfessionals();
  }

  Future<void> goToPage(int pageIndex) async {
    _currentPage = pageIndex;
    await _fetchProfessionals();
  }

  Future<void> nextPage() async {
    final currentState = state;
    if (currentState is _ProfessionalsLoaded &&
        currentState.page.hasNextPage) {
      _currentPage++;
      await _fetchProfessionals();
    }
  }

  Future<void> previousPage() async {
    if (_currentPage > 0) {
      _currentPage--;
      await _fetchProfessionals();
    }
  }

  Future<void> refresh() async {
    await _fetchProfessionals();
  }

  /// Toggle professional blocked status
  Future<void> toggleBlocked(String professionalId, bool currentlyBlocked) async {
    final newBlockedState = !currentlyBlocked;
    
    final result = await _repository.toggleProfessionalBlocked(
      professionalId,
      newBlockedState,
    );

    result.when(
      ok: (_) {
        // Update the local state optimistically
        final currentState = state;
        if (currentState is _ProfessionalsLoaded) {
          final updatedRows = currentState.page.rows.map((row) {
            if (row.id == professionalId) {
              return row.copyWith(isBlocked: newBlockedState);
            }
            return row;
          }).toList();

          emit(AdminProfessionalsState.loaded(
            page: AdminProfessionalsPage(
              rows: updatedRows,
              totalCount: currentState.page.totalCount,
              pageIndex: currentState.page.pageIndex,
              pageSize: currentState.page.pageSize,
            ),
            searchQuery: _searchQuery,
          ));
        }
      },
      err: (failure) {
        // On error, we could show a snackbar but for simplicity just refresh
        _fetchProfessionals();
      },
    );
  }

  Future<void> _fetchProfessionals() async {
    final result = await _repository.getProfessionals(
      pageIndex: _currentPage,
      pageSize: defaultPageSize,
      searchQuery: _searchQuery.isNotEmpty ? _searchQuery : null,
    );

    result.when(
      ok: (page) => emit(AdminProfessionalsState.loaded(
        page: page,
        searchQuery: _searchQuery,
      )),
      err: (failure) => emit(AdminProfessionalsState.error(failure.message)),
    );
  }
}
