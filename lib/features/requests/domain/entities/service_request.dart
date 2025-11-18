import 'package:freezed_annotation/freezed_annotation.dart';
import 'request_type.dart';

part 'service_request.freezed.dart';

@freezed
class ServiceRequest with _$ServiceRequest {
  const factory ServiceRequest({
    required String id,
    required String title,
    required String description,
    required String category,
    double? budget,
    required String clientId,
    required DateTime createdAt,
    @Default('open') String status,
    String? professionalId,
    DateTime? updatedAt,
    String? location,
    @Default([]) List<String> photos,
    @Default(RequestType.normal) RequestType type,
    String? assignedTo,
    Map<String, double>? clientGpsLocation,
    String? assignedProfessionalId,
    String? acceptedOfferId,
    DateTime? acceptedAt,
    DateTime? completedAt,
    String? rejectionReason,
    double? acceptedOfferAmount,
  }) = _ServiceRequest;

  const ServiceRequest._();

  bool get isQuick => type == RequestType.quick;

  bool get isAssigned => status == 'assigned' && assignedTo != null;
}
