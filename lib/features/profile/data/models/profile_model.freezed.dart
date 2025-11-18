// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'profile_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$ProfileModel {
  String get id => throw _privateConstructorUsedError;
  String? get email => throw _privateConstructorUsedError;
  String get role => throw _privateConstructorUsedError;
  String get fullName => throw _privateConstructorUsedError;
  String? get phone => throw _privateConstructorUsedError;
  String? get city => throw _privateConstructorUsedError;
  String? get governorate => throw _privateConstructorUsedError;
  String? get locality => throw _privateConstructorUsedError;
  DateTime? get dateOfBirth => throw _privateConstructorUsedError;
  String? get bio => throw _privateConstructorUsedError;
  String? get avatarUrl => throw _privateConstructorUsedError;
  int get yearsExperience => throw _privateConstructorUsedError;
  List<String> get certifications => throw _privateConstructorUsedError;
  String? get specialization => throw _privateConstructorUsedError;
  List<String> get fcmTokens => throw _privateConstructorUsedError;
  DateTime? get createdAt => throw _privateConstructorUsedError;
  DateTime? get updatedAt => throw _privateConstructorUsedError;

  /// Create a copy of ProfileModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ProfileModelCopyWith<ProfileModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ProfileModelCopyWith<$Res> {
  factory $ProfileModelCopyWith(
    ProfileModel value,
    $Res Function(ProfileModel) then,
  ) = _$ProfileModelCopyWithImpl<$Res, ProfileModel>;
  @useResult
  $Res call({
    String id,
    String? email,
    String role,
    String fullName,
    String? phone,
    String? city,
    String? governorate,
    String? locality,
    DateTime? dateOfBirth,
    String? bio,
    String? avatarUrl,
    int yearsExperience,
    List<String> certifications,
    String? specialization,
    List<String> fcmTokens,
    DateTime? createdAt,
    DateTime? updatedAt,
  });
}

/// @nodoc
class _$ProfileModelCopyWithImpl<$Res, $Val extends ProfileModel>
    implements $ProfileModelCopyWith<$Res> {
  _$ProfileModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ProfileModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? email = freezed,
    Object? role = null,
    Object? fullName = null,
    Object? phone = freezed,
    Object? city = freezed,
    Object? governorate = freezed,
    Object? locality = freezed,
    Object? dateOfBirth = freezed,
    Object? bio = freezed,
    Object? avatarUrl = freezed,
    Object? yearsExperience = null,
    Object? certifications = null,
    Object? specialization = freezed,
    Object? fcmTokens = null,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            email: freezed == email
                ? _value.email
                : email // ignore: cast_nullable_to_non_nullable
                      as String?,
            role: null == role
                ? _value.role
                : role // ignore: cast_nullable_to_non_nullable
                      as String,
            fullName: null == fullName
                ? _value.fullName
                : fullName // ignore: cast_nullable_to_non_nullable
                      as String,
            phone: freezed == phone
                ? _value.phone
                : phone // ignore: cast_nullable_to_non_nullable
                      as String?,
            city: freezed == city
                ? _value.city
                : city // ignore: cast_nullable_to_non_nullable
                      as String?,
            governorate: freezed == governorate
                ? _value.governorate
                : governorate // ignore: cast_nullable_to_non_nullable
                      as String?,
            locality: freezed == locality
                ? _value.locality
                : locality // ignore: cast_nullable_to_non_nullable
                      as String?,
            dateOfBirth: freezed == dateOfBirth
                ? _value.dateOfBirth
                : dateOfBirth // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
            bio: freezed == bio
                ? _value.bio
                : bio // ignore: cast_nullable_to_non_nullable
                      as String?,
            avatarUrl: freezed == avatarUrl
                ? _value.avatarUrl
                : avatarUrl // ignore: cast_nullable_to_non_nullable
                      as String?,
            yearsExperience: null == yearsExperience
                ? _value.yearsExperience
                : yearsExperience // ignore: cast_nullable_to_non_nullable
                      as int,
            certifications: null == certifications
                ? _value.certifications
                : certifications // ignore: cast_nullable_to_non_nullable
                      as List<String>,
            specialization: freezed == specialization
                ? _value.specialization
                : specialization // ignore: cast_nullable_to_non_nullable
                      as String?,
            fcmTokens: null == fcmTokens
                ? _value.fcmTokens
                : fcmTokens // ignore: cast_nullable_to_non_nullable
                      as List<String>,
            createdAt: freezed == createdAt
                ? _value.createdAt
                : createdAt // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
            updatedAt: freezed == updatedAt
                ? _value.updatedAt
                : updatedAt // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$ProfileModelImplCopyWith<$Res>
    implements $ProfileModelCopyWith<$Res> {
  factory _$$ProfileModelImplCopyWith(
    _$ProfileModelImpl value,
    $Res Function(_$ProfileModelImpl) then,
  ) = __$$ProfileModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String? email,
    String role,
    String fullName,
    String? phone,
    String? city,
    String? governorate,
    String? locality,
    DateTime? dateOfBirth,
    String? bio,
    String? avatarUrl,
    int yearsExperience,
    List<String> certifications,
    String? specialization,
    List<String> fcmTokens,
    DateTime? createdAt,
    DateTime? updatedAt,
  });
}

