import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import '../../../requests/domain/entities/service_request.dart';
import '../../domain/usecases/list_active_jobs.dart';
import '../../domain/usecases/mark_job_ready.dart';

part 'active_jobs_state.dart';

@injectable
class ActiveJobsCubit extends Cubit<ActiveJobsState> {
  final ListActiveJobs _listActiveJobs;
  final MarkJobReady _markJobReady;

  ActiveJobsCubit(this._listActiveJobs, this._markJobReady)
    : super(const ActiveJobsInitial());

  Future<void> loadActiveJobs(String professionalId) async {
    emit(const ActiveJobsLoading());

    final result = await _listActiveJobs(professionalId);

    result.when(
      ok: (jobs) => emit(ActiveJobsLoaded(jobs)),
      err: (failure) => emit(ActiveJobsError(failure.message)),
    );
  }

  Future<void> markJobReady({
    required String requestId,
    required String professionalId,
  }) async {
    emit(const ActiveJobsMarking());

    final result = await _markJobReady(
      requestId: requestId,
      professionalId: professionalId,
    );

    result.when(
      ok: (_) {
        emit(const ActiveJobsMarked());
        loadActiveJobs(professionalId);
      },
      err: (failure) => emit(ActiveJobsError(failure.message)),
    );
  }
}
