import 'package:injectable/injectable.dart';
import '../../../../core/error/result.dart';
import '../entities/message.dart';
import '../repositories/chat_repository.dart';

@injectable
class ListMessages {
  final ChatRepository _repository;

  ListMessages(this._repository);

  Future<Result<List<Message>>> call(String conversationId) async {
    return await _repository.listMessages(conversationId);
  }
}
