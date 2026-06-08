// ignore_for_file: file_names

import 'dart:io';

import 'package:flutter/material.dart';

import '../../../../config/colors.dart';
import '../../../../config/constants.dart';
import '../../../../services/format_helper.dart';

class PetugasHistoryTabContent extends StatelessWidget {
  const PetugasHistoryTabContent({
    super.key,
    required this.data,
    required this.isCompleted,
    required this.itemsPerPage,
    required this.currentPage,
    required this.onPrevious,
    required this.onNext,
    required this.formatDateTime,
    required this.formatDuration,
  });

  final List<Map<String, dynamic>> data;
  final bool isCompleted;
  final int itemsPerPage;
  final int currentPage;
  final VoidCallback? onPrevious;
  final VoidCallback? onNext;
  final String Function(String? dateTimeStr) formatDateTime;
  final String Function({
    required bool isCompleted,
    required DateTime? waktuMasuk,
    required DateTime? waktuKeluar,
  })
  formatDuration;

  @override
  Widget build(BuildContext context) {
    final totalBiaya = data.fold<int>(
      0,
      (sum, item) => sum + (item[AppConstants.colTotalBiaya] as int? ?? 0),
    );

    final totalPages = (data.length / itemsPerPage).ceil();
    final safeCurrentPage = totalPages == 0
        ? 0
        : currentPage.clamp(0, totalPages - 1);

    final startIndex = safeCurrentPage * itemsPerPage;
    final endIndex = (startIndex + itemsPerPage).clamp(0, data.length);
    final paginatedData = data.sublist(startIndex, endIndex);

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _PetugasHistorySummaryItem(
                  label: 'Total Transaksi',
                  value: '${data.length}',
                ),
                _PetugasHistorySummaryItem(
                  label: 'Total Pendapatan',
                  value: FormatHelper.formatRupiah(totalBiaya),
                ),
              ],
            ),
            const SizedBox(height: 24),
            if (data.isEmpty)
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
                        isCompleted
                            ? 'Tidak ada transaksi selesai untuk periode ini'
                            : 'Tidak ada kendaraan sedang parkir',
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
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: DataTable(
                  columnSpacing: 16,
                  dataRowMinHeight: 56,
                  dataRowMaxHeight: 56,
                  headingRowHeight: 48,
                  showCheckboxColumn: false,
                  columns: [
                    const DataColumn(label: Text('Foto')),
                    const DataColumn(label: Text('Plat Nomor')),
                    const DataColumn(label: Text('Jenis')),
                    const DataColumn(label: Text('Masuk')),
                    if (isCompleted) const DataColumn(label: Text('Keluar')),
                    const DataColumn(label: Text('Durasi')),
                    const DataColumn(label: Text('Biaya'), numeric: true),
                  ],
                  rows: paginatedData.map((history) {
                    final waktuMasuk = DateTime.tryParse(
                      history[AppConstants.colWaktuMasuk] ?? '',
                    );
                    final waktuKeluar = DateTime.tryParse(
                      history[AppConstants.colWaktuKeluar] ?? '',
                    );
                    final durasiText = formatDuration(
                      isCompleted: isCompleted,
                      waktuMasuk: waktuMasuk,
                      waktuKeluar: waktuKeluar,
                    );

                    final String? imagePath = history['image_path'] as String?;

                    return DataRow(
                      cells: [
                        DataCell(
                          imagePath != null && imagePath.isNotEmpty
                              ? Container(
                                  width: 40,
                                  height: 40,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(4),
                                    image: DecorationImage(
                                      image: FileImage(File(imagePath)),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                )
                              : Container(
                                  width: 40,
                                  height: 40,
                                  decoration: BoxDecoration(
                                    color: AppColors.tertiary,
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  child: const Icon(
                                    Icons.broken_image,
                                    size: 20,
                                    color: AppColors.inactive,
                                  ),
                                ),
                        ),
                        DataCell(
                          Text(
                            history[AppConstants.colPlatNomor],
                            style: const TextStyle(fontWeight: FontWeight.w600),
                          ),
                        ),
                        DataCell(
                          Text(history[AppConstants.colNamaJenis] ?? 'N/A'),
                        ),
                        DataCell(
                          Text(
                            formatDateTime(history[AppConstants.colWaktuMasuk]),
                          ),
                        ),
                        if (isCompleted)
                          DataCell(
                            Text(
                              formatDateTime(
                                history[AppConstants.colWaktuKeluar],
                              ),
                            ),
                          ),
                        DataCell(Text(durasiText)),
                        DataCell(
                          Text(
                            FormatHelper.formatRupiah(
                              history[AppConstants.colTotalBiaya] ?? 0,
                            ),
                            style: const TextStyle(
                              fontWeight: FontWeight.w600,
                              color: AppColors.primary,
                            ),
                          ),
                        ),
                      ],
                    );
                  }).toList(),
                ),
              ),
            const SizedBox(height: 24),
            if (data.isNotEmpty)
              Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextButton(
                      onPressed: onPrevious,
                      child: const Text('← Sebelumnya'),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: Text(
                        '${safeCurrentPage + 1}/${totalPages > 0 ? totalPages : 1}',
                        style: const TextStyle(
                          fontSize: 13,
                          color: AppColors.inactive,
                        ),
                      ),
                    ),
                    TextButton(
                      onPressed: onNext,
                      child: const Text('Berikutnya →'),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _PetugasHistorySummaryItem extends StatelessWidget {
  const _PetugasHistorySummaryItem({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 12, color: AppColors.inactive),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: AppColors.primary,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
