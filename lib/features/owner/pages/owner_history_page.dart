import 'package:flutter/material.dart';
import '../../../config/colors.dart';
import '../../../services/database_helper.dart';
import 'package:intl/intl.dart';

/// Owner History Page - Menampilkan riwayat parkir dengan filter dan search
class OwnerHistoryPage extends StatefulWidget {
  const OwnerHistoryPage({super.key});

  @override
  State<OwnerHistoryPage> createState() => _OwnerHistoryPageState();
}

class _OwnerHistoryPageState extends State<OwnerHistoryPage> {
  final _databaseHelper = DatabaseHelper();
  late List<Map<String, dynamic>> _allData = [];
  late List<Map<String, dynamic>> _filteredData = [];
  bool _isLoading = false;
  String _searchQuery = '';
  String _selectedCategory = 'Semua';
  DateTime? _startDate;
  DateTime? _endDate;

  final List<String> _categories = ['Semua', 'Motor', 'Mobil', 'Bus'];

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  /// Load transaction data from database
  Future<void> _loadData() async {
    if (_isLoading) return;

    if (mounted) {
      setState(() {
        _isLoading = true;
      });
    }

    try {
      // Get all transactions from database
      final transactions = await _databaseHelper.getAllTransactions();

      if (mounted) {
        setState(() {
          _allData = transactions;
          _filteredData = _filterAndSearchData(_allData);
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

  /// Filter and search combined data
  List<Map<String, dynamic>> _filterAndSearchData(
    List<Map<String, dynamic>> data,
  ) {
    final query = _searchQuery.toLowerCase();

    return data.where((item) {
      final platNomor = item['plat_nomor'] as String? ?? '';
      final merk = item['merk'] as String? ?? '';
      final jenisId = item['id_jenis'] as int? ?? 0;
      final waktuMasukStr = item['waktu_masuk'] as String? ?? '';

      // Filter by category
      final categoryMatch =
          _selectedCategory == 'Semua' ||
          _getJenisKendaraan(jenisId) == _selectedCategory;

      // Filter by search query
      final searchMatch =
          query.isEmpty ||
          platNomor.toLowerCase().contains(query) ||
          merk.toLowerCase().contains(query);

      // Filter by date range
      bool dateMatch = true;
      try {
        final waktuMasuk = DateTime.parse(waktuMasukStr);

        if (_startDate != null) {
          final startOfDay = DateTime(
            _startDate!.year,
            _startDate!.month,
            _startDate!.day,
          );
          dateMatch =
              waktuMasuk.isAfter(startOfDay) ||
              (waktuMasuk.day == startOfDay.day &&
                  waktuMasuk.month == startOfDay.month &&
                  waktuMasuk.year == startOfDay.year);
        }

        if (_endDate != null && dateMatch) {
          final endOfDay = DateTime(
            _endDate!.year,
            _endDate!.month,
            _endDate!.day,
            23,
            59,
            59,
          );
          dateMatch =
              waktuMasuk.isBefore(endOfDay) ||
              (waktuMasuk.day == endOfDay.day &&
                  waktuMasuk.month == endOfDay.month &&
                  waktuMasuk.year == endOfDay.year);
        }
      } catch (e) {
        dateMatch = false;
      }

      return categoryMatch && searchMatch && dateMatch;
    }).toList();
  }

  /// Get jenis kendaraan string
  String _getJenisKendaraan(int idJenis) {
    switch (idJenis) {
      case 1:
        return 'Motor';
      case 2:
        return 'Mobil';
      case 3:
        return 'Bus';
      default:
        return 'Lainnya';
    }
  }

  /// Filter dan search vehicles
  void _applyFiltersAndSearch() {
    setState(() {
      _filteredData = _filterAndSearchData(_allData);
    });
  }

  /// Show date picker untuk start date
  Future<void> _selectStartDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _startDate ?? DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
      locale: const Locale('id', 'ID'),
    );
    if (picked != null) {
      setState(() {
        _startDate = picked;
      });
      _applyFiltersAndSearch();
    }
  }

  /// Show date picker untuk end date
  Future<void> _selectEndDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _endDate ?? DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
      locale: const Locale('id', 'ID'),
    );
    if (picked != null) {
      setState(() {
        _endDate = picked;
      });
      _applyFiltersAndSearch();
    }
  }

  /// Reset date filter
  void _resetDateFilter() {
    setState(() {
      _startDate = null;
      _endDate = null;
    });
    _applyFiltersAndSearch();
  }

  /// Export to PDF
  void _exportToPDF() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.check_circle, color: Colors.white),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                'Mengekspor ${_filteredData.length} data kendaraan ke PDF...',
              ),
            ),
          ],
        ),
        duration: const Duration(seconds: 2),
        backgroundColor: Colors.green[600],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header with Title and Export Button
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Riwayat Kendaraan',
                              style: Theme.of(context).textTheme.headlineSmall
                                  ?.copyWith(fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Daftar semua kendaraan terdaftar',
                              style: Theme.of(context).textTheme.bodyMedium
                                  ?.copyWith(color: Colors.grey[600]),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 16),
                      ElevatedButton.icon(
                        onPressed: _exportToPDF,
                        icon: const Icon(Icons.download),
                        label: const Text('Export'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 12,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'Total: ${_filteredData.length} kendaraan',
                    style: Theme.of(
                      context,
                    ).textTheme.bodySmall?.copyWith(color: Colors.grey[500]),
                  ),
                  const SizedBox(height: 16),

                  // Search Field
                  TextField(
                    decoration: InputDecoration(
                      hintText: 'Cari plat nomor atau merek...',
                      prefixIcon: const Icon(Icons.search),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 10,
                      ),
                    ),
                    onChanged: (value) {
                      _searchQuery = value;
                      _applyFiltersAndSearch();
                    },
                  ),
                  const SizedBox(height: 16),

                  // Category Filter
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: _categories.map((category) {
                        final isSelected = _selectedCategory == category;
                        return Padding(
                          padding: const EdgeInsets.only(right: 8),
                          child: FilterChip(
                            label: Text(category),
                            selected: isSelected,
                            onSelected: (selected) {
                              setState(() {
                                _selectedCategory = category;
                              });
                              _applyFiltersAndSearch();
                            },
                            backgroundColor: Colors.transparent,
                            selectedColor: AppColors.primary.withValues(
                              alpha: 0.2,
                            ),
                            side: BorderSide(
                              color: isSelected
                                  ? AppColors.primary
                                  : AppColors.border,
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Date Range Filter
                  Row(
                    children: [
                      // Start Date Filter
                      IconButton.filled(
                        onPressed: _selectStartDate,
                        icon: const Icon(Icons.calendar_today),
                        style: IconButton.styleFrom(
                          backgroundColor: _startDate != null
                              ? AppColors.primary
                              : Colors.grey[300],
                          foregroundColor: _startDate != null
                              ? Colors.white
                              : Colors.grey[600],
                        ),
                        tooltip: _startDate != null
                            ? DateFormat('dd/MM/yyyy').format(_startDate!)
                            : 'Tanggal Mulai',
                      ),
                      const SizedBox(width: 8),
                      // Start Date Display
                      if (_startDate != null)
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.primary.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(6),
                            border: Border.all(
                              color: AppColors.primary,
                              width: 1,
                            ),
                          ),
                          child: Text(
                            DateFormat('dd/MM/yy').format(_startDate!),
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: AppColors.primary,
                            ),
                          ),
                        ),
                      const SizedBox(width: 8),
                      // End Date Filter
                      IconButton.filled(
                        onPressed: _selectEndDate,
                        icon: const Icon(Icons.calendar_today),
                        style: IconButton.styleFrom(
                          backgroundColor: _endDate != null
                              ? AppColors.primary
                              : Colors.grey[300],
                          foregroundColor: _endDate != null
                              ? Colors.white
                              : Colors.grey[600],
                        ),
                        tooltip: _endDate != null
                            ? DateFormat('dd/MM/yyyy').format(_endDate!)
                            : 'Tanggal Akhir',
                      ),
                      const SizedBox(width: 8),
                      // End Date Display
                      if (_endDate != null)
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.primary.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(6),
                            border: Border.all(
                              color: AppColors.primary,
                              width: 1,
                            ),
                          ),
                          child: Text(
                            DateFormat('dd/MM/yy').format(_endDate!),
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: AppColors.primary,
                            ),
                          ),
                        ),
                      const Spacer(),
                      // Reset Button
                      if (_startDate != null || _endDate != null)
                        IconButton(
                          onPressed: _resetDateFilter,
                          icon: const Icon(Icons.close),
                          iconSize: 20,
                          style: IconButton.styleFrom(
                            foregroundColor: Colors.red,
                          ),
                          tooltip: 'Bersihkan Filter',
                        ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Data Table
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: _filteredData.isEmpty
                        ? Center(
                            child: Padding(
                              padding: const EdgeInsets.all(32),
                              child: Text(
                                'Tidak ada data kendaraan',
                                style: Theme.of(context).textTheme.bodyMedium,
                              ),
                            ),
                          )
                        : DataTable(
                            columns: const [
                              DataColumn(
                                label: Text(
                                  'No',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ),
                              DataColumn(
                                label: Text(
                                  'Plat Nomor',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ),
                              DataColumn(
                                label: Text(
                                  'Jenis',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ),
                              DataColumn(
                                label: Text(
                                  'Merek',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
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
                            rows: List<DataRow>.generate(_filteredData.length, (
                              index,
                            ) {
                              final item = _filteredData[index];
                              final platNomor =
                                  item['plat_nomor'] as String? ?? '';
                              final jenisId = item['id_jenis'] as int? ?? 0;
                              final merk = item['merk'] as String? ?? '';
                              final waktuMasuk =
                                  item['waktu_masuk'] as String? ?? '';
                              final waktuKeluar =
                                  item['waktu_keluar'] as String?;

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
                                  DataCell(Text(_getJenisKendaraan(jenisId))),
                                  DataCell(Text(merk)),
                                  DataCell(
                                    Text(
                                      waktuMasuk,
                                      style: const TextStyle(fontSize: 12),
                                    ),
                                  ),
                                  DataCell(
                                    Text(
                                      waktuKeluar ?? '-',
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: waktuKeluar == null
                                            ? Colors.orange
                                            : Colors.green,
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
                  ),
                ],
              ),
            ),
    );
  }
}
