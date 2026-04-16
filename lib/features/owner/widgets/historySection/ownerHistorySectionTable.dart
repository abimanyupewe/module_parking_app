// ignore_for_file: file_names

import 'dart:io';

import 'package:flutter/material.dart';

import '../../../../config/colors.dart';
import '../../../../services/format_helper.dart';

class OwnerHistorySectionTable extends StatelessWidget {
  const OwnerHistorySectionTable({
    super.key,
    required this.data,
    required this.searchQuery,
    required this.selectedDate,
    required this.isLoading,
  });

  final List<Map<String, dynamic>> data;
  final String searchQuery;
  final DateTime? selectedDate;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (data.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 32),
          child: Text(
            searchQuery.isEmpty && selectedDate == null
                ? 'Tidak ada data'
                : 'Data tidak ditemukan',
            style: const TextStyle(color: AppColors.inactive),
          ),
        ),
      );
    }

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: DataTable(
        columnSpacing: 16,
        horizontalMargin: 0,
        headingRowColor: WidgetStateProperty.all(
          AppColors.tertiary.withValues(alpha: 0.5),
        ),
        dataRowColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return AppColors.secondary.withValues(alpha: 0.5);
          }
          return AppColors.white;
        }),
        columns: const [
          DataColumn(
            label: Text(
              'Foto',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: AppColors.primary,
              ),
            ),
          ),
          DataColumn(
            label: Text(
              'Plat Nomor',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: AppColors.primary,
              ),
            ),
          ),
          DataColumn(
            label: Text(
              'Jenis',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: AppColors.primary,
              ),
            ),
          ),
          DataColumn(
            label: Text(
              'Area',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: AppColors.primary,
              ),
            ),
          ),
          DataColumn(
            label: Text(
              'Masuk',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: AppColors.primary,
              ),
            ),
          ),
          DataColumn(
            label: Text(
              'Keluar',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: AppColors.primary,
              ),
            ),
          ),
          DataColumn(
            label: Text(
              'Biaya',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: AppColors.primary,
              ),
            ),
          ),
        ],
        rows: List.generate(data.length, (index) {
          final history = data[index];
          final platNomor = history['plat_nomor'] as String? ?? '';
          final namaJenis = history['nama_jenis'] as String? ?? '';
          final namaArea = history['nama_area'] as String? ?? '';
          final waktuMasuk = history['waktu_masuk'] as String? ?? '';
          final waktuKeluar = history['waktu_keluar'] as String?;
          final totalBiaya = history['total_biaya'] as int? ?? 0;
          final imagePath = history['image_path'] as String?;

          final fmtWaktuMasuk = waktuMasuk.isNotEmpty
              ? FormatHelper.formatFullDate(
                  DateTime.tryParse(waktuMasuk) ?? DateTime.now(),
                )
              : '-';
          final fmtWaktuKeluar = (waktuKeluar != null && waktuKeluar.isNotEmpty)
              ? FormatHelper.formatFullDate(
                  DateTime.tryParse(waktuKeluar) ?? DateTime.now(),
                )
              : '-';

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
                  platNomor,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: AppColors.primary,
                  ),
                ),
              ),
              DataCell(Text(namaJenis, style: const TextStyle(fontSize: 12))),
              DataCell(Text(namaArea, style: const TextStyle(fontSize: 12))),
              DataCell(
                Text(fmtWaktuMasuk, style: const TextStyle(fontSize: 12)),
              ),
              DataCell(
                Text(fmtWaktuKeluar, style: const TextStyle(fontSize: 12)),
              ),
              DataCell(
                Text(
                  FormatHelper.formatRupiah(totalBiaya),
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primary,
                  ),
                ),
              ),
            ],
          );
        }),
      ),
    );
  }
}
