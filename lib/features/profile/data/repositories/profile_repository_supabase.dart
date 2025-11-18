import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:supabase_flutter/supabase_flutter.dart' as supabase;
import '../../../../../core/error/failures.dart';
import '../../domain/entities/profile.dart';
import '../../domain/repositories/profile_repository.dart';
import '../datasources/profile_supabase_datasource.dart';
import '../models/profile_model.dart';


@LazySingleton(as: ProfileRepository, env: [Environment.prod])
class ProfileRepositorySupabase implements ProfileRepository {
  final ProfileSupabaseDataSource _dataSource;

  ProfileRepositorySupabase(this._dataSource);

  @override
  Future<Either<Failure, Profile>> getMyProfile() async {
    try {
      final profileModel = await _dataSource.getMyProfile();
      return Right(profileModel.toEntity());
    } on supabase.PostgrestException catch (e) {
      return Left(ServerFailure(_mapPostgrestError(e)));
    } catch (e) {
      return Left(ServerFailure('فشل في تحميل الملف الشخصي: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, Profile>> getProfileById(String userId) async {
    try {
      final profileModel = await _dataSource.getProfileById(userId);
      return Right(profileModel.toEntity());
    } on supabase.PostgrestException catch (e) {
      return Left(ServerFailure(_mapPostgrestError(e)));
    } catch (e) {
      return Left(ServerFailure('فشل في تحميل الملف الشخصي: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, Profile>> upsertProfile(Profile profile) async {
    try {
      final profileModel = ProfileModel.fromEntity(profile);
      final result = await _dataSource.upsertProfile(profileModel);
      return Right(result.toEntity());
    } on supabase.PostgrestException catch (e) {
      return Left(ServerFailure(_mapPostgrestError(e)));
    } catch (e) {
      return Left(ServerFailure('فشل في حفظ الملف الشخصي: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, Profile>> updateProfile({
    String? fullName,
    String? phone,
    String? city,
    String? governorate,
    String? locality,
    DateTime? dateOfBirth,
    String? bio,
    String? avatarUrl,
    int? yearsExperience,
    List<String>? certifications,
    String? specialization,
  }) async {
    try {
      final updates = <String, dynamic>{};

      if (fullName != null) updates['full_name'] = fullName;
      if (phone != null) updates['phone'] = phone;
      if (city != null) updates['city'] = city;
      if (governorate != null) updates['governorate'] = governorate;
      if (locality != null) updates['locality'] = locality;
      if (dateOfBirth != null) {
        updates['date_of_birth'] = dateOfBirth.toIso8601String();
      }
      if (bio != null) updates['bio'] = bio;
      if (avatarUrl != null) updates['avatar_url'] = avatarUrl;
      if (yearsExperience != null) {
        updates['years_experience'] = yearsExperience;
      }
      if (certifications != null) updates['certifications'] = certifications;
      if (specialization != null) updates['specialization'] = specialization;

      final result = await _dataSource.updateProfile(updates);
      return Right(result.toEntity());
    } on supabase.PostgrestException catch (e) {
      return Left(ServerFailure(_mapPostgrestError(e)));
    } catch (e) {
      return Left(ServerFailure('فشل في تحديث الملف الشخصي: ${e.toString()}'));
    }
  }

  
  String _mapPostgrestError(supabase.PostgrestException e) {
    final code = e.code;
    final message = e.message.toLowerCase();

    if (code == '23505') {
      if (message.contains('phone')) {
        return 'رقم الهاتف مستخدم من قبل';
      }
      if (message.contains('email')) {
        return 'البريد الإلكتروني مستخدم من قبل';
      }
      return 'البيانات مكررة';
    }

    if (code == '23514') {
      if (message.contains('bio_length')) {
        return 'النبذة التعريفية طويلة جداً (الحد الأقصى 500 حرف)';
      }
      if (message.contains('years_exp_range')) {
        return 'سنوات الخبرة يجب أن تكون بين 0 و 60';
      }
      if (message.contains('specialization_enum')) {
        return 'التخصص غير صالح';
      }
      return 'البيانات غير صالحة';
    }

    if (code == 'PGRST116') {
      return 'الملف الشخصي غير موجود';
    }

    return 'خطأ في الخادم: ${e.message}';
  }
}
