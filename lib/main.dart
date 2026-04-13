import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'dart:io';
import 'config/themes.dart';
import 'config/constants.dart';
import 'core/preferences/app_preferences.dart';
import 'features/splash/pages/splash_page.dart';
import 'features/onboarding/pages/onboarding_page.dart';
import 'features/auth/pages/login_page.dart';
import 'features/auth/pages/register_page.dart';
import 'features/auth/pages/debug_page.dart';
import 'features/owner/pages/owner_dashboard_page.dart';
import 'features/admin/pages/admin_dashboard_page.dart';
import 'features/petugas/pages/petugas_dashboard_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize sqflite_common_ffi for desktop/web platforms
  sqfliteFfiInit();

  // Set the databaseFactory for desktop platforms BEFORE using global openDatabase
  if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
    databaseFactory = databaseFactoryFfi;
    print(
      'DEBUG MAIN: Set databaseFactory to databaseFactoryFfi for desktop platform',
    );
  }

  await AppPreferences.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: AppConstants.appName,
      theme: AppTheme.lightTheme,
      home: const SplashPage(),
      routes: {
        '/splash': (context) => const SplashPage(),
        '/onboarding': (context) => const OnboardingPage(),
        '/login': (context) => const LoginPage(),
        '/register': (context) => const RegisterPage(),
        '/debug': (context) => const DebugPage(),
        '/owner_dashboard': (context) => const OwnerDashboardPage(),
        '/admin_dashboard': (context) => const AdminDashboardPage(),
        '/petugas_dashboard': (context) => const PetugasDashboardPage(),
      },
      debugShowCheckedModeBanner: false,
    );
  }
}
