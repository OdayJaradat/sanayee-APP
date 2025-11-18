import 'package:injectable/injectable.dart';
import '../../../../core/error/result.dart';
import '../../../chat/domain/repositories/chat_repository.dart';

@injectable
class EnsureConversationForHiring {
  final ChatRepository _chatRepository;

  EnsureConversationForHiring(this._chatRepository);

  
  
  
  
  Future<Result<String>> call({
    required String ownerId,
    required String applicantId,
    required String postId,
  }) async {
    final result = await _chatRepository.ensureConversationFor(
      requestId: 'hiring-$postId',
      clientId: applicantId,
      professionalId: ownerId,
    );

    return result.when(
      ok: (conversation) {
        _chatRepository.sendMessage(
          conversationId: conversation.id,
          senderId: 'system',
          text:
              '💼 تم التواصل بخصوص إعلان التوظيف.\n'
              'يمكنكما الآن مناقشة تفاصيل الوظيفة.',
        );

        return Ok(conversation.id);
      },
      err: (failure) => Err(failure),
    );
  }
}
