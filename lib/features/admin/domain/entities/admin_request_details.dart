/// Detailed request information entity for admin request details page
class AdminRequestDetails {
  final String id;
  final String title;
  final String? description;
  final String status;
  final String? category;
  final double? budget;
  final String? city;
  final String? clientId;
  final String? clientName;
  final String? professionalId;
  final String? professionalName;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final DateTime? acceptedAt;
  final DateTime? completedAt;
  final List<AdminOffer> offers;

  const AdminRequestDetails({
    required this.id,
    required this.title,
    this.description,
    required this.status,
    this.category,
    this.budget,
    this.city,
    this.clientId,
    this.clientName,
    this.professionalId,
    this.professionalName,
    this.createdAt,
    this.updatedAt,
    this.acceptedAt,
    this.completedAt,
    this.offers = const [],
  });

  factory AdminRequestDetails.fromJson(
    Map<String, dynamic> json, {
    List<AdminOffer> offers = const [],
  }) {
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

    return AdminRequestDetails(
      id: json['id'] as String,
      title: json['title'] as String? ?? '',
      description: json['description'] as String?,
      status: json['status'] as String? ?? 'open',
      category: json['category'] as String?,
      budget: json['budget'] != null ? (json['budget'] as num).toDouble() : null,
      city: json['location'] as String?,
      clientId: json['client_id'] as String?,
      clientName: clientName,
      professionalId: json['professional_id'] as String?,
      professionalName: professionalName,
      createdAt: json['created_at'] != null
          ? DateTime.tryParse(json['created_at'] as String)
          : null,
      updatedAt: json['updated_at'] != null
          ? DateTime.tryParse(json['updated_at'] as String)
          : null,
      acceptedAt: json['accepted_at'] != null
          ? DateTime.tryParse(json['accepted_at'] as String)
          : null,
      completedAt: json['completed_at'] != null
          ? DateTime.tryParse(json['completed_at'] as String)
          : null,
      offers: offers,
    );
  }

  /// Factory for separate queries (no joins) - avoids RLS and coercion issues
  factory AdminRequestDetails.fromJsonSeparate(
    Map<String, dynamic> json, {
    String? clientName,
    String? professionalName,
    List<AdminOffer> offers = const [],
  }) {
    return AdminRequestDetails(
      id: json['id'] as String,
      title: json['title'] as String? ?? '',
      description: json['description'] as String?,
      status: json['status'] as String? ?? 'open',
      category: json['category'] as String?,
      budget: json['budget'] != null ? (json['budget'] as num).toDouble() : null,
      city: json['location'] as String?,
      clientId: json['client_id'] as String?,
      clientName: clientName,
      professionalId: json['professional_id'] as String?,
      professionalName: professionalName,
      createdAt: json['created_at'] != null
          ? DateTime.tryParse(json['created_at'] as String)
          : null,
      updatedAt: json['updated_at'] != null
          ? DateTime.tryParse(json['updated_at'] as String)
          : null,
      acceptedAt: json['accepted_at'] != null
          ? DateTime.tryParse(json['accepted_at'] as String)
          : null,
      completedAt: json['completed_at'] != null
          ? DateTime.tryParse(json['completed_at'] as String)
          : null,
      offers: offers,
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

  /// Build timeline events from request data
  List<TimelineEvent> get timelineEvents {
    final events = <TimelineEvent>[];

    // Request created
    if (createdAt != null) {
      events.add(TimelineEvent(
        type: TimelineEventType.requestCreated,
        title: 'تم إنشاء الطلب',
        description: 'بواسطة العميل: $clientName',
        timestamp: createdAt!,
      ));
    }

    // Offers submitted
    for (final offer in offers) {
      events.add(TimelineEvent(
        type: TimelineEventType.offerSubmitted,
        title: 'عرض جديد',
        description: 'من ${offer.professionalName ?? "صنايعي"} - ${offer.amount?.toStringAsFixed(0) ?? "—"} ₪',
        timestamp: offer.createdAt ?? DateTime.now(),
        metadata: {'offerId': offer.id, 'status': offer.status},
      ));
    }

    // Request assigned
    if (acceptedAt != null || status == 'assigned') {
      events.add(TimelineEvent(
        type: TimelineEventType.requestAssigned,
        title: 'تم تعيين صنايعي',
        description: professionalName ?? 'صنايعي',
        timestamp: acceptedAt ?? updatedAt ?? DateTime.now(),
      ));
    }

    // Request completed
    if (completedAt != null || status == 'completed') {
      events.add(TimelineEvent(
        type: TimelineEventType.requestCompleted,
        title: 'تم إكمال الطلب',
        description: 'تم إنجاز العمل بنجاح',
        timestamp: completedAt ?? updatedAt ?? DateTime.now(),
      ));
    }

    // Request closed
    if (status == 'closed') {
      events.add(TimelineEvent(
        type: TimelineEventType.requestClosed,
        title: 'تم إغلاق الطلب',
        description: '',
        timestamp: updatedAt ?? DateTime.now(),
      ));
    }

    // Sort by timestamp
    events.sort((a, b) => a.timestamp.compareTo(b.timestamp));

    return events;
  }
}

/// Offer entity for request details
class AdminOffer {
  final String id;
  final String requestId;
  final String? professionalId;
  final String? professionalName;
  final double? amount;
  final String? message;
  final String status;
  final DateTime? createdAt;

  const AdminOffer({
    required this.id,
    required this.requestId,
    this.professionalId,
    this.professionalName,
    this.amount,
    this.message,
    required this.status,
    this.createdAt,
  });

  factory AdminOffer.fromJson(Map<String, dynamic> json) {
    // Handle nested professional profile if present
    String? professionalName;
    if (json['professional'] is Map) {
      professionalName = json['professional']['full_name'] as String?;
    }

    return AdminOffer(
      id: json['id'] as String,
      requestId: json['request_id'] as String,
      professionalId: json['professional_id'] as String?,
      professionalName: professionalName,
      amount: json['amount'] != null ? (json['amount'] as num).toDouble() : null,
      message: json['message'] as String?,
      status: json['status'] as String? ?? 'pending',
      createdAt: json['created_at'] != null
          ? DateTime.tryParse(json['created_at'] as String)
          : null,
    );
  }

  /// Factory for separate queries (no joins)
  factory AdminOffer.fromJsonWithName(Map<String, dynamic> json, String? professionalName) {
    return AdminOffer(
      id: json['id'] as String,
      requestId: json['request_id'] as String,
      professionalId: json['professional_id'] as String?,
      professionalName: professionalName,
      amount: json['amount'] != null ? (json['amount'] as num).toDouble() : null,
      message: json['message'] as String?,
      status: json['status'] as String? ?? 'pending',
      createdAt: json['created_at'] != null
          ? DateTime.tryParse(json['created_at'] as String)
          : null,
    );
  }

  String get statusLabel {
    switch (status) {
      case 'accepted':
        return 'مقبول';
      case 'rejected':
        return 'مرفوض';
      case 'pending':
      default:
        return 'قيد الانتظار';
    }
  }
}

/// Timeline event types
enum TimelineEventType {
  requestCreated,
  offerSubmitted,
  requestAssigned,
  requestCompleted,
  requestClosed,
}

/// Timeline event for visual display
class TimelineEvent {
  final TimelineEventType type;
  final String title;
  final String description;
  final DateTime timestamp;
  final Map<String, dynamic>? metadata;

  const TimelineEvent({
    required this.type,
    required this.title,
    required this.description,
    required this.timestamp,
    this.metadata,
  });
}
