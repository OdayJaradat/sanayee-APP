import 'package:injectable/injectable.dart';
import '../../../../core/error/result.dart';
import '../entities/filter_criteria.dart';
import '../repositories/filters_repository.dart';

@injectable
class LoadFilters {
  final FiltersRepository _repository;

  LoadFilters(this._repository);

  Future<Result<FilterCriteria>> call(String role) async {
    final result = await _repository.loadFilters(role);

    return result.when(
      ok: (criteria) => Ok(criteria),
      err: (failure) {
        return Ok(FilterCriteria.defaultCriteria());
      },
    );
  }
}
