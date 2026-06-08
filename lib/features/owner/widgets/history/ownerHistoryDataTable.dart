// ignore_for_file: file_names

import 'package:flutter/material.dart';
import '../../../../config/colors.dart';

class OwnerHistoryDataTable extends StatelessWidget {
  const OwnerHistoryDataTable({
    super.key,
    required this.data,
    required this.getJenisKendaraan,
  });

  final List<Map<String, dynamic>> data;
  final String Function(int idJenis) getJenisKendaraan;

  @override
  Widget build(BuildContext context) {
    if (data.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Text(
            'Tidak ada data kendaraan',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ),
      );
    }

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: DataTable(
        columns: const [
          DataColumn(
            label: Text('No', style: TextStyle(fontWeight: FontWeight.bold)),
          ),
          DataColumn(
            label: Text(
              'Plat Nomor',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          DataColumn(
            label: Text('Jenis', style: TextStyle(fontWeight: FontWeight.bold)),
          ),
          DataColumn(
            label: Text('Merek', style: TextStyle(fontWeight: FontWeight.bold)),
          ),
          DataColumn(
            label: Text(
              'Waktu Masuk',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          DataColumn(
            label: Text(
              'Waktu Keluar',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ],
        rows: List<DataRow>.generate(data.length, (index) {
          final item = data[index];
          final platNomor = item['plat_nomor'] as String? ?? '';
          final jenisId = item['id_jenis'] as int? ?? 0;
          final merk = item['merk'] as String? ?? '';
          final waktuMasuk = item['waktu_masuk'] as String? ?? '';
          final waktuKeluar = item['waktu_keluar'] as String?;

          return DataRow(
            cells: [
              DataCell(Text('${index + 1}')),
              DataCell(
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.primaryLight,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    platNomor,
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 12,
                    ),
                  ),
                ),
              ),
              DataCell(Text(getJenisKendaraan(jenisId))),
              DataCell(Text(merk)),
              DataCell(Text(waktuMasuk, style: const TextStyle(fontSize: 12))),
              DataCell(
                Text(
                  waktuKeluar ?? '-',
                  style: TextStyle(
                    fontSize: 12,
                    color: waktuKeluar == null ? Colors.orange : Colors.green,
                    fontWeight: waktuKeluar == null
                        ? FontWeight.w600
                        : FontWeight.normal,
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
