// ignore_for_file: file_names

import 'package:flutter/material.dart';

class AdminAuditHeader extends StatelessWidget {
  const AdminAuditHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Log Aktivitas Sistem',
          style: Theme.of(context).textTheme.headlineSmall,
        ),
        const SizedBox(height: 8),
        Text(
          'Riwayat semua aktivitas petugas (Read-Only)',
          style: Theme.of(context).textTheme.bodySmall,
        ),
      ],
    );
  }
}
