import '../entities/user_role.dart';



abstract class SessionRepository {
  
  
  Future<UserRole> getRole();

  
  
  Future<void> setRole(UserRole role);

  
  
  UserRole getCurrentRoleSync();

  
  
  Future<void> initialize();
}
