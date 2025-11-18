import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/user.dart';
import '../../../profile/domain/entities/user_role.dart';


abstract class UserRepository {
  
  Future<Either<Failure, User>> signInWithEmail({
    required String email,
    required String password,
  });

  
  
  Future<Either<Failure, User>> signUpWithEmail({
    required String email,
    required String password,
    required UserRole role,
    String? fullName,
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
  });

  
  Future<Either<Failure, String>> signInWithPhone({
    required String phoneNumber,
  });

  
  Future<Either<Failure, User>> verifyPhoneOtp({
    required String verificationId,
    required String otp,
    UserRole? role, 
  });

  
  Future<Either<Failure, void>> signOut();

  
  Future<Either<Failure, User?>> getCurrentUser();

  
  Future<Either<Failure, UserRole?>> getCurrentUserRole();

  
  Future<Either<Failure, Unit>> changePassword({
    required String currentPassword,
    required String newPassword,
  });

  
  Stream<User?> get authStateChanges;
}
