import 'package:supabase_flutter/supabase_flutter.dart';
import '../../domain/entities/admin_dashboard_stats.dart';
import '../../domain/entities/admin_user_row.dart';
import '../../domain/entities/admin_request_row.dart';
import '../../domain/entities/admin_user_details.dart';
import '../../domain/entities/admin_request_details.dart';
import '../../domain/entities/admin_report.dart';
import '../../domain/entities/admin_professional_row.dart';

/// Supabase data source for admin operations
/// Note: Uses manual DI via AdminInjection (not Injectable)
class AdminSupabaseDataSource {
  final SupabaseClient _supabase;

  AdminSupabaseDataSource(this._supabase);

  /// Fetch dashboard KPI statistics using efficient count queries
  Future<AdminDashboardStats> getDashboardStats() async {
    // Total users count
    final usersResponse = await _supabase
        .from('profiles')
        .select('id')
        .count(CountOption.exact);
    final totalUsers = usersResponse.count;

    // Clients count: role == 'client' OR role == 'user' OR role == 'customer' OR role IS NULL
    final clientsResponse = await _supabase
        .from('profiles')
        .select('id')
        .or('role.eq.client,role.eq.user,role.eq.customer,role.is.null')
        .count(CountOption.exact);
    final totalClients = clientsResponse.count;

    // Professionals count
    final prosResponse = await _supabase
        .from('profiles')
        .select('id')
        .eq('role', 'professional')
        .count(CountOption.exact);
    final totalProfessionals = prosResponse.count;

    // Open requests count: status IN ('open', 'assigned', 'pending_review')
    final openRequestsResponse = await _supabase
        .from('requests')
        .select('id')
        .inFilter('status', ['open', 'assigned', 'pending_review'])
        .count(CountOption.exact);
    final openRequests = openRequestsResponse.count;

    // Completed requests count
    final completedRequestsResponse = await _supabase
        .from('requests')
        .select('id')
        .eq('status', 'completed')
        .count(CountOption.exact);
    final completedRequests = completedRequestsResponse.count;

    // Open reports count
    int openReports = 0;
    try {
      final openReportsResponse = await _supabase
          .from('reports')
          .select('id')
          .eq('status', 'open')
          .count(CountOption.exact);
      openReports = openReportsResponse.count;
    } catch (e) {
      // Reports table might not exist
      openReports = 0;
    }

    return AdminDashboardStats(
      totalUsers: totalUsers,
      totalClients: totalClients,
      totalProfessionals: totalProfessionals,
      openRequests: openRequests,
      completedRequests: completedRequests,
      openReports: openReports,
    );
  }

  /// Fetch paginated users list with filters
  Future<({List<AdminUserRow> rows, int totalCount})> getUsers({
    required int pageIndex,
    required int pageSize,
    String? searchQuery,
    String? roleFilter,
  }) async {
    // Build base query for counting
    var countQuery = _supabase.from('profiles').select('id');

    // Apply role filter if specified
    // 'client' filter includes role IS NULL and common client role variations
    if (roleFilter != null && roleFilter != 'all') {
      if (roleFilter == 'client') {
        countQuery = countQuery.or('role.eq.client,role.eq.user,role.eq.customer,role.is.null');
      } else {
        countQuery = countQuery.eq('role', roleFilter);
      }
    }

    // Apply search filter if specified
    if (searchQuery != null && searchQuery.isNotEmpty) {
      // Search in full_name or phone using OR
      countQuery = countQuery.or('full_name.ilike.%$searchQuery%,phone.ilike.%$searchQuery%');
    }

    // Get total count
    final countResponse = await countQuery.count(CountOption.exact);
    final totalCount = countResponse.count;

    // Build data query
    var dataQuery = _supabase.from('profiles').select('''
      id,
      full_name,
      email,
      phone,
      role,
      city,
      created_at,
      is_blocked
    ''');

    // Apply same filters
    if (roleFilter != null && roleFilter != 'all') {
      if (roleFilter == 'client') {
        dataQuery = dataQuery.or('role.eq.client,role.eq.user,role.eq.customer,role.is.null');
      } else {
        dataQuery = dataQuery.eq('role', roleFilter);
      }
    }

    if (searchQuery != null && searchQuery.isNotEmpty) {
      dataQuery = dataQuery.or('full_name.ilike.%$searchQuery%,phone.ilike.%$searchQuery%');
    }

    // Apply pagination and ordering
    final from = pageIndex * pageSize;
    final to = from + pageSize - 1;

    final response = await dataQuery
        .order('created_at', ascending: false)
        .range(from, to);

    final rows = (response as List)
        .map((json) => AdminUserRow.fromJson(json))
        .toList();

    return (rows: rows, totalCount: totalCount);
  }

