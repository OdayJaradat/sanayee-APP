import 'package:injectable/injectable.dart';
import '../../../../core/error/result.dart';
import '../../../../core/error/failures.dart';
import '../entities/offer.dart';
import '../repositories/offers_repository.dart';

@injectable
class SubmitOffer {
  final OffersRepository _repository;

  SubmitOffer(this._repository);

  Future<Result<Offer>> call({
    required String requestId,
    required String professionalId,
    required double amount,
    String? note,
  }) async {
    if (requestId.trim().isEmpty) {
      return Err(ValidationFailure('معرف الطلب مطلوب'));
    }

    if (professionalId.trim().isEmpty) {
      return Err(ValidationFailure('معرف الصنايعي مطلوب'));
    }

    if (amount <= 0) {
      return Err(ValidationFailure('المبلغ يجب أن يكون أكبر من صفر'));
    }

    return await _repository.submitOffer(
      requestId: requestId,
      professionalId: professionalId,
      amount: amount,
      note: note,
    );
  }
}
