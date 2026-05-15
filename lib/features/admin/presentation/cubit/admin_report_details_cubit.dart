import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../domain/entities/admin_report.dart';
import '../../domain/repositories/admin_repository.dart';

part 'admin_report_details_state.dart';

/// Note: Uses manual DI via AdminInjection (not Injectable)
class AdminReportDetailsCubit extends Cubit<AdminReportDetailsState> {
  final AdminRepository _repository;

  AdminReportDetailsCubit(this._repository)
      : super(const AdminReportDetailsState.initial());

  Future<void> load(String reportId) async {
    emit(const AdminReportDetailsState.loading());

    final result = await _repository.getReportById(reportId);

    result.when(
      ok: (report) => emit(AdminReportDetailsState.loaded(report)),
      err: (failure) => emit(AdminReportDetailsState.error(failure.message)),
    );
  }

  Future<void> updateStatus({
    required String reportId,
    required String status,
    String? adminNotes,
  }) async {
    emit(const AdminReportDetailsState.updating());

    final result = await _repository.updateReport(
      reportId: reportId,
      status: status,
      adminNotes: adminNotes,
    );

    result.when(
      ok: (report) => emit(AdminReportDetailsState.loaded(report)),
      err: (failure) => emit(AdminReportDetailsState.error(failure.message)),
    );
  }

  Future<void> refresh(String reportId) async {
    await load(reportId);
  }
}
