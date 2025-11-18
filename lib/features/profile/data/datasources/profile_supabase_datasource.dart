import 'package:injectable/injectable.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/profile_model.dart';

@lazySingleton
class ProfileSupabaseDataSource {
  final SupabaseClient _supabase;

  ProfileSupabaseDataSource(this._supabase);

  Future<ProfileModel> getMyProfile() async {
    final userId = _supabase.auth.currentUser?.id;
    if (userId == null) {
      throw Exception('لم يتم تسجيل الدخول');
    }

    final response = await _supabase
        .from('profiles')
        .select()
        .eq('id', userId)
        .single();

    return ProfileModel.fromJson(response);
  }

  Future<ProfileModel> getProfileById(String userId) async {
    final response = await _supabase
        .from('profiles')
        .select()
        .eq('id', userId)
        .single();

    return ProfileModel.fromJson(response);
  }

  Future<ProfileModel> upsertProfile(ProfileModel profile) async {
    final data = profile.toJson();

    data.removeWhere((key, value) => value == null);
    data.remove('created_at');

    final response = await _supabase
        .from('profiles')
        .upsert(data)
        .select()
        .single();

    return ProfileModel.fromJson(response);
  }

  Future<ProfileModel> updateProfile(Map<String, dynamic> updates) async {
    final userId = _supabase.auth.currentUser?.id;
    if (userId == null) {
      throw Exception('لم يتم تسجيل الدخول');
    }

    updates.removeWhere((key, value) => value == null);

    final response = await _supabase
        .from('profiles')
        .update(updates)
        .eq('id', userId)
        .select()
        .single();

    return ProfileModel.fromJson(response);
  }

  Future<bool> profileExists(String userId) async {
    final response = await _supabase
        .from('profiles')
        .select('id')
        .eq('id', userId)
        .maybeSingle();

    return response != null;
  }
}
