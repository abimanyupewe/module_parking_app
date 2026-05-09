import 'package:flutter/material.dart';
import '../../../services/database_helper.dart';
import '../../../services/csv_service.dart';
import '../../../services/pdf_service.dart';
import '../widgets/history/adminHistoryHeader.dart';
import '../widgets/history/adminHistorySearchField.dart';
import '../widgets/history/adminHistoryCategoryFilter.dart';
import '../widgets/history/adminHistoryDataTable.dart';
import '../widgets/history/adminHistoryExportDialog.dart';

/// Admin History Page - Menampilkan riwayat kendaraan dengan filter dan search
class AdminHistoryPage extends StatefulWidget {
  const AdminHistoryPage({super.key});

  @override
  State<AdminHistoryPage> createState() => _AdminHistoryPageState();
}

class _AdminHistoryPageState extends State<AdminHistoryPage> {
  final _databaseHelper = DatabaseHelper();
  late List<Map<String, dynamic>> _allData = [];
  late List<Map<String, dynamic>> _filteredData = [];
  late List<String> _categories = ['Semua'];
  bool _isLoading = false;
  String _searchQuery = '';
  String _selectedCategory = 'Semua';

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

      // Get all jenis kendaraan for categories
      final jenisData = await _databaseHelper.getAllJenisKendaraan();
      final jenisNames = jenisData.map((j) => j.namaJenis).toList();

      if (mounted) {
        setState(() {
          _allData = transactions;
          _categories = ['Semua', ...jenisNames];
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
      final namaJenis = item['nama_jenis'] as String? ?? '';

      // Filter by category
      final categoryMatch =
          _selectedCategory == 'Semua' || namaJenis == _selectedCategory;

      // Filter by search query
      final searchMatch =
          query.isEmpty ||
          platNomor.toLowerCase().contains(query) ||
          merk.toLowerCase().contains(query);

      return categoryMatch && searchMatch;
    }).toList();
  }

  /// Filter dan search vehicles
  void _applyFiltersAndSearch() {
    setState(() {
      _filteredData = _filterAndSearchData(_allData);
    });
  }

  /// Export to PDF or CSV
  void _exportToPDF() {
    showDialog(
      context: context,
      builder: (dialogContext) => AdminHistoryExportDialog(
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
                  'Mengunduh ${_filteredData.length} data kendaraan sebagai CSV...',
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
                    'Berhasil mengunduh ${_filteredData.length} data kendaraan',
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
                  'Mengekspor ${_filteredData.length} data kendaraan ke PDF...',
                ),
              ),
            ],
          ),
          duration: const Duration(seconds: 2),
          backgroundColor: Colors.orange[600],
        ),
      );

      await PdfService.generateParkedVehiclesReport(vehicles: _filteredData);
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
                  AdminHistoryHeader(onExportPressed: _exportToPDF),
                  const SizedBox(height: 20),
                  Text(
                    'Total: ${_filteredData.length} kendaraan',
                    style: Theme.of(
                      context,
                    ).textTheme.bodySmall?.copyWith(color: Colors.grey[500]),
                  ),
                  const SizedBox(height: 16),

                  AdminHistorySearchField(
                    onChanged: (value) {
                      _searchQuery = value;
                      _applyFiltersAndSearch();
                    },
                  ),
                  const SizedBox(height: 16),

                  AdminHistoryCategoryFilter(
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

                  AdminHistoryDataTable(data: _filteredData),
                ],
              ),
            ),
    );
  }
}
