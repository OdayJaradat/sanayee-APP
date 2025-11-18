import 'package:freezed_annotation/freezed_annotation.dart';

part 'conversation.freezed.dart';

@freezed
class Conversation with _$Conversation {
  const factory Conversation({
    required String id,
    required String requestId,
    required String clientId,
    required String professionalId,
    required DateTime createdAt,
    DateTime? lastMessageAt,
    String? lastMessageText,
    @Default(0) int unreadCountForClient,
    @Default(0) int unreadCountForPro,
  }) = _Conversation;

  const Conversation._();

  
  int getUnreadCountFor(String userId) {
    if (userId == clientId) return unreadCountForClient;
    if (userId == professionalId) return unreadCountForPro;
    return 0;
  }
}
