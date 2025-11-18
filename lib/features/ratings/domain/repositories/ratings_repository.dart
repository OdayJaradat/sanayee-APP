import '../../../../core/error/result.dart';
import '../entities/rating.dart';

abstract class RatingsRepository {
  Future<Result<void>> addRating(Rating rating);
  Future<Result<List<Rating>>> getRatingsForProfessional(String professionalId);
  Future<Result<bool>> hasRatingForRequest(String requestId);
}
