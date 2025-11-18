import '../../../../core/error/result.dart';
import '../entities/offer.dart';

abstract class OffersRepository {
  Future<Result<Offer>> submitOffer({
    required String requestId,
    required String professionalId,
    required double amount,
    String? note,
  });

  Future<Result<List<Offer>>> getOffersByRequest(String requestId);
  Future<Result<List<Offer>>> getOffersByProfessionalId(String professionalId);
  Future<Result<Offer>> acceptOffer(String offerId);
  Future<Result<Offer>> declineOffer(String offerId);
  Future<Result<Offer>> counterOffer({
    required String offerId,
    required double newAmount,
    String? note,
  });
  Future<Result<Offer>> withdrawOffer({
    required String offerId,
    required String professionalId,
  });

  Future<Result<Offer>> acceptCounterOffer({
    required String offerId,
    required String professionalId,
  });
}
