import 'package:injectable/injectable.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/hiring_post_model.dart';


@injectable
class HiringPostsSupabaseDataSource {
  final SupabaseClient _supabase;

  HiringPostsSupabaseDataSource(this._supabase);

  
  Future<HiringPostModel> create(HiringPostModel post) async {
    final Map<String, dynamic> data = {
      'professional_id': post.professionalId,
      'title': post.title,
      'description': post.description,
      'job_type': post.jobType.name,
      'duration_text': post.durationText,
      'salary_amount': post.salaryAmount,
      'status': post.status.name,
      'created_at': post.createdAt.toIso8601String(),
      'category': post.category?.toJson(),
      'governorate': post.governorate,
      'locality': post.locality,
      'address': post.address,
      'pay_type': post.payType?.name,
      'fixed_amount': post.fixedAmount,
      'range_min': post.rangeMin,
      'range_max': post.rangeMax,
    };

    if (post.location != null) {
      data['location_latitude'] = post.location!['latitude'];
      data['location_longitude'] = post.location!['longitude'];
    }

    final response = await _supabase
        .from('hiring_posts')
        .insert(data)
        .select()
        .single();

    return _modelFromJson(response);
  }

  
  Future<void> close(String postId) async {
    await _supabase
        .from('hiring_posts')
        .update({'status': 'closed'})
        .eq('id', postId);
  }

  
  Future<void> reopen(String postId) async {
    await _supabase
        .from('hiring_posts')
        .update({'status': 'open'})
        .eq('id', postId);
  }

  
  Future<void> delete(String postId) async {
    await _supabase.from('hiring_posts').delete().eq('id', postId);
  }

  
  Future<List<HiringPostModel>> listMyPosts(String professionalId) async {
    final response = await _supabase
        .from('hiring_posts')
        .select()
        .eq('professional_id', professionalId)
        .order('created_at', ascending: false);

    return (response as List).map((json) => _modelFromJson(json)).toList();
  }

  
  Future<List<HiringPostModel>> listOpenPosts() async {
    final response = await _supabase
        .from('hiring_posts')
        .select()
        .eq('status', 'open')
        .order('created_at', ascending: false);

    return (response as List).map((json) => _modelFromJson(json)).toList();
  }

  
  Future<HiringPostModel> getById(String postId) async {
    final response = await _supabase
        .from('hiring_posts')
        .select()
        .eq('id', postId)
        .single();

    return _modelFromJson(response);
  }

  
  
  HiringPostModel _modelFromJson(Map<String, dynamic> json) {
    Map<String, double>? location;
    if (json['location_latitude'] != null &&
        json['location_longitude'] != null) {
      location = {
        'latitude': (json['location_latitude'] as num).toDouble(),
        'longitude': (json['location_longitude'] as num).toDouble(),
      };
    }

    return HiringPostModel.fromJson({
      'id': json['id'],
      'professionalId': json['professional_id'],
      'title': json['title'],
      'description': json['description'],
      'jobType': json['job_type'],
      'durationText': json['duration_text'],
      'salaryAmount': json['salary_amount'],
      'location': location,
      'status': json['status'],
      'createdAt': json['created_at'],
      'category': json['category'],
      'governorate': json['governorate'],
      'locality': json['locality'],
      'address': json['address'],
      'payType': json['pay_type'],
      'fixedAmount': json['fixed_amount'],
      'rangeMin': json['range_min'],
      'rangeMax': json['range_max'],
    });
  }
}
