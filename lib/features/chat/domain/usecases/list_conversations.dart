import 'package:injectable/injectable.dart';
import '../../../../core/error/result.dart';
import '../entities/conversation.dart';
import '../repositories/chat_repository.dart';

@injectable
class ListConversations {
  final ChatRepository _repository;

  ListConversations(this._repository);

  Future<Result<List<Conversation>>> call(String userId) async {
    return await _repository.listConversations(userId);
  }
}
