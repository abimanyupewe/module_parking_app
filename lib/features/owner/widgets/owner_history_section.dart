import 'package:flutter/material.dart';
import '../../../config/colors.dart';
import '../../../services/database_helper.dart';
import '../../../services/format_helper.dart';
import '../../../services/pdf_service.dart';

/// Owner History Section - Global history dengan data table
class OwnerHistorySection extends StatefulWidget {
  const OwnerHistorySection({super.key});

  @override
  State<OwnerHistorySection> createState() => _OwnerHistorySectionState();
}

class _OwnerHistorySectionState extends State<OwnerHistorySection> {
  final _databaseHelper = DatabaseHelper();
  String _searchQuery = '';
  DateTime? _selectedDate;

  List<Map<String, dynamic>> _allHistory = [];
  List<Map<String, dynamic>> _filteredHistory = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadHistory();
  }

  Future<void> _loadHistory() async {
    try {
      setState(() {
        _isLoading = true;
      });

      final transactions = await _databaseHelper.getAllTransactions();

      if (mounted) {
        setState(() {
          _allHistory = transactions;
          _filteredHistory = _allHistory;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error: $e')));
      }
    }
  }

  void _filterHistory(String query) {
    setState(() {
      _searchQuery = query;
      _applyAllFilters();
    });
  }

  void _applyAllFilters() {
    _filteredHistory = _allHistory.where((item) {
      final platNomor = item['plat_nomor'] as String? ?? '';

      // Filter berdasarkan search query (plat nomor)
      if (!platNomor.toLowerCase().contains(_searchQuery.toLowerCase())) {
        return false;
      }

      // Filter berdasarkan tanggal
      if (_selectedDate != null) {
        final waktuMasukStr = item['waktu_masuk'] as String? ?? '';
        try {
          final itemDate = DateTime.parse(waktuMasukStr);
          if (itemDate.year != _selectedDate!.year ||
              itemDate.month != _selectedDate!.month ||
              itemDate.day != _selectedDate!.day) {
            return false;
          }
        } catch (e) {
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
    try {
      if (!mounted) return;

      final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: _selectedDate ?? DateTime.now(),
        firstDate: DateTime(2020),
        lastDate: DateTime.now().add(const Duration(days: 365)),
      );

      if (picked != null && mounted) {
        _onDateChanged(picked);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error memilih tanggal: $e')));
      }
    }
  }

  Future<void> _printHistory() async {
    try {
      await PdfService.generateTransactionReport(
        transactions: _filteredHistory,
        reportTitle: 'LAPORAN TRANSAKSI PARKIR',
      );
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error cetak laporan: $e'),
            backgroundColor: AppColors.danger,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final totalBiaya = _filteredHistory.fold<int>(0, (sum, item) {
      final biaya = item['total_biaya'] as int? ?? 0;
      return sum + biaya;
    });

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

          // Filter Row (Date Picker) - Icon Based
          Row(
            children: [
              // Date Picker Icon Button
              IconButton.filled(
                onPressed: _selectDate,
                icon: const Icon(Icons.calendar_today),
                style: IconButton.styleFrom(
                  backgroundColor: _selectedDate != null
                      ? AppColors.primary
                      : Colors.grey[300],
                  foregroundColor: _selectedDate != null
                      ? Colors.white
                      : Colors.grey[600],
                ),
                tooltip: _selectedDate != null
                    ? '${_selectedDate!.day}/${_selectedDate!.month}/${_selectedDate!.year}'
                    : 'Pilih Tanggal',
              ),
              const SizedBox(width: 8),
              // Date Display Badge
              if (_selectedDate != null)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(color: AppColors.primary, width: 1),
                  ),
                  child: Text(
                    '${_selectedDate!.day}/${_selectedDate!.month}/${_selectedDate!.year}',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: AppColors.primary,
                    ),
                  ),
                ),
              const Spacer(),
              // Clear Button
              if (_selectedDate != null)
                IconButton(
                  onPressed: _clearFilters,
                  icon: const Icon(Icons.close),
                  iconSize: 20,
                  style: IconButton.styleFrom(foregroundColor: Colors.red),
                  tooltip: 'Bersihkan Filter',
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
          if (_isLoading)
            const Center(child: CircularProgressIndicator())
          else if (_filteredHistory.isEmpty)
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
                ],
                rows: List.generate(_filteredHistory.length, (index) {
                  final h = _filteredHistory[index];
                  final platNomor = h['plat_nomor'] as String? ?? '';
                  final namaJenis = h['nama_jenis'] as String? ?? '';
                  final namaArea = h['nama_area'] as String? ?? '';
                  final waktuMasuk = h['waktu_masuk'] as String? ?? '';
                  final waktuKeluar = h['waktu_keluar'] as String?;
                  final totalBiaya = h['total_biaya'] as int? ?? 0;

                  return DataRow(
                    cells: [
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
                      DataCell(
                        Text(namaJenis, style: const TextStyle(fontSize: 12)),
                      ),
                      DataCell(
                        Text(namaArea, style: const TextStyle(fontSize: 12)),
                      ),
                      DataCell(
                        Text(waktuMasuk, style: const TextStyle(fontSize: 12)),
                      ),
                      DataCell(
                        Text(
                          waktuKeluar ?? '-',
                          style: const TextStyle(fontSize: 12),
                        ),
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
            ),
        ],
      ),
    );
  }
}

// CustomSearchBar widget import
class CustomSearchBar extends StatelessWidget {
  final String hintText;
  final Function(String) onChanged;
  final IconData prefixIcon;

  const CustomSearchBar({
    required this.hintText,
    required this.onChanged,
    required this.prefixIcon,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      decoration: InputDecoration(
        hintText: hintText,
        prefixIcon: Icon(prefixIcon),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 10,
        ),
      ),
      onChanged: onChanged,
    );
  }
}
