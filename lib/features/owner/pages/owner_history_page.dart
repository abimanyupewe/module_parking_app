import 'package:flutter/material.dart';
import '../../../config/colors.dart';
import '../../../models/kendaraan_model.dart';
import '../../../models/transaksi_model.dart';
import 'package:intl/intl.dart';

/// Owner History Page - Menampilkan riwayat parkir dengan filter dan search
class OwnerHistoryPage extends StatefulWidget {
  const OwnerHistoryPage({super.key});

  @override
  State<OwnerHistoryPage> createState() => _OwnerHistoryPageState();
}

class _OwnerHistoryPageState extends State<OwnerHistoryPage> {
  late List<KendaraanModel> _allVehicles = [];
  late List<TransaksiModel> _allTransaksi = [];
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
    _loadVehicles();
  }

  /// Load vehicle data
  Future<void> _loadVehicles() async {
    if (_isLoading) return;

    if (mounted) {
      setState(() {
        _isLoading = true;
      });
    }

    try {
      // Simulasi loading delay
      await Future.delayed(const Duration(milliseconds: 500));

      // Generate mock data
      final vehicles = _generateMockVehicles();
      final transaksi = _generateMockTransaksi();

      if (mounted) {
        setState(() {
          _allVehicles = vehicles;
          _allTransaksi = transaksi;
          _filteredData = _combinedData();
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

  /// Generate mock vehicle data
  List<KendaraanModel> _generateMockVehicles() {
    final vehicles = <KendaraanModel>[];
    final merk = [
      'Honda Vario',
      'Toyota Avanza',
      'Yamaha Nmax',
      'Daihatsu Xenia',
      'Suzuki Carry',
    ];

    for (int i = 0; i < 15; i++) {
      final jenisIdx = i % 3;
      vehicles.add(
        KendaraanModel(
          idKendaraan: i + 1,
          platNomor: 'AB ${1000 + i} CD',
          idJenis: jenisIdx,
          merk: merk[i % merk.length],
          warna: 'Hitam',
        ),
      );
    }

    return vehicles;
  }

  /// Generate mock transaksi data
  List<TransaksiModel> _generateMockTransaksi() {
    final transaksi = <TransaksiModel>[];
    final now = DateTime.now();

    for (int i = 0; i < 15; i++) {
      final waktuMasuk = now.subtract(Duration(hours: 24 - i));
      final waktuKeluar = i < 10
          ? waktuMasuk.add(Duration(hours: 2 + i))
          : null;

      transaksi.add(
        TransaksiModel(
          idTransaksi: i + 1,
          idKendaraan: i + 1,
          idArea: (i % 3) + 1,
          waktuMasuk: waktuMasuk,
          waktuKeluar: waktuKeluar,
          status: waktuKeluar != null ? 'Selesai' : 'Parkir',
          totalBiaya: waktuKeluar != null ? (10000 + (i * 5000)) : null,
          idUser: 1,
        ),
      );
    }

    return transaksi;
  }

  /// Combine vehicle and transaksi data
  List<Map<String, dynamic>> _combinedData() {
    final combined = <Map<String, dynamic>>[];

    for (final transaksi in _allTransaksi) {
      final vehicle = _allVehicles.firstWhere(
        (v) => v.idKendaraan == transaksi.idKendaraan,
        orElse: () => KendaraanModel(
          idKendaraan: 0,
          platNomor: 'N/A',
          idJenis: 0,
          merk: 'N/A',
          warna: 'N/A',
        ),
      );

      combined.add({'vehicle': vehicle, 'transaksi': transaksi});
    }

    return _filterAndSearchData(combined);
  }

  /// Filter and search combined data
  List<Map<String, dynamic>> _filterAndSearchData(
    List<Map<String, dynamic>> data,
  ) {
    final query = _searchQuery.toLowerCase();

    return data.where((item) {
      final vehicle = item['vehicle'] as KendaraanModel;
      final transaksi = item['transaksi'] as TransaksiModel;

      // Filter by category
      final categoryMatch =
          _selectedCategory == 'Semua' ||
          _getJenisKendaraan(vehicle.idJenis) == _selectedCategory;

      // Filter by search query
      final searchMatch =
          query.isEmpty ||
          vehicle.platNomor.toLowerCase().contains(query) ||
          vehicle.merk.toLowerCase().contains(query);

      // Filter by date range
      bool dateMatch = true;
      if (_startDate != null) {
        final startOfDay = DateTime(
          _startDate!.year,
          _startDate!.month,
          _startDate!.day,
        );
        dateMatch =
            transaksi.waktuMasuk.isAfter(startOfDay) ||
            transaksi.waktuMasuk.day == startOfDay.day &&
                transaksi.waktuMasuk.month == startOfDay.month &&
                transaksi.waktuMasuk.year == startOfDay.year;
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
            transaksi.waktuMasuk.isBefore(endOfDay) ||
            transaksi.waktuMasuk.day == endOfDay.day &&
                transaksi.waktuMasuk.month == endOfDay.month &&
                transaksi.waktuMasuk.year == endOfDay.year;
      }

      return categoryMatch && searchMatch && dateMatch;
    }).toList();
  }

  /// Get jenis kendaraan string
  String _getJenisKendaraan(int idJenis) {
    switch (idJenis) {
      case 0:
        return 'Motor';
      case 1:
        return 'Mobil';
      case 2:
        return 'Bus';
      default:
        return 'Lainnya';
    }
  }

  /// Filter dan search vehicles
  void _applyFiltersAndSearch() {
    setState(() {
      _filteredData = _combinedData();
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
    // TODO: Implement actual PDF export using pdf package
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
                              final vehicle = item['vehicle'] as KendaraanModel;
                              final transaksi =
                                  item['transaksi'] as TransaksiModel;

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
                                        vehicle.platNomor,
                                        style: const TextStyle(
                                          fontWeight: FontWeight.w600,
                                          fontSize: 12,
                                        ),
                                      ),
                                    ),
                                  ),
                                  DataCell(
                                    Text(_getJenisKendaraan(vehicle.idJenis)),
                                  ),
                                  DataCell(Text(vehicle.merk)),
                                  DataCell(
                                    Text(
                                      DateFormat(
                                        'dd/MM/yyyy HH:mm',
                                      ).format(transaksi.waktuMasuk),
                                      style: const TextStyle(fontSize: 12),
                                    ),
                                  ),
                                  DataCell(
                                    Text(
                                      transaksi.waktuKeluar != null
                                          ? DateFormat(
                                              'dd/MM/yyyy HH:mm',
                                            ).format(transaksi.waktuKeluar!)
                                          : '-',
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: transaksi.waktuKeluar == null
                                            ? Colors.orange
                                            : Colors.green,
                                        fontWeight:
                                            transaksi.waktuKeluar == null
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
