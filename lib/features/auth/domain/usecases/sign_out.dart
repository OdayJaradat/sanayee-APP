import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/error/failures.dart';
import '../repositories/user_repository.dart';

@lazySingleton
class SignOut {
  final UserRepository _repository;

  SignOut(this._repository);

  Future<Either<Failure, void>> call() {
    return _repository.signOut();
  }
}
