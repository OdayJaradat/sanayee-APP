import 'package:freezed_annotation/freezed_annotation.dart';

part 'message.freezed.dart';

@freezed
class Message with _$Message {
  const factory Message({
    required String id,
    required String conversationId,
    required String senderId,
    required String text,
    required DateTime createdAt,
    @Default([]) List<String> readBy,
  }) = _Message;

  const Message._();

  
  bool isReadBy(String userId) => readBy.contains(userId);
}
