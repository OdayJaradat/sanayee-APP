// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'conversation_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$ConversationModel {
  String get id => throw _privateConstructorUsedError;
  String get requestId => throw _privateConstructorUsedError;
  String get clientId => throw _privateConstructorUsedError;
  String get professionalId => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;
  DateTime? get lastMessageAt => throw _privateConstructorUsedError;
  String? get lastMessageText => throw _privateConstructorUsedError;
  int get unreadCountForClient => throw _privateConstructorUsedError;
  int get unreadCountForPro => throw _privateConstructorUsedError;
  bool get deletedForClient => throw _privateConstructorUsedError;
  bool get deletedForPro => throw _privateConstructorUsedError;

  /// Create a copy of ConversationModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ConversationModelCopyWith<ConversationModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ConversationModelCopyWith<$Res> {
  factory $ConversationModelCopyWith(
    ConversationModel value,
    $Res Function(ConversationModel) then,
  ) = _$ConversationModelCopyWithImpl<$Res, ConversationModel>;
  @useResult
  $Res call({
    String id,
    String requestId,
    String clientId,
    String professionalId,
    DateTime createdAt,
    DateTime? lastMessageAt,
    String? lastMessageText,
    int unreadCountForClient,
    int unreadCountForPro,
    bool deletedForClient,
    bool deletedForPro,
  });
}

/// @nodoc
class _$ConversationModelCopyWithImpl<$Res, $Val extends ConversationModel>
    implements $ConversationModelCopyWith<$Res> {
  _$ConversationModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ConversationModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? requestId = null,
    Object? clientId = null,
    Object? professionalId = null,
    Object? createdAt = null,
    Object? lastMessageAt = freezed,
    Object? lastMessageText = freezed,
    Object? unreadCountForClient = null,
    Object? unreadCountForPro = null,
    Object? deletedForClient = null,
    Object? deletedForPro = null,
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
            createdAt: null == createdAt
                ? _value.createdAt
                : createdAt // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            lastMessageAt: freezed == lastMessageAt
                ? _value.lastMessageAt
                : lastMessageAt // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
            lastMessageText: freezed == lastMessageText
                ? _value.lastMessageText
                : lastMessageText // ignore: cast_nullable_to_non_nullable
                      as String?,
            unreadCountForClient: null == unreadCountForClient
                ? _value.unreadCountForClient
                : unreadCountForClient // ignore: cast_nullable_to_non_nullable
                      as int,
            unreadCountForPro: null == unreadCountForPro
                ? _value.unreadCountForPro
                : unreadCountForPro // ignore: cast_nullable_to_non_nullable
                      as int,
            deletedForClient: null == deletedForClient
                ? _value.deletedForClient
                : deletedForClient // ignore: cast_nullable_to_non_nullable
                      as bool,
            deletedForPro: null == deletedForPro
                ? _value.deletedForPro
                : deletedForPro // ignore: cast_nullable_to_non_nullable
                      as bool,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$ConversationModelImplCopyWith<$Res>
    implements $ConversationModelCopyWith<$Res> {
  factory _$$ConversationModelImplCopyWith(
    _$ConversationModelImpl value,
    $Res Function(_$ConversationModelImpl) then,
  ) = __$$ConversationModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String requestId,
    String clientId,
    String professionalId,
    DateTime createdAt,
    DateTime? lastMessageAt,
    String? lastMessageText,
    int unreadCountForClient,
    int unreadCountForPro,
    bool deletedForClient,
    bool deletedForPro,
  });
}

/// @nodoc
class __$$ConversationModelImplCopyWithImpl<$Res>
    extends _$ConversationModelCopyWithImpl<$Res, _$ConversationModelImpl>
    implements _$$ConversationModelImplCopyWith<$Res> {
  __$$ConversationModelImplCopyWithImpl(
    _$ConversationModelImpl _value,
    $Res Function(_$ConversationModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ConversationModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? requestId = null,
    Object? clientId = null,
    Object? professionalId = null,
    Object? createdAt = null,
    Object? lastMessageAt = freezed,
    Object? lastMessageText = freezed,
    Object? unreadCountForClient = null,
    Object? unreadCountForPro = null,
    Object? deletedForClient = null,
    Object? deletedForPro = null,
  }) {
    return _then(
      _$ConversationModelImpl(
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
        createdAt: null == createdAt
            ? _value.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        lastMessageAt: freezed == lastMessageAt
            ? _value.lastMessageAt
            : lastMessageAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        lastMessageText: freezed == lastMessageText
            ? _value.lastMessageText
            : lastMessageText // ignore: cast_nullable_to_non_nullable
                  as String?,
        unreadCountForClient: null == unreadCountForClient
            ? _value.unreadCountForClient
            : unreadCountForClient // ignore: cast_nullable_to_non_nullable
                  as int,
        unreadCountForPro: null == unreadCountForPro
            ? _value.unreadCountForPro
            : unreadCountForPro // ignore: cast_nullable_to_non_nullable
                  as int,
        deletedForClient: null == deletedForClient
            ? _value.deletedForClient
            : deletedForClient // ignore: cast_nullable_to_non_nullable
                  as bool,
        deletedForPro: null == deletedForPro
            ? _value.deletedForPro
            : deletedForPro // ignore: cast_nullable_to_non_nullable
                  as bool,
      ),
    );
  }
}

