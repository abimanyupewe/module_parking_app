import 'package:flutter/material.dart';
import '../controllers/splash_controller.dart';
import '../../../config/colors.dart';
import '../../../services/database_manager.dart';
import '../../../core/preferences/app_preferences.dart';

/// Splash Screen Page
class SplashPage extends StatefulWidget {
  const SplashPage({Key? key}) : super(key: key);

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  late SplashController _controller;

  @override
  void initState() {
    super.initState();
    _controller = SplashController(context);
    _initializeApp();
  }

  /// Initialize application (preferences + database)
  Future<void> _initializeApp() async {
    try {
      // 1. Initialize SharedPreferences
      await AppPreferences.init();

      // 2. Initialize Database (akan auto-create dengan default data jika first run)
      // DatabaseManager akan menggunakan SQLite untuk desktop/mobile
      // dan SharedPreferences untuk web
      final dbManager = DatabaseManager();
      await dbManager.initialize();
      await dbManager.getDatabasePath();

      // 3. Verify default data
      await dbManager.getAllUsers();

      // 4. Continue with splash flow
      if (mounted) {
        _controller.handleSplashFlow();
      }
    } catch (e) {
      // Fallback: continue anyway
      if (mounted) {
        _controller.handleSplashFlow();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            const Spacer(),
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Logo / App Name
                  Container(
                    width: 70,
                    height: 70,
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Text(
                        'P',
                        style: Theme.of(context).textTheme.displayLarge
                            ?.copyWith(
                              color: AppColors.background,
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 40),
                  // App Name
                  Text(
                    'Manajemen Parkir',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      color: AppColors.primary,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            const Spacer(),
            Padding(
              padding: const EdgeInsets.only(bottom: 24),
              child: Text(
                'v1.0.0',
                style: Theme.of(
                  context,
                ).textTheme.bodySmall?.copyWith(color: AppColors.inactive),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
