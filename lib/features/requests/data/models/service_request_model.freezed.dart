// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'service_request_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

ServiceRequestModel _$ServiceRequestModelFromJson(Map<String, dynamic> json) {
  return _ServiceRequestModel.fromJson(json);
}

/// @nodoc
mixin _$ServiceRequestModel {
  String get id => throw _privateConstructorUsedError;
  String get title => throw _privateConstructorUsedError;
  String get description => throw _privateConstructorUsedError;
  String get category => throw _privateConstructorUsedError;
  double? get budget => throw _privateConstructorUsedError;
  String get clientId => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;
  String get status => throw _privateConstructorUsedError;
  String? get professionalId => throw _privateConstructorUsedError;
  DateTime? get updatedAt => throw _privateConstructorUsedError;
  String? get location => throw _privateConstructorUsedError;
  List<String> get photos => throw _privateConstructorUsedError;
  RequestType get type => throw _privateConstructorUsedError;
  String? get assignedTo => throw _privateConstructorUsedError;
  Map<String, double>? get clientGpsLocation =>
      throw _privateConstructorUsedError;
  String? get assignedProfessionalId => throw _privateConstructorUsedError;
  String? get acceptedOfferId => throw _privateConstructorUsedError;
  DateTime? get acceptedAt => throw _privateConstructorUsedError;
  DateTime? get completedAt => throw _privateConstructorUsedError;
  String? get rejectionReason => throw _privateConstructorUsedError;
  double? get acceptedOfferAmount => throw _privateConstructorUsedError;

  /// Serializes this ServiceRequestModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ServiceRequestModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ServiceRequestModelCopyWith<ServiceRequestModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ServiceRequestModelCopyWith<$Res> {
  factory $ServiceRequestModelCopyWith(
    ServiceRequestModel value,
    $Res Function(ServiceRequestModel) then,
  ) = _$ServiceRequestModelCopyWithImpl<$Res, ServiceRequestModel>;
  @useResult
  $Res call({
    String id,
    String title,
    String description,
    String category,
    double? budget,
    String clientId,
    DateTime createdAt,
    String status,
    String? professionalId,
    DateTime? updatedAt,
    String? location,
    List<String> photos,
    RequestType type,
    String? assignedTo,
    Map<String, double>? clientGpsLocation,
    String? assignedProfessionalId,
    String? acceptedOfferId,
    DateTime? acceptedAt,
    DateTime? completedAt,
    String? rejectionReason,
    double? acceptedOfferAmount,
  });
}

