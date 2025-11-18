// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'filter_criteria.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$FilterCriteriaImpl _$$FilterCriteriaImplFromJson(Map<String, dynamic> json) =>
    _$FilterCriteriaImpl(
      categories:
          (json['categories'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      budgetMin: (json['budgetMin'] as num?)?.toDouble(),
      budgetMax: (json['budgetMax'] as num?)?.toDouble(),
      distanceKm: (json['distanceKm'] as num?)?.toDouble(),
      sortBy:
          $enumDecodeNullable(_$SortByEnumMap, json['sortBy']) ??
          SortBy.dateDesc,
    );

Map<String, dynamic> _$$FilterCriteriaImplToJson(
  _$FilterCriteriaImpl instance,
) => <String, dynamic>{
  'categories': instance.categories,
  'budgetMin': instance.budgetMin,
  'budgetMax': instance.budgetMax,
  'distanceKm': instance.distanceKm,
  'sortBy': _$SortByEnumMap[instance.sortBy]!,
};

const _$SortByEnumMap = {
  SortBy.dateDesc: 'dateDesc',
  SortBy.budgetDesc: 'budgetDesc',
  SortBy.distanceAsc: 'distanceAsc',
};
