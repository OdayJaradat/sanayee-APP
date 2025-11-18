import '../../../../core/error/result.dart';
import '../entities/service_request.dart';

abstract class RequestsRepository {
  Future<Result<List<ServiceRequest>>> fetchRequests({String? clientId});
  Future<Result<List<ServiceRequest>>> fetchOpenRequests();
  Future<Result<ServiceRequest>> create(ServiceRequest request);
  Future<Result<ServiceRequest>> getById(String id);
  Future<Result<void>> updateStatus(String requestId, String status);
  Future<Result<void>> deleteById(String id);
  Future<Result<void>> setAssigned(String requestId, String professionalId);
  Future<Result<ServiceRequest>> acceptOffer({
    required String offerId,
    required String clientId,
  });
  Future<Result<ServiceRequest>> markRequestCompleted({
    required String requestId,
    required String professionalId,
  });

  Future<Result<List<ServiceRequest>>> getActiveJobsByProfessionalId(
    String professionalId,
  );

  Future<Result<ServiceRequest>> markJobReadyForReview({
    required String requestId,
    required String professionalId,
  });

  Future<Result<ServiceRequest>> confirmJobCompletion({
    required String requestId,
    required String clientId,
  });

  Future<Result<ServiceRequest>> rejectJobCompletion({
    required String requestId,
    required String clientId,
    String? reason,
  });

  Future<Result<ServiceRequest>> closeRequest({
    required String requestId,
    required String clientId,
  });
}
