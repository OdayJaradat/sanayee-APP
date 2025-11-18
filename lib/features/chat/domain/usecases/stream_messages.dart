import 'package:injectable/injectable.dart';
import '../../../../core/error/result.dart';
import '../entities/message.dart';
import '../repositories/chat_repository.dart';

@lazySingleton
class StreamMessages {
  final ChatRepository _repository;

  StreamMessages(this._repository);

  Stream<Result<List<Message>>> call(String conversationId) {
    return _repository.streamMessages(conversationId);
  }
}
