import 'package:flutter/material.dart';
import '../../../../../config/colors.dart';
import 'area_status_item.dart';

/// Area Status Section - Displays parking area status overview
class AreaStatusSection extends StatelessWidget {
  const AreaStatusSection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Status Area Parkir',
          style: Theme.of(
            context,
          ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        // Lantai 1 Motor
        AreaStatusItem(
          name: 'Lantai 1 Motor',
          occupied: 87,
          total: 100,
          color: AppColors.primary,
        ),
        const SizedBox(height: 12),
        // Lantai 2 Mobil
        AreaStatusItem(
          name: 'Lantai 2 Mobil',
          occupied: 48,
          total: 50,
          color: AppColors.warning,
        ),
        const SizedBox(height: 12),
        // Basement Motor
        AreaStatusItem(
          name: 'Basement Motor',
          occupied: 45,
          total: 80,
          color: AppColors.success,
        ),
      ],
    );
  }
}
