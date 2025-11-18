part of 'active_jobs_cubit.dart';

sealed class ActiveJobsState {
  const ActiveJobsState();
}

class ActiveJobsInitial extends ActiveJobsState {
  const ActiveJobsInitial();
}

class ActiveJobsLoading extends ActiveJobsState {
  const ActiveJobsLoading();
}

class ActiveJobsLoaded extends ActiveJobsState {
  final List<ServiceRequest> jobs;
  const ActiveJobsLoaded(this.jobs);
}

class ActiveJobsMarking extends ActiveJobsState {
  const ActiveJobsMarking();
}

class ActiveJobsMarked extends ActiveJobsState {
  const ActiveJobsMarked();
}

class ActiveJobsError extends ActiveJobsState {
  final String message;
  const ActiveJobsError(this.message);
}
