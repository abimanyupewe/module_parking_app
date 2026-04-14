import 'package:flutter/material.dart';
import '../../../config/colors.dart';
import '../../../models/kendaraan_model.dart';
import '../../../models/transaksi_model.dart';
import 'package:intl/intl.dart';

/// Admin History Page - Menampilkan riwayat kendaraan dengan filter dan search
class AdminHistoryPage extends StatefulWidget {
  const AdminHistoryPage({super.key});

  @override
  State<AdminHistoryPage> createState() => _AdminHistoryPageState();
}

class _AdminHistoryPageState extends State<AdminHistoryPage> {
  late List<KendaraanModel> _allVehicles = [];
  late List<TransaksiModel> _allTransaksi = [];
  late List<Map<String, dynamic>> _filteredData = [];
  bool _isLoading = false;
  String _searchQuery = '';
  String _selectedCategory = 'Semua';

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

      // Filter by category
      final categoryMatch =
          _selectedCategory == 'Semua' ||
          _getJenisKendaraan(vehicle.idJenis) == _selectedCategory;

      // Filter by search query
      final searchMatch =
          query.isEmpty ||
          vehicle.platNomor.toLowerCase().contains(query) ||
          vehicle.merk.toLowerCase().contains(query);

      return categoryMatch && searchMatch;
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
