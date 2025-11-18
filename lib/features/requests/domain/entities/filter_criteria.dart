import 'package:freezed_annotation/freezed_annotation.dart';
import 'sort_by.dart';

part 'filter_criteria.freezed.dart';
part 'filter_criteria.g.dart';

@freezed
class FilterCriteria with _$FilterCriteria {
  const factory FilterCriteria({
    @Default([]) List<String> categories,
    double? budgetMin,
    double? budgetMax,
    double? distanceKm,
    @Default(SortBy.dateDesc) SortBy sortBy,
  }) = _FilterCriteria;

  factory FilterCriteria.fromJson(Map<String, dynamic> json) =>
      _$FilterCriteriaFromJson(json);

  factory FilterCriteria.defaultCriteria() => const FilterCriteria();
}
