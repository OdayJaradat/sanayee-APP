import 'package:injectable/injectable.dart';
import '../../../../core/error/result.dart';
import '../../../../core/error/failures.dart';
import '../entities/offer.dart';
import '../repositories/offers_repository.dart';

@injectable
class DeclineOffer {
  final OffersRepository _repository;

  DeclineOffer(this._repository);

  Future<Result<Offer>> call(String offerId) async {
    if (offerId.trim().isEmpty) {
      return Err(ValidationFailure('معرف العرض مطلوب'));
    }

    return await _repository.declineOffer(offerId);
  }
}
