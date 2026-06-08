// ignore_for_file: file_names

import 'package:flutter/material.dart';

import '../../../../config/colors.dart';
import '../../../../config/constants.dart';
import '../../../../services/format_helper.dart';

Future<void> showPetugasCheckoutDetailDialog(
  BuildContext context, {
  required Map<String, dynamic> transaction,
  required String Function(DateTime dateTime) formatTime,
  required VoidCallback onConfirmCheckout,
}) async {
  final waktuMasuk =
      DateTime.tryParse(transaction[AppConstants.colWaktuMasuk] ?? '') ??
      DateTime.now();
  final durasi = DateTime.now().difference(waktuMasuk);
  final durasiText = '${durasi.inHours}h ${durasi.inMinutes % 60}m';

  await showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text('Konfirmasi Checkout'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _PetugasCheckoutDetailRow(
            label: 'Plat Nomor',
            value: transaction[AppConstants.colPlatNomor],
          ),
          const SizedBox(height: 12),
          _PetugasCheckoutDetailRow(
            label: 'Jenis Kendaraan',
            value: transaction[AppConstants.colNamaJenis] ?? 'N/A',
          ),
          const SizedBox(height: 12),
          _PetugasCheckoutDetailRow(
            label: 'Merk',
            value: transaction[AppConstants.colMerk],
          ),
          const SizedBox(height: 12),
          _PetugasCheckoutDetailRow(
            label: 'Waktu Masuk',
            value: formatTime(waktuMasuk),
          ),
          const SizedBox(height: 12),
          _PetugasCheckoutDetailRow(
            label: 'Area',
            value: transaction[AppConstants.colNamaArea],
          ),
          const SizedBox(height: 12),
          _PetugasCheckoutDetailRow(label: 'Durasi', value: durasiText),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: AppColors.primary),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Total Biaya',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppColors.primary,
                  ),
                ),
                Text(
                  FormatHelper.formatRupiah(
                    transaction[AppConstants.colTotalBiaya] ?? 0,
                  ),
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Batal'),
        ),
        ElevatedButton(
          onPressed: () {
            Navigator.pop(context);
            onConfirmCheckout();
          },
          style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary),
          child: const Text('Konfirmasi Checkout'),
        ),
      ],
    ),
  );
}

class _PetugasCheckoutDetailRow extends StatelessWidget {
  const _PetugasCheckoutDetailRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 13, color: AppColors.inactive),
        ),
        Text(
          value,
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: AppColors.primary,
          ),
        ),
      ],
    );
  }
}
