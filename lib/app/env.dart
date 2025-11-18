import '../features/profile/domain/entities/user_role.dart';

class Env {
  static String _apiBaseUrl = '';
  static String _apiKey = '';
  static String _supabaseUrl = '';
  static String _supabaseAnonKey = '';
  static bool _useAuth = false;
  static UserRole _defaultRole = UserRole.client;

  static String get apiBaseUrl => _apiBaseUrl;
  static String get apiKey => _apiKey;
  static String get supabaseUrl => _supabaseUrl;
  static String get supabaseAnonKey => _supabaseAnonKey;

  static bool get useAuth => _useAuth;
  static UserRole get defaultRole => _defaultRole;

  static Future<void> load() async {
    _apiBaseUrl = const String.fromEnvironment(
      'API_BASE_URL',
      defaultValue: 'https://api.sanayee.ps/v1',
    );
    _apiKey = const String.fromEnvironment('API_KEY', defaultValue: 'dev-key');

    _supabaseUrl = const String.fromEnvironment(
      'SUPABASE_URL',
      defaultValue: '',
    );
    _supabaseAnonKey = const String.fromEnvironment(
      'SUPABASE_ANON_KEY',
      defaultValue: '',
    );

    _useAuth = const bool.fromEnvironment('USE_AUTH', defaultValue: false);

    const defaultRoleStr = String.fromEnvironment(
      'DEFAULT_ROLE',
      defaultValue: 'client',
    );
    _defaultRole = UserRole.fromString(defaultRoleStr);
  }
}
