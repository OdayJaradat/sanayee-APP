import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'admin_app.dart';
import 'injection.dart';

/// Initializes admin app dependencies and runs the admin app
Future<void> bootstrapAdmin() async {
  await Hive.initFlutter();
  configureDependencies();
  runApp(const AdminApp());
}
