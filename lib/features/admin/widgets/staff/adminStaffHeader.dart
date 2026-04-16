// ignore_for_file: file_names

import 'package:flutter/material.dart';

class AdminStaffHeader extends StatelessWidget {
  const AdminStaffHeader({super.key, required this.totalStaff});

  final int totalStaff;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Data Petugas Parkir',
          style: Theme.of(
            context,
          ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        Text(
          'Total: $totalStaff petugas',
          style: Theme.of(context).textTheme.bodySmall,
        ),
      ],
    );
  }
}
