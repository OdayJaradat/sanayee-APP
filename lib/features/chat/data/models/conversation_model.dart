import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/conversation.dart';

part 'conversation_model.freezed.dart';

@Freezed(toJson: false, fromJson: false)
class ConversationModel with _$ConversationModel {
  const ConversationModel._();

  const factory ConversationModel({
    required String id,
    required String requestId,
    required String clientId,
    required String professionalId,
    required DateTime createdAt,
    DateTime? lastMessageAt,
    String? lastMessageText,
    @Default(0) int unreadCountForClient,
    @Default(0) int unreadCountForPro,
    @Default(false) bool deletedForClient,
    @Default(false) bool deletedForPro,
  }) = _ConversationModel;

  factory ConversationModel.fromJson(Map<String, dynamic> json) {
    return ConversationModel(
      id: json['id'] as String,
      requestId: json['request_id'] as String,
      clientId: json['client_id'] as String,
      professionalId: json['professional_id'] as String,
      createdAt: DateTime.parse(json['created_at'] as String),
      lastMessageAt: json['last_message_at'] != null
          ? DateTime.parse(json['last_message_at'] as String)
          : null,
      lastMessageText: json['last_message_text'] as String?,
      unreadCountForClient: json['unread_count_for_client'] as int? ?? 0,
      unreadCountForPro: json['unread_count_for_pro'] as int? ?? 0,
      deletedForClient: json['deleted_for_client'] as bool? ?? false,
      deletedForPro: json['deleted_for_pro'] as bool? ?? false,
    );
  }

  Conversation toEntity() => Conversation(
    id: id,
    requestId: requestId,
    clientId: clientId,
    professionalId: professionalId,
    createdAt: createdAt,
    lastMessageAt: lastMessageAt,
    lastMessageText: lastMessageText,
    unreadCountForClient: unreadCountForClient,
    unreadCountForPro: unreadCountForPro,
  );

  factory ConversationModel.fromEntity(Conversation entity) =>
      ConversationModel(
        id: entity.id,
        requestId: entity.requestId,
        clientId: entity.clientId,
        professionalId: entity.professionalId,
        createdAt: entity.createdAt,
        lastMessageAt: entity.lastMessageAt,
        lastMessageText: entity.lastMessageText,
        unreadCountForClient: entity.unreadCountForClient,
        unreadCountForPro: entity.unreadCountForPro,
      );
}
