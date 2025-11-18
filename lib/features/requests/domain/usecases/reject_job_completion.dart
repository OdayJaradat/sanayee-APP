import 'package:injectable/injectable.dart';
import '../../../../core/error/result.dart';
import '../entities/service_request.dart';
import '../repositories/requests_repository.dart';

@lazySingleton
class RejectJobCompletion {
  final RequestsRepository _repository;

  RejectJobCompletion(this._repository);

  Future<Result<ServiceRequest>> call({
    required String requestId,
    required String clientId,
    String? reason,
  }) async {
    return await _repository.rejectJobCompletion(
      requestId: requestId,
      clientId: clientId,
      reason: reason,
    );
  }
}
