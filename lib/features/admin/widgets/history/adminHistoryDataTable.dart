// ignore_for_file: file_names

import 'dart:io';

import 'package:flutter/material.dart';

import '../../../../config/colors.dart';
import '../../../../services/format_helper.dart';

class AdminHistoryDataTable extends StatelessWidget {
  const AdminHistoryDataTable({super.key, required this.data});

  final List<Map<String, dynamic>> data;

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
            label: Text('Foto', style: TextStyle(fontWeight: FontWeight.bold)),
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
          final namaJenis = item['nama_jenis'] as String? ?? '';
          final merk = item['merk'] as String? ?? '';
          final waktuMasuk = item['waktu_masuk'] as String? ?? '';
          final waktuKeluar = item['waktu_keluar'] as String?;
          final imagePath = item['image_path'] as String?;

          return DataRow(
            cells: [
              DataCell(Text('${index + 1}')),
              DataCell(AdminHistoryVehicleImageCell(imagePath: imagePath)),
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
              DataCell(Text(namaJenis)),
              DataCell(Text(merk)),
              DataCell(
                Text(
                  waktuMasuk.isNotEmpty
                      ? FormatHelper.formatFullDate(DateTime.parse(waktuMasuk))
                      : '-',
                  style: const TextStyle(fontSize: 12),
                ),
              ),
              DataCell(
                Text(
                  waktuKeluar != null && waktuKeluar.isNotEmpty
                      ? FormatHelper.formatFullDate(DateTime.parse(waktuKeluar))
                      : '-',
                  style: TextStyle(
                    fontSize: 12,
                    color: waktuKeluar == null || waktuKeluar.isEmpty
                        ? Colors.orange
                        : Colors.green,
                    fontWeight: waktuKeluar == null || waktuKeluar.isEmpty
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

class AdminHistoryVehicleImageCell extends StatelessWidget {
  const AdminHistoryVehicleImageCell({super.key, required this.imagePath});

  final String? imagePath;

  @override
  Widget build(BuildContext context) {
    if (imagePath != null && imagePath!.isNotEmpty) {
      return Container(
        margin: const EdgeInsets.symmetric(vertical: 4),
        width: 50,
        height: 50,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.grey.shade300),
          image: DecorationImage(
            image: FileImage(File(imagePath!)),
            fit: BoxFit.cover,
          ),
        ),
      );
    }

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4),
      width: 50,
      height: 50,
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: const Icon(Icons.directions_car, color: Colors.grey),
    );
  }
}
