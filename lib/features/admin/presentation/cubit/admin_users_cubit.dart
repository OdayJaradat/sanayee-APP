import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../domain/entities/admin_user_row.dart';
import '../../domain/repositories/admin_repository.dart';

part 'admin_users_state.dart';

/// Note: Uses manual DI via AdminInjection (not Injectable)
class AdminUsersCubit extends Cubit<AdminUsersState> {
  final AdminRepository _repository;

  static const int defaultPageSize = 20;

  String _searchQuery = '';
  String _roleFilter = 'all';
  int _currentPage = 0;

  AdminUsersCubit(this._repository) : super(const AdminUsersState.initial());

  Future<void> load() async {
    emit(const AdminUsersState.loading());
    await _fetchUsers();
  }

  Future<void> search(String query) async {
    _searchQuery = query;
    _currentPage = 0;
    await _fetchUsers();
  }

  Future<void> filterByRole(String role) async {
    _roleFilter = role;
    _currentPage = 0;
    await _fetchUsers();
  }

  Future<void> goToPage(int pageIndex) async {
    _currentPage = pageIndex;
    await _fetchUsers();
  }

  Future<void> nextPage() async {
    final currentState = state;
    if (currentState is _UsersLoaded && currentState.page.hasNextPage) {
      _currentPage++;
      await _fetchUsers();
    }
  }

  Future<void> previousPage() async {
    if (_currentPage > 0) {
      _currentPage--;
      await _fetchUsers();
    }
  }

  Future<void> refresh() async {
    await _fetchUsers();
  }

  Future<void> _fetchUsers() async {
    final result = await _repository.getUsers(
      pageIndex: _currentPage,
      pageSize: defaultPageSize,
      searchQuery: _searchQuery.isNotEmpty ? _searchQuery : null,
      roleFilter: _roleFilter,
    );

    result.when(
      ok: (page) => emit(AdminUsersState.loaded(
        page: page,
        searchQuery: _searchQuery,
        roleFilter: _roleFilter,
      )),
      err: (failure) => emit(AdminUsersState.error(failure.message)),
    );
  }

  /// Toggle user blocked status
  Future<bool> toggleBlocked(String userId, bool currentlyBlocked) async {
    final newBlockedStatus = !currentlyBlocked;
    
    final result = await _repository.toggleUserBlocked(userId, newBlockedStatus);
    
    return result.when(
      ok: (_) {
        // Optimistically update the local state
        final currentState = state;
        if (currentState is _UsersLoaded) {
          final updatedRows = currentState.page.rows.map((user) {
            if (user.id == userId) {
              return user.copyWith(isBlocked: newBlockedStatus);
            }
            return user;
          }).toList();

          emit(AdminUsersState.loaded(
            page: AdminUsersPage(
              rows: updatedRows,
              totalCount: currentState.page.totalCount,
              pageIndex: currentState.page.pageIndex,
              pageSize: currentState.page.pageSize,
            ),
            searchQuery: currentState.searchQuery,
            roleFilter: currentState.roleFilter,
          ));
        }
        return true;
      },
      err: (_) => false,
    );
  }
}
