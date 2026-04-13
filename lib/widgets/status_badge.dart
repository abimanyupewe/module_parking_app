import 'package:flutter/material.dart';
import '../config/colors.dart';

/// Status badge widget untuk menampilkan status dengan warna berbeda
class StatusBadge extends StatelessWidget {
  final String status;
  final Color? backgroundColor;
  final Color? textColor;
  final IconData? icon;
  final double fontSize;
  final EdgeInsets padding;

  const StatusBadge({
    Key? key,
    required this.status,
    this.backgroundColor,
    this.textColor,
    this.icon,
    this.fontSize = 12,
    this.padding = const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final colors = _getStatusColors();

    return Container(
      padding: padding,
      decoration: BoxDecoration(
        color: backgroundColor ?? colors['bg'],
        borderRadius: BorderRadius.circular(6),
        border: Border.all(
          color: (textColor ?? colors['text']!).withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: fontSize - 2, color: textColor ?? colors['text']),
            const SizedBox(width: 4),
          ],
          Text(
            status,
            style: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.w600,
              color: textColor ?? colors['text'],
            ),
          ),
        ],
      ),
    );
  }

  Map<String, Color> _getStatusColors() {
    final lowerStatus = status.toLowerCase();

    if (lowerStatus.contains('aktif') || lowerStatus.contains('selesai')) {
      return {
        'bg': AppColors.success.withOpacity(0.1),
        'text': AppColors.success,
      };
    } else if (lowerStatus.contains('nonaktif') ||
        lowerStatus.contains('parkir')) {
      return {
        'bg': AppColors.warning.withOpacity(0.1),
        'text': AppColors.warning,
      };
    } else if (lowerStatus.contains('pending')) {
      return {'bg': AppColors.info.withOpacity(0.1), 'text': AppColors.info};
    } else {
      return {
        'bg': AppColors.inactive.withOpacity(0.1),
        'text': AppColors.inactive,
      };
    }
  }
}

/// Large status indicator widget
class StatusIndicator extends StatelessWidget {
  final String status;
  final String label;
  final Color? backgroundColor;
  final Color? textColor;
  final IconData icon;
  final bool isActive;

  const StatusIndicator({
    Key? key,
    required this.status,
    required this.label,
    required this.icon,
    this.backgroundColor,
    this.textColor,
    this.isActive = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final colors = _getStatusColors();

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: backgroundColor ?? colors['bg'],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: (textColor ?? colors['text']!).withOpacity(0.2),
          width: 1.5,
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 40, color: textColor ?? colors['text']),
          const SizedBox(height: 12),
          Text(
            status,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: textColor ?? colors['text'],
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: (textColor ?? colors['text']!).withOpacity(0.7),
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Map<String, Color> _getStatusColors() {
    final lowerStatus = status.toLowerCase();

    if (lowerStatus.contains('aktif') || lowerStatus.contains('online')) {
      return {
        'bg': AppColors.success.withOpacity(0.1),
        'text': AppColors.success,
      };
    } else if (lowerStatus.contains('nonaktif') ||
        lowerStatus.contains('offline')) {
      return {
        'bg': AppColors.danger.withOpacity(0.1),
        'text': AppColors.danger,
      };
    } else if (lowerStatus.contains('pending')) {
      return {
        'bg': AppColors.warning.withOpacity(0.1),
        'text': AppColors.warning,
      };
    } else {
      return {'bg': AppColors.info.withOpacity(0.1), 'text': AppColors.info};
    }
  }
}
