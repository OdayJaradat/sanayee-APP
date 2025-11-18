import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/error/failures.dart';
import '../entities/user.dart';
import '../repositories/user_repository.dart';

@lazySingleton
class GetCurrentUser {
  final UserRepository _repository;

  GetCurrentUser(this._repository);

  Future<Either<Failure, User?>> call() {
    return _repository.getCurrentUser();
  }
}
