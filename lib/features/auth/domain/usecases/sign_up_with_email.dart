import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/error/failures.dart';
import '../entities/user.dart';
import '../repositories/user_repository.dart';
import '../../../profile/domain/entities/user_role.dart';



@lazySingleton
class SignUpWithEmail {
  final UserRepository _repository;

  SignUpWithEmail(this._repository);

  Future<Either<Failure, User>> call({
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
  }) {
    return _repository.signUpWithEmail(
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
  }
}
