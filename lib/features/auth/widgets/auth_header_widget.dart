import 'package:flutter/material.dart';
import '../../../config/colors.dart';

/// Header widget untuk authentication pages
class AuthHeaderWidget extends StatelessWidget {
  final String title;
  final String? subtitle;

  const AuthHeaderWidget({Key? key, required this.title, this.subtitle})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Logo / Icon
        Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            color: AppColors.primary,
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Text(
              'P',
              style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                color: AppColors.background,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        const SizedBox(height: 24),

        // Title
        Text(
          title,
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
            color: AppColors.primary,
            fontWeight: FontWeight.bold,
          ),
        ),

        // Subtitle
        if (subtitle != null) ...[
          const SizedBox(height: 8),
          Text(
            subtitle!,
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(color: AppColors.inactive),
            textAlign: TextAlign.center,
          ),
        ],
      ],
    );
  }
}
