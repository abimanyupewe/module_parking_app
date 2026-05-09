// ignore_for_file: file_names

import 'package:flutter/material.dart';

import '../../../../config/colors.dart';
import '../../../../services/format_helper.dart';

class OwnerHistorySectionSummary extends StatelessWidget {
  const OwnerHistorySectionSummary({
    super.key,
    required this.totalTransaksi,
    required this.totalBiaya,
  });

  final int totalTransaksi;
  final int totalBiaya;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.secondary.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.tertiary),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Column(
            children: [
              const Text(
                'Total Transaksi',
                style: TextStyle(fontSize: 12, color: AppColors.inactive),
              ),
              const SizedBox(height: 4),
              Text(
                '$totalTransaksi',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary,
                ),
              ),
            ],
          ),
          Column(
            children: [
              const Text(
                'Total Pendapatan',
                style: TextStyle(fontSize: 12, color: AppColors.inactive),
              ),
              const SizedBox(height: 4),
              Text(
                FormatHelper.formatRupiah(totalBiaya),
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
