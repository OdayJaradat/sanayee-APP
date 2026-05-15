/// Professional row entity for admin professionals list
/// Extends user data with professional-specific stats
class AdminProfessionalRow {
  final String id;
  final String fullName;
  final String? phone;
  final String? city;
  final DateTime? createdAt;
  final double? avgRating;
  final int completedJobs;
  final bool isBlocked;

  const AdminProfessionalRow({
    required this.id,
    required this.fullName,
    this.phone,
    this.city,
    this.createdAt,
    this.avgRating,
    this.completedJobs = 0,
    this.isBlocked = false,
  });

  factory AdminProfessionalRow.fromJson(Map<String, dynamic> json) {
    return AdminProfessionalRow(
      id: json['id'] as String,
      fullName: json['full_name'] as String? ?? '',
      phone: json['phone'] as String?,
      city: json['city'] as String?,
      createdAt: json['created_at'] != null
          ? DateTime.tryParse(json['created_at'] as String)
          : null,
      avgRating: json['avg_rating'] != null
          ? (json['avg_rating'] as num).toDouble()
          : null,
      completedJobs: json['completed_jobs'] as int? ?? 0,
      isBlocked: json['is_blocked'] as bool? ?? false,
    );
  }

  String get ratingDisplay =>
      avgRating != null ? avgRating!.toStringAsFixed(1) : '—';

  AdminProfessionalRow copyWith({bool? isBlocked}) {
    return AdminProfessionalRow(
      id: id,
      fullName: fullName,
      phone: phone,
      city: city,
      createdAt: createdAt,
      avgRating: avgRating,
      completedJobs: completedJobs,
      isBlocked: isBlocked ?? this.isBlocked,
    );
  }
}

/// Paginated response for professionals list
class AdminProfessionalsPage {
  final List<AdminProfessionalRow> rows;
  final int totalCount;
  final int pageIndex;
  final int pageSize;

  const AdminProfessionalsPage({
    required this.rows,
    required this.totalCount,
    required this.pageIndex,
    required this.pageSize,
  });

  int get totalPages => (totalCount / pageSize).ceil();
  bool get hasNextPage => pageIndex < totalPages - 1;
  bool get hasPreviousPage => pageIndex > 0;
}
