import 'package:flutter/material.dart';
import '../../../core/preferences/app_preferences.dart';

/// Controller untuk Onboarding
class OnboardingController {
  final PageController pageController;
  final VoidCallback onStateChange;

  int currentPage = 0;

  OnboardingController({
    required this.pageController,
    required this.onStateChange,
  });

  /// Handle next button
  void onNext() {
    if (currentPage < 2) {
      pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  /// Handle skip button - go to login
  void onSkip() {
    // Navigation akan di-handle dari widget
  }

  /// Handle start button - go to login dan set is_first_run=false
  void onStart() {
    // Navigation akan di-handle dari widget
  }

  /// Set current page saat PageView berubah
  void setCurrentPage(int page) {
    currentPage = page;
    onStateChange();
  }

  /// Navigate ke login dan set is_first_run=false
  Future<void> completeOnboarding() async {
    await AppPreferences.setIsFirstRun(false);
  }

  /// Dispose page controller
  void dispose() {
    pageController.dispose();
  }
}
