// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'hiring_post_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

HiringPostModel _$HiringPostModelFromJson(Map<String, dynamic> json) {
  return _HiringPostModel.fromJson(json);
}

/// @nodoc
mixin _$HiringPostModel {
  String get id => throw _privateConstructorUsedError;
  String get professionalId => throw _privateConstructorUsedError;
  String get title => throw _privateConstructorUsedError;
  String get description => throw _privateConstructorUsedError;
  JobType get jobType => throw _privateConstructorUsedError;
  String? get durationText => throw _privateConstructorUsedError;
  double? get salaryAmount => throw _privateConstructorUsedError;
  Map<String, double>? get location => throw _privateConstructorUsedError;
  PostStatus get status => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;
  @ServiceCategoryConverter()
  ServiceCategory? get category => throw _privateConstructorUsedError;
  String? get governorate => throw _privateConstructorUsedError;
  String? get locality => throw _privateConstructorUsedError;
  String? get address => throw _privateConstructorUsedError;
  PayType? get payType => throw _privateConstructorUsedError;
  double? get fixedAmount => throw _privateConstructorUsedError;
  double? get rangeMin => throw _privateConstructorUsedError;
  double? get rangeMax => throw _privateConstructorUsedError;

  /// Serializes this HiringPostModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of HiringPostModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $HiringPostModelCopyWith<HiringPostModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $HiringPostModelCopyWith<$Res> {
  factory $HiringPostModelCopyWith(
    HiringPostModel value,
    $Res Function(HiringPostModel) then,
  ) = _$HiringPostModelCopyWithImpl<$Res, HiringPostModel>;
  @useResult
  $Res call({
    String id,
    String professionalId,
    String title,
    String description,
    JobType jobType,
    String? durationText,
    double? salaryAmount,
    Map<String, double>? location,
    PostStatus status,
    DateTime createdAt,
    @ServiceCategoryConverter() ServiceCategory? category,
    String? governorate,
    String? locality,
    String? address,
    PayType? payType,
    double? fixedAmount,
    double? rangeMin,
    double? rangeMax,
  });
}

/// @nodoc
class _$HiringPostModelCopyWithImpl<$Res, $Val extends HiringPostModel>
    implements $HiringPostModelCopyWith<$Res> {
  _$HiringPostModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of HiringPostModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? professionalId = null,
    Object? title = null,
    Object? description = null,
    Object? jobType = null,
    Object? durationText = freezed,
    Object? salaryAmount = freezed,
    Object? location = freezed,
    Object? status = null,
    Object? createdAt = null,
    Object? category = freezed,
    Object? governorate = freezed,
    Object? locality = freezed,
    Object? address = freezed,
    Object? payType = freezed,
    Object? fixedAmount = freezed,
    Object? rangeMin = freezed,
    Object? rangeMax = freezed,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            professionalId: null == professionalId
                ? _value.professionalId
                : professionalId // ignore: cast_nullable_to_non_nullable
                      as String,
            title: null == title
                ? _value.title
                : title // ignore: cast_nullable_to_non_nullable
                      as String,
            description: null == description
                ? _value.description
                : description // ignore: cast_nullable_to_non_nullable
                      as String,
            jobType: null == jobType
                ? _value.jobType
                : jobType // ignore: cast_nullable_to_non_nullable
                      as JobType,
            durationText: freezed == durationText
                ? _value.durationText
                : durationText // ignore: cast_nullable_to_non_nullable
                      as String?,
            salaryAmount: freezed == salaryAmount
                ? _value.salaryAmount
                : salaryAmount // ignore: cast_nullable_to_non_nullable
                      as double?,
            location: freezed == location
                ? _value.location
                : location // ignore: cast_nullable_to_non_nullable
                      as Map<String, double>?,
            status: null == status
                ? _value.status
                : status // ignore: cast_nullable_to_non_nullable
                      as PostStatus,
            createdAt: null == createdAt
                ? _value.createdAt
                : createdAt // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            category: freezed == category
                ? _value.category
                : category // ignore: cast_nullable_to_non_nullable
                      as ServiceCategory?,
            governorate: freezed == governorate
                ? _value.governorate
                : governorate // ignore: cast_nullable_to_non_nullable
                      as String?,
            locality: freezed == locality
                ? _value.locality
                : locality // ignore: cast_nullable_to_non_nullable
                      as String?,
            address: freezed == address
                ? _value.address
                : address // ignore: cast_nullable_to_non_nullable
                      as String?,
            payType: freezed == payType
                ? _value.payType
                : payType // ignore: cast_nullable_to_non_nullable
                      as PayType?,
            fixedAmount: freezed == fixedAmount
                ? _value.fixedAmount
                : fixedAmount // ignore: cast_nullable_to_non_nullable
                      as double?,
            rangeMin: freezed == rangeMin
                ? _value.rangeMin
                : rangeMin // ignore: cast_nullable_to_non_nullable
                      as double?,
            rangeMax: freezed == rangeMax
                ? _value.rangeMax
                : rangeMax // ignore: cast_nullable_to_non_nullable
                      as double?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$HiringPostModelImplCopyWith<$Res>
    implements $HiringPostModelCopyWith<$Res> {
  factory _$$HiringPostModelImplCopyWith(
    _$HiringPostModelImpl value,
    $Res Function(_$HiringPostModelImpl) then,
  ) = __$$HiringPostModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String professionalId,
    String title,
    String description,
    JobType jobType,
    String? durationText,
    double? salaryAmount,
    Map<String, double>? location,
    PostStatus status,
    DateTime createdAt,
    @ServiceCategoryConverter() ServiceCategory? category,
    String? governorate,
    String? locality,
    String? address,
    PayType? payType,
    double? fixedAmount,
    double? rangeMin,
    double? rangeMax,
  });
}

