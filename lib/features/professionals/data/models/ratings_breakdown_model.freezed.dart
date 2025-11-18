// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'ratings_breakdown_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

RatingsBreakdownModel _$RatingsBreakdownModelFromJson(
  Map<String, dynamic> json,
) {
  return _RatingsBreakdownModel.fromJson(json);
}

/// @nodoc
mixin _$RatingsBreakdownModel {
  int get rating => throw _privateConstructorUsedError;
  int get count => throw _privateConstructorUsedError;
  double get percentage => throw _privateConstructorUsedError;

  /// Serializes this RatingsBreakdownModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of RatingsBreakdownModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $RatingsBreakdownModelCopyWith<RatingsBreakdownModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $RatingsBreakdownModelCopyWith<$Res> {
  factory $RatingsBreakdownModelCopyWith(
    RatingsBreakdownModel value,
    $Res Function(RatingsBreakdownModel) then,
  ) = _$RatingsBreakdownModelCopyWithImpl<$Res, RatingsBreakdownModel>;
  @useResult
  $Res call({int rating, int count, double percentage});
}

/// @nodoc
class _$RatingsBreakdownModelCopyWithImpl<
  $Res,
  $Val extends RatingsBreakdownModel
>
    implements $RatingsBreakdownModelCopyWith<$Res> {
  _$RatingsBreakdownModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of RatingsBreakdownModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? rating = null,
    Object? count = null,
    Object? percentage = null,
  }) {
    return _then(
      _value.copyWith(
            rating: null == rating
                ? _value.rating
                : rating // ignore: cast_nullable_to_non_nullable
                      as int,
            count: null == count
                ? _value.count
                : count // ignore: cast_nullable_to_non_nullable
                      as int,
            percentage: null == percentage
                ? _value.percentage
                : percentage // ignore: cast_nullable_to_non_nullable
                      as double,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$RatingsBreakdownModelImplCopyWith<$Res>
    implements $RatingsBreakdownModelCopyWith<$Res> {
  factory _$$RatingsBreakdownModelImplCopyWith(
    _$RatingsBreakdownModelImpl value,
    $Res Function(_$RatingsBreakdownModelImpl) then,
  ) = __$$RatingsBreakdownModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({int rating, int count, double percentage});
}

/// @nodoc
class __$$RatingsBreakdownModelImplCopyWithImpl<$Res>
    extends
        _$RatingsBreakdownModelCopyWithImpl<$Res, _$RatingsBreakdownModelImpl>
    implements _$$RatingsBreakdownModelImplCopyWith<$Res> {
  __$$RatingsBreakdownModelImplCopyWithImpl(
    _$RatingsBreakdownModelImpl _value,
    $Res Function(_$RatingsBreakdownModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of RatingsBreakdownModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? rating = null,
    Object? count = null,
    Object? percentage = null,
  }) {
    return _then(
      _$RatingsBreakdownModelImpl(
        rating: null == rating
            ? _value.rating
            : rating // ignore: cast_nullable_to_non_nullable
                  as int,
        count: null == count
            ? _value.count
            : count // ignore: cast_nullable_to_non_nullable
                  as int,
        percentage: null == percentage
            ? _value.percentage
            : percentage // ignore: cast_nullable_to_non_nullable
                  as double,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$RatingsBreakdownModelImpl implements _RatingsBreakdownModel {
  const _$RatingsBreakdownModelImpl({
    required this.rating,
    required this.count,
    required this.percentage,
  });

  factory _$RatingsBreakdownModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$RatingsBreakdownModelImplFromJson(json);

  @override
  final int rating;
  @override
  final int count;
  @override
  final double percentage;

  @override
  String toString() {
    return 'RatingsBreakdownModel(rating: $rating, count: $count, percentage: $percentage)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$RatingsBreakdownModelImpl &&
            (identical(other.rating, rating) || other.rating == rating) &&
            (identical(other.count, count) || other.count == count) &&
            (identical(other.percentage, percentage) ||
                other.percentage == percentage));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, rating, count, percentage);

  /// Create a copy of RatingsBreakdownModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$RatingsBreakdownModelImplCopyWith<_$RatingsBreakdownModelImpl>
  get copyWith =>
      __$$RatingsBreakdownModelImplCopyWithImpl<_$RatingsBreakdownModelImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$RatingsBreakdownModelImplToJson(this);
  }
}

abstract class _RatingsBreakdownModel implements RatingsBreakdownModel {
  const factory _RatingsBreakdownModel({
    required final int rating,
    required final int count,
    required final double percentage,
  }) = _$RatingsBreakdownModelImpl;

  factory _RatingsBreakdownModel.fromJson(Map<String, dynamic> json) =
      _$RatingsBreakdownModelImpl.fromJson;

  @override
  int get rating;
  @override
  int get count;
  @override
  double get percentage;

  /// Create a copy of RatingsBreakdownModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$RatingsBreakdownModelImplCopyWith<_$RatingsBreakdownModelImpl>
  get copyWith => throw _privateConstructorUsedError;
}
