// ignore_for_file: file_names

import 'package:flutter/material.dart';

Future<void> showPetugasCheckinSuccessDialog(
  BuildContext context, {
  required VoidCallback onPrintPressed,
}) async {
  await showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text('Check-In Berhasil'),
      content: const Text(
        'Kendaraan telah berhasil dicatat. '
        'Silakan cetak karcis untuk diberikan kepada pengendara.',
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('OK'),
        ),
        TextButton(
          onPressed: () {
            Navigator.pop(context);
            onPrintPressed();
          },
          child: const Text('Cetak Struk'),
        ),
      ],
    ),
  );
}
