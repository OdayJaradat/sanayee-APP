import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../features/profile/domain/repositories/session_repository.dart';
import 'app.dart';
import 'injection.dart';

// initializes app dependencies and runs the app
Future<void> bootstrap() async {
  await Hive.initFlutter();
  configureDependencies(); // sets up dependency injection
  await sl<SessionRepository>().initialize();
  runApp(const SanayeeApp());
}
