/// User row entity for admin users list
class AdminUserRow {
  final String id;
  final String fullName;
  final String? email;
  final String? phone;
  final String role;
  final String? city;
  final DateTime? createdAt;
  final bool isBlocked;

  const AdminUserRow({
    required this.id,
    required this.fullName,
    this.email,
    this.phone,
    required this.role,
    this.city,
    this.createdAt,
    this.isBlocked = false,
  });

  factory AdminUserRow.fromJson(Map<String, dynamic> json) {
    return AdminUserRow(
      id: json['id'] as String,
      fullName: json['full_name'] as String? ?? '',
      email: json['email'] as String?,
      phone: json['phone'] as String?,
      role: json['role'] as String? ?? 'client',
      city: json['city'] as String?,
      createdAt: json['created_at'] != null
          ? DateTime.tryParse(json['created_at'] as String)
          : null,
      isBlocked: json['is_blocked'] as bool? ?? false,
    );
  }

  /// Create a copy with updated isBlocked status
  AdminUserRow copyWith({bool? isBlocked}) {
    return AdminUserRow(
      id: id,
      fullName: fullName,
      email: email,
      phone: phone,
      role: role,
      city: city,
      createdAt: createdAt,
      isBlocked: isBlocked ?? this.isBlocked,
    );
  }

  String get roleLabel {
    switch (role) {
      case 'admin':
        return 'مسؤول';
      case 'professional':
        return 'صنايعي';
      case 'client':
      default:
        return 'عميل';
    }
  }
}

/// Paginated response for users list
class AdminUsersPage {
  final List<AdminUserRow> rows;
  final int totalCount;
  final int pageIndex;
  final int pageSize;

  const AdminUsersPage({
    required this.rows,
    required this.totalCount,
    required this.pageIndex,
    required this.pageSize,
  });

  int get totalPages => (totalCount / pageSize).ceil();
  bool get hasNextPage => pageIndex < totalPages - 1;
  bool get hasPreviousPage => pageIndex > 0;
}
