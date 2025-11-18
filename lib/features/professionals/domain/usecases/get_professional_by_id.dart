import 'package:injectable/injectable.dart';
import '../../../../core/error/result.dart';
import '../../../../core/error/failures.dart';
import '../entities/professional.dart';
import '../repositories/professionals_repository.dart';

@injectable
class GetProfessionalById {
  final ProfessionalsRepository _repository;

  GetProfessionalById(this._repository);

  Future<Result<Professional>> call(String id) async {
    if (id.trim().isEmpty) {
      return Err(ValidationFailure('معرف الصنايعي مطلوب'));
    }

    return await _repository.getProfessionalById(id);
  }
}
