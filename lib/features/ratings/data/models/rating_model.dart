import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/rating.dart';

part 'rating_model.freezed.dart';

@freezed
class RatingModel with _$RatingModel {
  const RatingModel._();

  const factory RatingModel({
    required String id,
    required String requestId,
    required String clientId,
    required String professionalId,
    required int rating,
    String? comment,
    required DateTime createdAt,
  }) = _RatingModel;

  factory RatingModel.fromJson(Map<String, dynamic> json) {
    return RatingModel(
      id: json['id'] as String,
      requestId: json['request_id'] as String,
      clientId: json['client_id'] as String,
      professionalId: json['professional_id'] as String,
      rating: json['rating'] as int,
      comment: json['comment'] as String?,
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'request_id': requestId,
      'client_id': clientId,
      'professional_id': professionalId,
      'rating': rating,
      'comment': comment,
      'created_at': createdAt.toIso8601String(),
    };
  }

  factory RatingModel.fromEntity(Rating entity) => RatingModel(
    id: entity.id,
    requestId: entity.requestId,
    clientId: entity.clientId,
    professionalId: entity.professionalId,
    rating: entity.rating,
    comment: entity.comment,
    createdAt: entity.createdAt,
  );

  Rating toEntity() => Rating(
    id: id,
    requestId: requestId,
    clientId: clientId,
    professionalId: professionalId,
    rating: rating,
    comment: comment,
    createdAt: createdAt,
  );
}
