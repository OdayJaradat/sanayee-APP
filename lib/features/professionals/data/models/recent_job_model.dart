import 'package:freezed_annotation/freezed_annotation.dart';

part 'recent_job_model.freezed.dart';


@freezed
class RecentJobModel with _$RecentJobModel {
  const factory RecentJobModel({
    required String requestId,
    required String title,
    String? description,
    required String status,
    required String clientId,
    String? clientName,
    String? clientAvatar,
    DateTime? completedAt,
  }) = _RecentJobModel;

  factory RecentJobModel.fromJson(Map<String, dynamic> json) {
    return RecentJobModel(
      requestId: json['request_id'] as String,
      title: json['title'] as String,
      description: json['description'] as String?,
      status: json['status'] as String,
      clientId: json['client_id'] as String,
      clientName: json['client_name'] as String?,
      clientAvatar: json['client_avatar'] as String?,
      completedAt: json['completed_at'] != null
          ? DateTime.parse(json['completed_at'] as String)
          : null,
    );
  }
}
