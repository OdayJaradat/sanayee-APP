import 'package:injectable/injectable.dart';
import '../../../../core/error/result.dart';
import '../repositories/filters_repository.dart';

@injectable
class ClearFilters {
  final FiltersRepository _repository;

  ClearFilters(this._repository);

  Future<Result<void>> call(String role) async {
    return await _repository.clearFilters(role);
  }
}
