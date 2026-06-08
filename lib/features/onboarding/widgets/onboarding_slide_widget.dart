import 'package:flutter/material.dart';
import '../../../config/colors.dart';

/// Widget untuk setiap slide di onboarding
/// Slide pertama menampilkan ilustrasi besar + description
/// Slide 2 & 3 menampilkan description saja tanpa container
class OnboardingSlideWidget extends StatelessWidget {
  final String title;
  final String description;
  final Widget? image;
  final IconData? icon;
  final Color iconColor;
  final bool showLargeIllustration;

  const OnboardingSlideWidget({
    Key? key,
    required this.title,
    required this.description,
    this.image,
    this.icon,
    this.iconColor = AppColors.primary,
    this.showLargeIllustration = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Slide dengan ilustrasi besar (Slide 1)
    if (showLargeIllustration) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Large Illustration
            if (image != null)
              SizedBox(width: double.infinity, height: 500, child: image)
            else
              Container(
                width: 280,
                height: 280,
                decoration: BoxDecoration(
                  color: AppColors.secondary,
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Icon(icon ?? Icons.image, size: 120, color: iconColor),
                ),
              ),
            const SizedBox(height: 48),

            // Title dan Description tanpa container (hanya text)
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title
                Text(
                  title,
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    color: AppColors.primary,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.left,
                ),
                const SizedBox(height: 12),

                // Description
                Text(
                  description,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppColors.textSecondary,
                    height: 1.5,
                  ),
                  textAlign: TextAlign.left,
                ),
              ],
            ),
          ],
        ),
      );
    }

    // Slide minimal (Slide 2 & 3) - hanya description text centered
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Title
          Text(
            title,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              color: AppColors.primary,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),

          // Description
          Text(
            description,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: AppColors.textSecondary,
              height: 1.6,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
