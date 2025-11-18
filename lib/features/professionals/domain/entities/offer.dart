import 'package:freezed_annotation/freezed_annotation.dart';

part 'offer.freezed.dart';

@freezed
class Offer with _$Offer {
  const factory Offer({
    required String id,
    required String requestId,
    required String professionalId,
    required double amount,
    String? note,
    required DateTime createdAt,
    @Default('pending')
    String status, 
    DateTime? acceptedAt,
    DateTime? updatedAt,
  }) = _Offer;
}
