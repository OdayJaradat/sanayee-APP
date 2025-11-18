import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/offer.dart';

part 'offer_model.freezed.dart';
part 'offer_model.g.dart';

@freezed
class OfferModel with _$OfferModel {
  const OfferModel._();

  const factory OfferModel({
    required String id,
    required String requestId,
    required String professionalId,
    required double amount,
    String? note,
    required DateTime createdAt,
    @Default('pending') String status,
    DateTime? acceptedAt,
    DateTime? updatedAt,
  }) = _OfferModel;

  factory OfferModel.fromJson(Map<String, dynamic> json) =>
      _$OfferModelFromJson(json);

  Offer toEntity() => Offer(
    id: id,
    requestId: requestId,
    professionalId: professionalId,
    amount: amount,
    note: note,
    createdAt: createdAt,
    status: status,
    acceptedAt: acceptedAt,
    updatedAt: updatedAt,
  );

  factory OfferModel.fromEntity(Offer entity) => OfferModel(
    id: entity.id,
    requestId: entity.requestId,
    professionalId: entity.professionalId,
    amount: entity.amount,
    note: entity.note,
    createdAt: entity.createdAt,
    status: entity.status,
    acceptedAt: entity.acceptedAt,
    updatedAt: entity.updatedAt,
  );
}
