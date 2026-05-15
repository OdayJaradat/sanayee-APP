import 'package:injectable/injectable.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../profile/domain/entities/user_role.dart';
import '../models/user_model.dart';

const String kDefaultAvatarUrl =
    'hENTER YOUR SUPABASE URL HERE/storage/v1/object/public/media/person_icon.png';

/// Exception thrown when a blocked user tries to access the app
class BlockedUserException implements Exception {
  final String message;
  BlockedUserException([this.message = 'حسابك محظور. يرجى التواصل مع الدعم.']);

  @override
  String toString() => message;
}

@lazySingleton
class SupabaseAuthDataSource {
  final SupabaseClient _supabase;

  SupabaseAuthDataSource(this._supabase);

  Future<UserModel> signUpWithEmailAndPassword({
    required String email,
    required String password,
    required UserRole role,
    String? name,
    String? fullName,
    String? phone,
    String? city,
    String? governorate,
    String? locality,
    DateTime? dateOfBirth,
    String? bio,
    String? avatarUrl,
    int yearsExperience = 0,
    List<String> certifications = const [],
    String? specialization,
  }) async {
    String userId;

    try {
      final authResponse = await _supabase.auth.signUp(
        email: email,
        password: password,
        data: {
          'role': role.value,
          'full_name': fullName ?? name ?? email.split('@')[0],
        },
      );

      if (authResponse.user == null) {
        throw Exception('فشل إنشاء المستخدم');
      }

      userId = authResponse.user!.id;
    } on AuthException catch (e) {
      if (e.statusCode == '500') {
        await Future.delayed(const Duration(milliseconds: 1000));

        try {
          final signInResponse = await _supabase.auth.signInWithPassword(
            email: email,
            password: password,
          );

          if (signInResponse.user != null) {
            userId = signInResponse.user!.id;
          } else {
            throw Exception('فشل في إنشاء الحساب بسبب خطأ في قاعدة البيانات');
          }
        } catch (signInError) {
          throw Exception('فشل في إنشاء الحساب: ${e.message}');
        }
      } else if (e.message.contains('already registered')) {
        throw Exception('هذا البريد الإلكتروني مسجل بالفعل');
      } else {
        throw Exception('فشل في إنشاء الحساب: ${e.message}');
      }
    }

    try {
      await Future.delayed(const Duration(milliseconds: 500));

      final profileJson = <String, dynamic>{
        'id': userId,
        'email': email,
        'role': role.value,
        'full_name': fullName ?? name ?? email.split('@')[0],
        'avatar_url': avatarUrl ?? kDefaultAvatarUrl,
        'updated_at': DateTime.now().toIso8601String(),
      };

      if (phone != null && phone.isNotEmpty) profileJson['phone'] = phone;
      if (city != null && city.isNotEmpty) profileJson['city'] = city;
      if (governorate != null && governorate.isNotEmpty) {
        profileJson['governorate'] = governorate;
      }
      if (locality != null && locality.isNotEmpty) {
        profileJson['locality'] = locality;
      }
      if (dateOfBirth != null) {
        profileJson['date_of_birth'] = dateOfBirth.toIso8601String().split(
          'T',
        )[0];
      }
      if (bio != null && bio.isNotEmpty) profileJson['bio'] = bio;

      if (role == UserRole.professional) {
        profileJson['years_experience'] = yearsExperience;
        profileJson['certifications'] = certifications;
        if (specialization != null && specialization.isNotEmpty) {
          profileJson['specialization'] = specialization;
        }
      }

      await _supabase.from('profiles').upsert(profileJson);

      final profile = await _supabase
          .from('profiles')
          .select()
          .eq('id', userId)
          .single();
      return UserModel(
        id: userId,
        email: email,
        role: profile['role'] as String,
      );
    } on PostgrestException catch (e) {
      if (e.message.contains('duplicate') || e.code == '23505') {
        if (e.message.contains('phone')) {
          throw Exception('رقم الهاتف مستخدم بالفعل');
        }
        throw Exception('البيانات مكررة، الرجاء استخدام بيانات مختلفة');
      }
      throw Exception('خطأ في قاعدة البيانات: ${e.message}');
    } catch (e) {
      throw Exception('فشل في إنشاء الملف الشخصي: ${e.toString()}');
    }
  }

  Future<UserModel> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      final authResponse = await _supabase.auth.signInWithPassword(
        email: email,
        password: password,
      );

      if (authResponse.user == null) {
        throw Exception('بيانات تسجيل الدخول غير صحيحة');
      }

      final userId = authResponse.user!.id;

