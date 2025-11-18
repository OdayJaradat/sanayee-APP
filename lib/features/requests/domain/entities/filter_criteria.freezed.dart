// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'filter_criteria.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

FilterCriteria _$FilterCriteriaFromJson(Map<String, dynamic> json) {
  return _FilterCriteria.fromJson(json);
}

/// @nodoc
mixin _$FilterCriteria {
  List<String> get categories => throw _privateConstructorUsedError;
  double? get budgetMin => throw _privateConstructorUsedError;
  double? get budgetMax => throw _privateConstructorUsedError;
  double? get distanceKm => throw _privateConstructorUsedError;
  SortBy get sortBy => throw _privateConstructorUsedError;

  /// Serializes this FilterCriteria to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of FilterCriteria
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $FilterCriteriaCopyWith<FilterCriteria> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $FilterCriteriaCopyWith<$Res> {
  factory $FilterCriteriaCopyWith(
    FilterCriteria value,
    $Res Function(FilterCriteria) then,
  ) = _$FilterCriteriaCopyWithImpl<$Res, FilterCriteria>;
  @useResult
  $Res call({
    List<String> categories,
    double? budgetMin,
    double? budgetMax,
    double? distanceKm,
    SortBy sortBy,
  });
}

/// @nodoc
class _$FilterCriteriaCopyWithImpl<$Res, $Val extends FilterCriteria>
    implements $FilterCriteriaCopyWith<$Res> {
  _$FilterCriteriaCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of FilterCriteria
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? categories = null,
    Object? budgetMin = freezed,
    Object? budgetMax = freezed,
    Object? distanceKm = freezed,
    Object? sortBy = null,
  }) {
    return _then(
      _value.copyWith(
            categories: null == categories
                ? _value.categories
                : categories // ignore: cast_nullable_to_non_nullable
                      as List<String>,
            budgetMin: freezed == budgetMin
                ? _value.budgetMin
                : budgetMin // ignore: cast_nullable_to_non_nullable
                      as double?,
            budgetMax: freezed == budgetMax
                ? _value.budgetMax
                : budgetMax // ignore: cast_nullable_to_non_nullable
                      as double?,
            distanceKm: freezed == distanceKm
                ? _value.distanceKm
                : distanceKm // ignore: cast_nullable_to_non_nullable
                      as double?,
            sortBy: null == sortBy
                ? _value.sortBy
                : sortBy // ignore: cast_nullable_to_non_nullable
                      as SortBy,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$FilterCriteriaImplCopyWith<$Res>
    implements $FilterCriteriaCopyWith<$Res> {
  factory _$$FilterCriteriaImplCopyWith(
    _$FilterCriteriaImpl value,
    $Res Function(_$FilterCriteriaImpl) then,
  ) = __$$FilterCriteriaImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    List<String> categories,
    double? budgetMin,
    double? budgetMax,
    double? distanceKm,
    SortBy sortBy,
  });
}

/// @nodoc
class __$$FilterCriteriaImplCopyWithImpl<$Res>
    extends _$FilterCriteriaCopyWithImpl<$Res, _$FilterCriteriaImpl>
    implements _$$FilterCriteriaImplCopyWith<$Res> {
  __$$FilterCriteriaImplCopyWithImpl(
    _$FilterCriteriaImpl _value,
    $Res Function(_$FilterCriteriaImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of FilterCriteria
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? categories = null,
    Object? budgetMin = freezed,
    Object? budgetMax = freezed,
    Object? distanceKm = freezed,
    Object? sortBy = null,
  }) {
    return _then(
      _$FilterCriteriaImpl(
        categories: null == categories
            ? _value._categories
            : categories // ignore: cast_nullable_to_non_nullable
                  as List<String>,
        budgetMin: freezed == budgetMin
            ? _value.budgetMin
            : budgetMin // ignore: cast_nullable_to_non_nullable
                  as double?,
        budgetMax: freezed == budgetMax
            ? _value.budgetMax
            : budgetMax // ignore: cast_nullable_to_non_nullable
                  as double?,
        distanceKm: freezed == distanceKm
            ? _value.distanceKm
            : distanceKm // ignore: cast_nullable_to_non_nullable
                  as double?,
        sortBy: null == sortBy
            ? _value.sortBy
            : sortBy // ignore: cast_nullable_to_non_nullable
                  as SortBy,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$FilterCriteriaImpl implements _FilterCriteria {
  const _$FilterCriteriaImpl({
    final List<String> categories = const [],
    this.budgetMin,
    this.budgetMax,
    this.distanceKm,
    this.sortBy = SortBy.dateDesc,
  }) : _categories = categories;

  factory _$FilterCriteriaImpl.fromJson(Map<String, dynamic> json) =>
      _$$FilterCriteriaImplFromJson(json);

  final List<String> _categories;
  @override
  @JsonKey()
  List<String> get categories {
    if (_categories is EqualUnmodifiableListView) return _categories;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_categories);
  }

  @override
  final double? budgetMin;
  @override
  final double? budgetMax;
  @override
  final double? distanceKm;
  @override
  @JsonKey()
  final SortBy sortBy;

  @override
  String toString() {
    return 'FilterCriteria(categories: $categories, budgetMin: $budgetMin, budgetMax: $budgetMax, distanceKm: $distanceKm, sortBy: $sortBy)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$FilterCriteriaImpl &&
            const DeepCollectionEquality().equals(
              other._categories,
              _categories,
            ) &&
            (identical(other.budgetMin, budgetMin) ||
                other.budgetMin == budgetMin) &&
            (identical(other.budgetMax, budgetMax) ||
                other.budgetMax == budgetMax) &&
            (identical(other.distanceKm, distanceKm) ||
                other.distanceKm == distanceKm) &&
            (identical(other.sortBy, sortBy) || other.sortBy == sortBy));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    const DeepCollectionEquality().hash(_categories),
    budgetMin,
    budgetMax,
    distanceKm,
    sortBy,
  );

  /// Create a copy of FilterCriteria
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$FilterCriteriaImplCopyWith<_$FilterCriteriaImpl> get copyWith =>
      __$$FilterCriteriaImplCopyWithImpl<_$FilterCriteriaImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$FilterCriteriaImplToJson(this);
  }
}

abstract class _FilterCriteria implements FilterCriteria {
  const factory _FilterCriteria({
    final List<String> categories,
    final double? budgetMin,
    final double? budgetMax,
    final double? distanceKm,
    final SortBy sortBy,
  }) = _$FilterCriteriaImpl;

  factory _FilterCriteria.fromJson(Map<String, dynamic> json) =
      _$FilterCriteriaImpl.fromJson;

  @override
  List<String> get categories;
  @override
  double? get budgetMin;
  @override
  double? get budgetMax;
  @override
  double? get distanceKm;
  @override
  SortBy get sortBy;

  /// Create a copy of FilterCriteria
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$FilterCriteriaImplCopyWith<_$FilterCriteriaImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
