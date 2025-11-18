import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/hiring_post.dart';
import '../../domain/entities/job_type.dart';
import '../../domain/entities/post_status.dart';
import '../../domain/entities/service_category.dart';
import '../../domain/entities/pay_type.dart';

part 'hiring_post_model.freezed.dart';
part 'hiring_post_model.g.dart';

class ServiceCategoryConverter
    implements JsonConverter<ServiceCategory?, String?> {
  const ServiceCategoryConverter();

  @override
  ServiceCategory? fromJson(String? json) {
    if (json == null) return null;
    return ServiceCategory.fromJson(json);
  }

  @override
  String? toJson(ServiceCategory? object) => object?.toJson();
}

@freezed
class HiringPostModel with _$HiringPostModel {
  const HiringPostModel._();

  const factory HiringPostModel({
    required String id,
    required String professionalId,
    required String title,
    required String description,
    required JobType jobType,
    String? durationText,
    double? salaryAmount,
    Map<String, double>? location,
    @Default(PostStatus.open) PostStatus status,
    required DateTime createdAt,
    @ServiceCategoryConverter() ServiceCategory? category,
    String? governorate,
    String? locality,
    String? address,
    PayType? payType,
    double? fixedAmount,
    double? rangeMin,
    double? rangeMax,
  }) = _HiringPostModel;

  factory HiringPostModel.fromJson(Map<String, dynamic> json) =>
      _$HiringPostModelFromJson(json);

  HiringPost toEntity() => HiringPost(
    id: id,
    professionalId: professionalId,
    title: title,
    description: description,
    jobType: jobType,
    durationText: durationText,
    salaryAmount: salaryAmount,
    location: location,
    status: status,
    createdAt: createdAt,
    category: category,
    governorate: governorate,
    locality: locality,
    address: address,
    payType: payType,
    fixedAmount: fixedAmount,
    rangeMin: rangeMin,
    rangeMax: rangeMax,
  );

  factory HiringPostModel.fromEntity(HiringPost entity) => HiringPostModel(
    id: entity.id,
    professionalId: entity.professionalId,
    title: entity.title,
    description: entity.description,
    jobType: entity.jobType,
    durationText: entity.durationText,
    salaryAmount: entity.salaryAmount,
    location: entity.location,
    status: entity.status,
    createdAt: entity.createdAt,
    category: entity.category,
    governorate: entity.governorate,
    locality: entity.locality,
    address: entity.address,
    payType: entity.payType,
    fixedAmount: entity.fixedAmount,
    rangeMin: entity.rangeMin,
    rangeMax: entity.rangeMax,
  );
}
