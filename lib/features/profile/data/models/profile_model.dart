import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/profile.dart';
import '../../domain/entities/user_role.dart';

part 'profile_model.freezed.dart';

@freezed
class ProfileModel with _$ProfileModel {
  const ProfileModel._();

  const factory ProfileModel({
    required String id,
    String? email,
    required String role,
    @Default('') String fullName,
    String? phone,
    String? city,
    String? governorate,
    String? locality,
    DateTime? dateOfBirth,
    String? bio,
    String? avatarUrl,
    @Default(0) int yearsExperience,
    @Default([]) List<String> certifications,
    String? specialization,
    @Default([]) List<String> fcmTokens,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) = _ProfileModel;

  factory ProfileModel.fromJson(Map<String, dynamic> json) {
    return ProfileModel(
      id: json['id'] as String,
      email: json['email'] as String?,
      role: json['role'] as String,
      fullName: json['full_name'] as String? ?? '',
      phone: json['phone'] as String?,
      city: json['city'] as String?,
      governorate: json['governorate'] as String?,
      locality: json['locality'] as String?,
      dateOfBirth: json['date_of_birth'] != null
          ? DateTime.parse(json['date_of_birth'] as String)
          : null,
      bio: json['bio'] as String?,
      avatarUrl: json['avatar_url'] as String?,
      yearsExperience: json['years_experience'] as int? ?? 0,
      certifications:
          (json['certifications'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          [],
      specialization: json['specialization'] as String?,
      fcmTokens:
          (json['fcm_tokens'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          [],
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'] as String)
          : null,
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'] as String)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'role': role,
      'full_name': fullName,
      'phone': phone,
      'city': city,
      'governorate': governorate,
      'locality': locality,
      'date_of_birth': dateOfBirth?.toIso8601String(),
      'bio': bio,
      'avatar_url': avatarUrl,
      'years_experience': yearsExperience,
      'certifications': certifications,
      'specialization': specialization,
      'fcm_tokens': fcmTokens,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }

  Profile toEntity() {
    return Profile(
      id: id,
      email: email,
      role: UserRole.fromString(role),
      fullName: fullName,
      phone: phone,
      city: city,
      governorate: governorate,
      locality: locality,
      dateOfBirth: dateOfBirth,
      bio: bio,
      avatarUrl: avatarUrl,
      yearsExperience: yearsExperience,
      certifications: certifications,
      specialization: specialization,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }

  factory ProfileModel.fromEntity(Profile entity) {
    return ProfileModel(
      id: entity.id,
      email: entity.email,
      role: entity.role.value,
      fullName: entity.fullName,
      phone: entity.phone,
      city: entity.city,
      governorate: entity.governorate,
      locality: entity.locality,
      dateOfBirth: entity.dateOfBirth,
      bio: entity.bio,
      avatarUrl: entity.avatarUrl,
      yearsExperience: entity.yearsExperience,
      certifications: entity.certifications,
      specialization: entity.specialization,
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt,
    );
  }

  factory ProfileModel.createNew({
    required String id,
    required String email,
    required UserRole role,
    required String fullName,
    String? phone,
    String? city,
    String? governorate,
    String? locality,
    DateTime? dateOfBirth,
    String? bio,
    String? avatarUrl,
    int yearsExperience = 0,
    List<String> certifications = const [],
    String? specialization,
  }) {
    return ProfileModel(
      id: id,
      email: email,
      role: role.value,
      fullName: fullName,
      phone: phone,
      city: city,
      governorate: governorate,
      locality: locality,
      dateOfBirth: dateOfBirth,
      bio: bio,
      avatarUrl:
          avatarUrl ??
          'hENTER YOUR SUPABASE URL HERE/storage/v1/object/public/media/person_icon.png',
      yearsExperience: yearsExperience,
      certifications: certifications,
      specialization: specialization,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
  }
}
