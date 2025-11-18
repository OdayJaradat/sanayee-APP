import 'package:injectable/injectable.dart';
import '../../../../core/error/result.dart';
import '../entities/offer.dart';
import '../repositories/offers_repository.dart';

@lazySingleton
class WithdrawOffer {
  final OffersRepository _repository;

  WithdrawOffer(this._repository);

  Future<Result<Offer>> call({
    required String offerId,
    required String professionalId,
  }) async {
    return await _repository.withdrawOffer(
      offerId: offerId,
      professionalId: professionalId,
    );
  }
}
