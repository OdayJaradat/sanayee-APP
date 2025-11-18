import 'package:injectable/injectable.dart';
import '../../../../core/error/result.dart';
import '../../../../core/error/failures.dart';
import '../entities/service_request.dart';
import '../repositories/requests_repository.dart';

@injectable
class GetRequestById {
  final RequestsRepository _repository;

  GetRequestById(this._repository);

  Future<Result<ServiceRequest>> call(String id) async {
    if (id.trim().isEmpty) {
      return Err(ValidationFailure('معرف الطلب مطلوب'));
    }

    return await _repository.getById(id);
  }
}
