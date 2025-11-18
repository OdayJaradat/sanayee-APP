import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import '../../domain/entities/offer.dart';
import '../../domain/usecases/list_my_offers.dart';
import '../../domain/usecases/withdraw_offer.dart';
import '../../domain/usecases/accept_counter_offer.dart';

part 'my_offers_state.dart';

@injectable
class MyOffersCubit extends Cubit<MyOffersState> {
  final ListMyOffers _listMyOffers;
  final WithdrawOffer _withdrawOffer;
  final AcceptCounterOffer _acceptCounterOffer;

  MyOffersCubit(
    this._listMyOffers,
    this._withdrawOffer,
    this._acceptCounterOffer,
  ) : super(const MyOffersInitial());

  Future<void> loadMyOffers(String professionalId) async {
    emit(const MyOffersLoading());

    final result = await _listMyOffers(professionalId);

    result.when(
      ok: (offers) => emit(MyOffersLoaded(offers)),
      err: (failure) => emit(MyOffersError(failure.message)),
    );
  }

  Future<void> withdrawOffer({
    required String offerId,
    required String professionalId,
  }) async {
    emit(const MyOffersWithdrawing());

    final result = await _withdrawOffer(
      offerId: offerId,
      professionalId: professionalId,
    );

    result.when(
      ok: (_) {
        emit(const MyOffersWithdrawn());
        loadMyOffers(professionalId);
      },
      err: (failure) => emit(MyOffersError(failure.message)),
    );
  }

  Future<void> acceptCounterOffer({
    required String offerId,
    required String professionalId,
  }) async {
    emit(const MyOffersWithdrawing()); 

    final result = await _acceptCounterOffer(
      offerId: offerId,
      professionalId: professionalId,
    );

    result.when(
      ok: (_) {
        emit(const MyOffersWithdrawn()); 
        loadMyOffers(professionalId);
      },
      err: (failure) => emit(MyOffersError(failure.message)),
    );
  }
}