/// @nodoc
class _$ServiceRequestModelCopyWithImpl<$Res, $Val extends ServiceRequestModel>
    implements $ServiceRequestModelCopyWith<$Res> {
  _$ServiceRequestModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ServiceRequestModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? description = null,
    Object? category = null,
    Object? budget = freezed,
    Object? clientId = null,
    Object? createdAt = null,
    Object? status = null,
    Object? professionalId = freezed,
    Object? updatedAt = freezed,
    Object? location = freezed,
    Object? photos = null,
    Object? type = null,
    Object? assignedTo = freezed,
    Object? clientGpsLocation = freezed,
    Object? assignedProfessionalId = freezed,
    Object? acceptedOfferId = freezed,
    Object? acceptedAt = freezed,
    Object? completedAt = freezed,
    Object? rejectionReason = freezed,
    Object? acceptedOfferAmount = freezed,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            title: null == title
                ? _value.title
                : title // ignore: cast_nullable_to_non_nullable
                      as String,
            description: null == description
                ? _value.description
                : description // ignore: cast_nullable_to_non_nullable
                      as String,
            category: null == category
                ? _value.category
                : category // ignore: cast_nullable_to_non_nullable
                      as String,
            budget: freezed == budget
                ? _value.budget
                : budget // ignore: cast_nullable_to_non_nullable
                      as double?,
            clientId: null == clientId
                ? _value.clientId
                : clientId // ignore: cast_nullable_to_non_nullable
                      as String,
            createdAt: null == createdAt
                ? _value.createdAt
                : createdAt // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            status: null == status
                ? _value.status
                : status // ignore: cast_nullable_to_non_nullable
                      as String,
            professionalId: freezed == professionalId
                ? _value.professionalId
                : professionalId // ignore: cast_nullable_to_non_nullable
                      as String?,
            updatedAt: freezed == updatedAt
                ? _value.updatedAt
                : updatedAt // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
            location: freezed == location
                ? _value.location
                : location // ignore: cast_nullable_to_non_nullable
                      as String?,
            photos: null == photos
                ? _value.photos
                : photos // ignore: cast_nullable_to_non_nullable
                      as List<String>,
            type: null == type
                ? _value.type
                : type // ignore: cast_nullable_to_non_nullable
                      as RequestType,
            assignedTo: freezed == assignedTo
                ? _value.assignedTo
                : assignedTo // ignore: cast_nullable_to_non_nullable
                      as String?,
            clientGpsLocation: freezed == clientGpsLocation
                ? _value.clientGpsLocation
                : clientGpsLocation // ignore: cast_nullable_to_non_nullable
                      as Map<String, double>?,
            assignedProfessionalId: freezed == assignedProfessionalId
                ? _value.assignedProfessionalId
                : assignedProfessionalId // ignore: cast_nullable_to_non_nullable
                      as String?,
            acceptedOfferId: freezed == acceptedOfferId
                ? _value.acceptedOfferId
                : acceptedOfferId // ignore: cast_nullable_to_non_nullable
                      as String?,
            acceptedAt: freezed == acceptedAt
                ? _value.acceptedAt
                : acceptedAt // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
            completedAt: freezed == completedAt
                ? _value.completedAt
                : completedAt // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
            rejectionReason: freezed == rejectionReason
                ? _value.rejectionReason
                : rejectionReason // ignore: cast_nullable_to_non_nullable
                      as String?,
            acceptedOfferAmount: freezed == acceptedOfferAmount
                ? _value.acceptedOfferAmount
                : acceptedOfferAmount // ignore: cast_nullable_to_non_nullable
                      as double?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$ServiceRequestModelImplCopyWith<$Res>
    implements $ServiceRequestModelCopyWith<$Res> {
  factory _$$ServiceRequestModelImplCopyWith(
    _$ServiceRequestModelImpl value,
    $Res Function(_$ServiceRequestModelImpl) then,
  ) = __$$ServiceRequestModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String title,
    String description,
    String category,
    double? budget,
    String clientId,
    DateTime createdAt,
    String status,
    String? professionalId,
    DateTime? updatedAt,
    String? location,
    List<String> photos,
    RequestType type,
    String? assignedTo,
    Map<String, double>? clientGpsLocation,
    String? assignedProfessionalId,
    String? acceptedOfferId,
    DateTime? acceptedAt,
    DateTime? completedAt,
    String? rejectionReason,
    double? acceptedOfferAmount,
  });
}