/// @nodoc
class __$$HiringPostModelImplCopyWithImpl<$Res>
    extends _$HiringPostModelCopyWithImpl<$Res, _$HiringPostModelImpl>
    implements _$$HiringPostModelImplCopyWith<$Res> {
  __$$HiringPostModelImplCopyWithImpl(
    _$HiringPostModelImpl _value,
    $Res Function(_$HiringPostModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of HiringPostModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? professionalId = null,
    Object? title = null,
    Object? description = null,
    Object? jobType = null,
    Object? durationText = freezed,
    Object? salaryAmount = freezed,
    Object? location = freezed,
    Object? status = null,
    Object? createdAt = null,
    Object? category = freezed,
    Object? governorate = freezed,
    Object? locality = freezed,
    Object? address = freezed,
    Object? payType = freezed,
    Object? fixedAmount = freezed,
    Object? rangeMin = freezed,
    Object? rangeMax = freezed,
  }) {
    return _then(
      _$HiringPostModelImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        professionalId: null == professionalId
            ? _value.professionalId
            : professionalId // ignore: cast_nullable_to_non_nullable
                  as String,
        title: null == title
            ? _value.title
            : title // ignore: cast_nullable_to_non_nullable
                  as String,
        description: null == description
            ? _value.description
            : description // ignore: cast_nullable_to_non_nullable
                  as String,
        jobType: null == jobType
            ? _value.jobType
            : jobType // ignore: cast_nullable_to_non_nullable
                  as JobType,
        durationText: freezed == durationText
            ? _value.durationText
            : durationText // ignore: cast_nullable_to_non_nullable
                  as String?,
        salaryAmount: freezed == salaryAmount
            ? _value.salaryAmount
            : salaryAmount // ignore: cast_nullable_to_non_nullable
                  as double?,
        location: freezed == location
            ? _value._location
            : location // ignore: cast_nullable_to_non_nullable
                  as Map<String, double>?,
        status: null == status
            ? _value.status
            : status // ignore: cast_nullable_to_non_nullable
                  as PostStatus,
        createdAt: null == createdAt
            ? _value.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        category: freezed == category
            ? _value.category
            : category // ignore: cast_nullable_to_non_nullable
                  as ServiceCategory?,
        governorate: freezed == governorate
            ? _value.governorate
            : governorate // ignore: cast_nullable_to_non_nullable
                  as String?,
        locality: freezed == locality
            ? _value.locality
            : locality // ignore: cast_nullable_to_non_nullable
                  as String?,
        address: freezed == address
            ? _value.address
            : address // ignore: cast_nullable_to_non_nullable
                  as String?,
        payType: freezed == payType
            ? _value.payType
            : payType // ignore: cast_nullable_to_non_nullable
                  as PayType?,
        fixedAmount: freezed == fixedAmount
            ? _value.fixedAmount
            : fixedAmount // ignore: cast_nullable_to_non_nullable
                  as double?,
        rangeMin: freezed == rangeMin
            ? _value.rangeMin
            : rangeMin // ignore: cast_nullable_to_non_nullable
                  as double?,
        rangeMax: freezed == rangeMax
            ? _value.rangeMax
            : rangeMax // ignore: cast_nullable_to_non_nullable
                  as double?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$HiringPostModelImpl extends _HiringPostModel {
  const _$HiringPostModelImpl({
    required this.id,
    required this.professionalId,
    required this.title,
    required this.description,
    required this.jobType,
    this.durationText,
    this.salaryAmount,
    final Map<String, double>? location,
    this.status = PostStatus.open,
    required this.createdAt,
    @ServiceCategoryConverter() this.category,
    this.governorate,
    this.locality,
    this.address,
    this.payType,
    this.fixedAmount,
    this.rangeMin,
    this.rangeMax,
  }) : _location = location,
       super._();

  factory _$HiringPostModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$HiringPostModelImplFromJson(json);

  @override
  final String id;
  @override
  final String professionalId;
  @override
  final String title;
  @override
  final String description;
  @override
  final JobType jobType;
  @override
  final String? durationText;
  @override
  final double? salaryAmount;
  final Map<String, double>? _location;
  @override
  Map<String, double>? get location {
    final value = _location;
    if (value == null) return null;
    if (_location is EqualUnmodifiableMapView) return _location;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  @override
  @JsonKey()
  final PostStatus status;
  @override
  final DateTime createdAt;
  @override
  @ServiceCategoryConverter()
  final ServiceCategory? category;
  @override
  final String? governorate;
  @override
  final String? locality;
  @override
  final String? address;
  @override
  final PayType? payType;
  @override
  final double? fixedAmount;
  @override
  final double? rangeMin;
  @override
  final double? rangeMax;

  @override
  String toString() {
    return 'HiringPostModel(id: $id, professionalId: $professionalId, title: $title, description: $description, jobType: $jobType, durationText: $durationText, salaryAmount: $salaryAmount, location: $location, status: $status, createdAt: $createdAt, category: $category, governorate: $governorate, locality: $locality, address: $address, payType: $payType, fixedAmount: $fixedAmount, rangeMin: $rangeMin, rangeMax: $rangeMax)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$HiringPostModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.professionalId, professionalId) ||
                other.professionalId == professionalId) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.jobType, jobType) || other.jobType == jobType) &&
            (identical(other.durationText, durationText) ||
                other.durationText == durationText) &&
            (identical(other.salaryAmount, salaryAmount) ||
                other.salaryAmount == salaryAmount) &&
            const DeepCollectionEquality().equals(other._location, _location) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.category, category) ||
                other.category == category) &&
            (identical(other.governorate, governorate) ||
                other.governorate == governorate) &&
            (identical(other.locality, locality) ||
                other.locality == locality) &&
            (identical(other.address, address) || other.address == address) &&
            (identical(other.payType, payType) || other.payType == payType) &&
            (identical(other.fixedAmount, fixedAmount) ||
                other.fixedAmount == fixedAmount) &&
            (identical(other.rangeMin, rangeMin) ||
                other.rangeMin == rangeMin) &&
            (identical(other.rangeMax, rangeMax) ||
                other.rangeMax == rangeMax));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    professionalId,
    title,
    description,
    jobType,
    durationText,
    salaryAmount,
    const DeepCollectionEquality().hash(_location),
    status,
    createdAt,
    category,
    governorate,
    locality,
    address,
    payType,
    fixedAmount,
    rangeMin,
    rangeMax,
  );

  /// Create a copy of HiringPostModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$HiringPostModelImplCopyWith<_$HiringPostModelImpl> get copyWith =>
      __$$HiringPostModelImplCopyWithImpl<_$HiringPostModelImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$HiringPostModelImplToJson(this);
  }
}

