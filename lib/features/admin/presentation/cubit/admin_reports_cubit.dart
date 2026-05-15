import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../domain/entities/admin_report.dart';
import '../../domain/repositories/admin_repository.dart';

part 'admin_reports_state.dart';

/// Note: Uses manual DI via AdminInjection (not Injectable)
class AdminReportsCubit extends Cubit<AdminReportsState> {
  final AdminRepository _repository;

  static const int defaultPageSize = 20;

  AdminReportsFilter _filter = const AdminReportsFilter();
  int _currentPage = 0;

  AdminReportsCubit(this._repository) : super(const AdminReportsState.initial());

  /// Set initial filters before loading (used for query parameter filtering)
  void setInitialFilters({
    String? targetType,
    String? targetId,
    String? status,
  }) {
    _filter = AdminReportsFilter(
      targetType: targetType,
      targetId: targetId,
      status: status,
    );
  }

  Future<void> load() async {
    emit(const AdminReportsState.loading());
    await _fetchReports();
  }

  Future<void> filterByStatus(String? status) async {
    _filter = _filter.copyWith(status: status);
    _currentPage = 0;
    await _fetchReports();
  }

  Future<void> filterByTargetType(String? targetType) async {
    _filter = _filter.copyWith(targetType: targetType);
    _currentPage = 0;
    await _fetchReports();
  }

  Future<void> search(String? query) async {
    _filter = AdminReportsFilter(
      status: _filter.status,
      targetType: _filter.targetType,
      targetId: _filter.targetId,
      searchQuery: query,
    );
    _currentPage = 0;
    await _fetchReports();
  }

  Future<void> clearFilters() async {
    _filter = const AdminReportsFilter();
    _currentPage = 0;
    await _fetchReports();
  }

  Future<void> goToPage(int pageIndex) async {
    _currentPage = pageIndex;
    await _fetchReports();
  }

  Future<void> nextPage() async {
    final currentState = state;
    if (currentState is _ReportsLoaded && currentState.page.hasNextPage) {
      _currentPage++;
      await _fetchReports();
    }
  }

  Future<void> previousPage() async {
    if (_currentPage > 0) {
      _currentPage--;
      await _fetchReports();
    }
  }

  Future<void> refresh() async {
    await _fetchReports();
  }

  Future<void> _fetchReports() async {
    final result = await _repository.getReports(
      pageIndex: _currentPage,
      pageSize: defaultPageSize,
      filter: _filter,
    );

    result.when(
      ok: (page) => emit(AdminReportsState.loaded(
        page: page,
        filter: _filter,
      )),
      err: (failure) => emit(AdminReportsState.error(failure.message)),
    );
  }
}
