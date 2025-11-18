part of 'pros_jobs_cubit.dart';

sealed class ProsJobsState extends Equatable {
  const ProsJobsState();

  const factory ProsJobsState.initial() = _Initial;
  const factory ProsJobsState.loading() = _Loading;
  const factory ProsJobsState.loaded(
    List<ServiceRequest> requests, [
    FilterCriteria filterCriteria,
  ]) = _Loaded;
  const factory ProsJobsState.submitting(
    List<ServiceRequest> requests, [
    FilterCriteria filterCriteria,
  ]) = _Submitting;
  const factory ProsJobsState.offerSubmitted(Offer offer) = _OfferSubmitted;
  const factory ProsJobsState.error(String message) = _Error;

  @override
  List<Object?> get props => [];
}

class _Initial extends ProsJobsState {
  const _Initial();
}

class _Loading extends ProsJobsState {
  const _Loading();
}

class _Loaded extends ProsJobsState {
  final List<ServiceRequest> requests;
  final FilterCriteria filterCriteria;

  const _Loaded(this.requests, [this.filterCriteria = const FilterCriteria()]);

  @override
  List<Object?> get props => [requests, filterCriteria];
}

class _Submitting extends ProsJobsState {
  final List<ServiceRequest> requests;
  final FilterCriteria filterCriteria;

  const _Submitting(
    this.requests, [
    this.filterCriteria = const FilterCriteria(),
  ]);

  @override
  List<Object?> get props => [requests, filterCriteria];
}

class _OfferSubmitted extends ProsJobsState {
  final Offer offer;

  const _OfferSubmitted(this.offer);

  @override
  List<Object?> get props => [offer];
}

class _Error extends ProsJobsState {
  final String message;

  const _Error(this.message);

  @override
  List<Object?> get props => [message];
}
