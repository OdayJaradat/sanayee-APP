import 'package:dartz/dartz.dart';
import '../../../../../core/error/failures.dart';
import '../entities/profile.dart';


abstract class ProfileRepository {
  
  Future<Either<Failure, Profile>> getMyProfile();

  
  Future<Either<Failure, Profile>> upsertProfile(Profile profile);

  
  Future<Either<Failure, Profile>> getProfileById(String userId);

  
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
  });
}
