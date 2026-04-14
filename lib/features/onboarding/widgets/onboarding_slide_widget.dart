import 'package:flutter/material.dart';
import '../../../config/colors.dart';

/// Widget untuk setiap slide di onboarding
class OnboardingSlideWidget extends StatelessWidget {
  final String title;
  final String description;
  final Widget? image;
  final IconData? icon;
  final Color iconColor;

  const OnboardingSlideWidget({
    Key? key,
    required this.title,
    required this.description,
    this.image,
    this.icon,
    this.iconColor = AppColors.primary,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Illustration / Icon
          Container(
            width: 280,
            height: 280,
            decoration: BoxDecoration(
              color: AppColors.secondary,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: image ?? Icon(icon, size: 120, color: iconColor),
            ),
          ),
          const SizedBox(height: 48),

          // Title
          Text(
            title,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              color: AppColors.primary,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),

          // Description
          Text(
            description,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: AppColors.inactive,
              height: 1.5,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
