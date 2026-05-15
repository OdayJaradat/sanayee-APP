/// Request row entity for admin requests list
class AdminRequestRow {
  final String id;
  final String title;
  final String status;
  final String? clientId;
  final String? clientName;
  final String? professionalId;
  final String? professionalName;
  final String? city;
  final DateTime? createdAt;
  final String? category;

  const AdminRequestRow({
    required this.id,
    required this.title,
    required this.status,
    this.clientId,
    this.clientName,
    this.professionalId,
    this.professionalName,
    this.city,
    this.createdAt,
    this.category,
  });

  factory AdminRequestRow.fromJson(Map<String, dynamic> json) {
    // Handle nested client profile if present
    String? clientName;
    if (json['client'] is Map) {
      clientName = json['client']['full_name'] as String?;
    }
    
    // Handle nested professional profile if present
    String? professionalName;
    if (json['professional'] is Map) {
      professionalName = json['professional']['full_name'] as String?;
    }

    return AdminRequestRow(
      id: json['id'] as String,
      title: json['title'] as String? ?? '',
      status: json['status'] as String? ?? 'open',
      clientId: json['client_id'] as String?,
      clientName: clientName,
      professionalId: json['professional_id'] as String?,
      professionalName: professionalName,
      city: json['location'] as String?,
      createdAt: json['created_at'] != null
          ? DateTime.tryParse(json['created_at'] as String)
          : null,
      category: json['category'] as String?,
    );
  }

  String get shortId => id.length > 8 ? id.substring(0, 8) : id;

  String get statusLabel {
    switch (status) {
      case 'open':
        return 'مفتوح';
      case 'assigned':
        return 'قيد التنفيذ';
      case 'pending_review':
        return 'بانتظار المراجعة';
      case 'completed':
        return 'مكتمل';
      case 'closed':
        return 'مغلق';
      default:
        return status;
    }
  }
}

/// Paginated response for requests list
class AdminRequestsPage {
  final List<AdminRequestRow> rows;
  final int totalCount;
  final int pageIndex;
  final int pageSize;

  const AdminRequestsPage({
    required this.rows,
    required this.totalCount,
    required this.pageIndex,
    required this.pageSize,
  });

  int get totalPages => (totalCount / pageSize).ceil();
  bool get hasNextPage => pageIndex < totalPages - 1;
  bool get hasPreviousPage => pageIndex > 0;
}

/// Filter parameters for requests list
class AdminRequestsFilter {
  final String? status;
  final String? city;
  final DateTime? startDate;
  final DateTime? endDate;
  final String? professionalId;

  const AdminRequestsFilter({
    this.status,
    this.city,
    this.startDate,
    this.endDate,
    this.professionalId,
  });

  AdminRequestsFilter copyWith({
    String? status,
    String? city,
    DateTime? startDate,
    DateTime? endDate,
    String? professionalId,
  }) {
    return AdminRequestsFilter(
      status: status ?? this.status,
      city: city ?? this.city,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      professionalId: professionalId ?? this.professionalId,
    );
  }
}
