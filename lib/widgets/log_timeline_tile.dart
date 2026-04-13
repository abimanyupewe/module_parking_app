import 'package:flutter/material.dart';
import '../config/colors.dart';

/// Timeline tile widget untuk menampilkan log aktivitas
class LogTimelineTile extends StatelessWidget {
  final String title;
  final String subtitle;
  final String timestamp;
  final String? category;
  final IconData icon;
  final Color? iconColor;
  final Color? backgroundColor;
  final bool isLast;
  final VoidCallback? onTap;
  final Widget? trailing;

  const LogTimelineTile({
    Key? key,
    required this.title,
    required this.subtitle,
    required this.timestamp,
    this.category,
    required this.icon,
    this.iconColor,
    this.backgroundColor,
    this.isLast = false,
    this.onTap,
    this.trailing,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Timeline line and dot
          Column(
            children: [
              // Dot
              Container(
                width: 12,
                height: 12,
                margin: const EdgeInsets.only(top: 4),
                decoration: BoxDecoration(
                  color: iconColor ?? AppColors.primary,
                  shape: BoxShape.circle,
                  border: Border.all(color: AppColors.white, width: 2),
                  boxShadow: [
                    BoxShadow(
                      color: (iconColor ?? AppColors.primary).withOpacity(0.3),
                      blurRadius: 4,
                    ),
                  ],
                ),
              ),
              // Vertical line
              if (!isLast)
                Container(
                  width: 2,
                  height: 80,
                  color: AppColors.tertiary,
                  margin: const EdgeInsets.only(top: 8),
                ),
            ],
          ),
          const SizedBox(width: 16),
          // Content
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: backgroundColor ?? AppColors.secondary.withOpacity(0.3),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: AppColors.tertiary, width: 1),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              title,
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: AppColors.primary,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            if (category != null) ...[
                              const SizedBox(height: 2),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 6,
                                  vertical: 2,
                                ),
                                decoration: BoxDecoration(
                                  color: (iconColor ?? AppColors.primary)
                                      .withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: Text(
                                  category!,
                                  style: TextStyle(
                                    fontSize: 10,
                                    fontWeight: FontWeight.w500,
                                    color: iconColor ?? AppColors.primary,
                                  ),
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                      if (trailing != null)
                        Padding(
                          padding: const EdgeInsets.only(left: 8),
                          child: trailing,
                        ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  // Subtitle
                  Text(
                    subtitle,
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.normal,
                      color: AppColors.black,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  // Timestamp
                  Text(
                    timestamp,
                    style: const TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w400,
                      color: AppColors.inactive,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Compact timeline tile widget untuk layout yang lebih padat
class CompactLogTimelineTile extends StatelessWidget {
  final String title;
  final String timestamp;
  final IconData icon;
  final Color? iconColor;
  final bool isLast;
  final VoidCallback? onTap;

  const CompactLogTimelineTile({
    Key? key,
    required this.title,
    required this.timestamp,
    required this.icon,
    this.iconColor,
    this.isLast = false,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Timeline column
          Column(
            children: [
              // Dot
              Container(
                width: 10,
                height: 10,
                decoration: BoxDecoration(
                  color: iconColor ?? AppColors.primary,
                  shape: BoxShape.circle,
                ),
              ),
              // Vertical line
              if (!isLast)
                Container(
                  width: 2,
                  height: 60,
                  color: AppColors.tertiary,
                  margin: const EdgeInsets.only(top: 4),
                ),
            ],
          ),
          const SizedBox(width: 12),
          // Content
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: AppColors.primary,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 2),
                  Text(
                    timestamp,
                    style: const TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w400,
                      color: AppColors.inactive,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
