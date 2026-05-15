
class AdminReport {
  final String id;
  final String targetType; // 'request', 'professional', 'client', 'offer'
  final String targetId;
  final String? createdBy;
  final String? creatorName;
  final String reason;
  final String? details;
  final String status; // 'open', 'resolved', 'dismissed'
  final String? adminNotes;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const AdminReport({
    required this.id,
    required this.targetType,
    required this.targetId,
    this.createdBy,
    this.creatorName,
    required this.reason,
    this.details,
    required this.status,
    this.adminNotes,
    this.createdAt,
    this.updatedAt,
  });

  factory AdminReport.fromJson(Map<String, dynamic> json) {
    // Handle nested creator profile if present
    String? creatorName;
    if (json['creator'] is Map) {
      creatorName = json['creator']['full_name'] as String?;
    }

    return AdminReport(
      id: json['id'] as String,
      targetType: json['target_type'] as String? ?? 'request',
      targetId: json['target_id'] as String? ?? '',
      createdBy: json['created_by'] as String?,
      creatorName: creatorName,
      reason: json['reason'] as String? ?? '',
      details: json['details'] as String?,
      status: json['status'] as String? ?? 'open',
      adminNotes: json['admin_notes'] as String?,
      createdAt: json['created_at'] != null
          ? DateTime.tryParse(json['created_at'] as String)
          : null,
      updatedAt: json['updated_at'] != null
          ? DateTime.tryParse(json['updated_at'] as String)
          : null,
    );
  }

  /// Factory for creating AdminReport with separately fetched creator name
  factory AdminReport.fromJsonWithCreator(
    Map<String, dynamic> json,
    String? creatorName,
  ) {
    return AdminReport(
      id: json['id'] as String,
      targetType: json['target_type'] as String? ?? 'request',
      targetId: json['target_id'] as String? ?? '',
      createdBy: json['created_by'] as String?,
      creatorName: creatorName,
      reason: json['reason'] as String? ?? '',
      details: json['details'] as String?,
      status: json['status'] as String? ?? 'open',
      adminNotes: json['admin_notes'] as String?,
      createdAt: json['created_at'] != null
          ? DateTime.tryParse(json['created_at'] as String)
          : null,
      updatedAt: json['updated_at'] != null
          ? DateTime.tryParse(json['updated_at'] as String)
          : null,
    );
  }

  String get shortId => id.length > 8 ? id.substring(0, 8) : id;
  String get shortTargetId =>
      targetId.length > 8 ? targetId.substring(0, 8) : targetId;

  String get targetTypeLabel {
    switch (targetType) {
      case 'request':
        return 'طلب';
      case 'professional':
        return 'صنايعي';
      case 'client':
        return 'عميل';
      case 'offer':
        return 'عرض';
      default:
        return targetType;
    }
  }

  String get statusLabel {
    switch (status) {
      case 'resolved':
        return 'تم الحل';
      case 'dismissed':
        return 'مرفوض';
      case 'open':
      default:
        return 'مفتوح';
    }
  }

  bool get isOpen => status == 'open';
  bool get isResolved => status == 'resolved';
  bool get isDismissed => status == 'dismissed';
}

/// Paginated response for reports list
class AdminReportsPage {
  final List<AdminReport> rows;
  final int totalCount;
  final int pageIndex;
  final int pageSize;

  const AdminReportsPage({
    required this.rows,
    required this.totalCount,
    required this.pageIndex,
    required this.pageSize,
  });

  int get totalPages => (totalCount / pageSize).ceil();
  bool get hasNextPage => pageIndex < totalPages - 1;
  bool get hasPreviousPage => pageIndex > 0;
}

/// Filter parameters for reports list
class AdminReportsFilter {
  final String? status;
  final String? targetType;
  final String? targetId;
  final String? searchQuery;

  const AdminReportsFilter({
    this.status,
    this.targetType,
    this.targetId,
    this.searchQuery,
  });

  AdminReportsFilter copyWith({
    String? status,
    String? targetType,
    String? targetId,
    String? searchQuery,
  }) {
    return AdminReportsFilter(
      status: status ?? this.status,
      targetType: targetType ?? this.targetType,
      targetId: targetId ?? this.targetId,
      searchQuery: searchQuery ?? this.searchQuery,
    );
  }
}
