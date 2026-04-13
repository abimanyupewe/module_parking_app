import 'package:flutter/material.dart';
import '../controllers/splash_controller.dart';
import '../../../config/colors.dart';
import '../../../services/database_helper.dart';
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
      print('DEBUG SPLASH: Starting app initialization...');

      // 1. Initialize SharedPreferences
      print('DEBUG SPLASH: Initializing SharedPreferences...');
      await AppPreferences.init();
      print('DEBUG SPLASH: SharedPreferences initialized');

      // 2. Initialize Database (akan auto-create dengan default data jika first run)
      print('DEBUG SPLASH: Initializing Database...');
      final dbHelper = DatabaseHelper();
      final database = await dbHelper.database;
      print('DEBUG SPLASH: Database initialized');
      print('DEBUG SPLASH: Database path: ${database.path}');

      // 3. Print database location untuk user dapat menemukan file
      dbHelper.printDatabaseLocation();

      // 4. Try create symlink/shortcut ke database (optional, best effort)
      final shortcutCreated = await dbHelper.createDatabaseShortcut();
      if (shortcutCreated) {
        print('DEBUG SPLASH: Database shortcut berhasil dibuat');
      }

      // 5. Verify default data was inserted
      print('DEBUG SPLASH: Verifying default users...');
      final users = await dbHelper.getAllUsers();
      print('DEBUG SPLASH: Found ${users.length} users in database');
      for (var user in users) {
        print('  - ${user.username} (${user.role})');
      }

      // 6. Continue with splash flow
      if (mounted) {
        print('DEBUG SPLASH: Proceeding with splash flow...');
        _controller.handleSplashFlow();
      }
    } catch (e) {
      print('ERROR SPLASH: Failed to initialize app: ${e.toString()}');
      print('ERROR SPLASH: Stack trace: $e');

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
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Logo / App Name
            Container(
              width: 250,
              height: 250,
              decoration: BoxDecoration(
                color: AppColors.primary,
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Text(
                  'P',
                  style: Theme.of(context).textTheme.displayLarge?.copyWith(
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
            const SizedBox(height: 20),
            // Version
            Text(
              'v1.0.0',
              style: Theme.of(
                context,
              ).textTheme.bodySmall?.copyWith(color: AppColors.inactive),
            ),
            const SizedBox(height: 40),
            // Loading Indicator
            const CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation(AppColors.primary),
            ),
          ],
        ),
      ),
    );
  }
}
