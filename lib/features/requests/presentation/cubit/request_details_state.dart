part of 'request_details_cubit.dart';

sealed class RequestDetailsState extends Equatable {
  const RequestDetailsState();

  const factory RequestDetailsState.initial() = _Initial;
  const factory RequestDetailsState.loading() = _Loading;
  const factory RequestDetailsState.loaded(
    ServiceRequest request,
    List<Offer> offers,
  ) = _Loaded;
  const factory RequestDetailsState.loadingOffers() = _LoadingOffers;
  const factory RequestDetailsState.offerActionInProgress(
    ServiceRequest request,
    List<Offer> offers,
  ) = _OfferActionInProgress;
  const factory RequestDetailsState.offerActionSuccess(String message) =
      _OfferActionSuccess;
  const factory RequestDetailsState.offerAccepted(
    String message,
    String conversationId,
  ) = _OfferAccepted;
  const factory RequestDetailsState.completionConfirmed(
    String message,
    String professionalId,
  ) = _CompletionConfirmed;
  const factory RequestDetailsState.deleting() = _Deleting;
  const factory RequestDetailsState.deleted() = _Deleted;
  const factory RequestDetailsState.error(String message) = _Error;

  @override
  List<Object?> get props => [];
}

class _Initial extends RequestDetailsState {
  const _Initial();
}

class _Loading extends RequestDetailsState {
  const _Loading();
}

class _Loaded extends RequestDetailsState {
  final ServiceRequest request;
  final List<Offer> offers;

  const _Loaded(this.request, this.offers);

  @override
  List<Object?> get props => [request, offers];
}

class _LoadingOffers extends RequestDetailsState {
  const _LoadingOffers();
}

class _OfferActionInProgress extends RequestDetailsState {
  final ServiceRequest request;
  final List<Offer> offers;

  const _OfferActionInProgress(this.request, this.offers);

  @override
  List<Object?> get props => [request, offers];
}

class _OfferActionSuccess extends RequestDetailsState {
  final String message;

  const _OfferActionSuccess(this.message);

  @override
  List<Object?> get props => [message];
}

class _OfferAccepted extends RequestDetailsState {
  final String message;
  final String conversationId;

  const _OfferAccepted(this.message, this.conversationId);

  @override
  List<Object?> get props => [message, conversationId];
}

class _CompletionConfirmed extends RequestDetailsState {
  final String message;
  final String professionalId;

  const _CompletionConfirmed(this.message, this.professionalId);

  @override
  List<Object?> get props => [message, professionalId];
}

class _Deleting extends RequestDetailsState {
  const _Deleting();
}

class _Deleted extends RequestDetailsState {
  const _Deleted();
}

class _Error extends RequestDetailsState {
  final String message;

  const _Error(this.message);

  @override
  List<Object?> get props => [message];
}
