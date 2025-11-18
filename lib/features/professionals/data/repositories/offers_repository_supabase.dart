import 'package:injectable/injectable.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../../core/error/result.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/offer.dart';
import '../../domain/repositories/offers_repository.dart';
import '../datasources/offers_supabase_datasource.dart';

@LazySingleton(as: OffersRepository, env: [Environment.prod])
class OffersRepositorySupabase implements OffersRepository {
  final OffersSupabaseDataSource _supabaseDataSource;

  OffersRepositorySupabase(this._supabaseDataSource);

  @override
  Future<Result<Offer>> submitOffer({
    required String requestId,
    required String professionalId,
    required double amount,
    String? note,
  }) async {
    try {
      final model = await _supabaseDataSource.submitOffer(
        requestId: requestId,
        professionalId: professionalId,
        amount: amount,
        note: note,
      );
      return Ok(model.toEntity());
    } on PostgrestException catch (e) {
      return Err(ServerFailure('فشل في إرسال العرض: ${e.message}'));
    } catch (e) {
      return Err(ServerFailure('فشل في إرسال العرض: ${e.toString()}'));
    }
  }

  @override
  Future<Result<List<Offer>>> getOffersByRequest(String requestId) async {
    try {
      final models = await _supabaseDataSource.getOffersByRequest(requestId);
      final entities = models.map((m) => m.toEntity()).toList();
      return Ok(entities);
    } on PostgrestException catch (e) {
      return Err(ServerFailure('فشل في جلب العروض: ${e.message}'));
    } catch (e) {
      return Err(ServerFailure('فشل في جلب العروض: ${e.toString()}'));
    }
  }

  @override
  
  Future<Result<Offer>> acceptOffer(String offerId) async {
    try {
      
      final model = await _supabaseDataSource.acceptOffer(offerId);
      return Ok(model.toEntity());
    } on PostgrestException catch (e) {
      return Err(ServerFailure('فشل في قبول العرض: ${e.message}'));
    } catch (e) {
      return Err(ServerFailure('فشل في قبول العرض: ${e.toString()}'));
    }
  }

  @override
  Future<Result<Offer>> declineOffer(String offerId) async {
    try {
      final model = await _supabaseDataSource.declineOffer(offerId);
      return Ok(model.toEntity());
    } on PostgrestException catch (e) {
      return Err(ServerFailure('فشل في رفض العرض: ${e.message}'));
    } catch (e) {
      return Err(ServerFailure('فشل في رفض العرض: ${e.toString()}'));
    }
  }

  @override
  Future<Result<Offer>> counterOffer({
    required String offerId,
    required double newAmount,
    String? note,
  }) async {
    try {
      final model = await _supabaseDataSource.counterOffer(
        offerId: offerId,
        newAmount: newAmount,
        note: note,
      );
      return Ok(model.toEntity());
    } on PostgrestException catch (e) {
      return Err(ServerFailure('فشل في إرسال عرض مضاد: ${e.message}'));
    } catch (e) {
      return Err(ServerFailure('فشل في إرسال عرض مضاد: ${e.toString()}'));
    }
  }

  @override
  Future<Result<Offer>> withdrawOffer({
    required String offerId,
    required String professionalId,
  }) async {
    try {
      final model = await _supabaseDataSource.withdrawOffer(
        offerId: offerId,
        professionalId: professionalId,
      );
      return Ok(model.toEntity());
    } on PostgrestException catch (e) {
      return Err(ServerFailure('فشل في سحب العرض: ${e.message}'));
    } catch (e) {
      return Err(ServerFailure('فشل في سحب العرض: ${e.toString()}'));
    }
  }

  @override
  Future<Result<List<Offer>>> getOffersByProfessionalId(
    String professionalId,
  ) async {
    try {
      final models = await _supabaseDataSource.getOffersByProfessionalId(
        professionalId,
      );
      final entities = models.map((m) => m.toEntity()).toList();
      return Ok(entities);
    } on PostgrestException catch (e) {
      return Err(ServerFailure('فشل في جلب عروضي: ${e.message}'));
    } catch (e) {
      return Err(ServerFailure('فشل في جلب عروضي: ${e.toString()}'));
    }
  }

  @override
  Future<Result<Offer>> acceptCounterOffer({
    required String offerId,
    required String professionalId,
  }) async {
    try {
      final model = await _supabaseDataSource.acceptCounterOffer(
        offerId: offerId,
        professionalId: professionalId,
      );
      return Ok(model.toEntity());
    } on PostgrestException catch (e) {
      return Err(ServerFailure('فشل في قبول العرض المضاد: ${e.message}'));
    } catch (e) {
      return Err(ServerFailure('فشل في قبول العرض المضاد: ${e.toString()}'));
    }
  }
}