/// @nodoc
class __$$ServiceRequestModelImplCopyWithImpl<$Res>
    extends _$ServiceRequestModelCopyWithImpl<$Res, _$ServiceRequestModelImpl>
    implements _$$ServiceRequestModelImplCopyWith<$Res> {
  __$$ServiceRequestModelImplCopyWithImpl(
    _$ServiceRequestModelImpl _value,
    $Res Function(_$ServiceRequestModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ServiceRequestModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? description = null,
    Object? category = null,
    Object? budget = freezed,
    Object? clientId = null,
    Object? createdAt = null,
    Object? status = null,
    Object? professionalId = freezed,
    Object? updatedAt = freezed,
    Object? location = freezed,
    Object? photos = null,
    Object? type = null,
    Object? assignedTo = freezed,
    Object? clientGpsLocation = freezed,
    Object? assignedProfessionalId = freezed,
    Object? acceptedOfferId = freezed,
    Object? acceptedAt = freezed,
    Object? completedAt = freezed,
    Object? rejectionReason = freezed,
    Object? acceptedOfferAmount = freezed,
  }) {
    return _then(
      _$ServiceRequestModelImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        title: null == title
            ? _value.title
            : title // ignore: cast_nullable_to_non_nullable
                  as String,
        description: null == description
            ? _value.description
            : description // ignore: cast_nullable_to_non_nullable
                  as String,
        category: null == category
            ? _value.category
            : category // ignore: cast_nullable_to_non_nullable
                  as String,
        budget: freezed == budget
            ? _value.budget
            : budget // ignore: cast_nullable_to_non_nullable
                  as double?,
        clientId: null == clientId
            ? _value.clientId
            : clientId // ignore: cast_nullable_to_non_nullable
                  as String,
        createdAt: null == createdAt
            ? _value.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        status: null == status
            ? _value.status
            : status // ignore: cast_nullable_to_non_nullable
                  as String,
        professionalId: freezed == professionalId
            ? _value.professionalId
            : professionalId // ignore: cast_nullable_to_non_nullable
                  as String?,
        updatedAt: freezed == updatedAt
            ? _value.updatedAt
            : updatedAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        location: freezed == location
            ? _value.location
            : location // ignore: cast_nullable_to_non_nullable
                  as String?,
        photos: null == photos
            ? _value._photos
            : photos // ignore: cast_nullable_to_non_nullable
                  as List<String>,
        type: null == type
            ? _value.type
            : type // ignore: cast_nullable_to_non_nullable
                  as RequestType,
        assignedTo: freezed == assignedTo
            ? _value.assignedTo
            : assignedTo // ignore: cast_nullable_to_non_nullable
                  as String?,
        clientGpsLocation: freezed == clientGpsLocation
            ? _value._clientGpsLocation
            : clientGpsLocation // ignore: cast_nullable_to_non_nullable
                  as Map<String, double>?,
        assignedProfessionalId: freezed == assignedProfessionalId
            ? _value.assignedProfessionalId
            : assignedProfessionalId // ignore: cast_nullable_to_non_nullable
                  as String?,
        acceptedOfferId: freezed == acceptedOfferId
            ? _value.acceptedOfferId
            : acceptedOfferId // ignore: cast_nullable_to_non_nullable
                  as String?,
        acceptedAt: freezed == acceptedAt
            ? _value.acceptedAt
            : acceptedAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        completedAt: freezed == completedAt
            ? _value.completedAt
            : completedAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        rejectionReason: freezed == rejectionReason
            ? _value.rejectionReason
            : rejectionReason // ignore: cast_nullable_to_non_nullable
                  as String?,
        acceptedOfferAmount: freezed == acceptedOfferAmount
            ? _value.acceptedOfferAmount
            : acceptedOfferAmount // ignore: cast_nullable_to_non_nullable
                  as double?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$ServiceRequestModelImpl extends _ServiceRequestModel {
  const _$ServiceRequestModelImpl({
    required this.id,
    required this.title,
    required this.description,
    required this.category,
    this.budget,
    required this.clientId,
    required this.createdAt,
    this.status = 'open',
    this.professionalId,
    this.updatedAt,
    this.location,
    final List<String> photos = const [],
    this.type = RequestType.normal,
    this.assignedTo,
    final Map<String, double>? clientGpsLocation,
    this.assignedProfessionalId,
    this.acceptedOfferId,
    this.acceptedAt,
    this.completedAt,
    this.rejectionReason,
    this.acceptedOfferAmount,
  }) : _photos = photos,
       _clientGpsLocation = clientGpsLocation,
       super._();

  factory _$ServiceRequestModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$ServiceRequestModelImplFromJson(json);

  @override
  final String id;
  @override
  final String title;
  @override
  final String description;
  @override
  final String category;
  @override
  final double? budget;
  @override
  final String clientId;
  @override
  final DateTime createdAt;
  @override
  @JsonKey()
  final String status;
  @override
  final String? professionalId;
  @override
  final DateTime? updatedAt;
  @override
  final String? location;
  final List<String> _photos;
  @override
  @JsonKey()
  List<String> get photos {
    if (_photos is EqualUnmodifiableListView) return _photos;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_photos);
  }

  @override
  @JsonKey()
  final RequestType type;
  @override
  final String? assignedTo;
  final Map<String, double>? _clientGpsLocation;
  @override
  Map<String, double>? get clientGpsLocation {
    final value = _clientGpsLocation;
    if (value == null) return null;
    if (_clientGpsLocation is EqualUnmodifiableMapView)
      return _clientGpsLocation;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  @override
  final String? assignedProfessionalId;
  @override
  final String? acceptedOfferId;
  @override
  final DateTime? acceptedAt;
  @override
  final DateTime? completedAt;
  @override
  final String? rejectionReason;
  @override
  final double? acceptedOfferAmount;

  @override
  String toString() {
    return 'ServiceRequestModel(id: $id, title: $title, description: $description, category: $category, budget: $budget, clientId: $clientId, createdAt: $createdAt, status: $status, professionalId: $professionalId, updatedAt: $updatedAt, location: $location, photos: $photos, type: $type, assignedTo: $assignedTo, clientGpsLocation: $clientGpsLocation, assignedProfessionalId: $assignedProfessionalId, acceptedOfferId: $acceptedOfferId, acceptedAt: $acceptedAt, completedAt: $completedAt, rejectionReason: $rejectionReason, acceptedOfferAmount: $acceptedOfferAmount)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ServiceRequestModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.category, category) ||
                other.category == category) &&
            (identical(other.budget, budget) || other.budget == budget) &&
            (identical(other.clientId, clientId) ||
                other.clientId == clientId) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.professionalId, professionalId) ||
                other.professionalId == professionalId) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt) &&
            (identical(other.location, location) ||
                other.location == location) &&
            const DeepCollectionEquality().equals(other._photos, _photos) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.assignedTo, assignedTo) ||
                other.assignedTo == assignedTo) &&
            const DeepCollectionEquality().equals(
              other._clientGpsLocation,
              _clientGpsLocation,
            ) &&
            (identical(other.assignedProfessionalId, assignedProfessionalId) ||
                other.assignedProfessionalId == assignedProfessionalId) &&
            (identical(other.acceptedOfferId, acceptedOfferId) ||
                other.acceptedOfferId == acceptedOfferId) &&
            (identical(other.acceptedAt, acceptedAt) ||
                other.acceptedAt == acceptedAt) &&
            (identical(other.completedAt, completedAt) ||
                other.completedAt == completedAt) &&
            (identical(other.rejectionReason, rejectionReason) ||
                other.rejectionReason == rejectionReason) &&
            (identical(other.acceptedOfferAmount, acceptedOfferAmount) ||
                other.acceptedOfferAmount == acceptedOfferAmount));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hashAll([
    runtimeType,
    id,
    title,
    description,
    category,
    budget,
    clientId,
    createdAt,
    status,
    professionalId,
    updatedAt,
    location,
    const DeepCollectionEquality().hash(_photos),
    type,
    assignedTo,
    const DeepCollectionEquality().hash(_clientGpsLocation),
    assignedProfessionalId,
    acceptedOfferId,
    acceptedAt,
    completedAt,
    rejectionReason,
    acceptedOfferAmount,
  ]);

  /// Create a copy of ServiceRequestModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ServiceRequestModelImplCopyWith<_$ServiceRequestModelImpl> get copyWith =>
      __$$ServiceRequestModelImplCopyWithImpl<_$ServiceRequestModelImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$ServiceRequestModelImplToJson(this);
  }
}

