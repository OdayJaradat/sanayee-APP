import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/error/failures.dart';
import '../repositories/user_repository.dart';

@lazySingleton
class SignInWithPhone {
  final UserRepository _repository;

  SignInWithPhone(this._repository);

  Future<Either<Failure, String>> call({required String phoneNumber}) {
    return _repository.signInWithPhone(phoneNumber: phoneNumber);
  }
}
