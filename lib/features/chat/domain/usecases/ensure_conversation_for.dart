import 'package:injectable/injectable.dart';
import '../../../../core/error/result.dart';
import '../entities/conversation.dart';
import '../repositories/chat_repository.dart';

@injectable
class EnsureConversationFor {
  final ChatRepository _repository;

  EnsureConversationFor(this._repository);

  Future<Result<Conversation>> call({
    required String requestId,
    required String clientId,
    required String professionalId,
  }) async {
    return await _repository.ensureConversationFor(
      requestId: requestId,
      clientId: clientId,
      professionalId: professionalId,
    );
  }
}
