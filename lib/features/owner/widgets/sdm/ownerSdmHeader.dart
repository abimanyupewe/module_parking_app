// ignore_for_file: file_names

import 'package:flutter/material.dart';

import '../../../../config/colors.dart';

class OwnerSdmHeader extends StatelessWidget {
  const OwnerSdmHeader({
    super.key,
    required this.filteredCount,
    required this.totalCount,
    required this.onAddPressed,
  });

  final int filteredCount;
  final int totalCount;
  final VoidCallback onAddPressed;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Manajemen SDM',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 4),
            Text(
              '$filteredCount dari $totalCount anggota',
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        ),
        FloatingActionButton.small(
          onPressed: onAddPressed,
          backgroundColor: AppColors.primary,
          foregroundColor: AppColors.white,
          child: const Icon(Icons.add),
        ),
      ],
    );
  }
}
