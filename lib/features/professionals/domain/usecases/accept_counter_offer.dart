import 'package:injectable/injectable.dart';
import '../../../../core/error/result.dart';
import '../entities/offer.dart';
import '../repositories/offers_repository.dart';




@injectable
class AcceptCounterOffer {
  final OffersRepository _repository;

  AcceptCounterOffer(this._repository);

  
  
  Future<Result<Offer>> call({
    required String offerId,
    required String professionalId,
  }) async {
    return await _repository.acceptCounterOffer(
      offerId: offerId,
      professionalId: professionalId,
    );
  }
}
