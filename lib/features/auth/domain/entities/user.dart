import 'package:equatable/equatable.dart';
import '../../../profile/domain/entities/user_role.dart';


class User extends Equatable {
  final String id;
  final String? email;
  final String? phoneNumber;
  final UserRole role;

  const User({
    required this.id,
    this.email,
    this.phoneNumber,
    required this.role,
  });

  User copyWith({
    String? id,
    String? email,
    String? phoneNumber,
    UserRole? role,
  }) {
    return User(
      id: id ?? this.id,
      email: email ?? this.email,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      role: role ?? this.role,
    );
  }

  @override
  List<Object?> get props => [id, email, phoneNumber, role];
}
