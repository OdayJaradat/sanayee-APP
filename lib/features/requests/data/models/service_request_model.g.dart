// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'service_request_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ServiceRequestModelImpl _$$ServiceRequestModelImplFromJson(
  Map<String, dynamic> json,
) => _$ServiceRequestModelImpl(
  id: json['id'] as String,
  title: json['title'] as String,
  description: json['description'] as String,
  category: json['category'] as String,
  budget: (json['budget'] as num?)?.toDouble(),
  clientId: json['clientId'] as String,
  createdAt: DateTime.parse(json['createdAt'] as String),
  status: json['status'] as String? ?? 'open',
  professionalId: json['professionalId'] as String?,
  updatedAt: json['updatedAt'] == null
      ? null
      : DateTime.parse(json['updatedAt'] as String),
  location: json['location'] as String?,
  photos:
      (json['photos'] as List<dynamic>?)?.map((e) => e as String).toList() ??
      const [],
  type:
      $enumDecodeNullable(_$RequestTypeEnumMap, json['type']) ??
      RequestType.normal,
  assignedTo: json['assignedTo'] as String?,
  clientGpsLocation: (json['clientGpsLocation'] as Map<String, dynamic>?)?.map(
    (k, e) => MapEntry(k, (e as num).toDouble()),
  ),
  assignedProfessionalId: json['assignedProfessionalId'] as String?,
  acceptedOfferId: json['acceptedOfferId'] as String?,
  acceptedAt: json['acceptedAt'] == null
      ? null
      : DateTime.parse(json['acceptedAt'] as String),
  completedAt: json['completedAt'] == null
      ? null
      : DateTime.parse(json['completedAt'] as String),
  rejectionReason: json['rejectionReason'] as String?,
  acceptedOfferAmount: (json['acceptedOfferAmount'] as num?)?.toDouble(),
);

Map<String, dynamic> _$$ServiceRequestModelImplToJson(
  _$ServiceRequestModelImpl instance,
) => <String, dynamic>{
  'id': instance.id,
  'title': instance.title,
  'description': instance.description,
  'category': instance.category,
  'budget': instance.budget,
  'clientId': instance.clientId,
  'createdAt': instance.createdAt.toIso8601String(),
  'status': instance.status,
  'professionalId': instance.professionalId,
  'updatedAt': instance.updatedAt?.toIso8601String(),
  'location': instance.location,
  'photos': instance.photos,
  'type': instance.type,
  'assignedTo': instance.assignedTo,
  'clientGpsLocation': instance.clientGpsLocation,
  'assignedProfessionalId': instance.assignedProfessionalId,
  'acceptedOfferId': instance.acceptedOfferId,
  'acceptedAt': instance.acceptedAt?.toIso8601String(),
  'completedAt': instance.completedAt?.toIso8601String(),
  'rejectionReason': instance.rejectionReason,
  'acceptedOfferAmount': instance.acceptedOfferAmount,
};

const _$RequestTypeEnumMap = {
  RequestType.normal: 'normal',
  RequestType.quick: 'quick',
};
