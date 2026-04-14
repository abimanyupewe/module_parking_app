import 'package:flutter/material.dart';
import '../../../config/colors.dart';

/// Button navigation untuk onboarding
class OnboardingButtonsWidget extends StatelessWidget {
  final int currentPage;
  final VoidCallback onNext;
  final VoidCallback onSkip;
  final VoidCallback onStart;

  const OnboardingButtonsWidget({
    Key? key,
    required this.currentPage,
    required this.onNext,
    required this.onSkip,
    required this.onStart,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Skip button (always visible)
          TextButton(
            onPressed: onSkip,
            child: Text(
              'Lewati',
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(color: AppColors.inactive),
            ),
          ),

          // Next or Start button
          if (currentPage < 2)
            IconButton(
              onPressed: onNext,
              icon: const Icon(Icons.arrow_forward),
              color: AppColors.primary,
              iconSize: 28,
            )
          else
            ElevatedButton(
              onPressed: onStart,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: AppColors.background,
                padding: const EdgeInsets.symmetric(
                  horizontal: 32,
                  vertical: 12,
                ),
              ),
              child: const Text('Mulai'),
            ),
        ],
      ),
    );
  }
}