/// @nodoc
class __$$ProfileModelImplCopyWithImpl<$Res>
    extends _$ProfileModelCopyWithImpl<$Res, _$ProfileModelImpl>
    implements _$$ProfileModelImplCopyWith<$Res> {
  __$$ProfileModelImplCopyWithImpl(
    _$ProfileModelImpl _value,
    $Res Function(_$ProfileModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ProfileModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? email = freezed,
    Object? role = null,
    Object? fullName = null,
    Object? phone = freezed,
    Object? city = freezed,
    Object? governorate = freezed,
    Object? locality = freezed,
    Object? dateOfBirth = freezed,
    Object? bio = freezed,
    Object? avatarUrl = freezed,
    Object? yearsExperience = null,
    Object? certifications = null,
    Object? specialization = freezed,
    Object? fcmTokens = null,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
  }) {
    return _then(
      _$ProfileModelImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        email: freezed == email
            ? _value.email
            : email // ignore: cast_nullable_to_non_nullable
                  as String?,
        role: null == role
            ? _value.role
            : role // ignore: cast_nullable_to_non_nullable
                  as String,
        fullName: null == fullName
            ? _value.fullName
            : fullName // ignore: cast_nullable_to_non_nullable
                  as String,
        phone: freezed == phone
            ? _value.phone
            : phone // ignore: cast_nullable_to_non_nullable
                  as String?,
        city: freezed == city
            ? _value.city
            : city // ignore: cast_nullable_to_non_nullable
                  as String?,
        governorate: freezed == governorate
            ? _value.governorate
            : governorate // ignore: cast_nullable_to_non_nullable
                  as String?,
        locality: freezed == locality
            ? _value.locality
            : locality // ignore: cast_nullable_to_non_nullable
                  as String?,
        dateOfBirth: freezed == dateOfBirth
            ? _value.dateOfBirth
            : dateOfBirth // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        bio: freezed == bio
            ? _value.bio
            : bio // ignore: cast_nullable_to_non_nullable
                  as String?,
        avatarUrl: freezed == avatarUrl
            ? _value.avatarUrl
            : avatarUrl // ignore: cast_nullable_to_non_nullable
                  as String?,
        yearsExperience: null == yearsExperience
            ? _value.yearsExperience
            : yearsExperience // ignore: cast_nullable_to_non_nullable
                  as int,
        certifications: null == certifications
            ? _value._certifications
            : certifications // ignore: cast_nullable_to_non_nullable
                  as List<String>,
        specialization: freezed == specialization
            ? _value.specialization
            : specialization // ignore: cast_nullable_to_non_nullable
                  as String?,
        fcmTokens: null == fcmTokens
            ? _value._fcmTokens
            : fcmTokens // ignore: cast_nullable_to_non_nullable
                  as List<String>,
        createdAt: freezed == createdAt
            ? _value.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        updatedAt: freezed == updatedAt
            ? _value.updatedAt
            : updatedAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
      ),
    );
  }
}

/// @nodoc

class _$ProfileModelImpl extends _ProfileModel {
  const _$ProfileModelImpl({
    required this.id,
    this.email,
    required this.role,
    this.fullName = '',
    this.phone,
    this.city,
    this.governorate,
    this.locality,
    this.dateOfBirth,
    this.bio,
    this.avatarUrl,
    this.yearsExperience = 0,
    final List<String> certifications = const [],
    this.specialization,
    final List<String> fcmTokens = const [],
    this.createdAt,
    this.updatedAt,
  }) : _certifications = certifications,
       _fcmTokens = fcmTokens,
       super._();

