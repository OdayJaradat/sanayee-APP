import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/user.dart';
import '../../../profile/domain/entities/user_role.dart';

part 'auth_state.freezed.dart';

@freezed
class AuthState with _$AuthState {
  const factory AuthState.initial() = _Initial;
  const factory AuthState.loading() = _Loading;
  const factory AuthState.authenticated(User user) = _Authenticated;
  const factory AuthState.unauthenticated(String? message) = _Unauthenticated;
  const factory AuthState.phoneCodeSent(String verificationId) = _PhoneCodeSent;
  const factory AuthState.error(String message) = _Error;
  const factory AuthState.blocked(String message) = _Blocked;
}


extension AuthStateX on AuthState {
  
  User? get user =>
      maybeWhen(authenticated: (user) => user, orElse: () => null);

  
  String? get userId => user?.id;

  
  UserRole? get userRole => user?.role;

  
  bool get isAuthenticated => user != null;

  
  bool get isProfessional => userRole?.isProfessional ?? false;

  
  bool get isClient => userRole?.isClient ?? false;
}
