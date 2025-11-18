import 'package:injectable/injectable.dart';
import '../../../../core/error/result.dart';
import '../../../../core/error/failures.dart';
import '../entities/service_request.dart';
import '../repositories/requests_repository.dart';

@injectable
class MarkRequestCompleted {
  final RequestsRepository _repository;

  MarkRequestCompleted(this._repository);

  Future<Result<ServiceRequest>> call({
    required String requestId,
    required String professionalId,
  }) async {
    if (requestId.trim().isEmpty) {
      return Err(ValidationFailure('معرف الطلب مطلوب'));
    }

    if (professionalId.trim().isEmpty) {
      return Err(ValidationFailure('معرف الصنايعي مطلوب'));
    }

    return await _repository.markRequestCompleted(
      requestId: requestId,
      professionalId: professionalId,
    );
  }
}
