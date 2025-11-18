// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'recent_job_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$RecentJobModel {
  String get requestId => throw _privateConstructorUsedError;
  String get title => throw _privateConstructorUsedError;
  String? get description => throw _privateConstructorUsedError;
  String get status => throw _privateConstructorUsedError;
  String get clientId => throw _privateConstructorUsedError;
  String? get clientName => throw _privateConstructorUsedError;
  String? get clientAvatar => throw _privateConstructorUsedError;
  DateTime? get completedAt => throw _privateConstructorUsedError;

  /// Create a copy of RecentJobModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $RecentJobModelCopyWith<RecentJobModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $RecentJobModelCopyWith<$Res> {
  factory $RecentJobModelCopyWith(
    RecentJobModel value,
    $Res Function(RecentJobModel) then,
  ) = _$RecentJobModelCopyWithImpl<$Res, RecentJobModel>;
  @useResult
  $Res call({
    String requestId,
    String title,
    String? description,
    String status,
    String clientId,
    String? clientName,
    String? clientAvatar,
    DateTime? completedAt,
  });
}

/// @nodoc
class _$RecentJobModelCopyWithImpl<$Res, $Val extends RecentJobModel>
    implements $RecentJobModelCopyWith<$Res> {
  _$RecentJobModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of RecentJobModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? requestId = null,
    Object? title = null,
    Object? description = freezed,
    Object? status = null,
    Object? clientId = null,
    Object? clientName = freezed,
    Object? clientAvatar = freezed,
    Object? completedAt = freezed,
  }) {
    return _then(
      _value.copyWith(
            requestId: null == requestId
                ? _value.requestId
                : requestId // ignore: cast_nullable_to_non_nullable
                      as String,
            title: null == title
                ? _value.title
                : title // ignore: cast_nullable_to_non_nullable
                      as String,
            description: freezed == description
                ? _value.description
                : description // ignore: cast_nullable_to_non_nullable
                      as String?,
            status: null == status
                ? _value.status
                : status // ignore: cast_nullable_to_non_nullable
                      as String,
            clientId: null == clientId
                ? _value.clientId
                : clientId // ignore: cast_nullable_to_non_nullable
                      as String,
            clientName: freezed == clientName
                ? _value.clientName
                : clientName // ignore: cast_nullable_to_non_nullable
                      as String?,
            clientAvatar: freezed == clientAvatar
                ? _value.clientAvatar
                : clientAvatar // ignore: cast_nullable_to_non_nullable
                      as String?,
            completedAt: freezed == completedAt
                ? _value.completedAt
                : completedAt // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$RecentJobModelImplCopyWith<$Res>
    implements $RecentJobModelCopyWith<$Res> {
  factory _$$RecentJobModelImplCopyWith(
    _$RecentJobModelImpl value,
    $Res Function(_$RecentJobModelImpl) then,
  ) = __$$RecentJobModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String requestId,
    String title,
    String? description,
    String status,
    String clientId,
    String? clientName,
    String? clientAvatar,
    DateTime? completedAt,
  });
}

/// @nodoc
class __$$RecentJobModelImplCopyWithImpl<$Res>
    extends _$RecentJobModelCopyWithImpl<$Res, _$RecentJobModelImpl>
    implements _$$RecentJobModelImplCopyWith<$Res> {
  __$$RecentJobModelImplCopyWithImpl(
    _$RecentJobModelImpl _value,
    $Res Function(_$RecentJobModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of RecentJobModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? requestId = null,
    Object? title = null,
    Object? description = freezed,
    Object? status = null,
    Object? clientId = null,
    Object? clientName = freezed,
    Object? clientAvatar = freezed,
    Object? completedAt = freezed,
  }) {
    return _then(
      _$RecentJobModelImpl(
        requestId: null == requestId
            ? _value.requestId
            : requestId // ignore: cast_nullable_to_non_nullable
                  as String,
        title: null == title
            ? _value.title
            : title // ignore: cast_nullable_to_non_nullable
                  as String,
        description: freezed == description
            ? _value.description
            : description // ignore: cast_nullable_to_non_nullable
                  as String?,
        status: null == status
            ? _value.status
            : status // ignore: cast_nullable_to_non_nullable
                  as String,
        clientId: null == clientId
            ? _value.clientId
            : clientId // ignore: cast_nullable_to_non_nullable
                  as String,
        clientName: freezed == clientName
            ? _value.clientName
            : clientName // ignore: cast_nullable_to_non_nullable
                  as String?,
        clientAvatar: freezed == clientAvatar
            ? _value.clientAvatar
            : clientAvatar // ignore: cast_nullable_to_non_nullable
                  as String?,
        completedAt: freezed == completedAt
            ? _value.completedAt
            : completedAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
      ),
    );
  }
}

/// @nodoc

class _$RecentJobModelImpl implements _RecentJobModel {
  const _$RecentJobModelImpl({
    required this.requestId,
    required this.title,
    this.description,
    required this.status,
    required this.clientId,
    this.clientName,
    this.clientAvatar,
    this.completedAt,
  });

  @override
  final String requestId;
  @override
  final String title;
  @override
  final String? description;
  @override
  final String status;
  @override
  final String clientId;
  @override
  final String? clientName;
  @override
  final String? clientAvatar;
  @override
  final DateTime? completedAt;

  @override
  String toString() {
    return 'RecentJobModel(requestId: $requestId, title: $title, description: $description, status: $status, clientId: $clientId, clientName: $clientName, clientAvatar: $clientAvatar, completedAt: $completedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$RecentJobModelImpl &&
            (identical(other.requestId, requestId) ||
                other.requestId == requestId) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.clientId, clientId) ||
                other.clientId == clientId) &&
            (identical(other.clientName, clientName) ||
                other.clientName == clientName) &&
            (identical(other.clientAvatar, clientAvatar) ||
                other.clientAvatar == clientAvatar) &&
            (identical(other.completedAt, completedAt) ||
                other.completedAt == completedAt));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    requestId,
    title,
    description,
    status,
    clientId,
    clientName,
    clientAvatar,
    completedAt,
  );

  /// Create a copy of RecentJobModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$RecentJobModelImplCopyWith<_$RecentJobModelImpl> get copyWith =>
      __$$RecentJobModelImplCopyWithImpl<_$RecentJobModelImpl>(
        this,
        _$identity,
      );
}

abstract class _RecentJobModel implements RecentJobModel {
  const factory _RecentJobModel({
    required final String requestId,
    required final String title,
    final String? description,
    required final String status,
    required final String clientId,
    final String? clientName,
    final String? clientAvatar,
    final DateTime? completedAt,
  }) = _$RecentJobModelImpl;

  @override
  String get requestId;
  @override
  String get title;
  @override
  String? get description;
  @override
  String get status;
  @override
  String get clientId;
  @override
  String? get clientName;
  @override
  String? get clientAvatar;
  @override
  DateTime? get completedAt;

  /// Create a copy of RecentJobModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$RecentJobModelImplCopyWith<_$RecentJobModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
