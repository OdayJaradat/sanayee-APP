import 'package:injectable/injectable.dart';
import '../../../../core/error/result.dart';
import '../entities/service_request.dart';
import '../repositories/requests_repository.dart';

@lazySingleton
class CloseRequest {
  final RequestsRepository _repository;

  CloseRequest(this._repository);

  Future<Result<ServiceRequest>> call({
    required String requestId,
    required String clientId,
  }) async {
    return await _repository.closeRequest(
      requestId: requestId,
      clientId: clientId,
    );
  }
}
