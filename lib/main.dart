import 'package:flutter/material.dart';
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
