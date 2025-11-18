import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/professional.dart';

part 'professional_model.freezed.dart';
part 'professional_model.g.dart';

@freezed
class ProfessionalModel with _$ProfessionalModel {
  const ProfessionalModel._();

  const factory ProfessionalModel({
    required String id,
    required String name,
    String? avatarUrl,
    required List<String> skills,
    required double rating,
    required int jobsCount,
    String? bio,
    double? latitude,
    double? longitude,
  }) = _ProfessionalModel;

  factory ProfessionalModel.fromJson(Map<String, dynamic> json) =>
      _$ProfessionalModelFromJson(json);

  Professional toEntity() => Professional(
    id: id,
    name: name,
    avatarUrl: avatarUrl,
    skills: skills,
    rating: rating,
    jobsCount: jobsCount,
    bio: bio,
    latitude: latitude,
    longitude: longitude,
  );

  factory ProfessionalModel.fromEntity(Professional entity) =>
      ProfessionalModel(
        id: entity.id,
        name: entity.name,
        avatarUrl: entity.avatarUrl,
        skills: entity.skills,
        rating: entity.rating,
        jobsCount: entity.jobsCount,
        bio: entity.bio,
        latitude: entity.latitude,
        longitude: entity.longitude,
      );
}