abstract class _HiringPostModel extends HiringPostModel {
  const factory _HiringPostModel({
    required final String id,
    required final String professionalId,
    required final String title,
    required final String description,
    required final JobType jobType,
    final String? durationText,
    final double? salaryAmount,
    final Map<String, double>? location,
    final PostStatus status,
    required final DateTime createdAt,
    @ServiceCategoryConverter() final ServiceCategory? category,
    final String? governorate,
    final String? locality,
    final String? address,
    final PayType? payType,
    final double? fixedAmount,
    final double? rangeMin,
    final double? rangeMax,
  }) = _$HiringPostModelImpl;
  const _HiringPostModel._() : super._();

  factory _HiringPostModel.fromJson(Map<String, dynamic> json) =
      _$HiringPostModelImpl.fromJson;

  @override
  String get id;
  @override
  String get professionalId;
  @override
  String get title;
  @override
  String get description;
  @override
  JobType get jobType;
  @override
  String? get durationText;
  @override
  double? get salaryAmount;
  @override
  Map<String, double>? get location;
  @override
  PostStatus get status;
  @override
  DateTime get createdAt;
  @override
  @ServiceCategoryConverter()
  ServiceCategory? get category;
  @override
  String? get governorate;
  @override
  String? get locality;
  @override
  String? get address;
  @override
  PayType? get payType;
  @override
  double? get fixedAmount;
  @override
  double? get rangeMin;
  @override
  double? get rangeMax;

  /// Create a copy of HiringPostModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$HiringPostModelImplCopyWith<_$HiringPostModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
