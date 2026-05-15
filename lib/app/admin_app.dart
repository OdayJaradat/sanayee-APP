import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import '../core/config/app_theme.dart';
import '../features/admin/presentation/pages/admin_desktop_only_page.dart';
import 'admin_router.dart';

/// Admin Panel App - Web & Desktop only
class AdminApp extends StatelessWidget {
  const AdminApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Sanayee Admin',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      routerConfig: adminRouter,
      locale: const Locale('ar'),
      supportedLocales: const [Locale('ar'), Locale('en')],
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      builder: (context, child) {
        // Enforce desktop-only (min width 900px)
        return LayoutBuilder(
          builder: (context, constraints) {
            if (constraints.maxWidth < 900) {
              return const AdminDesktopOnlyPage(
                message: 'لوحة الإدارة تتطلب شاشة سطح المكتب.\n'
                    'يرجى استخدام متصفح على جهاز كمبيوتر بعرض شاشة 900 بكسل على الأقل.',
              );
            }
            return child ?? const SizedBox.shrink();
          },
        );
      },
    );
  }
}
