import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/error/failures.dart';
import '../repositories/user_repository.dart';
import '../../../profile/domain/entities/user_role.dart';

@lazySingleton
class GetCurrentUserRole {
  final UserRepository _repository;

  GetCurrentUserRole(this._repository);

  Future<Either<Failure, UserRole?>> call() {
    return _repository.getCurrentUserRole();
  }
}
