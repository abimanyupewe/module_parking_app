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
  int? _selectedMonth; // null = semua bulan
  int? _selectedDay; // null = semua hari

  final List<String> _months = [
    'Januari',
    'Februari',
    'Maret',
    'April',
    'Mei',
    'Juni',
    'Juli',
    'Agustus',
    'September',
    'Oktober',
    'November',
    'Desember',
  ];

  final List<int> _days = List.generate(31, (index) => index + 1);

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

      // Filter berdasarkan bulan
      if (_selectedMonth != null) {
        if (item['tanggal'].month != _selectedMonth) {
          return false;
        }
      }

      // Filter berdasarkan hari/tanggal
      if (_selectedDay != null) {
        if (item['tanggal'].day != _selectedDay) {
          return false;
        }
      }

      return true;
    }).toList();
  }

  void _clearFilters() {
    setState(() {
      _selectedMonth = null;
      _selectedDay = null;
      _searchQuery = '';
      _filteredHistory = _allHistory;
    });
  }

  void _onMonthChanged(int? value) {
    setState(() {
      _selectedMonth = value;
      _applyAllFilters();
    });
  }

  void _onDayChanged(int? value) {
    setState(() {
      _selectedDay = value;
      _applyAllFilters();
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

          // Filter Row (Bulan, Hari, Clear)
          Row(
            children: [
              // Filter Bulan
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Bulan',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: AppColors.primary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: AppColors.tertiary),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: DropdownButton<int?>(
                        isExpanded: true,
                        underline: const SizedBox(),
                        value: _selectedMonth,
                        hint: const Text('Semua Bulan'),
                        items: [
                          const DropdownMenuItem<int?>(
                            value: null,
                            child: Padding(
                              padding: EdgeInsets.symmetric(horizontal: 12),
                              child: Text('Semua Bulan'),
                            ),
                          ),
                          ..._months.asMap().entries.map((entry) {
                            return DropdownMenuItem<int?>(
                              value: entry.key + 1,
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                ),
                                child: Text(entry.value),
                              ),
                            );
                          }),
                        ],
                        onChanged: _onMonthChanged,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),

              // Filter Hari
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Tanggal',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: AppColors.primary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: AppColors.tertiary),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: DropdownButton<int?>(
                        isExpanded: true,
                        underline: const SizedBox(),
                        value: _selectedDay,
                        hint: const Text('Semua Tanggal'),
                        items: [
                          const DropdownMenuItem<int?>(
                            value: null,
                            child: Padding(
                              padding: EdgeInsets.symmetric(horizontal: 12),
                              child: Text('Semua Tanggal'),
                            ),
                          ),
                          ..._days.map((day) {
                            return DropdownMenuItem<int?>(
                              value: day,
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                ),
                                child: Text('$day'),
                              ),
                            );
                          }),
                        ],
                        onChanged: _onDayChanged,
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
                  _searchQuery.isEmpty &&
                          _selectedMonth == null &&
                          _selectedDay == null
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
