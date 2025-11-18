import 'package:injectable/injectable.dart';
import '../entities/user_role.dart';
import '../repositories/session_repository.dart';

@injectable
class GetCurrentRole {
  final SessionRepository _repository;

  GetCurrentRole(this._repository);

  Future<UserRole> call() async {
    return await _repository.getRole();
  }

  
  UserRole sync() {
    return _repository.getCurrentRoleSync();
  }
}
