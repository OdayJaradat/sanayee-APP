import 'package:injectable/injectable.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/error/result.dart';
import '../entities/service_request.dart';
import '../repositories/requests_repository.dart';

@injectable
class CreateRequest {
  final RequestsRepository _repository;

  CreateRequest(this._repository);

  Future<Result<ServiceRequest>> call({
    required String title,
    required String description,
    required String category,
    required String clientId,
    double? budget,
    String? location,
    List<String>? photos,
  }) async {
    if (title.trim().isEmpty) {
      return Err(ValidationFailure('عنوان الخدمة مطلوب'));
    }

    if (description.trim().isEmpty) {
      return Err(ValidationFailure('وصف الخدمة مطلوب'));
    }

    if (category.trim().isEmpty) {
      return Err(ValidationFailure('الفئة مطلوبة'));
    }

    if (budget != null && budget <= 0) {
      return Err(ValidationFailure('الميزانية يجب أن تكون أكبر من صفر'));
    }

    final request = ServiceRequest(
      id: '', 
      title: title.trim(),
      description: description.trim(),
      category: category,
      budget: budget,
      clientId: clientId,
      createdAt: DateTime.now(),
      status: 'open',
      location: location,
      photos: photos ?? [],
    );

    return await _repository.create(request);
  }
}