  /// Fetch paginated professionals list with stats (avg rating, completed jobs)
  Future<({List<AdminProfessionalRow> rows, int totalCount})> getProfessionals({
    required int pageIndex,
    required int pageSize,
    String? searchQuery,
  }) async {
    // Build base query for counting - role fixed to 'professional'
    var countQuery = _supabase
        .from('profiles')
        .select('id')
        .eq('role', 'professional');

    // Apply search filter if specified
    if (searchQuery != null && searchQuery.isNotEmpty) {
      countQuery = countQuery
          .or('full_name.ilike.%$searchQuery%,phone.ilike.%$searchQuery%');
    }

    // Get total count
    final countResponse = await countQuery.count(CountOption.exact);
    final totalCount = countResponse.count;

    // Build data query - get basic profile data including is_blocked
    var dataQuery = _supabase.from('profiles').select('''
      id,
      full_name,
      phone,
      city,
      created_at,
      is_blocked
    ''').eq('role', 'professional');

    // Apply search filter
    if (searchQuery != null && searchQuery.isNotEmpty) {
      dataQuery = dataQuery
          .or('full_name.ilike.%$searchQuery%,phone.ilike.%$searchQuery%');
    }

    // Apply pagination and ordering
    final from = pageIndex * pageSize;
    final to = from + pageSize - 1;

    final response = await dataQuery
        .order('created_at', ascending: false)
        .range(from, to);

    final profiles = response as List;

    // Fetch stats for each professional
    final List<AdminProfessionalRow> rows = [];

    for (final profile in profiles) {
      final proId = profile['id'] as String;

      // Get completed jobs count
      int completedJobs = 0;
      try {
        final jobsResponse = await _supabase
            .from('requests')
            .select('id')
            .eq('professional_id', proId)
            .eq('status', 'completed')
            .count(CountOption.exact);
        completedJobs = jobsResponse.count;
      } catch (_) {}

      // Get average rating
      double? avgRating;
      try {
        final ratingsResponse = await _supabase
            .from('ratings')
            .select('rating')
            .eq('professional_id', proId);

        if ((ratingsResponse as List).isNotEmpty) {
          final ratings =
              ratingsResponse.map((r) => (r['rating'] as num).toDouble()).toList();
          avgRating = ratings.reduce((a, b) => a + b) / ratings.length;
        }
      } catch (_) {}

      rows.add(AdminProfessionalRow(
        id: proId,
        fullName: profile['full_name'] as String? ?? '',
        phone: profile['phone'] as String?,
        city: profile['city'] as String?,
        createdAt: profile['created_at'] != null
            ? DateTime.tryParse(profile['created_at'] as String)
            : null,
        avgRating: avgRating,
        completedJobs: completedJobs,
        isBlocked: profile['is_blocked'] as bool? ?? false,
      ));
    }

    return (rows: rows, totalCount: totalCount);
  }

  /// Toggle professional blocked status
  /// Note: Requires is_blocked column in profiles table.
  /// SQL: ALTER TABLE profiles ADD COLUMN IF NOT EXISTS is_blocked BOOLEAN DEFAULT FALSE;
  Future<void> toggleProfessionalBlocked(String professionalId, bool blocked) async {
    await _supabase
        .from('profiles')
        .update({'is_blocked': blocked})
        .eq('id', professionalId);
  }

  /// Toggle user blocked status (works for any user type: client, professional, admin)
  /// Note: Requires is_blocked column in profiles table.
  /// SQL: ALTER TABLE profiles ADD COLUMN IF NOT EXISTS is_blocked BOOLEAN DEFAULT FALSE;
  Future<void> toggleUserBlocked(String userId, bool blocked) async {
    await _supabase
        .from('profiles')
        .update({'is_blocked': blocked})
        .eq('id', userId);
  }

