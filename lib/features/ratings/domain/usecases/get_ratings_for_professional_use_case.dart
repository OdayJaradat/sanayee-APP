import 'package:injectable/injectable.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/error/result.dart';
import '../entities/rating.dart';
import '../repositories/ratings_repository.dart';

@injectable
class GetRatingsForProfessionalUseCase {
  final RatingsRepository _repository;

  GetRatingsForProfessionalUseCase(this._repository);

  Future<Result<List<Rating>>> call(String professionalId) {
    if (professionalId.trim().isEmpty) {
      return Future.value(
        Err(ValidationFailure('معرّف الصنايعي مطلوب لعرض التقييمات')),
      );
    }

    return _repository.getRatingsForProfessional(professionalId);
  }
}
