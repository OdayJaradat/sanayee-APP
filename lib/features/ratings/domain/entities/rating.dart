import 'package:freezed_annotation/freezed_annotation.dart';

part 'rating.freezed.dart';

@freezed
class Rating with _$Rating {
  const Rating._();

  const factory Rating({
    required String id,
    required String requestId,
    required String clientId,
    required String professionalId,
    required int rating,
    String? comment,
    required DateTime createdAt,
  }) = _Rating;

  bool get hasComment => (comment?.trim().isNotEmpty ?? false);
}
