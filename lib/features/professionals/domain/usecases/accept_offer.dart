import 'package:injectable/injectable.dart';
import '../../../../core/error/result.dart';
import '../../../../core/error/failures.dart';
import '../../../requests/domain/entities/service_request.dart';
import '../../../requests/domain/repositories/requests_repository.dart';
import '../../../chat/domain/usecases/ensure_conversation_for.dart';

class AcceptOfferResult {
  final ServiceRequest request;
  final String conversationId;

  AcceptOfferResult({required this.request, required this.conversationId});
}

@injectable
class AcceptOffer {
  final RequestsRepository _requestsRepository;
  final EnsureConversationFor _ensureConversationFor;

  AcceptOffer(this._requestsRepository, this._ensureConversationFor);

  Future<Result<AcceptOfferResult>> call(
    String offerId,
    String requestId,
    String clientId,
  ) async {
    if (offerId.trim().isEmpty) {
      return Err(ValidationFailure('معرف العرض مطلوب'));
    }

    final requestResult = await _requestsRepository.acceptOffer(
      offerId: offerId,
      clientId: clientId,
    );

    return requestResult.when(
      ok: (request) async {
        final professionalId = request.assignedProfessionalId;

        if (professionalId == null) {
          return Err(ServerFailure('لم يتم تعيين صنايعي للطلب'));
        }

        final conversationResult = await _ensureConversationFor(
          requestId: requestId,
          clientId: clientId,
          professionalId: professionalId,
        );

        return conversationResult.when(
          ok: (conversation) => Ok(
            AcceptOfferResult(
              request: request,
              conversationId: conversation.id,
            ),
          ),
          err: (failure) => Err(failure),
        );
      },
      err: (failure) => Err(failure),
    );
  }
}