      final profile = await _getOrCreateProfile(
        userId: userId,
        email: email,
        metadata: authResponse.user!.userMetadata,
      );

      // Check if user is blocked
      final isBlocked = profile['is_blocked'] as bool? ?? false;
      if (isBlocked) {
        // Sign out immediately if blocked
        await _supabase.auth.signOut();
        throw BlockedUserException();
      }

      return UserModel(
        id: userId,
        email: authResponse.user!.email ?? email,
        role: profile['role'] as String,
      );
    } on BlockedUserException {
      rethrow;
    } catch (e) {
      if (e.toString().contains('Invalid login credentials')) {
        throw Exception('البريد الإلكتروني أو كلمة المرور غير صحيحة');
      }
      throw Exception('فشل تسجيل الدخول: ${e.toString()}');
    }
  }

  Future<Map<String, dynamic>> _getOrCreateProfile({
    required String userId,
    required String email,
    Map<String, dynamic>? metadata,
  }) async {
    var profile = await _supabase
        .from('profiles')
        .select()
        .eq('id', userId)
        .maybeSingle();

    if (profile != null) {
      return profile;
    }

    final role = metadata?['role'] as String? ?? 'client';
    final name = metadata?['name'] as String? ?? email.split('@')[0];

    await _supabase.from('profiles').insert({
      'id': userId,
      'email': email,
      'role': role,
      'name': name,
      'avatar_url': kDefaultAvatarUrl,
    });

    profile = await _supabase
        .from('profiles')
        .select()
        .eq('id', userId)
        .single();

    return profile;
  }

  Future<void> signOut() async {
    await _supabase.auth.signOut();
  }

  String getCurrentUserEmail() {
    return _supabase.auth.currentUser?.email ?? '';
  }

  Future<UserModel?> getCurrentUser() async {
    final user = _supabase.auth.currentUser;
    if (user == null) return null;

    try {
      final profile = await _getProfile(user.id);

      // Check if user is blocked
      final isBlocked = profile['is_blocked'] as bool? ?? false;
      if (isBlocked) {
        // Sign out immediately if blocked
        await _supabase.auth.signOut();
        throw BlockedUserException();
      }

      return UserModel(
        id: user.id,
        email: user.email,
        phoneNumber: user.phone,
        role: profile['role'] as String,
      );
    } on BlockedUserException {
      rethrow;
    } catch (e) {
      return null;
    }
  }

  Future<Map<String, dynamic>> _getProfile(String userId) async {
    final response = await _supabase
        .from('profiles')
        .select()
        .eq('id', userId)
        .single();

    return response;
  }

  Stream<UserModel?> get authStateChanges {
    return _supabase.auth.onAuthStateChange.asyncMap((data) async {
      final user = data.session?.user;
      if (user == null) return null;

      try {
        final profile = await _getProfile(user.id);
        return UserModel(
          id: user.id,
          email: user.email,
          phoneNumber: user.phone,
          role: profile['role'] as String,
        );
      } catch (e) {
        return null;
      }
    });
  }

  Future<void> updateFcmToken(String token) async {
    final user = _supabase.auth.currentUser;
    if (user == null) return;

    final profile = await _getProfile(user.id);
    final tokens = List<String>.from(profile['fcm_tokens'] ?? []);

    if (!tokens.contains(token)) {
      tokens.add(token);
      await _supabase
          .from('profiles')
          .update({'fcm_tokens': tokens})
          .eq('id', user.id);
    }
  }

  Future<void> removeFcmToken(String token) async {
    final user = _supabase.auth.currentUser;
    if (user == null) return;

    final profile = await _getProfile(user.id);
    final tokens = List<String>.from(profile['fcm_tokens'] ?? []);

    tokens.remove(token);
    await _supabase
        .from('profiles')
        .update({'fcm_tokens': tokens})
        .eq('id', user.id);
  }

  Future<void> changePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    final user = _supabase.auth.currentUser;
    if (user == null || user.email == null) {
      throw Exception('لم يتم تسجيل الدخول');
    }

    try {
      await _supabase.auth.signInWithPassword(
        email: user.email!,
        password: currentPassword,
      );
    } on AuthException catch (e) {
      if (e.message.contains('Invalid') || e.message.contains('password')) {
        throw Exception('كلمة السر الحالية غير صحيحة');
      }
      throw Exception('فشل التحقق من كلمة السر: ${e.message}');
    }

    try {
      await _supabase.auth.updateUser(UserAttributes(password: newPassword));
    } on AuthException catch (e) {
      throw Exception('فشل تغيير كلمة السر: ${e.message}');
    }
  }
}
