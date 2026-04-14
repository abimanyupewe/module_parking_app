import 'package:flutter/material.dart';
import '../../../config/colors.dart';
import '../../../widgets/widgets.dart';
import '../../../services/format_helper.dart';

/// Petugas History Section - Riwayat transaksi
class PetugasHistorySection extends StatefulWidget {
  const PetugasHistorySection({Key? key}) : super(key: key);

  @override
  State<PetugasHistorySection> createState() => _PetugasHistorySectionState();
}

class _PetugasHistorySectionState extends State<PetugasHistorySection> {
  // Mock data - nanti ganti dengan data dari DB
  final List<Map<String, dynamic>> _historyData = [
    {
      'id': 1,
      'platNomor': 'AB 1234 CD',
      'jenis': 'Motor',
      'waktuMasuk': '08:30',
      'waktuKeluar': '10:45',
      'durasi': '2 jam 15 menit',
      'biaya': 4500,
      'status': 'Selesai',
      'area': 'Blok A',
    },
    {
      'id': 2,
      'platNomor': 'DE 5678 FG',
      'jenis': 'Mobil',
      'waktuMasuk': '09:15',
      'waktuKeluar': '11:30',
      'durasi': '2 jam 15 menit',
      'biaya': 9000,
      'status': 'Selesai',
      'area': 'Blok B',
    },
    {
      'id': 3,
      'platNomor': 'HI 9012 JK',
      'jenis': 'Motor',
      'waktuMasuk': '10:00',
      'waktuKeluar': '11:15',
      'durasi': '1 jam 15 menit',
      'biaya': 2500,
      'status': 'Selesai',
      'area': 'Blok A',
    },
  ];

  int _selectedFilterIndex = 0;
  final List<String> _filters = [
    'Semua',
    'Hari Ini',
    'Minggu Ini',
    'Bulan Ini',
  ];

  @override
  Widget build(BuildContext context) {
    final totalBiaya = _historyData.fold<int>(
      0,
      (sum, item) => sum + (item['biaya'] as int),
    );

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Text(
              'Riwayat Transaksi',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 16),

            // Filter chips
            SizedBox(
              height: 40,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: _filters.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: EdgeInsets.only(
                      right: index != _filters.length - 1 ? 8 : 0,
                    ),
                    child: CustomFilterChip(
                      label: _filters[index],
                      isSelected: _selectedFilterIndex == index,
                      onTap: () {
                        setState(() {
                          _selectedFilterIndex = index;
                        });
                      },
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 24),

            // Summary
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildSummaryItem('Total Transaksi', '${_historyData.length}'),
                _buildSummaryItem(
                  'Total Pendapatan',
                  FormatHelper.formatRupiah(totalBiaya),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Table
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: DataTable(
                columnSpacing: 16,
                dataRowHeight: 56,
                headingRowHeight: 48,
                showCheckboxColumn: false,
                columns: const [
                  DataColumn(label: Text('Plat Nomor')),
                  DataColumn(label: Text('Jenis')),
                  DataColumn(label: Text('Masuk')),
                  DataColumn(label: Text('Keluar')),
                  DataColumn(label: Text('Durasi')),
                  DataColumn(label: Text('Biaya'), numeric: true),
                ],
                rows: _historyData
                    .map(
                      (history) => DataRow(
                        cells: [
                          DataCell(Text(history['platNomor'])),
                          DataCell(Text(history['jenis'])),
                          DataCell(Text(history['waktuMasuk'])),
                          DataCell(Text(history['waktuKeluar'])),
                          DataCell(Text(history['durasi'])),
                          DataCell(
                            Text(
                              FormatHelper.formatRupiah(history['biaya']),
                              style: const TextStyle(
                                fontWeight: FontWeight.w600,
                                color: AppColors.primary,
                              ),
                            ),
                          ),
                        ],
                      ),
                    )
                    .toList(),
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryItem(String label, String value) {
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
