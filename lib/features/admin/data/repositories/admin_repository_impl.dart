import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../../core/error/result.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/admin_dashboard_stats.dart';
import '../../domain/entities/admin_user_row.dart';
import '../../domain/entities/admin_request_row.dart';
import '../../domain/entities/admin_user_details.dart';
import '../../domain/entities/admin_request_details.dart';
import '../../domain/entities/admin_report.dart';
import '../../domain/entities/admin_professional_row.dart';
import '../../domain/repositories/admin_repository.dart';
import '../datasources/admin_supabase_datasource.dart';

/// Admin repository implementation using Supabase
/// Note: Uses manual DI via AdminInjection (not Injectable)
class AdminRepositoryImpl implements AdminRepository {
  final AdminSupabaseDataSource _dataSource;

  AdminRepositoryImpl(this._dataSource);

  @override
  Future<Result<AdminDashboardStats>> getDashboardStats() async {
    try {
      final stats = await _dataSource.getDashboardStats();
      return Ok(stats);
    } on PostgrestException catch (e) {
      return Err(ServerFailure('فشل في جلب الإحصائيات: ${e.message}'));
    } catch (e) {
      return Err(ServerFailure('فشل في جلب الإحصائيات: ${e.toString()}'));
    }
  }

  @override
  Future<Result<AdminUsersPage>> getUsers({
    required int pageIndex,
    required int pageSize,
    String? searchQuery,
    String? roleFilter,
  }) async {
    try {
      final result = await _dataSource.getUsers(
        pageIndex: pageIndex,
        pageSize: pageSize,
        searchQuery: searchQuery,
        roleFilter: roleFilter,
      );

      return Ok(AdminUsersPage(
        rows: result.rows,
        totalCount: result.totalCount,
        pageIndex: pageIndex,
        pageSize: pageSize,
      ));
    } on PostgrestException catch (e) {
      return Err(ServerFailure('فشل في جلب المستخدمين: ${e.message}'));
    } catch (e) {
      return Err(ServerFailure('فشل في جلب المستخدمين: ${e.toString()}'));
    }
  }

  @override
  Future<Result<AdminProfessionalsPage>> getProfessionals({
    required int pageIndex,
    required int pageSize,
    String? searchQuery,
  }) async {
    try {
      final result = await _dataSource.getProfessionals(
        pageIndex: pageIndex,
        pageSize: pageSize,
        searchQuery: searchQuery,
      );

      return Ok(AdminProfessionalsPage(
        rows: result.rows,
        totalCount: result.totalCount,
        pageIndex: pageIndex,
        pageSize: pageSize,
      ));
    } on PostgrestException catch (e) {
      return Err(ServerFailure('فشل في جلب الصنايعية: ${e.message}'));
    } catch (e) {
      return Err(ServerFailure('فشل في جلب الصنايعية: ${e.toString()}'));
    }
  }

  @override
  Future<Result<void>> toggleProfessionalBlocked(String professionalId, bool blocked) async {
    try {
      await _dataSource.toggleProfessionalBlocked(professionalId, blocked);
      return const Ok(null);
    } on PostgrestException catch (e) {
      return Err(ServerFailure('فشل في تحديث حالة الحظر: ${e.message}'));
    } catch (e) {
      return Err(ServerFailure('فشل في تحديث حالة الحظر: ${e.toString()}'));
    }
  }

  @override
  Future<Result<void>> toggleUserBlocked(String userId, bool blocked) async {
    try {
      await _dataSource.toggleUserBlocked(userId, blocked);
      return const Ok(null);
    } on PostgrestException catch (e) {
      return Err(ServerFailure('فشل في تحديث حالة الحظر: ${e.message}'));
    } catch (e) {
      return Err(ServerFailure('فشل في تحديث حالة الحظر: ${e.toString()}'));
    }
  }

  @override
  Future<Result<AdminRequestsPage>> getRequests({
    required int pageIndex,
    required int pageSize,
    AdminRequestsFilter? filter,
  }) async {
    try {
      final result = await _dataSource.getRequests(
        pageIndex: pageIndex,
        pageSize: pageSize,
        filter: filter,
      );

      return Ok(AdminRequestsPage(
        rows: result.rows,
        totalCount: result.totalCount,
        pageIndex: pageIndex,
        pageSize: pageSize,
      ));
    } on PostgrestException catch (e) {
      return Err(ServerFailure('فشل في جلب الطلبات: ${e.message}'));
    } catch (e) {
      return Err(ServerFailure('فشل في جلب الطلبات: ${e.toString()}'));
    }
  }

