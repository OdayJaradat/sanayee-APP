import 'package:hive_flutter/hive_flutter.dart';
import 'package:injectable/injectable.dart';
import '../../../../app/env.dart';
import '../../../../app/injection.dart';
import '../../../auth/domain/repositories/user_repository.dart';
import '../../domain/entities/user_role.dart';
import '../../domain/repositories/session_repository.dart';

@LazySingleton(as: SessionRepository)
class SessionRepositoryHive implements SessionRepository {
  static const String _boxName = 'session';
  static const String _roleKey = 'role';

  UserRepository? _userRepository;

  Box<String>? _box;
  UserRole? _cachedRole;

  SessionRepositoryHive();

  @override
  Future<void> initialize() async {
    _box = await Hive.openBox<String>(_boxName);

    try {
      _userRepository = sl<UserRepository>();
      final result = await _userRepository!.getCurrentUserRole();
      result.fold(
        (failure) {
          _initializeFromHive();
        },
        (role) {
          if (role != null) {
            _cachedRole = role;
            _box?.put(_roleKey, role.value);
          } else {
            _initializeFromHive();
          }
        },
      );
    } catch (e) {
      _initializeFromHive();
    }
  }

  void _initializeFromHive() {
    final storedRole = _box?.get(_roleKey);
    if (storedRole != null) {
      _cachedRole = UserRole.fromString(storedRole);
    } else {
      _cachedRole = Env.defaultRole;
      _box?.put(_roleKey, _cachedRole!.value);
    }
  }

  @override
  Future<UserRole> getRole() async {
    if (_userRepository != null) {
      final result = await _userRepository!.getCurrentUserRole();
      final authRole = result.fold((l) => null, (r) => r);
      if (authRole != null) {
        _cachedRole = authRole;
        await _box?.put(_roleKey, authRole.value);
        return authRole;
      }
    }

    if (_cachedRole != null) {
      return _cachedRole!;
    }

    final storedRole = _box?.get(_roleKey);
    if (storedRole != null) {
      _cachedRole = UserRole.fromString(storedRole);
      return _cachedRole!;
    }

    _cachedRole = Env.defaultRole;
    await _box?.put(_roleKey, _cachedRole!.value);
    return _cachedRole!;
  }

  @override
  Future<void> setRole(UserRole role) async {
    _cachedRole = role;
    await _box?.put(_roleKey, role.value);
  }

  @override
  UserRole getCurrentRoleSync() {
    return _cachedRole ?? Env.defaultRole;
  }
}
