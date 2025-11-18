import 'package:flutter/widgets.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'app/bootstrap.dart';
import 'app/env.dart';


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Env.load();

  await Supabase.initialize(url: Env.supabaseUrl, anonKey: Env.supabaseAnonKey);

  await bootstrap();
}
