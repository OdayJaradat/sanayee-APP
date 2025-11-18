import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:supabase_flutter/supabase_flutter.dart' as supabase;
import '../../../../core/error/failures.dart';
import '../../../profile/domain/entities/user_role.dart';
import '../../domain/entities/user.dart';
import '../../domain/repositories/user_repository.dart';
import '../datasources/supabase_auth_datasource.dart';
import '../models/user_model.dart';


@LazySingleton(as: UserRepository, env: [Environment.prod])
class UserRepositorySupabase implements UserRepository {
  final SupabaseAuthDataSource _dataSource;

  UserRepositorySupabase(this._dataSource);

  @override
  Future<Either<Failure, User>> signInWithEmail({
    required String email,
    required String password,
  }) async {
    try {
      final userModel = await _dataSource.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return Right(userModel.toDomain());
    } on supabase.AuthException catch (e) {
      return Left(AuthFailure(_getAuthErrorMessage(e)));
    } catch (e) {
      return Left(AuthFailure('Failed to sign in: ${e.toString()}'));
    }
  }

  @override
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
  }) async {
    try {
      final userModel = await _dataSource.signUpWithEmailAndPassword(
        email: email,
        password: password,
        role: role,
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
      );
      return Right(userModel.toDomain());
    } on supabase.AuthException catch (e) {
      return Left(AuthFailure(_getAuthErrorMessage(e)));
    } catch (e) {
      return Left(AuthFailure('Failed to sign up: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, String>> signInWithPhone({
    required String phoneNumber,
  }) async {
    return Left(
      AuthFailure('Phone authentication not implemented for Supabase'),
    );
  }

  @override
  Future<Either<Failure, User>> verifyPhoneOtp({
    required String verificationId,
    required String otp,
    UserRole? role,
  }) async {
    return Left(
      AuthFailure('Phone authentication not implemented for Supabase'),
    );
  }

  @override
  Future<Either<Failure, void>> signOut() async {
    try {
      await _dataSource.signOut();
      return const Right(null);
    } catch (e) {
      return Left(AuthFailure('Failed to sign out: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, User?>> getCurrentUser() async {
    try {
      final userModel = await _dataSource.getCurrentUser();
      return Right(userModel?.toDomain());
    } catch (e) {
      return Left(AuthFailure('Failed to get current user: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, UserRole?>> getCurrentUserRole() async {
    try {
      final userModel = await _dataSource.getCurrentUser();
      return Right(
        userModel != null ? UserRole.fromString(userModel.role) : null,
      );
    } catch (e) {
      return Left(AuthFailure('Failed to get user role: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, Unit>> changePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    try {
      await _dataSource.changePassword(
        currentPassword: currentPassword,
        newPassword: newPassword,
      );
      return const Right(unit);
    } on supabase.AuthException catch (e) {
      return Left(AuthFailure(_getAuthErrorMessage(e)));
    } catch (e) {
      return Left(AuthFailure(e.toString()));
    }
  }

  @override
  Stream<User?> get authStateChanges {
    return _dataSource.authStateChanges.map(
      (userModel) => userModel?.toDomain(),
    );
  }

  String _getAuthErrorMessage(supabase.AuthException e) {
    final message = e.message.toLowerCase();

    if (message.contains('invalid login credentials') ||
        message.contains('invalid email or password')) {
      return 'البريد الإلكتروني أو كلمة المرور غير صحيحة';
    } else if (message.contains('email already registered') ||
        message.contains('user already registered')) {
      return 'البريد الإلكتروني مستخدم بالفعل';
    } else if (message.contains('password') && message.contains('weak')) {
      return 'كلمة المرور ضعيفة جداً';
    } else if (message.contains('invalid email')) {
      return 'البريد الإلكتروني غير صالح';
    } else if (message.contains('email not confirmed')) {
      return 'يرجى تأكيد البريد الإلكتروني';
    }

    return e.message;
  }
}
