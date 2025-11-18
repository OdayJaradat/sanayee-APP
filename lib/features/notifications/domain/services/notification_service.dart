import 'package:injectable/injectable.dart';

// simple notification service (simplified - no actual notifications sent)
@LazySingleton()
class NotificationService {
  // notifications disabled for simplicity - all methods do nothing
  // all parameters are optional to match different use cases

  Future<void> sendNewOfferNotification({
    String? userId,
    String? offerId,
    String? clientName,
    double? amount,
    String? requestTitle,
  }) async {}

  Future<void> sendOfferDeclinedNotification({
    String? userId,
    String? offerId,
    String? professionalName,
    String? requestTitle,
  }) async {}

  Future<void> sendCounterOfferNotification({
    String? userId,
    String? offerId,
    String? professionalName,
    double? counterAmount,
    double? newAmount,
    String? requestTitle,
  }) async {}

  Future<void> sendCounterAcceptedNotification({
    String? userId,
    String? offerId,
    String? clientName,
    String? requestTitle,
  }) async {}

  Future<void> sendNewMessageNotification({
    String? userId,
    String? conversationId,
    String? senderName,
    String? messagePreview,
  }) async {}

  Future<void> sendJobReadyNotification({
    String? userId,
    String? requestTitle,
  }) async {}

  Future<void> sendJobCompletedNotification({
    String? userId,
    String? requestTitle,
  }) async {}

  Future<void> sendRatingReceivedNotification({
    String? userId,
    String? requestTitle,
    int? rating,
  }) async {}

  Future<void> sendNewRatingNotification({
    String? professionalId,
    String? userId,
    String? requestTitle,
    String? ratingId,
    String? raterName,
    double? rating,
    String? comment,
  }) async {}

  Future<void> sendOfferAcceptedNotification({
    String? professionalId,
    String? userId,
    String? requestTitle,
    String? offerId,
    String? professionalName,
  }) async {}

  Future<void> sendRequestAssignedNotification({
    String? professionalId,
    String? userId,
    String? requestTitle,
    String? requestId,
    String? clientName,
  }) async {}

  Future<void> sendRequestCompletedNotification({
    String? clientId,
    String? userId,
    String? requestTitle,
    String? requestId,
    String? professionalName,
  }) async {}
}
