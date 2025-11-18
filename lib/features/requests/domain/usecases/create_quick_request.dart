import 'package:injectable/injectable.dart';
import '../../../../core/error/result.dart';
import '../../../professionals/domain/entities/professional.dart';
import '../../../chat/domain/repositories/chat_repository.dart';
import '../entities/service_request.dart';
import '../entities/request_type.dart';
import '../repositories/requests_repository.dart';

@injectable
class CreateQuickRequest {
  final RequestsRepository _requestsRepository;
  final ChatRepository _chatRepository;

  CreateQuickRequest(this._requestsRepository, this._chatRepository);

  Future<Result<ServiceRequest>> call({
    required String clientId,
    required Professional professional,
    required Map<String, double> clientLocation,
    String? title,
    String? description,
  }) async {
    final request = ServiceRequest(
      id: '',
      title: title ?? 'طلب سريع ⚡',
      description:
          description ?? 'طلب سريع تم إنشاؤه تلقائياً وربطه بأقرب صنايعي',
      category: 'quick',
      clientId: clientId,
      createdAt: DateTime.now(),
      status: 'assigned',
      type: RequestType.quick,
      assignedTo: professional.id,
      professionalId: professional.id,
      clientGpsLocation: clientLocation,
    );

    final createResult = await _requestsRepository.create(request);

    return createResult.when(
      ok: (createdRequest) => Ok(createdRequest),
      err: (failure) => Err(failure),
    );
  }

  Future<Result<QuickRequestResult>> createWithConversation({
    required String clientId,
    required Professional professional,
    required Map<String, double> clientLocation,
    String? title,
    String? description,
  }) async {
    final requestResult = await call(
      clientId: clientId,
      professional: professional,
      clientLocation: clientLocation,
      title: title,
      description: description,
    );

    return requestResult.when(
      ok: (request) async {
        final conversationResult = await _chatRepository.ensureConversationFor(
          requestId: request.id,
          clientId: clientId,
          professionalId: professional.id,
        );

        return conversationResult.when(
          ok: (conversation) {
            _chatRepository.sendMessage(
              conversationId: conversation.id,
              senderId: 'system',
              text:
                  'مرحباً! تم إنشاء طلب سريع وربطكما تلقائياً. 🎉\n'
                  'الصنايعي: ${professional.name}\n'
                  'يمكنكما الآن التواصل مباشرة لإتمام الخدمة.',
            );

            return Ok(
              QuickRequestResult(
                request: request,
                conversationId: conversation.id,
                professional: professional,
              ),
            );
          },
          err: (failure) => Err(failure),
        );
      },
      err: (failure) => Err(failure),
    );
  }
}

class QuickRequestResult {
  final ServiceRequest request;
  final String conversationId;
  final Professional professional;

  QuickRequestResult({
    required this.request,
    required this.conversationId,
    required this.professional,
  });
}
