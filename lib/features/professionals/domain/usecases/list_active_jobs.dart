import 'package:injectable/injectable.dart';
import '../../../../core/error/result.dart';
import '../../../requests/domain/entities/service_request.dart';
import '../../../requests/domain/repositories/requests_repository.dart';

@lazySingleton
class ListActiveJobs {
  final RequestsRepository _repository;

  ListActiveJobs(this._repository);

  Future<Result<List<ServiceRequest>>> call(String professionalId) async {
    return await _repository.getActiveJobsByProfessionalId(professionalId);
  }
}
