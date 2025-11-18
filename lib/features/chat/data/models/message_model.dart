import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/message.dart';

part 'message_model.freezed.dart';

@Freezed(toJson: false, fromJson: false)
class MessageModel with _$MessageModel {
  const MessageModel._();

  const factory MessageModel({
    required String id,
    required String conversationId,
    required String senderId,
    required String text,
    required DateTime createdAt,
    @Default([]) List<String> readBy,
  }) = _MessageModel;

  factory MessageModel.fromJson(Map<String, dynamic> json) {
    return MessageModel(
      id: json['id'] as String,
      conversationId: json['conversation_id'] as String,
      senderId: json['sender_id'] as String,
      text: json['text'] as String,
      createdAt: DateTime.parse(json['created_at'] as String),
      readBy:
          (json['read_by'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          [],
    );
  }

  Message toEntity() => Message(
    id: id,
    conversationId: conversationId,
    senderId: senderId,
    text: text,
    createdAt: createdAt,
    readBy: readBy,
  );

  factory MessageModel.fromEntity(Message entity) => MessageModel(
    id: entity.id,
    conversationId: entity.conversationId,
    senderId: entity.senderId,
    text: entity.text,
    createdAt: entity.createdAt,
    readBy: entity.readBy,
  );
}
