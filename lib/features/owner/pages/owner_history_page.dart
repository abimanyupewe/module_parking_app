import 'package:flutter/material.dart';
import '../../../services/database_helper.dart';
import '../../../services/csv_service.dart';
import '../../../services/pdf_service.dart';
import '../widgets/history/ownerHistoryHeader.dart';
import '../widgets/history/ownerHistorySearchField.dart';
import '../widgets/history/ownerHistoryCategoryFilter.dart';
import '../widgets/history/ownerHistoryDateFilterBar.dart';
import '../widgets/history/ownerHistoryDataTable.dart';
import '../widgets/history/ownerHistoryExportDialog.dart';

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

  /// Export to PDF or CSV
  void _exportToPDF() {
    showDialog(
      context: context,
      builder: (dialogContext) => OwnerHistoryExportDialog(
        onExportCsv: () {
          Navigator.pop(dialogContext);
          _exportToCSV();
        },
        onExportPdf: () {
          Navigator.pop(dialogContext);
          _exportToPDFFormat();
        },
      ),
    );
  }

  /// Export filtered data to CSV
  Future<void> _exportToCSV() async {
    try {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const Icon(Icons.downloading, color: Colors.white),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  'Mengunduh ${_filteredData.length} data parkir sebagai CSV...',
                ),
              ),
            ],
          ),
          duration: const Duration(seconds: 3),
          backgroundColor: Colors.blue[600],
        ),
      );

      await CsvService.generateTransactionCSV(transactions: _filteredData);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                const Icon(Icons.check_circle, color: Colors.white),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Berhasil mengunduh ${_filteredData.length} data parkir',
                  ),
                ),
              ],
            ),
            duration: const Duration(seconds: 2),
            backgroundColor: Colors.green[600],
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: $e'),
            backgroundColor: Colors.red[600],
          ),
        );
      }
    }
  }

  /// Export filtered data to PDF
  Future<void> _exportToPDFFormat() async {
    try {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const Icon(Icons.print, color: Colors.white),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  'Mengekspor ${_filteredData.length} data parkir ke PDF...',
                ),
              ),
            ],
          ),
          duration: const Duration(seconds: 2),
          backgroundColor: Colors.orange[600],
        ),
      );

      await PdfService.generateTransactionReport(
        transactions: _filteredData,
        reportTitle: 'LAPORAN TRANSAKSI PARKIR',
      );
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: $e'),
            backgroundColor: Colors.red[600],
          ),
        );
      }
    }
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
                  OwnerHistoryHeader(onExportPressed: _exportToPDF),
                  const SizedBox(height: 20),
                  Text(
                    'Total: ${_filteredData.length} kendaraan',
                    style: Theme.of(
                      context,
                    ).textTheme.bodySmall?.copyWith(color: Colors.grey[500]),
                  ),
                  const SizedBox(height: 16),

                  OwnerHistorySearchField(
                    onChanged: (value) {
                      _searchQuery = value;
                      _applyFiltersAndSearch();
                    },
                  ),
                  const SizedBox(height: 16),

                  OwnerHistoryCategoryFilter(
                    categories: _categories,
                    selectedCategory: _selectedCategory,
                    onSelected: (category) {
                      setState(() {
                        _selectedCategory = category;
                      });
                      _applyFiltersAndSearch();
                    },
                  ),
                  const SizedBox(height: 16),

                  OwnerHistoryDateFilterBar(
                    startDate: _startDate,
                    endDate: _endDate,
                    onSelectStartDate: _selectStartDate,
                    onSelectEndDate: _selectEndDate,
                    onResetFilter: _resetDateFilter,
                  ),
                  const SizedBox(height: 16),

                  OwnerHistoryDataTable(
                    data: _filteredData,
                    getJenisKendaraan: _getJenisKendaraan,
                  ),
                ],
              ),
            ),
    );
  }
}
