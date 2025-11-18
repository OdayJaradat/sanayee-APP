import 'package:injectable/injectable.dart';
import '../../../../core/error/result.dart';
import '../entities/conversation.dart';
import '../repositories/chat_repository.dart';

@lazySingleton
class StreamConversations {
  final ChatRepository _repository;

  StreamConversations(this._repository);

  Stream<Result<List<Conversation>>> call(String userId) {
    return _repository.streamConversations(userId);
  }
}
