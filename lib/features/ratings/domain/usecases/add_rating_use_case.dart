import 'package:injectable/injectable.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/error/result.dart';
import '../entities/rating.dart';
import '../repositories/ratings_repository.dart';

@injectable
class AddRatingUseCase {
  final RatingsRepository _repository;

  AddRatingUseCase(this._repository);

  Future<Result<void>> call(Rating rating) async {
    if (rating.requestId.trim().isEmpty) {
      return Err(ValidationFailure('رقم الطلب مطلوب لإرسال التقييم'));
    }
    if (rating.clientId.trim().isEmpty) {
      return Err(ValidationFailure('حساب العميل غير معروف'));
    }
    if (rating.professionalId.trim().isEmpty) {
      return Err(ValidationFailure('لا يمكن تحديد الصنايعي للتقييم'));
    }
    if (rating.rating < 1 || rating.rating > 5) {
      return Err(ValidationFailure('التقييم يجب أن يكون بين 1 و 5 نجوم'));
    }

    final prepared = rating.copyWith(
      id: rating.id.isEmpty ? _generateId(rating) : rating.id,
      comment: rating.comment?.trim().isNotEmpty == true
          ? rating.comment!.trim()
          : null,
      createdAt: rating.createdAt,
    );

    return _repository.addRating(prepared);
  }

  String _generateId(Rating rating) {
    final timestamp = rating.createdAt.millisecondsSinceEpoch;
    return '${rating.requestId}_${rating.clientId}_$timestamp';
  }
}
