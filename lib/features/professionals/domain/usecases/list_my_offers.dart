import 'package:injectable/injectable.dart';
import '../../../../core/error/result.dart';
import '../entities/offer.dart';
import '../repositories/offers_repository.dart';

@lazySingleton
class ListMyOffers {
  final OffersRepository _repository;

  ListMyOffers(this._repository);

  Future<Result<List<Offer>>> call(String professionalId) async {
    return await _repository.getOffersByProfessionalId(professionalId);
  }
}
