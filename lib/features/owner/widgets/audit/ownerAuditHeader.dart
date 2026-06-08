// ignore_for_file: file_names

import 'package:flutter/material.dart';

import '../../../../config/colors.dart';

class OwnerAuditHeader extends StatelessWidget {
  const OwnerAuditHeader({super.key, required this.onPrintPressed});

  final VoidCallback onPrintPressed;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          'Audit Log',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        ElevatedButton.icon(
          onPressed: onPrintPressed,
          icon: const Icon(Icons.print, size: 18),
          label: const Text('Print'),
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
            foregroundColor: AppColors.white,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          ),
        ),
      ],
    );
  }
}