  @override
  Future<Result<AdminUserDetails>> getUserDetails(String userId) async {
    try {
      final details = await _dataSource.getUserDetails(userId);
      return Ok(details);
    } on PostgrestException catch (e) {
      return Err(ServerFailure('فشل في جلب تفاصيل المستخدم: ${e.message}'));
    } catch (e) {
      return Err(ServerFailure('فشل في جلب تفاصيل المستخدم: ${e.toString()}'));
    }
  }

  @override
  Future<Result<AdminRequestDetails?>> getRequestDetails(String requestId) async {
    try {
      final details = await _dataSource.getRequestDetails(requestId);
      return Ok(details);
    } on PostgrestException catch (e) {
      return Err(ServerFailure('فشل في جلب تفاصيل الطلب: ${e.message}'));
    } catch (e) {
      return Err(ServerFailure('فشل في جلب تفاصيل الطلب: ${e.toString()}'));
    }
  }

  // ============================================================================
  // REPORTS
  // ============================================================================

  @override
  Future<Result<AdminReport>> createReport({
    required String targetType,
    required String targetId,
    required String reason,
    String? details,
    required String createdBy,
  }) async {
    try {
      final report = await _dataSource.createReport(
        targetType: targetType,
        targetId: targetId,
        reason: reason,
        details: details,
        createdBy: createdBy,
      );
      return Ok(report);
    } on PostgrestException catch (e) {
      return Err(ServerFailure('فشل في إنشاء البلاغ: ${e.message}'));
    } catch (e) {
      return Err(ServerFailure('فشل في إنشاء البلاغ: ${e.toString()}'));
    }
  }

  @override
  Future<Result<AdminReportsPage>> getReports({
    required int pageIndex,
    required int pageSize,
    AdminReportsFilter? filter,
  }) async {
    try {
      final result = await _dataSource.getReports(
        pageIndex: pageIndex,
        pageSize: pageSize,
        filter: filter,
      );

      return Ok(AdminReportsPage(
        rows: result.rows,
        totalCount: result.totalCount,
        pageIndex: pageIndex,
        pageSize: pageSize,
      ));
    } on PostgrestException catch (e) {
      // Handle case where reports table doesn't exist
      if (e.message.contains('relation') && e.message.contains('does not exist')) {
        return Err(ServerFailure('جدول البلاغات غير موجود في قاعدة البيانات. يرجى إنشاء الجدول أولاً.'));
      }
      return Err(ServerFailure('فشل في جلب البلاغات: ${e.message}'));
    } catch (e) {
      return Err(ServerFailure('فشل في جلب البلاغات: ${e.toString()}'));
    }
  }

  @override
  Future<Result<AdminReport>> getReportById(String reportId) async {
    try {
      final report = await _dataSource.getReportById(reportId);
      return Ok(report);
    } on PostgrestException catch (e) {
      return Err(ServerFailure('فشل في جلب البلاغ: ${e.message}'));
    } catch (e) {
      return Err(ServerFailure('فشل في جلب البلاغ: ${e.toString()}'));
    }
  }

  @override
  Future<Result<AdminReport>> updateReport({
    required String reportId,
    required String status,
    String? adminNotes,
  }) async {
    try {
      final report = await _dataSource.updateReport(
        reportId: reportId,
        status: status,
        adminNotes: adminNotes,
      );
      return Ok(report);
    } on PostgrestException catch (e) {
      return Err(ServerFailure('فشل في تحديث البلاغ: ${e.message}'));
    } catch (e) {
      return Err(ServerFailure('فشل في تحديث البلاغ: ${e.toString()}'));
    }
  }

  @override
  Future<Result<List<AdminReport>>> getRecentActivity({int limit = 10}) async {
    try {
      final reports = await _dataSource.getRecentActivity(limit: limit);
      return Ok(reports);
    } on PostgrestException catch (e) {
      return Err(ServerFailure('فشل في جلب النشاط الأخير: ${e.message}'));
    } catch (e) {
      return Err(ServerFailure('فشل في جلب النشاط الأخير: ${e.toString()}'));
    }
  }
}
