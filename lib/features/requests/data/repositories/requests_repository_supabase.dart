import 'package:injectable/injectable.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../../core/error/result.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/service_request.dart';
import '../../domain/repositories/requests_repository.dart';
import '../datasources/requests_supabase_datasource.dart';
import '../models/service_request_model.dart';

@LazySingleton(as: RequestsRepository, env: [Environment.prod])
class RequestsRepositorySupabase implements RequestsRepository {
  final RequestsSupabaseDataSource _supabaseDataSource;

  RequestsRepositorySupabase(this._supabaseDataSource);

  @override
  Future<Result<List<ServiceRequest>>> fetchRequests({String? clientId}) async {
    try {
      if (clientId == null) {
        return Err(ServerFailure('معرف العميل مطلوب لجلب الطلبات'));
      }

      final models = await _supabaseDataSource.fetchRequests(clientId);
      final entities = models.map((m) => m.toEntity()).toList();
      return Ok(entities);
    } on PostgrestException catch (e) {
      return Err(ServerFailure('فشل في جلب الطلبات: ${e.message}'));
    } catch (e) {
      return Err(ServerFailure('فشل في جلب الطلبات: ${e.toString()}'));
    }
  }

  Future<Result<List<ServiceRequest>>> fetchRequestsForClient(
    String clientId,
  ) async {
    return fetchRequests(clientId: clientId);
  }

  @override
  Future<Result<List<ServiceRequest>>> fetchOpenRequests() async {
    try {
      final models = await _supabaseDataSource.fetchOpenRequests();
      final entities = models.map((m) => m.toEntity()).toList();
      return Ok(entities);
    } on PostgrestException catch (e) {
      return Err(ServerFailure('فشل في جلب الطلبات المفتوحة: ${e.message}'));
    } catch (e) {
      return Err(ServerFailure('فشل في جلب الطلبات المفتوحة: ${e.toString()}'));
    }
  }

  @override
  Future<Result<ServiceRequest>> create(ServiceRequest request) async {
    try {
      final model = await _supabaseDataSource.create(
        ServiceRequestModel.fromEntity(request),
      );
      return Ok(model.toEntity());
    } on PostgrestException catch (e) {
      return Err(ServerFailure('فشل في إنشاء الطلب: ${e.message}'));
    } catch (e) {
      return Err(ServerFailure('فشل في إنشاء الطلب: ${e.toString()}'));
    }
  }

  @override
  Future<Result<ServiceRequest>> getById(String id) async {
    try {
      final model = await _supabaseDataSource.getById(id);

      if (model == null) {
        return Err(NotFoundFailure('الطلب غير موجود'));
      }

      return Ok(model.toEntity());
    } on PostgrestException catch (e) {
      return Err(ServerFailure('فشل في جلب الطلب: ${e.message}'));
    } catch (e) {
      return Err(ServerFailure('فشل في جلب الطلب: ${e.toString()}'));
    }
  }

  @override
  Future<Result<void>> updateStatus(String requestId, String status) async {
    try {
      await _supabaseDataSource.updateStatus(requestId, status);
      return const Ok(null);
    } on PostgrestException catch (e) {
      return Err(ServerFailure('فشل في تحديث حالة الطلب: ${e.message}'));
    } catch (e) {
      return Err(ServerFailure('فشل في تحديث حالة الطلب: ${e.toString()}'));
    }
  }

  @override
  Future<Result<void>> setAssigned(
    String requestId,
    String professionalId,
  ) async {
    try {
      await _supabaseDataSource.setAssigned(requestId, professionalId);
      return const Ok(null);
    } on PostgrestException catch (e) {
      return Err(ServerFailure('فشل في تعيين الصنايعي: ${e.message}'));
    } catch (e) {
      return Err(ServerFailure('فشل في تعيين الصنايعي: ${e.toString()}'));
    }
  }

  @override
  Future<Result<void>> deleteById(String id) async {
    try {
      await _supabaseDataSource.deleteById(id);
      return const Ok(null);
    } on PostgrestException catch (e) {
      return Err(ServerFailure('فشل في حذف الطلب: ${e.message}'));
    } catch (e) {
      return Err(ServerFailure('فشل في حذف الطلب: ${e.toString()}'));
    }
  }

