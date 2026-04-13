import 'package:flutter/material.dart';
import '../../../config/colors.dart';
import '../../../widgets/widgets.dart';
import '../../../services/format_helper.dart';
import '../../../services/pdf_service.dart';

/// Owner History Section - Global history dengan data table
class OwnerHistorySection extends StatefulWidget {
  const OwnerHistorySection({Key? key}) : super(key: key);

  @override
  State<OwnerHistorySection> createState() => _OwnerHistorySectionState();
}

class _OwnerHistorySectionState extends State<OwnerHistorySection> {
  String _searchQuery = '';

  final List<Map<String, dynamic>> _allHistory = [
    {
      'plat': 'AB 1234 CD',
      'jenis': 'Motor',
      'area': 'Blok A',
      'masuk': '08:30',
      'keluar': '10:45',
      'biaya': 4500,
    },
    {
      'plat': 'DE 5678 FG',
      'jenis': 'Mobil',
      'area': 'Blok B',
      'masuk': '09:15',
      'keluar': '11:30',
      'biaya': 9000,
    },
    {
      'plat': 'HI 9012 JK',
      'jenis': 'Motor',
      'area': 'Blok A',
      'masuk': '10:00',
      'keluar': '11:15',
      'biaya': 2500,
    },
  ];

  late List<Map<String, dynamic>> _filteredHistory;

  @override
  void initState() {
    super.initState();
    _filteredHistory = _allHistory;
  }

  void _filterHistory(String query) {
    setState(() {
      _searchQuery = query;
      _filteredHistory = _allHistory
          .where(
            (item) => item['plat'].toLowerCase().contains(query.toLowerCase()),
          )
          .toList();
    });
  }

  Future<void> _printHistory() async {
    try {
      await PdfService.generateTransactionReport(
        transactions: _filteredHistory,
        reportTitle: 'LAPORAN TRANSAKSI PARKIR',
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error cetak laporan: $e'),
          backgroundColor: AppColors.danger,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final totalBiaya = _filteredHistory.fold<int>(
      0,
      (sum, item) => sum + (item['biaya'] as int),
    );

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header dengan search dan print
          Row(
            children: [
              Expanded(
                child: CustomSearchBar(
                  hintText: 'Cari plat nomor...',
                  onChanged: _filterHistory,
                  prefixIcon: Icons.search,
                ),
              ),
              const SizedBox(width: 8),
              ElevatedButton.icon(
                onPressed: _printHistory,
                icon: const Icon(Icons.print, size: 18),
                label: const Text('Print'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: AppColors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 16,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Summary
          Container(
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
                      '${_filteredHistory.length}',
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
          ),
          const SizedBox(height: 24),

          // List
          if (_filteredHistory.isEmpty)
            Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 32),
                child: Text(
                  _searchQuery.isEmpty
                      ? 'Tidak ada data'
                      : 'Kendaraan tidak ditemukan',
                  style: const TextStyle(color: AppColors.inactive),
                ),
              ),
            )
          else
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _filteredHistory.length,
              itemBuilder: (context, index) {
                final h = _filteredHistory[index];
                return Container(
                  margin: EdgeInsets.only(
                    bottom: index != _filteredHistory.length - 1 ? 12 : 0,
                  ),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: AppColors.tertiary),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              h['plat'],
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: AppColors.primary,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              '${h['jenis']} • ${h['area']}',
                              style: const TextStyle(
                                fontSize: 11,
                                color: AppColors.inactive,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '${h['masuk']} - ${h['keluar']}',
                              style: const TextStyle(
                                fontSize: 11,
                                color: AppColors.inactive,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.primary.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          FormatHelper.formatRupiah(h['biaya']),
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: AppColors.primary,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
        ],
      ),
    );
  }
}
