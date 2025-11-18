import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/error/failures.dart';
import '../entities/user.dart';
import '../repositories/user_repository.dart';
import '../../../profile/domain/entities/user_role.dart';

@lazySingleton
class VerifyPhoneOtp {
  final UserRepository _repository;

  VerifyPhoneOtp(this._repository);

  Future<Either<Failure, User>> call({
    required String verificationId,
    required String otp,
    UserRole? role,
  }) {
    return _repository.verifyPhoneOtp(
      verificationId: verificationId,
      otp: otp,
      role: role,
    );
  }
}
