import 'package:injectable/injectable.dart';
import '../../../../core/error/result.dart';
import '../entities/offer.dart';
import '../repositories/offers_repository.dart';

@injectable
class ListOffers {
  final OffersRepository _repository;

  ListOffers(this._repository);

  Future<Result<List<Offer>>> call(String requestId) async {
    return await _repository.getOffersByRequest(requestId);
  }
}
