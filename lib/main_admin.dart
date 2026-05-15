import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'app/admin_bootstrap.dart';
import 'app/env.dart';

/// Admin Panel entrypoint - Web only
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Admin panel is web-only
  if (!kIsWeb) {
    runApp(const _AdminNotSupportedApp());
    return;
  }

  await Env.load();

  await Supabase.initialize(
    url: Env.supabaseUrl,
    anonKey: Env.supabaseAnonKey,
  );

  await bootstrapAdmin();
}

/// Fallback app shown when trying to run admin on non-web platforms
class _AdminNotSupportedApp extends StatelessWidget {
  const _AdminNotSupportedApp();

  @override
  Widget build(BuildContext context) {
    return const Directionality(
      textDirection: TextDirection.rtl,
      child: Center(
        child: Text(
          'Admin panel is available on Web only.',
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}