  /// Fetch paginated requests list with filters
  Future<({List<AdminRequestRow> rows, int totalCount})> getRequests({
    required int pageIndex,
    required int pageSize,
    AdminRequestsFilter? filter,
  }) async {
    // Build base query for counting
    var countQuery = _supabase.from('requests').select('id');

    // Apply status filter
    if (filter?.status != null && filter!.status != 'all') {
      countQuery = countQuery.eq('status', filter.status!);
    }

    // Apply city filter (using location column)
    if (filter?.city != null && filter!.city!.isNotEmpty) {
      countQuery = countQuery.ilike('location', '%${filter.city}%');
    }

    // Apply professional ID filter
    if (filter?.professionalId != null && filter!.professionalId!.isNotEmpty) {
      countQuery = countQuery.eq('professional_id', filter.professionalId!);
    }

    // Apply date range filter
    if (filter?.startDate != null) {
      countQuery = countQuery.gte('created_at', filter!.startDate!.toIso8601String());
    }
    if (filter?.endDate != null) {
      // Add one day to include the end date
      final endDate = filter!.endDate!.add(const Duration(days: 1));
      countQuery = countQuery.lt('created_at', endDate.toIso8601String());
    }

    // Get total count
    final countResponse = await countQuery.count(CountOption.exact);
    final totalCount = countResponse.count;

    // Build data query with joined profiles for client and professional names
    var dataQuery = _supabase.from('requests').select('''
      id,
      title,
      status,
      client_id,
      professional_id,
      location,
      created_at,
      category,
      client:profiles!requests_client_id_fkey(full_name),
      professional:profiles!requests_professional_id_fkey(full_name)
    ''');

    // Apply same filters
    if (filter?.status != null && filter!.status != 'all') {
      dataQuery = dataQuery.eq('status', filter.status!);
    }

    if (filter?.city != null && filter!.city!.isNotEmpty) {
      dataQuery = dataQuery.ilike('location', '%${filter.city}%');
    }

    // Apply professional ID filter
    if (filter?.professionalId != null && filter!.professionalId!.isNotEmpty) {
      dataQuery = dataQuery.eq('professional_id', filter.professionalId!);
    }

    if (filter?.startDate != null) {
      dataQuery = dataQuery.gte('created_at', filter!.startDate!.toIso8601String());
    }
    if (filter?.endDate != null) {
      final endDate = filter!.endDate!.add(const Duration(days: 1));
      dataQuery = dataQuery.lt('created_at', endDate.toIso8601String());
    }

    // Apply pagination and ordering
    final from = pageIndex * pageSize;
    final to = from + pageSize - 1;

    final response = await dataQuery
        .order('created_at', ascending: false)
        .range(from, to);

    final rows = (response as List)
        .map((json) => AdminRequestRow.fromJson(json))
        .toList();

    return (rows: rows, totalCount: totalCount);
  }

  // ============================================================================
  // USER DETAILS
  // ============================================================================

  /// Fetch detailed user information with stats
  Future<AdminUserDetails> getUserDetails(String userId) async {
    // Fetch profile
    final profileResponse = await _supabase
        .from('profiles')
        .select('''
          id,
          full_name,
          email,
          phone,
          role,
          city,
          governorate,
          bio,
          avatar_url,
          specialization,
          years_experience,
          created_at,
          updated_at
        ''')
        .eq('id', userId)
        .single();

    final role = profileResponse['role'] as String? ?? 'client';

    // Fetch stats based on role
    int requestsCount = 0;
    int completedJobsCount = 0;
    double? avgRating;
    int ratingsCount = 0;

    if (role == 'client') {
      // Count requests created by client
      final requestsResponse = await _supabase
          .from('requests')
          .select('id')
          .eq('client_id', userId)
          .count(CountOption.exact);
      requestsCount = requestsResponse.count;
    } else if (role == 'professional') {
      // Count completed jobs
      final jobsResponse = await _supabase
          .from('requests')
          .select('id')
          .eq('professional_id', userId)
          .eq('status', 'completed')
          .count(CountOption.exact);
      completedJobsCount = jobsResponse.count;

      // Calculate average rating
      try {
        final ratingsResponse = await _supabase
            .from('ratings')
            .select('rating')
            .eq('professional_id', userId);

        if (ratingsResponse.isNotEmpty) {
          final ratings = (ratingsResponse as List)
              .map((r) => (r['rating'] as num).toDouble())
              .toList();
          avgRating = ratings.reduce((a, b) => a + b) / ratings.length;
          ratingsCount = ratings.length;
        }
      } catch (e) {
        // Ratings might not exist
      }
    }

    return AdminUserDetails.fromJson(
      profileResponse,
      requestsCount: requestsCount,
      completedJobsCount: completedJobsCount,
      avgRating: avgRating,
      ratingsCount: ratingsCount,
    );
  }

  // ============================================================================
  // REQUEST DETAILS
  // ============================================================================

