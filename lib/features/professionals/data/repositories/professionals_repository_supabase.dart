import 'package:injectable/injectable.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../../core/error/result.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/professional.dart';
import '../../domain/repositories/professionals_repository.dart';
import '../datasources/professionals_supabase_datasource.dart';
import '../models/professional_stats_model.dart';
import '../models/ratings_breakdown_model.dart';
import '../models/recent_job_model.dart';

@LazySingleton(as: ProfessionalsRepository, env: [Environment.prod])
class ProfessionalsRepositorySupabase implements ProfessionalsRepository {
  final ProfessionalsSupabaseDataSource _supabaseDataSource;

  ProfessionalsRepositorySupabase(this._supabaseDataSource);

  @override
  Future<Result<Professional>> getProfessionalById(String id) async {
    try {
      final model = await _supabaseDataSource.getProfessionalById(id);

      if (model == null) {
        return Err(NotFoundFailure('الصنايعي غير موجود'));
      }

      return Ok(model.toEntity());
    } on PostgrestException catch (e) {
      return Err(ServerFailure('فشل في جلب بيانات الصنايعي: ${e.message}'));
    } catch (e) {
      return Err(ServerFailure('فشل في جلب بيانات الصنايعي: ${e.toString()}'));
    }
  }

  @override
  Future<Result<List<Professional>>> getAllProfessionals() async {
    try {
      final models = await _supabaseDataSource.getAllProfessionals();
      final entities = models.map((m) => m.toEntity()).toList();
      return Ok(entities);
    } on PostgrestException catch (e) {
      return Err(ServerFailure('فشل في جلب قائمة الصنايعية: ${e.message}'));
    } catch (e) {
      return Err(ServerFailure('فشل في جلب قائمة الصنايعية: ${e.toString()}'));
    }
  }

  Future<Result<List<Professional>>> getProfessionalsWithLocation() async {
    try {
      final models = await _supabaseDataSource.getProfessionalsWithLocation();
      final entities = models.map((m) => m.toEntity()).toList();
      return Ok(entities);
    } on PostgrestException catch (e) {
      return Err(ServerFailure('فشل في جلب الصنايعية: ${e.message}'));
    } catch (e) {
      return Err(ServerFailure('فشل في جلب الصنايعية: ${e.toString()}'));
    }
  }

  @override
  Future<Result<ProfessionalStatsModel>> fetchProfessionalStats(
    String professionalId,
  ) async {
    try {
      final stats = await _supabaseDataSource.getProfessionalStats(
        professionalId,
      );
      return Ok(stats);
    } on PostgrestException catch (e) {
      return Err(ServerFailure('فشل في جلب إحصائيات الصنايعي: ${e.message}'));
    } catch (e) {
      return Err(
        ServerFailure('فشل في جلب إحصائيات الصنايعي: ${e.toString()}'),
      );
    }
  }

  @override
  Future<Result<List<RatingsBreakdownModel>>> fetchRatingsBreakdown(
    String professionalId,
  ) async {
    try {
      final breakdown = await _supabaseDataSource.getRatingsBreakdown(
        professionalId,
      );
      return Ok(breakdown);
    } on PostgrestException catch (e) {
      return Err(ServerFailure('فشل في جلب توزيع التقييمات: ${e.message}'));
    } catch (e) {
      return Err(ServerFailure('فشل في جلب توزيع التقييمات: ${e.toString()}'));
    }
  }

  @override
  Future<Result<List<RecentJobModel>>> fetchRecentJobs(
    String professionalId, {
    int limit = 5,
  }) async {
    try {
      final jobs = await _supabaseDataSource.getRecentCompletedRequests(
        professionalId,
        limit: limit,
      );
      return Ok(jobs);
    } on PostgrestException catch (e) {
      return Err(ServerFailure('فشل في جلب الطلبات الأخيرة: ${e.message}'));
    } catch (e) {
      return Err(ServerFailure('فشل في جلب الطلبات الأخيرة: ${e.toString()}'));
    }
  }
}
