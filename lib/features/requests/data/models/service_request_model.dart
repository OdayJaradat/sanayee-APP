import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/service_request.dart';
import '../../domain/entities/request_type.dart';

part 'service_request_model.freezed.dart';
part 'service_request_model.g.dart';

@freezed
class ServiceRequestModel with _$ServiceRequestModel {
  const ServiceRequestModel._();

  const factory ServiceRequestModel({
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
  }) = _ServiceRequestModel;

  factory ServiceRequestModel.fromJson(Map<String, dynamic> json) =>
      _$ServiceRequestModelFromJson(json);

  ServiceRequest toEntity() => ServiceRequest(
    id: id,
    title: title,
    description: description,
    category: category,
    budget: budget,
    clientId: clientId,
    createdAt: createdAt,
    status: status,
    professionalId: professionalId,
    updatedAt: updatedAt,
    location: location,
    photos: photos,
    type: type,
    assignedTo: assignedTo,
    clientGpsLocation: clientGpsLocation,
    assignedProfessionalId: assignedProfessionalId,
    acceptedOfferId: acceptedOfferId,
    acceptedAt: acceptedAt,
    completedAt: completedAt,
    rejectionReason: rejectionReason,
    acceptedOfferAmount: acceptedOfferAmount,
  );

  factory ServiceRequestModel.fromEntity(ServiceRequest entity) =>
      ServiceRequestModel(
        id: entity.id,
        title: entity.title,
        description: entity.description,
        category: entity.category,
        budget: entity.budget,
        clientId: entity.clientId,
        createdAt: entity.createdAt,
        status: entity.status,
        professionalId: entity.professionalId,
        updatedAt: entity.updatedAt,
        location: entity.location,
        photos: entity.photos,
        type: entity.type,
        assignedTo: entity.assignedTo,
        clientGpsLocation: entity.clientGpsLocation,
        assignedProfessionalId: entity.assignedProfessionalId,
        acceptedOfferId: entity.acceptedOfferId,
        acceptedAt: entity.acceptedAt,
        completedAt: entity.completedAt,
        rejectionReason: entity.rejectionReason,
        acceptedOfferAmount: entity.acceptedOfferAmount,
      );
}
