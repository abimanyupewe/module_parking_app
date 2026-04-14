import 'package:flutter/material.dart';
import '../../../config/colors.dart';

/// Dots Indicator untuk Onboarding
class OnboardingDotsIndicator extends StatelessWidget {
  final int currentPage;
  final int totalPages;

  const OnboardingDotsIndicator({
    Key? key,
    required this.currentPage,
    required this.totalPages,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        totalPages,
        (index) => AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          margin: const EdgeInsets.symmetric(horizontal: 4),
          height: 8,
          width: currentPage == index ? 24 : 8,
          decoration: BoxDecoration(
            color: currentPage == index
                ? AppColors.primary
                : AppColors.secondary,
            borderRadius: BorderRadius.circular(4),
          ),
        ),
      ),
    );
  }
}
