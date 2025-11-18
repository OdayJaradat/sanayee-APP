import 'package:injectable/injectable.dart';
import '../../../../core/error/result.dart';
import '../entities/service_request.dart';
import '../repositories/requests_repository.dart';

@lazySingleton
class ConfirmJobCompletion {
  final RequestsRepository _repository;

  ConfirmJobCompletion(this._repository);

  Future<Result<ServiceRequest>> call({
    required String requestId,
    required String clientId,
  }) async {
    return await _repository.confirmJobCompletion(
      requestId: requestId,
      clientId: clientId,
    );
  }
}
