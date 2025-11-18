import 'package:freezed_annotation/freezed_annotation.dart';

part 'ratings_breakdown_model.freezed.dart';
part 'ratings_breakdown_model.g.dart';


@freezed
class RatingsBreakdownModel with _$RatingsBreakdownModel {
  const factory RatingsBreakdownModel({
    required int rating,
    required int count,
    required double percentage,
  }) = _RatingsBreakdownModel;

  factory RatingsBreakdownModel.fromJson(Map<String, dynamic> json) =>
      _$RatingsBreakdownModelFromJson(json);
}
