part of 'my_offers_cubit.dart';

sealed class MyOffersState {
  const MyOffersState();
}

class MyOffersInitial extends MyOffersState {
  const MyOffersInitial();
}

class MyOffersLoading extends MyOffersState {
  const MyOffersLoading();
}

class MyOffersLoaded extends MyOffersState {
  final List<Offer> offers;
  const MyOffersLoaded(this.offers);
}

class MyOffersWithdrawing extends MyOffersState {
  const MyOffersWithdrawing();
}

class MyOffersWithdrawn extends MyOffersState {
  const MyOffersWithdrawn();
}

class MyOffersError extends MyOffersState {
  final String message;
  const MyOffersError(this.message);
}
