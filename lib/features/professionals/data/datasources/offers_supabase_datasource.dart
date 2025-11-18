import 'package:injectable/injectable.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../notifications/domain/services/notification_service.dart';
import '../models/offer_model.dart';

@LazySingleton(env: [Environment.prod])
class OffersSupabaseDataSource {
  final SupabaseClient _supabase;
  final NotificationService _notificationService;

  OffersSupabaseDataSource(this._supabase, this._notificationService);

  Map<String, dynamic> _convertFromSupabase(Map<String, dynamic> json) {
    return {
      'id': json['id'],
      'requestId': json['request_id'],
      'professionalId': json['professional_id'],
      'amount': json['amount'],
      'note': json['note'],
      'createdAt': json['created_at'],
      'status': json['status'],
      'acceptedAt': json['accepted_at'],
      'updatedAt': json['updated_at'],
    };
  }

  Future<OfferModel> submitOffer({
    required String requestId,
    required String professionalId,
    required double amount,
    String? note,
  }) async {
    final data = {
      'request_id': requestId,
      'professional_id': professionalId,
      'amount': amount,
      'note': note,
      'status': 'pending',
      'created_at': DateTime.now().toIso8601String(),
    };

    final response = await _supabase
        .from('offers')
        .insert(data)
        .select()
        .single();

    final offer = OfferModel.fromJson(_convertFromSupabase(response));
    try {
      final requestData = await _supabase
          .from('requests')
          .select('client_id')
          .eq('id', requestId)
          .single();

      final clientId = requestData['client_id'] as String;
      final professionalData = await _supabase
          .from('profiles')
          .select('full_name')
          .eq('id', professionalId)
          .maybeSingle();

      final professionalName =
          professionalData?['full_name'] as String? ?? 'صنايعي';
      await _notificationService.sendNewOfferNotification(
        userId: clientId,
        offerId: offer.id,
        clientName: professionalName,
        amount: amount,
      );
    } catch (e) {
      final _ = e;
    }

    return offer;
  }

  Future<List<OfferModel>> getOffersByRequest(String requestId) async {
    final response = await _supabase
        .from('offers')
        .select()
        .eq('request_id', requestId)
        .order('created_at', ascending: false);

    return (response as List)
        .map((json) => OfferModel.fromJson(_convertFromSupabase(json)))
        .toList();
  }

  Future<OfferModel> withdrawOffer({
    required String offerId,
    required String professionalId,
  }) async {
    final response = await _supabase.rpc(
      'withdraw_offer',
      params: {'_offer': offerId, '_pro': professionalId},
    );

    return OfferModel.fromJson(_convertFromSupabase(response));
  }

  Future<OfferModel> acceptOffer(String offerId) async {
    final response = await _supabase
        .from('offers')
        .update({'status': 'accepted'})
        .eq('id', offerId)
        .select()
        .maybeSingle();

    if (response == null) {
      throw Exception('Offer not found with id: $offerId');
    }

    return OfferModel.fromJson(_convertFromSupabase(response));
  }

  Future<OfferModel> declineOffer(String offerId) async {
    final userId = _supabase.auth.currentUser?.id;
    if (userId == null) {
      throw Exception('User not authenticated');
    }

    final response = await _supabase.rpc(
      'decline_offer',
      params: {'_offer': offerId, '_client': userId},
    );

    final offer = OfferModel.fromJson(_convertFromSupabase(response));

    try {
      final offerData = await _supabase
          .from('offers')
          .select('professional_id')
          .eq('id', offerId)
          .single();

      final professionalId = offerData['professional_id'] as String;

      final clientData = await _supabase
          .from('profiles')
          .select('full_name')
          .eq('id', userId)
          .maybeSingle();

      final clientName = clientData?['full_name'] as String? ?? 'عميل';

      await _notificationService.sendOfferDeclinedNotification(
        userId: professionalId,
        offerId: offerId,
        professionalName: clientName,
      );
    } catch (e) {
      final _ = e;
    }

    return offer;
  }

  Future<OfferModel> counterOffer({
    required String offerId,
    required double newAmount,
    String? note,
  }) async {
    final userId = _supabase.auth.currentUser?.id;
    if (userId == null) {
      throw Exception('User not authenticated');
    }

    final response = await _supabase.rpc(
      'counter_offer',
      params: {
        '_offer': offerId,
        '_client': userId,
        '_new_amount': newAmount,
        '_note': note,
      },
    );

    final offer = OfferModel.fromJson(_convertFromSupabase(response));
    try {
      final offerData = await _supabase
          .from('offers')
          .select('professional_id')
          .eq('id', offerId)
          .single();

      final professionalId = offerData['professional_id'] as String;
      final clientData = await _supabase
          .from('profiles')
          .select('full_name')
          .eq('id', userId)
          .maybeSingle();

      final clientName = clientData?['full_name'] as String? ?? 'عميل';
      await _notificationService.sendCounterOfferNotification(
        userId: professionalId,
        offerId: offerId,
        professionalName: clientName,
        counterAmount: newAmount,
      );
    } catch (e) {
      final _ = e;
    }

    return offer;
  }

  Future<List<OfferModel>> getOffersByProfessionalId(
    String professionalId,
  ) async {
    final response = await _supabase
        .from('offers')
        .select()
        .eq('professional_id', professionalId)
        .neq('status', 'accepted')
        .neq('status', 'withdrawn')
        .order('created_at', ascending: false);

    return (response as List)
        .map((json) => OfferModel.fromJson(_convertFromSupabase(json)))
        .toList();
  }

  Future<OfferModel> acceptCounterOffer({
    required String offerId,
    required String professionalId,
  }) async {
    final response = await _supabase.rpc(
      'accept_counter_offer',
      params: {'_offer': offerId, '_pro': professionalId},
    );

    final offer = OfferModel.fromJson(_convertFromSupabase(response));

    try {
      final offerData = await _supabase
          .from('offers')
          .select('request_id')
          .eq('id', offerId)
          .single();

      final requestId = offerData['request_id'] as String;

      final requestData = await _supabase
          .from('requests')
          .select('user_id')
          .eq('id', requestId)
          .single();

      final clientId = requestData['user_id'] as String;

      final professionalData = await _supabase
          .from('profiles')
          .select('full_name')
          .eq('id', professionalId)
          .maybeSingle();

      final professionalName =
          professionalData?['full_name'] as String? ?? 'صنايعي';

      await _notificationService.sendCounterAcceptedNotification(
        userId: clientId,
        offerId: offerId,
        clientName: professionalName,
      );
    } catch (e) {
      final _ = e;
    }

    return offer;
  }
}
