import 'package:freezed_annotation/freezed_annotation.dart';

part 'professional_stats_model.freezed.dart';


@freezed
class ProfessionalStatsModel with _$ProfessionalStatsModel {
  const factory ProfessionalStatsModel({
    required double avgRating,
    required int ratingsCount,
    required int completedRequests,
  }) = _ProfessionalStatsModel;

  factory ProfessionalStatsModel.fromJson(Map<String, dynamic> json) {
    return ProfessionalStatsModel(
      avgRating: (json['avg_rating'] as num?)?.toDouble() ?? 0.0,
      ratingsCount: (json['ratings_count'] as int?) ?? 0,
      completedRequests: (json['completed_requests'] as int?) ?? 0,
    );
  }

  
  factory ProfessionalStatsModel.fromRpc(Map<String, dynamic> rpc) {
    return ProfessionalStatsModel(
      avgRating: (rpc['avg_rating'] as num?)?.toDouble() ?? 0.0,
      ratingsCount: (rpc['ratings_count'] as int?) ?? 0,
      completedRequests: (rpc['completed_requests'] as int?) ?? 0,
    );
  }
}
