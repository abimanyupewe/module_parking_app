import 'package:flutter/material.dart';
import 'dart:io';
import '../../../config/colors.dart';
import '../../../services/format_helper.dart';
import '../../../services/database_helper.dart';
import '../../../services/csv_service.dart';
import '../../../services/pdf_service.dart';

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
      builder: (context) => AlertDialog(
        title: const Text('Pilih Format Export'),
        content: const Text('Pilih format file untuk mengekspor data:'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal'),
          ),
          ElevatedButton.icon(
            onPressed: () {
              Navigator.pop(context);
              _exportToCSV();
            },
            icon: const Icon(Icons.download),
            label: const Text('CSV'),
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary),
          ),
          ElevatedButton.icon(
            onPressed: () {
              Navigator.pop(context);
              _exportToPDFFormat();
            },
            icon: const Icon(Icons.picture_as_pdf),
            label: const Text('PDF'),
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary),
          ),
        ],
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
                                  'Foto',
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
                              final namaJenis =
                                  item['nama_jenis'] as String? ?? '';
                              final merk = item['merk'] as String? ?? '';
                              final waktuMasuk =
                                  item['waktu_masuk'] as String? ?? '';
                              final waktuKeluar =
                                  item['waktu_keluar'] as String?;
                              final imagePath = item['image_path'] as String?;

                              return DataRow(
                                cells: [
                                  DataCell(Text('${index + 1}')),
                                  DataCell(
                                    imagePath != null && imagePath.isNotEmpty
                                        ? Container(
                                            margin: const EdgeInsets.symmetric(
                                              vertical: 4,
                                            ),
                                            width: 50,
                                            height: 50,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                              border: Border.all(
                                                color: Colors.grey.shade300,
                                              ),
                                              image: DecorationImage(
                                                image: FileImage(
                                                  File(imagePath),
                                                ),
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                          )
                                        : Container(
                                            margin: const EdgeInsets.symmetric(
                                              vertical: 4,
                                            ),
                                            width: 50,
                                            height: 50,
                                            decoration: BoxDecoration(
                                              color: Colors.grey.shade200,
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                              border: Border.all(
                                                color: Colors.grey.shade300,
                                              ),
                                            ),
                                            child: const Icon(
                                              Icons.directions_car,
                                              color: Colors.grey,
                                            ),
                                          ),
                                  ),
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
                                          ? FormatHelper.formatFullDate(
                                              DateTime.parse(waktuMasuk),
                                            )
                                          : '-',
                                      style: const TextStyle(fontSize: 12),
                                    ),
                                  ),
                                  DataCell(
                                    Text(
                                      waktuKeluar != null &&
                                              waktuKeluar.isNotEmpty
                                          ? FormatHelper.formatFullDate(
                                              DateTime.parse(waktuKeluar),
                                            )
                                          : '-',
                                      style: TextStyle(
                                        fontSize: 12,
                                        color:
                                            waktuKeluar == null ||
                                                waktuKeluar.isEmpty
                                            ? Colors.orange
                                            : Colors.green,
                                        fontWeight:
                                            waktuKeluar == null ||
                                                waktuKeluar.isEmpty
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
