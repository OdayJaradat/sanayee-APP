import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/error/failures.dart';
import '../entities/user.dart';
import '../repositories/user_repository.dart';

@lazySingleton
class SignInWithEmail {
  final UserRepository _repository;

  SignInWithEmail(this._repository);

  Future<Either<Failure, User>> call({
    required String email,
    required String password,
  }) {
    return _repository.signInWithEmail(email: email, password: password);
  }
}