  /// Fetch detailed request information with offers
  /// Returns null if request not found (RLS restriction or doesn't exist)
  Future<AdminRequestDetails?> getRequestDetails(String requestId) async {
    // Fetch request basic data first (without joins that might duplicate)
    final requestResponse = await _supabase
        .from('requests')
        .select('''
          id,
          title,
          description,
          status,
          category,
          budget,
          location,
          client_id,
          professional_id,
          created_at,
          updated_at,
          accepted_at,
          completed_at
        ''')
        .eq('id', requestId)
        .maybeSingle();

    // Request not found or no permission
    if (requestResponse == null) {
      return null;
    }

    // Fetch client name separately
    String? clientName;
    final clientId = requestResponse['client_id'] as String?;
    if (clientId != null) {
      try {
        final clientResponse = await _supabase
            .from('profiles')
            .select('full_name')
            .eq('id', clientId)
            .maybeSingle();
        clientName = clientResponse?['full_name'] as String?;
      } catch (_) {}
    }

    // Fetch professional name separately
    String? professionalName;
    final professionalId = requestResponse['professional_id'] as String?;
    if (professionalId != null) {
      try {
        final proResponse = await _supabase
            .from('profiles')
            .select('full_name')
            .eq('id', professionalId)
            .maybeSingle();
        professionalName = proResponse?['full_name'] as String?;
      } catch (_) {}
    }

    // Fetch offers for this request separately
    List<AdminOffer> offers = [];
    try {
      final offersResponse = await _supabase
          .from('offers')
          .select('''
            id,
            request_id,
            professional_id,
            amount,
            message,
            status,
            created_at
          ''')
          .eq('request_id', requestId)
          .order('created_at', ascending: true);

      // Fetch professional names for offers
      for (final offerJson in (offersResponse as List)) {
        String? offerProName;
        final offerProId = offerJson['professional_id'] as String?;
        if (offerProId != null) {
          try {
            final proNameResponse = await _supabase
                .from('profiles')
                .select('full_name')
                .eq('id', offerProId)
                .maybeSingle();
            offerProName = proNameResponse?['full_name'] as String?;
          } catch (_) {}
        }
        offers.add(AdminOffer.fromJsonWithName(offerJson, offerProName));
      }
    } catch (e) {
      // Offers might not exist or no permission
    }

    return AdminRequestDetails.fromJsonSeparate(
      requestResponse,
      clientName: clientName,
      professionalName: professionalName,
      offers: offers,
    );
  }

  // ============================================================================
  // REPORTS
  // ============================================================================

  /// Create a new report
  Future<AdminReport> createReport({
    required String targetType,
    required String targetId,
    required String reason,
    String? details,
    required String createdBy,
  }) async {
    final response = await _supabase.from('reports').insert({
      'target_type': targetType,
      'target_id': targetId,
      'reason': reason,
      'details': details,
      'created_by': createdBy,
      'status': 'open',
      'created_at': DateTime.now().toIso8601String(),
    }).select().single();

    return AdminReport.fromJson(response);
  }

  /// Check if a string is a valid UUID format
  bool _isValidUuid(String str) {
    final uuidRegex = RegExp(
      r'^[0-9a-fA-F]{8}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{12}$',
    );
    return uuidRegex.hasMatch(str);
  }

