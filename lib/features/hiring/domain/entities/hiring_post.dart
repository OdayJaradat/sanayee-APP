import 'package:freezed_annotation/freezed_annotation.dart';
import 'job_type.dart';
import 'post_status.dart';
import 'service_category.dart';
import 'pay_type.dart';

part 'hiring_post.freezed.dart';


@freezed
class HiringPost with _$HiringPost {
  const factory HiringPost({
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
    ServiceCategory? category,
    String? governorate,
    String? locality,
    String? address,
    PayType? payType,
    double? fixedAmount,
    double? rangeMin,
    double? rangeMax,
  }) = _HiringPost;

  const HiringPost._();

  
  bool get isOpen => status.isOpen;

  
  bool get isClosed => status.isClosed;

  
  bool get hasLocation => location != null;

  
  bool get hasSalary => salaryAmount != null && salaryAmount! > 0;

  
  bool get hasDuration => durationText != null && durationText!.isNotEmpty;

  
  String get formattedSalary {
    if (!hasSalary) return 'غير محدد';
    return '${salaryAmount!.toStringAsFixed(0)} ₪';
  }
}