  @override
  final String id;
  @override
  final String? email;
  @override
  final String role;
  @override
  @JsonKey()
  final String fullName;
  @override
  final String? phone;
  @override
  final String? city;
  @override
  final String? governorate;
  @override
  final String? locality;
  @override
  final DateTime? dateOfBirth;
  @override
  final String? bio;
  @override
  final String? avatarUrl;
  @override
  @JsonKey()
  final int yearsExperience;
  final List<String> _certifications;
  @override
  @JsonKey()
  List<String> get certifications {
    if (_certifications is EqualUnmodifiableListView) return _certifications;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_certifications);
  }

  @override
  final String? specialization;
  final List<String> _fcmTokens;
  @override
  @JsonKey()
  List<String> get fcmTokens {
    if (_fcmTokens is EqualUnmodifiableListView) return _fcmTokens;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_fcmTokens);
  }

  @override
  final DateTime? createdAt;
  @override
  final DateTime? updatedAt;

  @override
  String toString() {
    return 'ProfileModel(id: $id, email: $email, role: $role, fullName: $fullName, phone: $phone, city: $city, governorate: $governorate, locality: $locality, dateOfBirth: $dateOfBirth, bio: $bio, avatarUrl: $avatarUrl, yearsExperience: $yearsExperience, certifications: $certifications, specialization: $specialization, fcmTokens: $fcmTokens, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ProfileModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.email, email) || other.email == email) &&
            (identical(other.role, role) || other.role == role) &&
            (identical(other.fullName, fullName) ||
                other.fullName == fullName) &&
            (identical(other.phone, phone) || other.phone == phone) &&
            (identical(other.city, city) || other.city == city) &&
            (identical(other.governorate, governorate) ||
                other.governorate == governorate) &&
            (identical(other.locality, locality) ||
                other.locality == locality) &&
            (identical(other.dateOfBirth, dateOfBirth) ||
                other.dateOfBirth == dateOfBirth) &&
            (identical(other.bio, bio) || other.bio == bio) &&
            (identical(other.avatarUrl, avatarUrl) ||
                other.avatarUrl == avatarUrl) &&
            (identical(other.yearsExperience, yearsExperience) ||
                other.yearsExperience == yearsExperience) &&
            const DeepCollectionEquality().equals(
              other._certifications,
              _certifications,
            ) &&
            (identical(other.specialization, specialization) ||
                other.specialization == specialization) &&
            const DeepCollectionEquality().equals(
              other._fcmTokens,
              _fcmTokens,
            ) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    email,
    role,
    fullName,
    phone,
    city,
    governorate,
    locality,
    dateOfBirth,
    bio,
    avatarUrl,
    yearsExperience,
    const DeepCollectionEquality().hash(_certifications),
    specialization,
    const DeepCollectionEquality().hash(_fcmTokens),
    createdAt,
    updatedAt,
  );

  /// Create a copy of ProfileModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ProfileModelImplCopyWith<_$ProfileModelImpl> get copyWith =>
      __$$ProfileModelImplCopyWithImpl<_$ProfileModelImpl>(this, _$identity);
}

abstract class _ProfileModel extends ProfileModel {
  const factory _ProfileModel({
    required final String id,
    final String? email,
    required final String role,
    final String fullName,
    final String? phone,
    final String? city,
    final String? governorate,
    final String? locality,
    final DateTime? dateOfBirth,
    final String? bio,
    final String? avatarUrl,
    final int yearsExperience,
    final List<String> certifications,
    final String? specialization,
    final List<String> fcmTokens,
    final DateTime? createdAt,
    final DateTime? updatedAt,
  }) = _$ProfileModelImpl;
  const _ProfileModel._() : super._();

  @override
  String get id;
  @override
  String? get email;
  @override
  String get role;
  @override
  String get fullName;
  @override
  String? get phone;
  @override
  String? get city;
  @override
  String? get governorate;
  @override
  String? get locality;
  @override
  DateTime? get dateOfBirth;
  @override
  String? get bio;
  @override
  String? get avatarUrl;
  @override
  int get yearsExperience;
  @override
  List<String> get certifications;
  @override
  String? get specialization;
  @override
  List<String> get fcmTokens;
  @override
  DateTime? get createdAt;
  @override
  DateTime? get updatedAt;

  /// Create a copy of ProfileModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ProfileModelImplCopyWith<_$ProfileModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
