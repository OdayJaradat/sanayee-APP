
import 'package:injectable/injectable.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../notifications/domain/services/notification_service.dart';
import '../models/rating_model.dart';


@injectable
class RatingsSupabaseDataSource {
  final SupabaseClient _supabase;
  final NotificationService _notificationService;

  RatingsSupabaseDataSource(this._supabase, this._notificationService);

  
  Future<RatingModel> addRating({
    required String requestId,
    required String clientId,
    required String professionalId,
    required int rating,
    String? comment,
  }) async {
    final data = {
      'request_id': requestId,
      'client_id': clientId,
      'professional_id': professionalId,
      'rating': rating,
      'created_at': DateTime.now().toIso8601String(),
    };

    if (comment != null) {
      data['comment'] = comment;
    }

    final response = await _supabase
        .from('ratings')
        .insert(data)
        .select()
        .single();

    final ratingModel = RatingModel.fromJson(response);

    try {
      final clientData = await _supabase
          .from('profiles')
          .select('full_name')
          .eq('id', clientId)
          .maybeSingle();

      final clientName = clientData?['full_name'] as String? ?? 'عميل';

      await _notificationService.sendNewRatingNotification(
        userId: professionalId,
        ratingId: ratingModel.id,
        raterName: clientName,
        rating: rating.toDouble(),
        comment: comment,
      );
    } catch (e) {
      final _ = e;
    }

    return ratingModel;
  }

  
  Future<List<RatingModel>> getRatingsForProfessional(
    String professionalId,
  ) async {
    final response = await _supabase
        .from('ratings')
        .select()
        .eq('professional_id', professionalId)
        .order('created_at', ascending: false);

    return (response as List)
        .map((json) => RatingModel.fromJson(json))
        .toList();
  }

  
  Future<RatingModel?> getRatingForRequest(String requestId) async {
    final response = await _supabase
        .from('ratings')
        .select()
        .eq('request_id', requestId)
        .maybeSingle();

    if (response == null) return null;
    return RatingModel.fromJson(response);
  }

  
  Future<bool> hasRatingForRequest(String requestId) async {
    final response = await _supabase
        .from('ratings')
        .select('id')
        .eq('request_id', requestId)
        .maybeSingle();

    return response != null;
  }

  
  Future<RatingModel> updateRating({
    required String ratingId,
    required int rating,
    String? comment,
  }) async {
    final response = await _supabase
        .from('ratings')
        .update({'rating': rating, 'comment': comment})
        .eq('id', ratingId)
        .select()
        .single();

    return RatingModel.fromJson(response);
  }
}
