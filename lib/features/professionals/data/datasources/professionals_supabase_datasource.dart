import 'package:injectable/injectable.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/professional_model.dart';
import '../models/professional_stats_model.dart';
import '../models/ratings_breakdown_model.dart';
import '../models/recent_job_model.dart';

@LazySingleton(env: [Environment.prod])
class ProfessionalsSupabaseDataSource {
  final SupabaseClient _supabase;

  ProfessionalsSupabaseDataSource(this._supabase);

  Future<ProfessionalModel?> getProfessionalById(String id) async {
    final response = await _supabase
        .from('profiles')
        .select()
        .eq('id', id)
        .eq('role', 'professional')
        .maybeSingle();

    if (response == null) return null;

    return _mapFromProfile(response);
  }

  Future<List<ProfessionalModel>> getAllProfessionals() async {
    final response = await _supabase
        .from('profiles')
        .select()
        .eq('role', 'professional')
        .order('created_at', ascending: false);

    return (response as List).map((json) => _mapFromProfile(json)).toList();
  }

  Future<List<ProfessionalModel>> getProfessionalsWithLocation() async {
    final response = await _supabase
        .from('profiles')
        .select()
        .eq('role', 'professional')
        .not('latitude', 'is', null)
        .not('longitude', 'is', null);

    return (response as List).map((json) => _mapFromProfile(json)).toList();
  }

  Future<ProfessionalStatsModel> getProfessionalStats(
    String professionalId,
  ) async {
    final response = await _supabase.rpc(
      'get_professional_stats',
      params: {'_pro': professionalId},
    );

    if (response is List && response.isNotEmpty) {
      return ProfessionalStatsModel.fromRpc(
        response[0] as Map<String, dynamic>,
      );
    }

    return const ProfessionalStatsModel(
      avgRating: 0.0,
      ratingsCount: 0,
      completedRequests: 0,
    );
  }

  Future<List<RatingsBreakdownModel>> getRatingsBreakdown(
    String professionalId,
  ) async {
    final response = await _supabase.rpc(
      'get_ratings_breakdown',
      params: {'_pro': professionalId},
    );

    return (response as List)
        .map((json) => RatingsBreakdownModel.fromJson(json))
        .toList();
  }

  Future<List<RecentJobModel>> getRecentCompletedRequests(
    String professionalId, {
    int limit = 5,
  }) async {
    final response = await _supabase.rpc(
      'get_recent_completed_requests',
      params: {'_pro': professionalId, '_limit': limit},
    );

    return (response as List)
        .map((json) => RecentJobModel.fromJson(json))
        .toList();
  }

  ProfessionalModel _mapFromProfile(Map<String, dynamic> json) {
    final skills = json['skills'] != null
        ? List<String>.from(json['skills'])
        : <String>[];

    return ProfessionalModel(
      id: json['id'],
      name: json['full_name'] ?? json['name'] ?? 'صنايعي',
      avatarUrl: json['avatar_url'],
      skills: skills,
      rating: (json['rating'] ?? 0.0).toDouble(),
      jobsCount: json['jobs_count'] ?? 0,
      bio: json['bio'],
      latitude: json['latitude'] != null
          ? (json['latitude'] as num).toDouble()
          : null,
      longitude: json['longitude'] != null
          ? (json['longitude'] as num).toDouble()
          : null,
    );
  }
}
