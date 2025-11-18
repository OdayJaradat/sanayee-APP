import 'package:injectable/injectable.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/error/result.dart';
import '../entities/hiring_post.dart';
import '../entities/job_type.dart';
import '../entities/post_status.dart';
import '../entities/service_category.dart';
import '../entities/pay_type.dart';
import '../repositories/hiring_posts_repository.dart';

@injectable
class CreateHiringPost {
  final HiringPostsRepository _repository;

  CreateHiringPost(this._repository);

  
  
  
  
  
  
  
  
  Future<Result<HiringPost>> call({
    required String professionalId,
    required String title,
    required String description,
    required JobType jobType,
    String? durationText,
    double? salaryAmount,
    Map<String, double>? location,
    ServiceCategory? category,
    String? governorate,
    String? locality,
    String? address,
    PayType? payType,
    double? fixedAmount,
    double? rangeMin,
    double? rangeMax,
  }) async {
    if (title.trim().isEmpty) {
      return Err(ValidationFailure('عنوان المهمة مطلوب'));
    }

    if (title.trim().length < 6) {
      return Err(
        ValidationFailure('عنوان المهمة يجب أن يكون 6 أحرف على الأقل'),
      );
    }

    if (description.trim().isEmpty) {
      return Err(ValidationFailure('الوصف مطلوب'));
    }

    if (description.trim().length < 20) {
      return Err(ValidationFailure('الوصف يجب أن يكون 20 حرف على الأقل'));
    }

    if (description.trim().length > 400) {
      return Err(ValidationFailure('الوصف يجب ألا يتجاوز 400 حرف'));
    }

    if (salaryAmount != null && salaryAmount <= 0) {
      return Err(ValidationFailure('الراتب يجب أن يكون أكبر من صفر'));
    }

    if (category != null &&
        governorate != null &&
        locality != null &&
        payType != null) {
      if (payType.isFixed && (fixedAmount == null || fixedAmount <= 0)) {
        return Err(ValidationFailure('المبلغ مطلوب ويجب أن يكون أكبر من صفر'));
      }

      if (payType.isRange) {
        if (rangeMin == null || rangeMin <= 0) {
          return Err(
            ValidationFailure(
              'الحد الأدنى للمبلغ مطلوب ويجب أن يكون أكبر من صفر',
            ),
          );
        }
        if (rangeMax == null || rangeMax < rangeMin) {
          return Err(
            ValidationFailure(
              'الحد الأقصى يجب أن يكون أكبر من أو يساوي الحد الأدنى',
            ),
          );
        }
      }
    }

    final post = HiringPost(
      id: '', 
      professionalId: professionalId,
      title: title.trim(),
      description: description.trim(),
      jobType: jobType,
      durationText: durationText?.trim(),
      salaryAmount: salaryAmount,
      location: location,
      status: PostStatus.open,
      createdAt: DateTime.now(),
      category: category,
      governorate: governorate,
      locality: locality,
      address: address?.trim(),
      payType: payType,
      fixedAmount: fixedAmount,
      rangeMin: rangeMin,
      rangeMax: rangeMax,
    );

    return await _repository.create(post);
  }
}
