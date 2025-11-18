import 'package:injectable/injectable.dart';
import '../entities/user_role.dart';
import '../repositories/session_repository.dart';

@injectable
class SwitchRole {
  final SessionRepository _repository;

  SwitchRole(this._repository);

  Future<void> call(UserRole newRole) async {
    await _repository.setRole(newRole);
  }
}
