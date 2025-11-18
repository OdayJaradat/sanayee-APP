import '../../../../core/error/result.dart';
import '../entities/professional.dart';
import '../../data/models/professional_stats_model.dart';
import '../../data/models/ratings_breakdown_model.dart';
import '../../data/models/recent_job_model.dart';

abstract class ProfessionalsRepository {
  Future<Result<Professional>> getProfessionalById(String id);
  Future<Result<List<Professional>>> getAllProfessionals();

  Future<Result<ProfessionalStatsModel>> fetchProfessionalStats(
    String professionalId,
  );

  Future<Result<List<RatingsBreakdownModel>>> fetchRatingsBreakdown(
    String professionalId,
  );

  Future<Result<List<RecentJobModel>>> fetchRecentJobs(
    String professionalId, {
    int limit = 5,
  });
}
