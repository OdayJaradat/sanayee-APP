import 'package:supabase_flutter/supabase_flutter.dart';
import 'data/datasources/admin_supabase_datasource.dart';
import 'data/repositories/admin_repository_impl.dart';
import 'domain/repositories/admin_repository.dart';
import 'presentation/cubit/admin_dashboard_cubit.dart';
import 'presentation/cubit/admin_users_cubit.dart';
import 'presentation/cubit/admin_professionals_cubit.dart';
import 'presentation/cubit/admin_requests_cubit.dart';
import 'presentation/cubit/admin_user_details_cubit.dart';
import 'presentation/cubit/admin_request_details_cubit.dart';
import 'presentation/cubit/admin_reports_cubit.dart';
import 'presentation/cubit/admin_report_details_cubit.dart';

/// Admin module dependency injection helper
/// 
/// Since admin is a separate entry point (main_admin.dart), we provide
/// simple factory methods to create the cubits without relying on the
/// main app's Injectable configuration.
class AdminInjection {
  static AdminSupabaseDataSource? _dataSource;
  static AdminRepository? _repository;

  /// Get or create the Supabase data source
  static AdminSupabaseDataSource get dataSource {
    _dataSource ??= AdminSupabaseDataSource(Supabase.instance.client);
    return _dataSource!;
  }

  /// Get or create the admin repository
  static AdminRepository get repository {
    _repository ??= AdminRepositoryImpl(dataSource);
    return _repository!;
  }

  /// Create a new AdminDashboardCubit instance
  static AdminDashboardCubit createDashboardCubit() {
    return AdminDashboardCubit(repository);
  }

  /// Create a new AdminUsersCubit instance
  static AdminUsersCubit createUsersCubit() {
    return AdminUsersCubit(repository);
  }

  /// Create a new AdminProfessionalsCubit instance
  static AdminProfessionalsCubit createProfessionalsCubit() {
    return AdminProfessionalsCubit(repository);
  }

  /// Create a new AdminRequestsCubit instance
  static AdminRequestsCubit createRequestsCubit() {
    return AdminRequestsCubit(repository);
  }

  /// Create a new AdminUserDetailsCubit instance
  static AdminUserDetailsCubit createUserDetailsCubit() {
    return AdminUserDetailsCubit(repository);
  }

  /// Create a new AdminRequestDetailsCubit instance
  static AdminRequestDetailsCubit createRequestDetailsCubit() {
    return AdminRequestDetailsCubit(repository);
  }

  /// Create a new AdminReportsCubit instance
  static AdminReportsCubit createReportsCubit() {
    return AdminReportsCubit(repository);
  }

  /// Create a new AdminReportDetailsCubit instance
  static AdminReportDetailsCubit createReportDetailsCubit() {
    return AdminReportDetailsCubit(repository);
  }

  /// Reset all cached instances (useful for testing)
  static void reset() {
    _dataSource = null;
    _repository = null;
  }
}
