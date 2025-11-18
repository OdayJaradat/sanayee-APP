// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'hiring_post_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$HiringPostModelImpl _$$HiringPostModelImplFromJson(
  Map<String, dynamic> json,
) => _$HiringPostModelImpl(
  id: json['id'] as String,
  professionalId: json['professionalId'] as String,
  title: json['title'] as String,
  description: json['description'] as String,
  jobType: $enumDecode(_$JobTypeEnumMap, json['jobType']),
  durationText: json['durationText'] as String?,
  salaryAmount: (json['salaryAmount'] as num?)?.toDouble(),
  location: (json['location'] as Map<String, dynamic>?)?.map(
    (k, e) => MapEntry(k, (e as num).toDouble()),
  ),
  status:
      $enumDecodeNullable(_$PostStatusEnumMap, json['status']) ??
      PostStatus.open,
  createdAt: DateTime.parse(json['createdAt'] as String),
  category: const ServiceCategoryConverter().fromJson(
    json['category'] as String?,
  ),
  governorate: json['governorate'] as String?,
  locality: json['locality'] as String?,
  address: json['address'] as String?,
  payType: $enumDecodeNullable(_$PayTypeEnumMap, json['payType']),
  fixedAmount: (json['fixedAmount'] as num?)?.toDouble(),
  rangeMin: (json['rangeMin'] as num?)?.toDouble(),
  rangeMax: (json['rangeMax'] as num?)?.toDouble(),
);

Map<String, dynamic> _$$HiringPostModelImplToJson(
  _$HiringPostModelImpl instance,
) => <String, dynamic>{
  'id': instance.id,
  'professionalId': instance.professionalId,
  'title': instance.title,
  'description': instance.description,
  'jobType': instance.jobType,
  'durationText': instance.durationText,
  'salaryAmount': instance.salaryAmount,
  'location': instance.location,
  'status': instance.status,
  'createdAt': instance.createdAt.toIso8601String(),
  'category': const ServiceCategoryConverter().toJson(instance.category),
  'governorate': instance.governorate,
  'locality': instance.locality,
  'address': instance.address,
  'payType': instance.payType,
  'fixedAmount': instance.fixedAmount,
  'rangeMin': instance.rangeMin,
  'rangeMax': instance.rangeMax,
};

const _$JobTypeEnumMap = {
  JobType.fullTime: 'fullTime',
  JobType.partTime: 'partTime',
  JobType.gig: 'gig',
};

const _$PostStatusEnumMap = {
  PostStatus.open: 'open',
  PostStatus.closed: 'closed',
};

const _$PayTypeEnumMap = {
  PayType.hourly: 'hourly',
  PayType.daily: 'daily',
  PayType.perTask: 'perTask',
};
