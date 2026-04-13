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

  // Inisialisasi sqflite_common_ffi untuk platform desktop/web
  try {
    sqfliteFfiInit();
    print('DEBUG MAIN: sqfliteFfiInit() berhasil dipanggil');
  } catch (e) {
    print('DEBUG MAIN: sqfliteFfiInit() error: $e');
  }

  // Set databaseFactory untuk platform desktop/web SEBELUM menggunakan global openDatabase
  if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
    try {
      databaseFactory = databaseFactoryFfi;
      print(
        'DEBUG MAIN: databaseFactory set ke databaseFactoryFfi untuk platform desktop',
      );
    } catch (e) {
      print('DEBUG MAIN: Error set databaseFactory: $e');
    }
  } else if (Platform.isAndroid || Platform.isIOS) {
    print(
      'DEBUG MAIN: Platform mobile (Android/iOS) - gunakan sqflite default',
    );
  } else {
    print('DEBUG MAIN: Platform lainnya (web/unknown)');
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
