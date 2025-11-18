import 'package:injectable/injectable.dart';
import '../../../../core/error/result.dart';
import '../../../requests/domain/entities/service_request.dart';
import '../../../requests/domain/repositories/requests_repository.dart';

@lazySingleton
class MarkJobReady {
  final RequestsRepository _repository;

  MarkJobReady(this._repository);

  Future<Result<ServiceRequest>> call({
    required String requestId,
    required String professionalId,
  }) async {
    return await _repository.markJobReadyForReview(
      requestId: requestId,
      professionalId: professionalId,
    );
  }
}
