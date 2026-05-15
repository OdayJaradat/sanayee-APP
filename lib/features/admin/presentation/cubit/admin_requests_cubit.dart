import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../domain/entities/admin_request_row.dart';
import '../../domain/repositories/admin_repository.dart';

part 'admin_requests_state.dart';

/// Note: Uses manual DI via AdminInjection (not Injectable)
class AdminRequestsCubit extends Cubit<AdminRequestsState> {
  final AdminRepository _repository;

  static const int defaultPageSize = 20;

  AdminRequestsFilter _filter = const AdminRequestsFilter();
  int _currentPage = 0;

  AdminRequestsCubit(this._repository) : super(const AdminRequestsState.initial());

  Future<void> load() async {
    emit(const AdminRequestsState.loading());
    await _fetchRequests();
  }

  Future<void> filterByStatus(String? status) async {
    _filter = _filter.copyWith(status: status);
    _currentPage = 0;
    await _fetchRequests();
  }

  Future<void> filterByCity(String? city) async {
    _filter = AdminRequestsFilter(
      status: _filter.status,
      city: city,
      startDate: _filter.startDate,
      endDate: _filter.endDate,
      professionalId: _filter.professionalId,
    );
    _currentPage = 0;
    await _fetchRequests();
  }

  Future<void> filterByDateRange(DateTime? start, DateTime? end) async {
    _filter = AdminRequestsFilter(
      status: _filter.status,
      city: _filter.city,
      startDate: start,
      endDate: end,
      professionalId: _filter.professionalId,
    );
    _currentPage = 0;
    await _fetchRequests();
  }

  Future<void> filterByProfessionalId(String? professionalId) async {
    _filter = AdminRequestsFilter(
      status: _filter.status,
      city: _filter.city,
      startDate: _filter.startDate,
      endDate: _filter.endDate,
      professionalId: professionalId,
    );
    _currentPage = 0;
    // Don't fetch here - let load() be called after
  }

  Future<void> clearFilters() async {
    _filter = const AdminRequestsFilter();
    _currentPage = 0;
    await _fetchRequests();
  }

  Future<void> goToPage(int pageIndex) async {
    _currentPage = pageIndex;
    await _fetchRequests();
  }

  Future<void> nextPage() async {
    final currentState = state;
    if (currentState is _RequestsLoaded && currentState.page.hasNextPage) {
      _currentPage++;
      await _fetchRequests();
    }
  }

  Future<void> previousPage() async {
    if (_currentPage > 0) {
      _currentPage--;
      await _fetchRequests();
    }
  }

  Future<void> refresh() async {
    await _fetchRequests();
  }

  Future<void> _fetchRequests() async {
    final result = await _repository.getRequests(
      pageIndex: _currentPage,
      pageSize: defaultPageSize,
      filter: _filter,
    );

    result.when(
      ok: (page) => emit(AdminRequestsState.loaded(
        page: page,
        filter: _filter,
      )),
      err: (failure) => emit(AdminRequestsState.error(failure.message)),
    );
  }
}
