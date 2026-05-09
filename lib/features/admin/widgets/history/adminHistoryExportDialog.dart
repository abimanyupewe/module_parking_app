// ignore_for_file: file_names

import 'package:flutter/material.dart';
import '../../../../config/colors.dart';

class AdminHistoryExportDialog extends StatelessWidget {
  const AdminHistoryExportDialog({
    super.key,
    required this.onExportCsv,
    required this.onExportPdf,
  });

  final VoidCallback onExportCsv;
  final VoidCallback onExportPdf;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Pilih Format Export'),
      content: const Text('Pilih format file untuk mengekspor data:'),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Batal'),
        ),
        ElevatedButton.icon(
          onPressed: onExportCsv,
          icon: const Icon(Icons.download),
          label: const Text('CSV'),
          style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary),
        ),
        ElevatedButton.icon(
          onPressed: onExportPdf,
          icon: const Icon(Icons.picture_as_pdf),
          label: const Text('PDF'),
          style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary),
        ),
      ],
    );
  }
}