  @override
  Future<Result<ServiceRequest>> acceptOffer({
    required String offerId,
    required String clientId,
  }) async {
    try {
      final model = await _supabaseDataSource.acceptOffer(
        offerId: offerId,
        clientId: clientId,
      );
      return Ok(model.toEntity());
    } on PostgrestException catch (e) {
      return Err(ServerFailure('فشل في قبول العرض: ${e.message}'));
    } catch (e) {
      return Err(ServerFailure('فشل في قبول العرض: ${e.toString()}'));
    }
  }

  @override
  Future<Result<ServiceRequest>> markRequestCompleted({
    required String requestId,
    required String professionalId,
  }) async {
    try {
      final model = await _supabaseDataSource.markRequestCompleted(
        requestId: requestId,
        professionalId: professionalId,
      );
      return Ok(model.toEntity());
    } on PostgrestException catch (e) {
      return Err(ServerFailure('فشل في تحديث حالة الطلب: ${e.message}'));
    } catch (e) {
      return Err(ServerFailure('فشل في تحديث حالة الطلب: ${e.toString()}'));
    }
  }

  @override
  Future<Result<List<ServiceRequest>>> getActiveJobsByProfessionalId(
    String professionalId,
  ) async {
    try {
      final models = await _supabaseDataSource.getActiveJobsByProfessionalId(
        professionalId,
      );
      final entities = models.map((m) => m.toEntity()).toList();
      return Ok(entities);
    } on PostgrestException catch (e) {
      return Err(ServerFailure('فشل في جلب المهام النشطة: ${e.message}'));
    } catch (e) {
      return Err(ServerFailure('فشل في جلب المهام النشطة: ${e.toString()}'));
    }
  }

  @override
  Future<Result<ServiceRequest>> markJobReadyForReview({
    required String requestId,
    required String professionalId,
  }) async {
    try {
      final model = await _supabaseDataSource.markJobReadyForReview(
        requestId: requestId,
        professionalId: professionalId,
      );
      return Ok(model.toEntity());
    } on PostgrestException catch (e) {
      return Err(ServerFailure('فشل في وضع علامة جاهز للمراجعة: ${e.message}'));
    } catch (e) {
      return Err(
        ServerFailure('فشل في وضع علامة جاهز للمراجعة: ${e.toString()}'),
      );
    }
  }

  @override
  Future<Result<ServiceRequest>> confirmJobCompletion({
    required String requestId,
    required String clientId,
  }) async {
    try {
      final model = await _supabaseDataSource.confirmJobCompletion(
        requestId: requestId,
        clientId: clientId,
      );
      return Ok(model.toEntity());
    } on PostgrestException catch (e) {
      return Err(ServerFailure('فشل في تأكيد إنجاز المهمة: ${e.message}'));
    } catch (e) {
      return Err(ServerFailure('فشل في تأكيد إنجاز المهمة: ${e.toString()}'));
    }
  }

  @override
  Future<Result<ServiceRequest>> rejectJobCompletion({
    required String requestId,
    required String clientId,
    String? reason,
  }) async {
    try {
      await _supabaseDataSource.updateStatusWithRejection(
        requestId,
        'assigned',
        reason,
      );

      final model = await _supabaseDataSource.getById(requestId);
      if (model == null) {
        return Err(NotFoundFailure('الطلب غير موجود'));
      }

      return Ok(model.toEntity());
    } on PostgrestException catch (e) {
      return Err(ServerFailure('فشل في رفض الإنجاز: ${e.message}'));
    } catch (e) {
      return Err(ServerFailure('فشل في رفض الإنجاز: ${e.toString()}'));
    }
  }

  @override
  Future<Result<ServiceRequest>> closeRequest({
    required String requestId,
    required String clientId,
  }) async {
    try {
      await _supabaseDataSource.updateStatus(requestId, 'closed');

      final model = await _supabaseDataSource.getById(requestId);
      if (model == null) {
        return Err(NotFoundFailure('الطلب غير موجود'));
      }

      return Ok(model.toEntity());
    } on PostgrestException catch (e) {
      return Err(ServerFailure('فشل في إغلاق الطلب: ${e.message}'));
    } catch (e) {
      return Err(ServerFailure('فشل في إغلاق الطلب: ${e.toString()}'));
    }
  }
}
