part of 'admin_report_details_cubit.dart';

sealed class AdminReportDetailsState extends Equatable {
  const AdminReportDetailsState();

  const factory AdminReportDetailsState.initial() = _ReportDetailsInitial;
  const factory AdminReportDetailsState.loading() = _ReportDetailsLoading;
  const factory AdminReportDetailsState.loaded(AdminReport report) =
      _ReportDetailsLoaded;
  const factory AdminReportDetailsState.updating() = _ReportDetailsUpdating;
  const factory AdminReportDetailsState.error(String message) =
      _ReportDetailsError;

  @override
  List<Object?> get props => [];

  bool get isInitial => this is _ReportDetailsInitial;
  bool get isLoading => this is _ReportDetailsLoading;
  bool get isUpdating => this is _ReportDetailsUpdating;
  bool get hasError => this is _ReportDetailsError;
  bool get hasData => this is _ReportDetailsLoaded;

  String? get errorMessage =>
      this is _ReportDetailsError ? (this as _ReportDetailsError).message : null;
  AdminReport? get dataOrNull =>
      this is _ReportDetailsLoaded ? (this as _ReportDetailsLoaded).report : null;
}

class _ReportDetailsInitial extends AdminReportDetailsState {
  const _ReportDetailsInitial();
}

class _ReportDetailsLoading extends AdminReportDetailsState {
  const _ReportDetailsLoading();
}

class _ReportDetailsLoaded extends AdminReportDetailsState {
  final AdminReport report;

  const _ReportDetailsLoaded(this.report);

  @override
  List<Object?> get props => [report];
}

class _ReportDetailsUpdating extends AdminReportDetailsState {
  const _ReportDetailsUpdating();
}

class _ReportDetailsError extends AdminReportDetailsState {
  final String message;

  const _ReportDetailsError(this.message);

  @override
  List<Object?> get props => [message];
}
