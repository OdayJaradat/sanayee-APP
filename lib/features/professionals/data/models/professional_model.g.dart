// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'professional_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ProfessionalModelImpl _$$ProfessionalModelImplFromJson(
  Map<String, dynamic> json,
) => _$ProfessionalModelImpl(
  id: json['id'] as String,
  name: json['name'] as String,
  avatarUrl: json['avatarUrl'] as String?,
  skills: (json['skills'] as List<dynamic>).map((e) => e as String).toList(),
  rating: (json['rating'] as num).toDouble(),
  jobsCount: (json['jobsCount'] as num).toInt(),
  bio: json['bio'] as String?,
  latitude: (json['latitude'] as num?)?.toDouble(),
  longitude: (json['longitude'] as num?)?.toDouble(),
);

Map<String, dynamic> _$$ProfessionalModelImplToJson(
  _$ProfessionalModelImpl instance,
) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'avatarUrl': instance.avatarUrl,
  'skills': instance.skills,
  'rating': instance.rating,
  'jobsCount': instance.jobsCount,
  'bio': instance.bio,
  'latitude': instance.latitude,
  'longitude': instance.longitude,
};
