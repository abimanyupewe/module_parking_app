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

            // List
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _historyData.length,
              itemBuilder: (context, index) {
                final history = _historyData[index];
                return Container(
                  margin: EdgeInsets.only(
                    bottom: index != _historyData.length - 1 ? 12 : 0,
                  ),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppColors.tertiary),
                  ),
                  child: GestureDetector(
                    onTap: () => _showDetailDialog(history),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Header row
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  history['platNomor'],
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.primary,
                                    letterSpacing: 2,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  history['jenis'],
                                  style: const TextStyle(
                                    fontSize: 12,
                                    color: AppColors.inactive,
                                  ),
                                ),
                              ],
                            ),
                            StatusBadge(
                              status: history['status'],
                              fontSize: 11,
                              icon: Icons.check_circle,
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        // Time info
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Masuk: ${history['waktuMasuk']}',
                              style: const TextStyle(
                                fontSize: 12,
                                color: AppColors.inactive,
                              ),
                            ),
                            Text(
                              'Keluar: ${history['waktuKeluar']}',
                              style: const TextStyle(
                                fontSize: 12,
                                color: AppColors.inactive,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        // Duration & Fee
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Durasi',
                                    style: TextStyle(
                                      fontSize: 11,
                                      color: AppColors.inactive,
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    history['durasi'],
                                    style: const TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w600,
                                      color: AppColors.primary,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 8,
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.primary.withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  const Text(
                                    'Total Biaya',
                                    style: TextStyle(
                                      fontSize: 11,
                                      color: AppColors.inactive,
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    FormatHelper.formatRupiah(history['biaya']),
                                    style: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.primary,
                                    ),
                                  ),
                                ],
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

  void _showDetailDialog(Map<String, dynamic> history) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Detail Transaksi'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildDetailRow('Plat Nomor', history['platNomor']),
            const SizedBox(height: 12),
            _buildDetailRow('Jenis Kendaraan', history['jenis']),
            const SizedBox(height: 12),
            _buildDetailRow('Area', history['area']),
            const SizedBox(height: 12),
            _buildDetailRow('Waktu Masuk', history['waktuMasuk']),
            const SizedBox(height: 12),
            _buildDetailRow('Waktu Keluar', history['waktuKeluar']),
            const SizedBox(height: 12),
            _buildDetailRow('Durasi', history['durasi']),
            const SizedBox(height: 16),
            // Total
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
                    FormatHelper.formatRupiah(history['biaya']),
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
            child: const Text('Tutup'),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
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
