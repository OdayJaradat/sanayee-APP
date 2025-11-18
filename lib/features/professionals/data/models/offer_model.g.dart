// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'offer_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$OfferModelImpl _$$OfferModelImplFromJson(Map<String, dynamic> json) =>
    _$OfferModelImpl(
      id: json['id'] as String,
      requestId: json['requestId'] as String,
      professionalId: json['professionalId'] as String,
      amount: (json['amount'] as num).toDouble(),
      note: json['note'] as String?,
      createdAt: DateTime.parse(json['createdAt'] as String),
      status: json['status'] as String? ?? 'pending',
      acceptedAt: json['acceptedAt'] == null
          ? null
          : DateTime.parse(json['acceptedAt'] as String),
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$$OfferModelImplToJson(_$OfferModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'requestId': instance.requestId,
      'professionalId': instance.professionalId,
      'amount': instance.amount,
      'note': instance.note,
      'createdAt': instance.createdAt.toIso8601String(),
      'status': instance.status,
      'acceptedAt': instance.acceptedAt?.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
    };
