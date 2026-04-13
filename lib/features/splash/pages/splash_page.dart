import 'package:flutter/material.dart';
import '../controllers/splash_controller.dart';
import '../../../config/colors.dart';

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
    _initSplash();
  }

  void _initSplash() {
    _controller.handleSplashFlow();
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
