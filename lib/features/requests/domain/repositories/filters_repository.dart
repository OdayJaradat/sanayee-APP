import '../../../../core/error/result.dart';
import '../entities/filter_criteria.dart';

abstract class FiltersRepository {
  Future<Result<FilterCriteria>> loadFilters(String role);
  Future<Result<void>> saveFilters(String role, FilterCriteria criteria);
  Future<Result<void>> clearFilters(String role);
}