/// @nodoc

class _$ConversationModelImpl extends _ConversationModel {
  const _$ConversationModelImpl({
    required this.id,
    required this.requestId,
    required this.clientId,
    required this.professionalId,
    required this.createdAt,
    this.lastMessageAt,
    this.lastMessageText,
    this.unreadCountForClient = 0,
    this.unreadCountForPro = 0,
    this.deletedForClient = false,
    this.deletedForPro = false,
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
  final DateTime createdAt;
  @override
  final DateTime? lastMessageAt;
  @override
  final String? lastMessageText;
  @override
  @JsonKey()
  final int unreadCountForClient;
  @override
  @JsonKey()
  final int unreadCountForPro;
  @override
  @JsonKey()
  final bool deletedForClient;
  @override
  @JsonKey()
  final bool deletedForPro;

  @override
  String toString() {
    return 'ConversationModel(id: $id, requestId: $requestId, clientId: $clientId, professionalId: $professionalId, createdAt: $createdAt, lastMessageAt: $lastMessageAt, lastMessageText: $lastMessageText, unreadCountForClient: $unreadCountForClient, unreadCountForPro: $unreadCountForPro, deletedForClient: $deletedForClient, deletedForPro: $deletedForPro)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ConversationModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.requestId, requestId) ||
                other.requestId == requestId) &&
            (identical(other.clientId, clientId) ||
                other.clientId == clientId) &&
            (identical(other.professionalId, professionalId) ||
                other.professionalId == professionalId) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.lastMessageAt, lastMessageAt) ||
                other.lastMessageAt == lastMessageAt) &&
            (identical(other.lastMessageText, lastMessageText) ||
                other.lastMessageText == lastMessageText) &&
            (identical(other.unreadCountForClient, unreadCountForClient) ||
                other.unreadCountForClient == unreadCountForClient) &&
            (identical(other.unreadCountForPro, unreadCountForPro) ||
                other.unreadCountForPro == unreadCountForPro) &&
            (identical(other.deletedForClient, deletedForClient) ||
                other.deletedForClient == deletedForClient) &&
            (identical(other.deletedForPro, deletedForPro) ||
                other.deletedForPro == deletedForPro));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    requestId,
    clientId,
    professionalId,
    createdAt,
    lastMessageAt,
    lastMessageText,
    unreadCountForClient,
    unreadCountForPro,
    deletedForClient,
    deletedForPro,
  );

  /// Create a copy of ConversationModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ConversationModelImplCopyWith<_$ConversationModelImpl> get copyWith =>
      __$$ConversationModelImplCopyWithImpl<_$ConversationModelImpl>(
        this,
        _$identity,
      );
}

abstract class _ConversationModel extends ConversationModel {
  const factory _ConversationModel({
    required final String id,
    required final String requestId,
    required final String clientId,
    required final String professionalId,
    required final DateTime createdAt,
    final DateTime? lastMessageAt,
    final String? lastMessageText,
    final int unreadCountForClient,
    final int unreadCountForPro,
    final bool deletedForClient,
    final bool deletedForPro,
  }) = _$ConversationModelImpl;
  const _ConversationModel._() : super._();

  @override
  String get id;
  @override
  String get requestId;
  @override
  String get clientId;
  @override
  String get professionalId;
  @override
  DateTime get createdAt;
  @override
  DateTime? get lastMessageAt;
  @override
  String? get lastMessageText;
  @override
  int get unreadCountForClient;
  @override
  int get unreadCountForPro;
  @override
  bool get deletedForClient;
  @override
  bool get deletedForPro;

  /// Create a copy of ConversationModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ConversationModelImplCopyWith<_$ConversationModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
