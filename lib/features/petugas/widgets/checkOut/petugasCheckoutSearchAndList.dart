// ignore_for_file: file_names

import 'dart:io';

import 'package:flutter/material.dart';

import '../../../../config/colors.dart';
import '../../../../config/constants.dart';
import '../../../../services/format_helper.dart';
import '../../../../widgets/widgets.dart';

class PetugasCheckoutSearchAndList extends StatelessWidget {
  const PetugasCheckoutSearchAndList({
    super.key,
    required this.searchController,
    required this.transactions,
    required this.onSearchChanged,
    required this.onItemTap,
    required this.formatTime,
  });

  final TextEditingController searchController;
  final List<Map<String, dynamic>> transactions;
  final ValueChanged<String> onSearchChanged;
  final ValueChanged<Map<String, dynamic>> onItemTap;
  final String Function(DateTime dateTime) formatTime;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomSearchBar(
              hintText: 'Cari plat nomor... (3+ karakter)',
              onChanged: onSearchChanged,
              controller: searchController,
              prefixIcon: Icons.search,
              backgroundColor: AppColors.tertiary,
            ),
            const SizedBox(height: 24),
            if (transactions.isEmpty)
              Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 32),
                  child: Column(
                    children: [
                      Icon(
                        Icons.inbox_outlined,
                        size: 64,
                        color: AppColors.inactive,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        searchController.text.isEmpty
                            ? 'Tidak ada kendaraan yang sedang parkir'
                            : 'Kendaraan tidak ditemukan',
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 14,
                          color: AppColors.inactive,
                        ),
                      ),
                    ],
                  ),
                ),
              )
            else
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: transactions.length,
                itemBuilder: (context, index) {
                  final tx = transactions[index];
                  final waktuMasuk =
                      DateTime.tryParse(tx[AppConstants.colWaktuMasuk] ?? '') ??
                      DateTime.now();
                  final durasi = DateTime.now().difference(waktuMasuk);
                  final durasiText =
                      '${durasi.inHours}h ${durasi.inMinutes % 60}m';

                  return GestureDetector(
                    onTap: () => onItemTap(tx),
                    child: Container(
                      margin: EdgeInsets.only(
                        bottom: index != transactions.length - 1 ? 12 : 0,
                      ),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: AppColors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: AppColors.tertiary),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.black.withValues(alpha: 0.05),
                            blurRadius: 4,
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              if (tx['image_path'] != null &&
                                  tx['image_path'].toString().isNotEmpty)
                                Container(
                                  width: 50,
                                  height: 50,
                                  margin: const EdgeInsets.only(right: 12),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8),
                                    image: DecorationImage(
                                      image: FileImage(File(tx['image_path'])),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                )
                              else
                                Container(
                                  width: 50,
                                  height: 50,
                                  margin: const EdgeInsets.only(right: 12),
                                  decoration: BoxDecoration(
                                    color: AppColors.tertiary,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: const Icon(
                                    Icons.directions_car,
                                    color: AppColors.inactive,
                                    size: 24,
                                  ),
                                ),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      tx[AppConstants.colPlatNomor],
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: AppColors.primary,
                                        letterSpacing: 2,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      tx[AppConstants.colMerk],
                                      style: const TextStyle(
                                        fontSize: 12,
                                        color: AppColors.inactive,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              StatusBadge(
                                status: tx[AppConstants.colNamaJenis] ?? 'N/A',
                                fontSize: 11,
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Masuk: ${formatTime(waktuMasuk)}',
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: AppColors.inactive,
                                ),
                              ),
                              Text(
                                'Area: ${tx[AppConstants.colNamaArea]}',
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: AppColors.inactive,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Durasi: $durasiText',
                                style: const TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.primary,
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: AppColors.primary.withValues(
                                    alpha: 0.1,
                                  ),
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Text(
                                  FormatHelper.formatRupiah(
                                    tx[AppConstants.colTotalBiaya] ?? 0,
                                  ),
                                  style: const TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.primary,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
