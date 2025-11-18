import '../../../../core/error/result.dart';
import '../entities/conversation.dart';
import '../entities/message.dart';

abstract class ChatRepository {
  Future<Result<Conversation>> ensureConversationFor({
    required String requestId,
    required String clientId,
    required String professionalId,
  });

  Future<Result<List<Conversation>>> listConversations(String userId);
  Future<Result<List<Message>>> listMessages(String conversationId);

  Future<Result<Message>> sendMessage({
    required String conversationId,
    required String senderId,
    required String text,
  });

  
  Stream<Result<List<Conversation>>> streamConversations(String userId);

  
  Stream<Result<List<Message>>> streamMessages(String conversationId);

  
  Future<Result<void>> markAsRead({
    required String conversationId,
    required String userId,
  });

  
  Future<Result<void>> deleteConversationForUser({
    required String conversationId,
    required String userId,
  });
}