  /// Fetch paginated reports list with filters
  Future<({List<AdminReport> rows, int totalCount})> getReports({
    required int pageIndex,
    required int pageSize,
    AdminReportsFilter? filter,
  }) async {
    // Build base query for counting
    var countQuery = _supabase.from('reports').select('id');

    // Apply status filter
    if (filter?.status != null && filter!.status != 'all') {
      countQuery = countQuery.eq('status', filter.status!);
    }

    // Apply target type filter
    if (filter?.targetType != null && filter!.targetType != 'all') {
      countQuery = countQuery.eq('target_type', filter.targetType!);
    }

    // Apply target ID filter (exact match)
    if (filter?.targetId != null && filter!.targetId!.isNotEmpty) {
      countQuery = countQuery.eq('target_id', filter.targetId!);
    }

    // Apply search filter - only use eq() if it's a valid UUID to avoid "uuid ~~*" error
    if (filter?.searchQuery != null && filter!.searchQuery!.isNotEmpty) {
      final query = filter.searchQuery!.trim();
      if (_isValidUuid(query)) {
        countQuery = countQuery.eq('target_id', query);
      }
      // If not a valid UUID, skip the filter (don't apply ilike on UUID columns)
    }

    // Get total count
    final countResponse = await countQuery.count(CountOption.exact);
    final totalCount = countResponse.count;

    // Build data query (without foreign key join to avoid schema cache issues)
    var dataQuery = _supabase.from('reports').select('''
      id,
      target_type,
      target_id,
      created_by,
      reason,
      details,
      status,
      admin_notes,
      created_at
    ''');

    // Apply same filters
    if (filter?.status != null && filter!.status != 'all') {
      dataQuery = dataQuery.eq('status', filter.status!);
    }

    if (filter?.targetType != null && filter!.targetType != 'all') {
      dataQuery = dataQuery.eq('target_type', filter.targetType!);
    }

    // Apply target ID filter (exact match)
    if (filter?.targetId != null && filter!.targetId!.isNotEmpty) {
      dataQuery = dataQuery.eq('target_id', filter.targetId!);
    }

    // Apply search filter - only use eq() if it's a valid UUID
    if (filter?.searchQuery != null && filter!.searchQuery!.isNotEmpty) {
      final query = filter.searchQuery!.trim();
      if (_isValidUuid(query)) {
        dataQuery = dataQuery.eq('target_id', query);
      }
      // If not a valid UUID, skip the filter
    }

    // Apply pagination and ordering
    final from = pageIndex * pageSize;
    final to = from + pageSize - 1;

    final response = await dataQuery
        .order('created_at', ascending: false)
        .range(from, to);

    // Build rows with reporter names fetched separately
    final List<AdminReport> rows = [];
    for (final json in (response as List)) {
      String? creatorName;
      final createdBy = json['created_by'] as String?;
      if (createdBy != null) {
        try {
          final creatorProfile = await _supabase
              .from('profiles')
              .select('full_name, phone, email')
              .eq('id', createdBy)
              .maybeSingle();

          if (creatorProfile != null) {
            creatorName = creatorProfile['full_name'] as String?;
            if (creatorName == null || creatorName.isEmpty) {
              creatorName = creatorProfile['phone'] as String?;
            }
            if (creatorName == null || creatorName.isEmpty) {
              creatorName = creatorProfile['email'] as String?;
            }
          }
        } catch (_) {
          // Ignore profile fetch errors
        }
      }
      rows.add(AdminReport.fromJsonWithCreator(json, creatorName));
    }

    return (rows: rows, totalCount: totalCount);
  }

  /// Fetch report by ID with reporter profile
  Future<AdminReport> getReportById(String reportId) async {
    final response = await _supabase
        .from('reports')
        .select('''
          id,
          target_type,
          target_id,
          created_by,
          reason,
          details,
          status,
          admin_notes,
          created_at
        ''')
        .eq('id', reportId)
        .single();

    // Fetch reporter profile separately to get name
    String? creatorName;
    final createdBy = response['created_by'] as String?;
    if (createdBy != null) {
      try {
        final creatorProfile = await _supabase
            .from('profiles')
            .select('full_name, phone, email')
            .eq('id', createdBy)
            .maybeSingle();

        if (creatorProfile != null) {
          // Use full_name first, fallback to phone, then email
          creatorName = creatorProfile['full_name'] as String?;
          if (creatorName == null || creatorName.isEmpty) {
            creatorName = creatorProfile['phone'] as String?;
          }
          if (creatorName == null || creatorName.isEmpty) {
            creatorName = creatorProfile['email'] as String?;
          }
        }
      } catch (_) {
        // Ignore profile fetch errors
      }
    }

    return AdminReport.fromJsonWithCreator(response, creatorName);
  }

  /// Update report status and admin notes
  Future<AdminReport> updateReport({
    required String reportId,
    required String status,
    String? adminNotes,
  }) async {
    final updateData = <String, dynamic>{
      'status': status,
    };

    if (adminNotes != null) {
      updateData['admin_notes'] = adminNotes;
    }

    await _supabase
        .from('reports')
        .update(updateData)
        .eq('id', reportId);

    return getReportById(reportId);
  }

  // ============================================================================
  // RECENT ACTIVITY (for dashboard)
  // ============================================================================

  /// Fetch recent reports for dashboard activity section
  Future<List<AdminReport>> getRecentActivity({int limit = 10}) async {
    try {
      final response = await _supabase
          .from('reports')
          .select('''
            id,
            target_type,
            target_id,
            created_by,
            reason,
            details,
            status,
            admin_notes,
            created_at
          ''')
          .order('created_at', ascending: false)
          .limit(limit);

      return (response as List)
          .map((json) => AdminReport.fromJson(json))
          .toList();
    } catch (e) {
      // Reports table might not exist
      return [];
    }
  }
}
