// ignore_for_file: file_names

import 'package:flutter/material.dart';

class AdminOverviewHeader extends StatelessWidget {
  const AdminOverviewHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Overview Sistem',
          style: Theme.of(
            context,
          ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        Text(
          'Ringkasan informasi sistem parkir',
          style: Theme.of(context).textTheme.bodySmall,
        ),
      ],
    );
  }
}
