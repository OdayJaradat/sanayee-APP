import 'package:injectable/injectable.dart';
import '../../../../core/error/result.dart';
import '../../../../core/error/failures.dart';
import '../entities/offer.dart';
import '../repositories/offers_repository.dart';

@injectable
class CounterOffer {
  final OffersRepository _repository;

  CounterOffer(this._repository);

  Future<Result<Offer>> call({
    required String offerId,
    required double newAmount,
    String? note,
  }) async {
    if (offerId.trim().isEmpty) {
      return Err(ValidationFailure('معرف العرض مطلوب'));
    }

    if (newAmount <= 0) {
      return Err(ValidationFailure('المبلغ يجب أن يكون أكبر من صفر'));
    }

    return await _repository.counterOffer(
      offerId: offerId,
      newAmount: newAmount,
      note: note,
    );
  }
}
