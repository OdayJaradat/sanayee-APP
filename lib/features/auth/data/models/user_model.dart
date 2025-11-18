import 'package:freezed_annotation/freezed_annotation.dart';
import '../../../profile/domain/entities/user_role.dart';
import '../../domain/entities/user.dart';

part 'user_model.freezed.dart';
part 'user_model.g.dart';

@freezed
class UserModel with _$UserModel {
  const factory UserModel({
    required String id,
    String? email,
    String? phoneNumber,
    required String role,
    @Default([]) List<String> fcmTokens,
  }) = _UserModel;

  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);

  factory UserModel.fromDomain(User user) {
    return UserModel(
      id: user.id,
      email: user.email,
      phoneNumber: user.phoneNumber,
      role: user.role.value,
    );
  }
}

extension UserModelX on UserModel {
  User toDomain() {
    return User(
      id: id,
      email: email,
      phoneNumber: phoneNumber,
      role: UserRole.fromString(role),
    );
  }
}

extension NullableUserModelX on UserModel? {
  User? toDomain() {
    final userModel = this;
    if (userModel == null) return null;
    return userModel.toDomain();
  }
}
