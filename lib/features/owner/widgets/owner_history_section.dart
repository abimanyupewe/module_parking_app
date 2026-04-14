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
  DateTime? _selectedDate; // null = semua tanggal

  final List<Map<String, dynamic>> _allHistory = [
    {
      'plat': 'AB 1234 CD',
      'jenis': 'Motor',
      'area': 'Blok A',
      'masuk': '08:30',
      'keluar': '10:45',
      'biaya': 4500,
      'tanggal': DateTime(2024, 4, 5),
    },
    {
      'plat': 'DE 5678 FG',
      'jenis': 'Mobil',
      'area': 'Blok B',
      'masuk': '09:15',
      'keluar': '11:30',
      'biaya': 9000,
      'tanggal': DateTime(2024, 4, 5),
    },
    {
      'plat': 'HI 9012 JK',
      'jenis': 'Motor',
      'area': 'Blok A',
      'masuk': '10:00',
      'keluar': '11:15',
      'biaya': 2500,
      'tanggal': DateTime(2024, 4, 5),
    },
    {
      'plat': 'JK 3456 LM',
      'jenis': 'Mobil',
      'area': 'Blok C',
      'masuk': '07:45',
      'keluar': '09:30',
      'biaya': 7500,
      'tanggal': DateTime(2024, 4, 6),
    },
    {
      'plat': 'MN 7890 OP',
      'jenis': 'Motor',
      'area': 'Blok B',
      'masuk': '11:00',
      'keluar': '13:45',
      'biaya': 6000,
      'tanggal': DateTime(2024, 4, 6),
    },
    {
      'plat': 'PQ 1111 RS',
      'jenis': 'Mobil',
      'area': 'Blok A',
      'masuk': '14:30',
      'keluar': '16:15',
      'biaya': 5500,
      'tanggal': DateTime(2024, 4, 7),
    },
    {
      'plat': 'ST 2222 UV',
      'jenis': 'Motor',
      'area': 'Blok D',
      'masuk': '08:00',
      'keluar': '10:20',
      'biaya': 4000,
      'tanggal': DateTime(2024, 4, 10),
    },
    {
      'plat': 'VW 3333 XY',
      'jenis': 'Mobil',
      'area': 'Blok B',
      'masuk': '12:15',
      'keluar': '14:45',
      'biaya': 8000,
      'tanggal': DateTime(2024, 4, 10),
    },
    {
      'plat': 'YZ 4444 AB',
      'jenis': 'Motor',
      'area': 'Blok C',
      'masuk': '09:30',
      'keluar': '11:00',
      'biaya': 3500,
      'tanggal': DateTime(2024, 4, 12),
    },
    {
      'plat': 'CD 5555 EF',
      'jenis': 'Mobil',
      'area': 'Blok A',
      'masuk': '15:00',
      'keluar': '17:30',
      'biaya': 9500,
      'tanggal': DateTime(2024, 4, 12),
    },
    {
      'plat': 'EF 6666 GH',
      'jenis': 'Motor',
      'area': 'Blok D',
      'masuk': '08:45',
      'keluar': '10:15',
      'biaya': 3000,
      'tanggal': DateTime(2024, 3, 28),
    },
    {
      'plat': 'GH 7777 IJ',
      'jenis': 'Mobil',
      'area': 'Blok C',
      'masuk': '10:30',
      'keluar': '13:00',
      'biaya': 8500,
      'tanggal': DateTime(2024, 3, 28),
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
      _applyAllFilters();
    });
  }

  void _applyAllFilters() {
    _filteredHistory = _allHistory.where((item) {
      // Filter berdasarkan search query (plat nomor)
      if (!item['plat'].toLowerCase().contains(_searchQuery.toLowerCase())) {
        return false;
      }

      // Filter berdasarkan tanggal
      if (_selectedDate != null) {
        final itemDate = item['tanggal'] as DateTime;
        if (itemDate.year != _selectedDate!.year ||
            itemDate.month != _selectedDate!.month ||
            itemDate.day != _selectedDate!.day) {
          return false;
        }
      }

      return true;
    }).toList();
  }

  void _clearFilters() {
    setState(() {
      _selectedDate = null;
      _searchQuery = '';
      _filteredHistory = _allHistory;
    });
  }

  void _onDateChanged(DateTime? value) {
    setState(() {
      _selectedDate = value;
      _applyAllFilters();
    });
  }

  Future<void> _selectDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime(2024),
      lastDate: DateTime(2025),
    );
    if (picked != null) {
      _onDateChanged(picked);
    }
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

          // Filter Row (Date Picker)
          Row(
            children: [
              // Filter Date Picker
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Pilih Tanggal',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: AppColors.primary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    GestureDetector(
                      onTap: _selectDate,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 12,
                        ),
                        decoration: BoxDecoration(
                          border: Border.all(color: AppColors.tertiary),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              _selectedDate == null
                                  ? 'Pilih tanggal...'
                                  : '${_selectedDate!.day}/${_selectedDate!.month}/${_selectedDate!.year}',
                              style: TextStyle(
                                fontSize: 12,
                                color: _selectedDate == null
                                    ? AppColors.inactive
                                    : AppColors.black,
                              ),
                            ),
                            const Icon(
                              Icons.calendar_today,
                              size: 18,
                              color: AppColors.primary,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),

              // Clear Button
              Padding(
                padding: const EdgeInsets.only(top: 20),
                child: SizedBox(
                  height: 40,
                  child: ElevatedButton.icon(
                    onPressed: _clearFilters,
                    icon: const Icon(Icons.refresh, size: 16),
                    label: const Text('Bersihkan'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.tertiary,
                      foregroundColor: AppColors.black,
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                    ),
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

          // Data Table
          if (_filteredHistory.isEmpty)
            Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 32),
                child: Text(
                  _searchQuery.isEmpty && _selectedDate == null
                      ? 'Tidak ada data'
                      : 'Data tidak ditemukan',
                  style: const TextStyle(color: AppColors.inactive),
                ),
              ),
            )
          else
            SingleChildScrollView(
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
                  DataColumn(
                    label: Text(
                      'Tanggal',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: AppColors.primary,
                      ),
                    ),
                  ),
                ],
                rows: List.generate(_filteredHistory.length, (index) {
                  final h = _filteredHistory[index];
                  final tanggal = h['tanggal'] as DateTime;
                  final tanggalFormatted =
                      '${tanggal.day}/${tanggal.month}/${tanggal.year}';

                  return DataRow(
                    cells: [
                      DataCell(
                        Text(
                          h['plat'],
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: AppColors.primary,
                          ),
                        ),
                      ),
                      DataCell(
                        Text(h['jenis'], style: const TextStyle(fontSize: 12)),
                      ),
                      DataCell(
                        Text(h['area'], style: const TextStyle(fontSize: 12)),
                      ),
                      DataCell(
                        Text(h['masuk'], style: const TextStyle(fontSize: 12)),
                      ),
                      DataCell(
                        Text(h['keluar'], style: const TextStyle(fontSize: 12)),
                      ),
                      DataCell(
                        Text(
                          FormatHelper.formatRupiah(h['biaya']),
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: AppColors.primary,
                          ),
                        ),
                      ),
                      DataCell(
                        Text(
                          tanggalFormatted,
                          style: const TextStyle(fontSize: 12),
                        ),
                      ),
                    ],
                  );
                }),
              ),
            ),
        ],
      ),
    );
  }
}
