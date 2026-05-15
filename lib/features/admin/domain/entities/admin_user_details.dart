/// Detailed user information entity for admin user details page
class AdminUserDetails {
  final String id;
  final String fullName;
  final String? email;
  final String? phone;
  final String role;
  final String? city;
  final String? governorate;
  final String? bio;
  final String? avatarUrl;
  final String? specialization;
  final int yearsExperience;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  
  // Stats (depends on role)
  final int requestsCount; // For clients: requests created
  final int completedJobsCount; // For professionals: completed jobs
  final double? avgRating; // For professionals
  final int ratingsCount; // For professionals

  const AdminUserDetails({
    required this.id,
    required this.fullName,
    this.email,
    this.phone,
    required this.role,
    this.city,
    this.governorate,
    this.bio,
    this.avatarUrl,
    this.specialization,
    this.yearsExperience = 0,
    this.createdAt,
    this.updatedAt,
    this.requestsCount = 0,
    this.completedJobsCount = 0,
    this.avgRating,
    this.ratingsCount = 0,
  });

  factory AdminUserDetails.fromJson(Map<String, dynamic> json, {
    int requestsCount = 0,
    int completedJobsCount = 0,
    double? avgRating,
    int ratingsCount = 0,
  }) {
    return AdminUserDetails(
      id: json['id'] as String,
      fullName: json['full_name'] as String? ?? '',
      email: json['email'] as String?,
      phone: json['phone'] as String?,
      role: json['role'] as String? ?? 'client',
      city: json['city'] as String?,
      governorate: json['governorate'] as String?,
      bio: json['bio'] as String?,
      avatarUrl: json['avatar_url'] as String?,
      specialization: json['specialization'] as String?,
      yearsExperience: json['years_experience'] as int? ?? 0,
      createdAt: json['created_at'] != null
          ? DateTime.tryParse(json['created_at'] as String)
          : null,
      updatedAt: json['updated_at'] != null
          ? DateTime.tryParse(json['updated_at'] as String)
          : null,
      requestsCount: requestsCount,
      completedJobsCount: completedJobsCount,
      avgRating: avgRating,
      ratingsCount: ratingsCount,
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

  bool get isClient => role == 'client';
  bool get isProfessional => role == 'professional';
  bool get isAdmin => role == 'admin';

  String get formattedAvgRating {
    if (avgRating == null) return '—';
    return avgRating!.toStringAsFixed(1);
  }
}
