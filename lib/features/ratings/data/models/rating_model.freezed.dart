// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'rating_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$RatingModel {
  String get id => throw _privateConstructorUsedError;
  String get requestId => throw _privateConstructorUsedError;
  String get clientId => throw _privateConstructorUsedError;
  String get professionalId => throw _privateConstructorUsedError;
  int get rating => throw _privateConstructorUsedError;
  String? get comment => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;

  /// Create a copy of RatingModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $RatingModelCopyWith<RatingModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $RatingModelCopyWith<$Res> {
  factory $RatingModelCopyWith(
    RatingModel value,
    $Res Function(RatingModel) then,
  ) = _$RatingModelCopyWithImpl<$Res, RatingModel>;
  @useResult
  $Res call({
    String id,
    String requestId,
    String clientId,
    String professionalId,
    int rating,
    String? comment,
    DateTime createdAt,
  });
}

/// @nodoc
class _$RatingModelCopyWithImpl<$Res, $Val extends RatingModel>
    implements $RatingModelCopyWith<$Res> {
  _$RatingModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of RatingModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? requestId = null,
    Object? clientId = null,
    Object? professionalId = null,
    Object? rating = null,
    Object? comment = freezed,
    Object? createdAt = null,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            requestId: null == requestId
                ? _value.requestId
                : requestId // ignore: cast_nullable_to_non_nullable
                      as String,
            clientId: null == clientId
                ? _value.clientId
                : clientId // ignore: cast_nullable_to_non_nullable
                      as String,
            professionalId: null == professionalId
                ? _value.professionalId
                : professionalId // ignore: cast_nullable_to_non_nullable
                      as String,
            rating: null == rating
                ? _value.rating
                : rating // ignore: cast_nullable_to_non_nullable
                      as int,
            comment: freezed == comment
                ? _value.comment
                : comment // ignore: cast_nullable_to_non_nullable
                      as String?,
            createdAt: null == createdAt
                ? _value.createdAt
                : createdAt // ignore: cast_nullable_to_non_nullable
                      as DateTime,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$RatingModelImplCopyWith<$Res>
    implements $RatingModelCopyWith<$Res> {
  factory _$$RatingModelImplCopyWith(
    _$RatingModelImpl value,
    $Res Function(_$RatingModelImpl) then,
  ) = __$$RatingModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String requestId,
    String clientId,
    String professionalId,
    int rating,
    String? comment,
    DateTime createdAt,
  });
}

/// @nodoc
class __$$RatingModelImplCopyWithImpl<$Res>
    extends _$RatingModelCopyWithImpl<$Res, _$RatingModelImpl>
    implements _$$RatingModelImplCopyWith<$Res> {
  __$$RatingModelImplCopyWithImpl(
    _$RatingModelImpl _value,
    $Res Function(_$RatingModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of RatingModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? requestId = null,
    Object? clientId = null,
    Object? professionalId = null,
    Object? rating = null,
    Object? comment = freezed,
    Object? createdAt = null,
  }) {
    return _then(
      _$RatingModelImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        requestId: null == requestId
            ? _value.requestId
            : requestId // ignore: cast_nullable_to_non_nullable
                  as String,
        clientId: null == clientId
            ? _value.clientId
            : clientId // ignore: cast_nullable_to_non_nullable
                  as String,
        professionalId: null == professionalId
            ? _value.professionalId
            : professionalId // ignore: cast_nullable_to_non_nullable
                  as String,
        rating: null == rating
            ? _value.rating
            : rating // ignore: cast_nullable_to_non_nullable
                  as int,
        comment: freezed == comment
            ? _value.comment
            : comment // ignore: cast_nullable_to_non_nullable
                  as String?,
        createdAt: null == createdAt
            ? _value.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
      ),
    );
  }
}

/// @nodoc

class _$RatingModelImpl extends _RatingModel {
  const _$RatingModelImpl({
    required this.id,
    required this.requestId,
    required this.clientId,
    required this.professionalId,
    required this.rating,
    this.comment,
    required this.createdAt,
  }) : super._();

  @override
  final String id;
  @override
  final String requestId;
  @override
  final String clientId;
  @override
  final String professionalId;
  @override
  final int rating;
  @override
  final String? comment;
  @override
  final DateTime createdAt;

  @override
  String toString() {
    return 'RatingModel(id: $id, requestId: $requestId, clientId: $clientId, professionalId: $professionalId, rating: $rating, comment: $comment, createdAt: $createdAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$RatingModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.requestId, requestId) ||
                other.requestId == requestId) &&
            (identical(other.clientId, clientId) ||
                other.clientId == clientId) &&
            (identical(other.professionalId, professionalId) ||
                other.professionalId == professionalId) &&
            (identical(other.rating, rating) || other.rating == rating) &&
            (identical(other.comment, comment) || other.comment == comment) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    requestId,
    clientId,
    professionalId,
    rating,
    comment,
    createdAt,
  );

  /// Create a copy of RatingModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$RatingModelImplCopyWith<_$RatingModelImpl> get copyWith =>
      __$$RatingModelImplCopyWithImpl<_$RatingModelImpl>(this, _$identity);
}

abstract class _RatingModel extends RatingModel {
  const factory _RatingModel({
    required final String id,
    required final String requestId,
    required final String clientId,
    required final String professionalId,
    required final int rating,
    final String? comment,
    required final DateTime createdAt,
  }) = _$RatingModelImpl;
  const _RatingModel._() : super._();

  @override
  String get id;
  @override
  String get requestId;
  @override
  String get clientId;
  @override
  String get professionalId;
  @override
  int get rating;
  @override
  String? get comment;
  @override
  DateTime get createdAt;

  /// Create a copy of RatingModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$RatingModelImplCopyWith<_$RatingModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
