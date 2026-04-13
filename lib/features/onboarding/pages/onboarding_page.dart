import 'package:flutter/material.dart';
import '../../../config/colors.dart';
import '../controllers/onboarding_controller.dart';
import '../widgets/onboarding_buttons.dart';
import '../widgets/onboarding_dots_indicator.dart';
import '../widgets/onboarding_slide_widget.dart';

/// Onboarding Page dengan 3 slides
class OnboardingPage extends StatefulWidget {
  const OnboardingPage({Key? key}) : super(key: key);

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  late PageController _pageController;
  late OnboardingController _controller;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _controller = OnboardingController(
      pageController: _pageController,
      onStateChange: () => setState(() {}),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            // PageView dengan 3 slides
            Expanded(
              child: PageView(
                controller: _pageController,
                onPageChanged: (page) {
                  _controller.setCurrentPage(page);
                },
                children: [
                  // Slide 1: Welcome
                  OnboardingSlideWidget(
                    title: 'Selamat Datang',
                    description:
                        'Sistem manajemen parkir modern yang mudah digunakan untuk semua jenis kendaraan.',
                    icon: Icons.local_parking,
                    iconColor: AppColors.primary,
                  ),

                  // Slide 2: Parking Management
                  OnboardingSlideWidget(
                    title: 'Kelola Parkir',
                    description:
                        'Check-in dan check-out kendaraan dengan cepat. Monitor kapasitas parkir real-time.',
                    icon: Icons.directions_car,
                    iconColor: AppColors.primary,
                  ),

                  // Slide 3: Reports
                  OnboardingSlideWidget(
                    title: 'Laporan Terpadu',
                    description:
                        'Lihat analitik pendapatan, riwayat transaksi, dan audit trail dalam satu dashboard.',
                    icon: Icons.assessment,
                    iconColor: AppColors.primary,
                  ),
                ],
              ),
            ),

            // Dots Indicator
            Padding(
              padding: const EdgeInsets.only(bottom: 24),
              child: OnboardingDotsIndicator(
                currentPage: _controller.currentPage,
                totalPages: 3,
              ),
            ),

            // Navigation Buttons
            OnboardingButtonsWidget(
              currentPage: _controller.currentPage,
              onNext: () => _controller.onNext(),
              onSkip: () => _handleSkip(),
              onStart: () => _handleStart(),
            ),
          ],
        ),
      ),
    );
  }

  /// Handle skip button - langsung ke login
  Future<void> _handleSkip() async {
    await _controller.completeOnboarding();
    if (mounted) {
      Navigator.of(context).pushReplacementNamed('/login');
    }
  }

  /// Handle start button - ke login
  Future<void> _handleStart() async {
    await _controller.completeOnboarding();
    if (mounted) {
      Navigator.of(context).pushReplacementNamed('/login');
    }
  }
}
