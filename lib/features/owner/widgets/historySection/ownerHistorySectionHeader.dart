// ignore_for_file: file_names

import 'package:flutter/material.dart';

import '../../../../config/colors.dart';
import 'ownerHistorySearchBar.dart';

class OwnerHistorySectionHeader extends StatelessWidget {
  const OwnerHistorySectionHeader({
    super.key,
    required this.onSearchChanged,
    required this.onPrintPressed,
  });

  final ValueChanged<String> onSearchChanged;
  final VoidCallback onPrintPressed;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: OwnerHistorySearchBar(
            hintText: 'Cari plat nomor...',
            onChanged: onSearchChanged,
          ),
        ),
        const SizedBox(width: 8),
        ElevatedButton.icon(
          onPressed: onPrintPressed,
          icon: const Icon(Icons.print, size: 18),
          label: const Text('Print'),
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
            foregroundColor: AppColors.white,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          ),
        ),
      ],
    );
  }
}
