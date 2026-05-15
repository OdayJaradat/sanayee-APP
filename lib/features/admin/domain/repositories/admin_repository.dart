import '../../../../core/error/result.dart';
import '../entities/admin_dashboard_stats.dart';
import '../entities/admin_user_row.dart';
import '../entities/admin_request_row.dart';
import '../entities/admin_user_details.dart';
import '../entities/admin_request_details.dart';
import '../entities/admin_report.dart';
import '../entities/admin_professional_row.dart';

/// Admin repository interface for dashboard, users and requests management
abstract class AdminRepository {
  /// Fetch dashboard KPI statistics
  Future<Result<AdminDashboardStats>> getDashboardStats();

  /// Fetch paginated users list with optional filters
  Future<Result<AdminUsersPage>> getUsers({
    required int pageIndex,
    required int pageSize,
    String? searchQuery,
    String? roleFilter,
  });

  /// Fetch paginated professionals list with stats
  Future<Result<AdminProfessionalsPage>> getProfessionals({
    required int pageIndex,
    required int pageSize,
    String? searchQuery,
  });

  /// Toggle professional blocked status
  Future<Result<void>> toggleProfessionalBlocked(String professionalId, bool blocked);

  /// Toggle user blocked status (works for any user type)
  Future<Result<void>> toggleUserBlocked(String userId, bool blocked);

  /// Fetch paginated requests list with optional filters
  Future<Result<AdminRequestsPage>> getRequests({
    required int pageIndex,
    required int pageSize,
    AdminRequestsFilter? filter,
  });

  /// Fetch detailed user information with stats
  Future<Result<AdminUserDetails>> getUserDetails(String userId);

  /// Fetch detailed request information with offers
  /// Returns null if request not found or no permission
  Future<Result<AdminRequestDetails?>> getRequestDetails(String requestId);

  // ============================================================================
  // REPORTS
  // ============================================================================

  /// Create a new report
  Future<Result<AdminReport>> createReport({
    required String targetType,
    required String targetId,
    required String reason,
    String? details,
    required String createdBy,
  });

  /// Fetch paginated reports list with optional filters
  Future<Result<AdminReportsPage>> getReports({
    required int pageIndex,
    required int pageSize,
    AdminReportsFilter? filter,
  });

  /// Fetch report by ID
  Future<Result<AdminReport>> getReportById(String reportId);

  /// Update report status and admin notes
  Future<Result<AdminReport>> updateReport({
    required String reportId,
    required String status,
    String? adminNotes,
  });

  /// Fetch recent reports for dashboard activity section
  Future<Result<List<AdminReport>>> getRecentActivity({int limit = 10});
}