abstract class _ServiceRequestModel extends ServiceRequestModel {
  const factory _ServiceRequestModel({
    required final String id,
    required final String title,
    required final String description,
    required final String category,
    final double? budget,
    required final String clientId,
    required final DateTime createdAt,
    final String status,
    final String? professionalId,
    final DateTime? updatedAt,
    final String? location,
    final List<String> photos,
    final RequestType type,
    final String? assignedTo,
    final Map<String, double>? clientGpsLocation,
    final String? assignedProfessionalId,
    final String? acceptedOfferId,
    final DateTime? acceptedAt,
    final DateTime? completedAt,
    final String? rejectionReason,
    final double? acceptedOfferAmount,
  }) = _$ServiceRequestModelImpl;
  const _ServiceRequestModel._() : super._();

  factory _ServiceRequestModel.fromJson(Map<String, dynamic> json) =
      _$ServiceRequestModelImpl.fromJson;

  @override
  String get id;
  @override
  String get title;
  @override
  String get description;
  @override
  String get category;
  @override
  double? get budget;
  @override
  String get clientId;
  @override
  DateTime get createdAt;
  @override
  String get status;
  @override
  String? get professionalId;
  @override
  DateTime? get updatedAt;
  @override
  String? get location;
  @override
  List<String> get photos;
  @override
  RequestType get type;
  @override
  String? get assignedTo;
  @override
  Map<String, double>? get clientGpsLocation;
  @override
  String? get assignedProfessionalId;
  @override
  String? get acceptedOfferId;
  @override
  DateTime? get acceptedAt;
  @override
  DateTime? get completedAt;
  @override
  String? get rejectionReason;
  @override
  double? get acceptedOfferAmount;

  /// Create a copy of ServiceRequestModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ServiceRequestModelImplCopyWith<_$ServiceRequestModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
