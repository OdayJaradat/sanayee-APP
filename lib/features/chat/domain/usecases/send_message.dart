import 'package:injectable/injectable.dart';
import '../../../../core/error/result.dart';
import '../../../../core/error/failures.dart';
import '../entities/message.dart';
import '../repositories/chat_repository.dart';

@injectable
class SendMessage {
  final ChatRepository _repository;

  SendMessage(this._repository);

  Future<Result<Message>> call({
    required String conversationId,
    required String senderId,
    required String text,
  }) async {
    if (text.trim().isEmpty) {
      return Err(ValidationFailure('الرسالة لا يمكن أن تكون فارغة'));
    }

    return await _repository.sendMessage(
      conversationId: conversationId,
      senderId: senderId,
      text: text.trim(),
    );
  }
}
