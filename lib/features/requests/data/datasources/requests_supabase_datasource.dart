import 'package:injectable/injectable.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../notifications/domain/services/notification_service.dart';
import '../models/service_request_model.dart';

@LazySingleton(env: [Environment.prod])
class RequestsSupabaseDataSource {
  final SupabaseClient _supabase;
  final NotificationService _notificationService;

  RequestsSupabaseDataSource(this._supabase, this._notificationService);

  Future<List<ServiceRequestModel>> fetchRequests(String clientId) async {
    final response = await _supabase
        .from('requests')
        .select()
        .eq('client_id', clientId)
        .order('created_at', ascending: false);

    return (response as List)
        .map((json) => ServiceRequestModel.fromJson(_convertFromSupabase(json)))
        .toList();
  }

  Future<List<ServiceRequestModel>> fetchOpenRequests() async {
    final response = await _supabase
        .from('requests')
        .select()
        .eq('status', 'open')
        .order('created_at', ascending: false);

    return (response as List)
        .map((json) => ServiceRequestModel.fromJson(_convertFromSupabase(json)))
        .toList();
  }

  Future<ServiceRequestModel?> getById(String id) async {
    final response = await _supabase
        .from('requests')
        .select()
        .eq('id', id)
        .maybeSingle();

    if (response == null) return null;

    return ServiceRequestModel.fromJson(_convertFromSupabase(response));
  }

  Future<ServiceRequestModel> create(ServiceRequestModel request) async {
    final data = {
      'title': request.title,
      'description': request.description,
      'category': request.category,
      'budget': request.budget,
      'client_id': request.clientId,
      'status': request.status,
      'professional_id': request.professionalId,
      'location': request.location,
      'photos': request.photos,
      'type': request.type.name,
      'assigned_to': request.assignedTo,
      'client_gps_location': request.clientGpsLocation,
      'created_at': DateTime.now().toIso8601String(),
      'updated_at': DateTime.now().toIso8601String(),
    };

    final response = await _supabase
        .from('requests')
        .insert(data)
        .select()
        .single();

    return ServiceRequestModel.fromJson(_convertFromSupabase(response));
  }

  Future<void> updateStatus(String requestId, String status) async {
    await _supabase
        .from('requests')
        .update({
          'status': status,
          'updated_at': DateTime.now().toIso8601String(),
        })
        .eq('id', requestId);
  }

  Future<void> updateStatusWithRejection(
    String requestId,
    String status,
    String? rejectionReason,
  ) async {
    final updateData = {
      'status': status,
      'updated_at': DateTime.now().toIso8601String(),
    };

    if (rejectionReason != null && rejectionReason.isNotEmpty) {
      updateData['rejection_reason'] = rejectionReason;
    }

    await _supabase.from('requests').update(updateData).eq('id', requestId);
  }

  Future<void> setAssigned(String requestId, String professionalId) async {
    await _supabase
        .from('requests')
        .update({
          'status': 'assigned',
          'assigned_to': professionalId,
          'professional_id': professionalId,
          'updated_at': DateTime.now().toIso8601String(),
        })
        .eq('id', requestId);
  }

  Future<void> deleteById(String id) async {
    await _supabase.from('requests').delete().eq('id', id);
  }

  Map<String, dynamic> _convertFromSupabase(Map<String, dynamic> json) {
    return {
      'id': json['id'],
      'title': json['title'],
      'description': json['description'],
      'category': json['category'],
      'budget': json['budget'],
      'clientId': json['client_id'],
      'createdAt': json['created_at'],
      'status': json['status'] ?? 'open',
      'professionalId': json['professional_id'],
      'updatedAt': json['updated_at'],
      'location': json['location'],
      'photos': json['photos'] ?? [],
      'type': json['type'] ?? 'normal',
      'assignedTo': json['assigned_to'],
      'clientGpsLocation': json['client_gps_location'],
      'assignedProfessionalId': json['assigned_professional_id'],
      'acceptedOfferId': json['accepted_offer_id'],
      'acceptedAt': json['accepted_at'],
      'completedAt': json['completed_at'],
      'rejectionReason': json['rejection_reason'],
      'acceptedOfferAmount': json['accepted_offer_amount'],
    };
  }

  Future<ServiceRequestModel> acceptOffer({
    required String offerId,
    required String clientId,
  }) async {
    final response = await _supabase.rpc(
      'accept_offer',
      params: {'_offer': offerId, '_client': clientId},
    );

    final request = ServiceRequestModel.fromJson(
      _convertFromSupabase(response),
    );

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
          .eq('id', clientId)
          .maybeSingle();

      final clientName = clientData?['full_name'] as String? ?? 'عميل';

      await _notificationService.sendOfferAcceptedNotification(
        userId: professionalId,
        offerId: offerId,
        professionalName: clientName,
      );

      await _notificationService.sendRequestAssignedNotification(
        userId: professionalId,
        requestId: request.id,
        clientName: clientName,
        requestTitle: request.title,
      );
    } catch (e) {
      final _ = e;
    }

    return request;
  }

  Future<ServiceRequestModel> markRequestCompleted({
    required String requestId,
    required String professionalId,
  }) async {
    final response = await _supabase.rpc(
      'pro_mark_request_completed',
      params: {'_request': requestId, '_pro': professionalId},
    );

    final request = ServiceRequestModel.fromJson(
      _convertFromSupabase(response),
    );

    try {
      final professionalData = await _supabase
          .from('profiles')
          .select('full_name')
          .eq('id', professionalId)
          .maybeSingle();

      final professionalName =
          professionalData?['full_name'] as String? ?? 'صنايعي';

      await _notificationService.sendRequestCompletedNotification(
        userId: request.clientId,
        requestId: requestId,
        professionalName: professionalName,
      );
    } catch (e) {
      final _ = e;
    }

    return request;
  }

  Future<List<ServiceRequestModel>> getActiveJobsByProfessionalId(
    String professionalId,
  ) async {
    final response = await _supabase
        .from('requests')
        .select('*, accepted_offer_amount:offers!accepted_offer_id(amount)')
        .eq('assigned_professional_id', professionalId)
        .inFilter('status', ['assigned', 'pending_review', 'completed'])
        .order('created_at', ascending: false);

    return (response as List).map((json) {
      final offerData = json['accepted_offer_amount'];
      final offerAmount = offerData is Map ? offerData['amount'] : null;

      final modifiedJson = Map<String, dynamic>.from(json);
      modifiedJson['accepted_offer_amount'] = offerAmount;

      return ServiceRequestModel.fromJson(_convertFromSupabase(modifiedJson));
    }).toList();
  }

  Future<ServiceRequestModel> markJobReadyForReview({
    required String requestId,
    required String professionalId,
  }) async {
    final response = await _supabase.rpc(
      'mark_job_ready_for_review',
      params: {'_request': requestId, '_pro': professionalId},
    );

    return ServiceRequestModel.fromJson(_convertFromSupabase(response));
  }

  Future<ServiceRequestModel> confirmJobCompletion({
    required String requestId,
    required String clientId,
  }) async {
    final response = await _supabase.rpc(
      'confirm_job_completion',
      params: {'_request': requestId, '_client': clientId},
    );

    return ServiceRequestModel.fromJson(_convertFromSupabase(response));
  }
}
