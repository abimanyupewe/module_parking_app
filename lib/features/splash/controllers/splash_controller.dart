import 'package:flutter/material.dart';
import '../../../core/preferences/app_preferences.dart';

/// Controller untuk Splash Screen
class SplashController {
  final BuildContext context;

  SplashController(this.context);

  /// Handle splash screen logic
  Future<void> handleSplashFlow() async {
    // Delay untuk splash screen effect
    await Future.delayed(const Duration(seconds: 2));

    // Check is_first_run flag
    bool isFirstRun = await AppPreferences.isFirstRun();

    if (isFirstRun) {
      // Navigasi ke Onboarding
      if (context.mounted) {
        Navigator.of(context).pushReplacementNamed('/onboarding');
      }
    } else {
      // Check is_logged_in
      bool isLoggedIn = AppPreferences.isLoggedIn();

      if (isLoggedIn) {
        // Get user role
        String? userRole = AppPreferences.getUserRole()?.toLowerCase();

        // Navigate ke dashboard sesuai role
        if (context.mounted) {
          switch (userRole) {
            case 'owner':
              Navigator.of(context).pushReplacementNamed('/owner_dashboard');
              break;
            case 'admin':
              Navigator.of(context).pushReplacementNamed('/admin_dashboard');
              break;
            case 'petugas':
              Navigator.of(context).pushReplacementNamed('/petugas_dashboard');
              break;
            default:
              Navigator.of(context).pushReplacementNamed('/login');
          }
        }
      } else {
        // Navigate ke Login
        if (context.mounted) {
          Navigator.of(context).pushReplacementNamed('/login');
        }
      }
    }
  }
}
