// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ratings_breakdown_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$RatingsBreakdownModelImpl _$$RatingsBreakdownModelImplFromJson(
  Map<String, dynamic> json,
) => _$RatingsBreakdownModelImpl(
  rating: (json['rating'] as num).toInt(),
  count: (json['count'] as num).toInt(),
  percentage: (json['percentage'] as num).toDouble(),
);

Map<String, dynamic> _$$RatingsBreakdownModelImplToJson(
  _$RatingsBreakdownModelImpl instance,
) => <String, dynamic>{
  'rating': instance.rating,
  'count': instance.count,
  'percentage': instance.percentage,
};
