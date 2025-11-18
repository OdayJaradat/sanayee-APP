import 'package:injectable/injectable.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../../core/error/result.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/rating.dart';
import '../../domain/repositories/ratings_repository.dart';
import '../datasources/ratings_supabase_datasource.dart';


@LazySingleton(as: RatingsRepository, env: [Environment.prod])
class RatingsRepositorySupabase implements RatingsRepository {
  final RatingsSupabaseDataSource _dataSource;

  RatingsRepositorySupabase(this._dataSource);

  @override
  Future<Result<void>> addRating(Rating rating) async {
    try {
      await _dataSource.addRating(
        requestId: rating.requestId,
        clientId: rating.clientId,
        professionalId: rating.professionalId,
        rating: rating.rating,
        comment: rating.comment,
      );
      return const Ok(null);
    } on PostgrestException catch (e) {
      return Err(_handlePostgrestError(e));
    } catch (e) {
      return Err(ServerFailure('فشل في إضافة التقييم: $e'));
    }
  }

  @override
  Future<Result<List<Rating>>> getRatingsForProfessional(
    String professionalId,
  ) async {
    try {
      final models = await _dataSource.getRatingsForProfessional(
        professionalId,
      );
      final entities = models.map((m) => m.toEntity()).toList();
      return Ok(entities);
    } on PostgrestException catch (e) {
      return Err(_handlePostgrestError(e));
    } catch (e) {
      return Err(ServerFailure('فشل في جلب التقييمات: $e'));
    }
  }

  @override
  Future<Result<bool>> hasRatingForRequest(String requestId) async {
    try {
      final hasRating = await _dataSource.hasRatingForRequest(requestId);
      return Ok(hasRating);
    } on PostgrestException catch (e) {
      return Err(_handlePostgrestError(e));
    } catch (e) {
      return Err(ServerFailure('فشل في التحقق من التقييم: $e'));
    }
  }

  
  Failure _handlePostgrestError(PostgrestException e) {
    final code = e.code;
    final message = e.message;

    if (code == '23505') {
      return const ServerFailure('لقد قمت بتقييم هذا الطلب مسبقاً');
    } else if (code == '23503') {
      return const NotFoundFailure('الطلب أو المستخدم غير موجود');
    } else if (code == '23514') {
      return const ValidationFailure('يجب أن يكون التقييم بين 1 و 5');
    } else if (code == '42501') {
      return const UnauthorizedFailure('ليس لديك صلاحية لتقييم هذا الطلب');
    }

    return ServerFailure('خطأ في قاعدة البيانات: $message (Code: $code)');
  }
}
