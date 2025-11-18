import 'package:injectable/injectable.dart';
import '../../../../core/error/result.dart';
import '../entities/filter_criteria.dart';
import '../repositories/filters_repository.dart';

@injectable
class SaveFilters {
  final FiltersRepository _repository;

  SaveFilters(this._repository);

  Future<Result<void>> call(String role, FilterCriteria criteria) async {
    return await _repository.saveFilters(role, criteria);
  }
}
