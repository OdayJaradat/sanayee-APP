import 'package:injectable/injectable.dart';
import '../../../../core/error/result.dart';
import '../../../requests/domain/entities/service_request.dart';
import '../../../requests/domain/repositories/requests_repository.dart';

@injectable
class FetchOpenRequests {
  final RequestsRepository _repository;

  FetchOpenRequests(this._repository);

  Future<Result<List<ServiceRequest>>> call() async {
    return await _repository.fetchOpenRequests();
  }
}
