// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'professional.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$Professional {
  String get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String? get avatarUrl => throw _privateConstructorUsedError;
  List<String> get skills => throw _privateConstructorUsedError;
  double get rating => throw _privateConstructorUsedError;
  int get jobsCount => throw _privateConstructorUsedError;
  String? get bio => throw _privateConstructorUsedError;
  double? get latitude => throw _privateConstructorUsedError;
  double? get longitude => throw _privateConstructorUsedError;

  /// Create a copy of Professional
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ProfessionalCopyWith<Professional> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ProfessionalCopyWith<$Res> {
  factory $ProfessionalCopyWith(
    Professional value,
    $Res Function(Professional) then,
  ) = _$ProfessionalCopyWithImpl<$Res, Professional>;
  @useResult
  $Res call({
    String id,
    String name,
    String? avatarUrl,
    List<String> skills,
    double rating,
    int jobsCount,
    String? bio,
    double? latitude,
    double? longitude,
  });
}

/// @nodoc
class _$ProfessionalCopyWithImpl<$Res, $Val extends Professional>
    implements $ProfessionalCopyWith<$Res> {
  _$ProfessionalCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Professional
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? avatarUrl = freezed,
    Object? skills = null,
    Object? rating = null,
    Object? jobsCount = null,
    Object? bio = freezed,
    Object? latitude = freezed,
    Object? longitude = freezed,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            name: null == name
                ? _value.name
                : name // ignore: cast_nullable_to_non_nullable
                      as String,
            avatarUrl: freezed == avatarUrl
                ? _value.avatarUrl
                : avatarUrl // ignore: cast_nullable_to_non_nullable
                      as String?,
            skills: null == skills
                ? _value.skills
                : skills // ignore: cast_nullable_to_non_nullable
                      as List<String>,
            rating: null == rating
                ? _value.rating
                : rating // ignore: cast_nullable_to_non_nullable
                      as double,
            jobsCount: null == jobsCount
                ? _value.jobsCount
                : jobsCount // ignore: cast_nullable_to_non_nullable
                      as int,
            bio: freezed == bio
                ? _value.bio
                : bio // ignore: cast_nullable_to_non_nullable
                      as String?,
            latitude: freezed == latitude
                ? _value.latitude
                : latitude // ignore: cast_nullable_to_non_nullable
                      as double?,
            longitude: freezed == longitude
                ? _value.longitude
                : longitude // ignore: cast_nullable_to_non_nullable
                      as double?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$ProfessionalImplCopyWith<$Res>
    implements $ProfessionalCopyWith<$Res> {
  factory _$$ProfessionalImplCopyWith(
    _$ProfessionalImpl value,
    $Res Function(_$ProfessionalImpl) then,
  ) = __$$ProfessionalImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String name,
    String? avatarUrl,
    List<String> skills,
    double rating,
    int jobsCount,
    String? bio,
    double? latitude,
    double? longitude,
  });
}

/// @nodoc
class __$$ProfessionalImplCopyWithImpl<$Res>
    extends _$ProfessionalCopyWithImpl<$Res, _$ProfessionalImpl>
    implements _$$ProfessionalImplCopyWith<$Res> {
  __$$ProfessionalImplCopyWithImpl(
    _$ProfessionalImpl _value,
    $Res Function(_$ProfessionalImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of Professional
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? avatarUrl = freezed,
    Object? skills = null,
    Object? rating = null,
    Object? jobsCount = null,
    Object? bio = freezed,
    Object? latitude = freezed,
    Object? longitude = freezed,
  }) {
    return _then(
      _$ProfessionalImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        name: null == name
            ? _value.name
            : name // ignore: cast_nullable_to_non_nullable
                  as String,
        avatarUrl: freezed == avatarUrl
            ? _value.avatarUrl
            : avatarUrl // ignore: cast_nullable_to_non_nullable
                  as String?,
        skills: null == skills
            ? _value._skills
            : skills // ignore: cast_nullable_to_non_nullable
                  as List<String>,
        rating: null == rating
            ? _value.rating
            : rating // ignore: cast_nullable_to_non_nullable
                  as double,
        jobsCount: null == jobsCount
            ? _value.jobsCount
            : jobsCount // ignore: cast_nullable_to_non_nullable
                  as int,
        bio: freezed == bio
            ? _value.bio
            : bio // ignore: cast_nullable_to_non_nullable
                  as String?,
        latitude: freezed == latitude
            ? _value.latitude
            : latitude // ignore: cast_nullable_to_non_nullable
                  as double?,
        longitude: freezed == longitude
            ? _value.longitude
            : longitude // ignore: cast_nullable_to_non_nullable
                  as double?,
      ),
    );
  }
}

/// @nodoc

class _$ProfessionalImpl extends _Professional {
  const _$ProfessionalImpl({
    required this.id,
    required this.name,
    this.avatarUrl,
    required final List<String> skills,
    required this.rating,
    required this.jobsCount,
    this.bio,
    this.latitude,
    this.longitude,
  }) : _skills = skills,
       super._();

  @override
  final String id;
  @override
  final String name;
  @override
  final String? avatarUrl;
  final List<String> _skills;
  @override
  List<String> get skills {
    if (_skills is EqualUnmodifiableListView) return _skills;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_skills);
  }

  @override
  final double rating;
  @override
  final int jobsCount;
  @override
  final String? bio;
  @override
  final double? latitude;
  @override
  final double? longitude;

  @override
  String toString() {
    return 'Professional(id: $id, name: $name, avatarUrl: $avatarUrl, skills: $skills, rating: $rating, jobsCount: $jobsCount, bio: $bio, latitude: $latitude, longitude: $longitude)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ProfessionalImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.avatarUrl, avatarUrl) ||
                other.avatarUrl == avatarUrl) &&
            const DeepCollectionEquality().equals(other._skills, _skills) &&
            (identical(other.rating, rating) || other.rating == rating) &&
            (identical(other.jobsCount, jobsCount) ||
                other.jobsCount == jobsCount) &&
            (identical(other.bio, bio) || other.bio == bio) &&
            (identical(other.latitude, latitude) ||
                other.latitude == latitude) &&
            (identical(other.longitude, longitude) ||
                other.longitude == longitude));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    name,
    avatarUrl,
    const DeepCollectionEquality().hash(_skills),
    rating,
    jobsCount,
    bio,
    latitude,
    longitude,
  );

  /// Create a copy of Professional
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ProfessionalImplCopyWith<_$ProfessionalImpl> get copyWith =>
      __$$ProfessionalImplCopyWithImpl<_$ProfessionalImpl>(this, _$identity);
}

abstract class _Professional extends Professional {
  const factory _Professional({
    required final String id,
    required final String name,
    final String? avatarUrl,
    required final List<String> skills,
    required final double rating,
    required final int jobsCount,
    final String? bio,
    final double? latitude,
    final double? longitude,
  }) = _$ProfessionalImpl;
  const _Professional._() : super._();

  @override
  String get id;
  @override
  String get name;
  @override
  String? get avatarUrl;
  @override
  List<String> get skills;
  @override
  double get rating;
  @override
  int get jobsCount;
  @override
  String? get bio;
  @override
  double? get latitude;
  @override
  double? get longitude;

  /// Create a copy of Professional
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ProfessionalImplCopyWith<_$ProfessionalImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
