
class AdminComplaint {
  final String id;
  final String? requestId;
  final String? createdBy;
  final String? creatorName;
  final String reason;
  final String? details;
  final String status;
  final String? adminNotes;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const AdminComplaint({
    required this.id,
    this.requestId,
    this.createdBy,
    this.creatorName,
    required this.reason,
    this.details,
    required this.status,
    this.adminNotes,
    this.createdAt,
    this.updatedAt,
  });

  factory AdminComplaint.fromJson(Map<String, dynamic> json) {
    // Handle nested creator profile if present
    String? creatorName;
    if (json['creator'] is Map) {
      creatorName = json['creator']['full_name'] as String?;
    }

    return AdminComplaint(
      id: json['id'] as String,
      requestId: json['request_id'] as String?,
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
  String get shortRequestId => requestId != null && requestId!.length > 8
      ? requestId!.substring(0, 8)
      : (requestId ?? '—');

  String get statusLabel {
    switch (status) {
      case 'resolved':
        return 'تم الحل';
      case 'open':
      default:
        return 'مفتوحة';
    }
  }

  bool get isOpen => status == 'open';
  bool get isResolved => status == 'resolved';
}

/// Paginated response for complaints list
class AdminComplaintsPage {
  final List<AdminComplaint> rows;
  final int totalCount;
  final int pageIndex;
  final int pageSize;

  const AdminComplaintsPage({
    required this.rows,
    required this.totalCount,
    required this.pageIndex,
    required this.pageSize,
  });

  int get totalPages => (totalCount / pageSize).ceil();
  bool get hasNextPage => pageIndex < totalPages - 1;
  bool get hasPreviousPage => pageIndex > 0;
}

/// Filter parameters for complaints list
class AdminComplaintsFilter {
  final String? status;
  final String? searchQuery;

  const AdminComplaintsFilter({
    this.status,
    this.searchQuery,
  });

  AdminComplaintsFilter copyWith({
    String? status,
    String? searchQuery,
  }) {
    return AdminComplaintsFilter(
      status: status ?? this.status,
      searchQuery: searchQuery ?? this.searchQuery,
    );
  }
}
