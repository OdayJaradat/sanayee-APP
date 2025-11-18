import 'package:injectable/injectable.dart';
import '../../../../core/error/result.dart';
import '../../../../core/error/failures.dart';
import '../repositories/requests_repository.dart';

@injectable
class DeleteRequest {
  final RequestsRepository _repository;

  DeleteRequest(this._repository);

  Future<Result<void>> call(String id) async {
    if (id.trim().isEmpty) {
      return Err(ValidationFailure('معرف الطلب مطلوب'));
    }

    return await _repository.deleteById(id);
  }
}
