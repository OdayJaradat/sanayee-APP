// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'professional_stats_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$ProfessionalStatsModel {
  double get avgRating => throw _privateConstructorUsedError;
  int get ratingsCount => throw _privateConstructorUsedError;
  int get completedRequests => throw _privateConstructorUsedError;

  /// Create a copy of ProfessionalStatsModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ProfessionalStatsModelCopyWith<ProfessionalStatsModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ProfessionalStatsModelCopyWith<$Res> {
  factory $ProfessionalStatsModelCopyWith(
    ProfessionalStatsModel value,
    $Res Function(ProfessionalStatsModel) then,
  ) = _$ProfessionalStatsModelCopyWithImpl<$Res, ProfessionalStatsModel>;
  @useResult
  $Res call({double avgRating, int ratingsCount, int completedRequests});
}

/// @nodoc
class _$ProfessionalStatsModelCopyWithImpl<
  $Res,
  $Val extends ProfessionalStatsModel
>
    implements $ProfessionalStatsModelCopyWith<$Res> {
  _$ProfessionalStatsModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ProfessionalStatsModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? avgRating = null,
    Object? ratingsCount = null,
    Object? completedRequests = null,
  }) {
    return _then(
      _value.copyWith(
            avgRating: null == avgRating
                ? _value.avgRating
                : avgRating // ignore: cast_nullable_to_non_nullable
                      as double,
            ratingsCount: null == ratingsCount
                ? _value.ratingsCount
                : ratingsCount // ignore: cast_nullable_to_non_nullable
                      as int,
            completedRequests: null == completedRequests
                ? _value.completedRequests
                : completedRequests // ignore: cast_nullable_to_non_nullable
                      as int,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$ProfessionalStatsModelImplCopyWith<$Res>
    implements $ProfessionalStatsModelCopyWith<$Res> {
  factory _$$ProfessionalStatsModelImplCopyWith(
    _$ProfessionalStatsModelImpl value,
    $Res Function(_$ProfessionalStatsModelImpl) then,
  ) = __$$ProfessionalStatsModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({double avgRating, int ratingsCount, int completedRequests});
}

/// @nodoc
class __$$ProfessionalStatsModelImplCopyWithImpl<$Res>
    extends
        _$ProfessionalStatsModelCopyWithImpl<$Res, _$ProfessionalStatsModelImpl>
    implements _$$ProfessionalStatsModelImplCopyWith<$Res> {
  __$$ProfessionalStatsModelImplCopyWithImpl(
    _$ProfessionalStatsModelImpl _value,
    $Res Function(_$ProfessionalStatsModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ProfessionalStatsModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? avgRating = null,
    Object? ratingsCount = null,
    Object? completedRequests = null,
  }) {
    return _then(
      _$ProfessionalStatsModelImpl(
        avgRating: null == avgRating
            ? _value.avgRating
            : avgRating // ignore: cast_nullable_to_non_nullable
                  as double,
        ratingsCount: null == ratingsCount
            ? _value.ratingsCount
            : ratingsCount // ignore: cast_nullable_to_non_nullable
                  as int,
        completedRequests: null == completedRequests
            ? _value.completedRequests
            : completedRequests // ignore: cast_nullable_to_non_nullable
                  as int,
      ),
    );
  }
}

/// @nodoc

class _$ProfessionalStatsModelImpl implements _ProfessionalStatsModel {
  const _$ProfessionalStatsModelImpl({
    required this.avgRating,
    required this.ratingsCount,
    required this.completedRequests,
  });

  @override
  final double avgRating;
  @override
  final int ratingsCount;
  @override
  final int completedRequests;

  @override
  String toString() {
    return 'ProfessionalStatsModel(avgRating: $avgRating, ratingsCount: $ratingsCount, completedRequests: $completedRequests)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ProfessionalStatsModelImpl &&
            (identical(other.avgRating, avgRating) ||
                other.avgRating == avgRating) &&
            (identical(other.ratingsCount, ratingsCount) ||
                other.ratingsCount == ratingsCount) &&
            (identical(other.completedRequests, completedRequests) ||
                other.completedRequests == completedRequests));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, avgRating, ratingsCount, completedRequests);

  /// Create a copy of ProfessionalStatsModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ProfessionalStatsModelImplCopyWith<_$ProfessionalStatsModelImpl>
  get copyWith =>
      __$$ProfessionalStatsModelImplCopyWithImpl<_$ProfessionalStatsModelImpl>(
        this,
        _$identity,
      );
}

abstract class _ProfessionalStatsModel implements ProfessionalStatsModel {
  const factory _ProfessionalStatsModel({
    required final double avgRating,
    required final int ratingsCount,
    required final int completedRequests,
  }) = _$ProfessionalStatsModelImpl;

  @override
  double get avgRating;
  @override
  int get ratingsCount;
  @override
  int get completedRequests;

  /// Create a copy of ProfessionalStatsModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ProfessionalStatsModelImplCopyWith<_$ProfessionalStatsModelImpl>
  get copyWith => throw _privateConstructorUsedError;
}
