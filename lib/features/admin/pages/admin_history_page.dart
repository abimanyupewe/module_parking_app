import 'package:flutter/material.dart';
import '../../../config/colors.dart';
import '../../../models/kendaraan_model.dart';

/// Admin History Page - Menampilkan riwayat kendaraan dengan filter dan search
class AdminHistoryPage extends StatefulWidget {
  const AdminHistoryPage({Key? key}) : super(key: key);

  @override
  State<AdminHistoryPage> createState() => _AdminHistoryPageState();
}

class _AdminHistoryPageState extends State<AdminHistoryPage> {
  late List<KendaraanModel> _allVehicles = [];
  late List<KendaraanModel> _filteredVehicles = [];
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

      if (mounted) {
        setState(() {
          _allVehicles = vehicles;
          _filteredVehicles = vehicles;
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
    final query = _searchQuery.toLowerCase();

    _filteredVehicles = _allVehicles.where((vehicle) {
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

    setState(() {});
  }

  /// Export to PDF
  void _exportToPDF() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Exporting to PDF...'),
        duration: Duration(seconds: 2),
      ),
    );
    // TODO: Implement actual PDF export using pdf package
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Riwayat Kendaraan'),
        elevation: 0,
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: IconButton(
              icon: const Icon(Icons.download),
              onPressed: _exportToPDF,
              tooltip: 'Export to PDF',
            ),
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title
                  Text(
                    'Daftar Semua Kendaraan Terdaftar',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Total: ${_filteredVehicles.length} kendaraan',
                    style: Theme.of(context).textTheme.bodySmall,
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
                    child: _filteredVehicles.isEmpty
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
                                  'Warna',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ),
                            ],
                            rows: List<DataRow>.generate(
                              _filteredVehicles.length,
                              (index) {
                                final vehicle = _filteredVehicles[index];
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
                                          borderRadius: BorderRadius.circular(
                                            6,
                                          ),
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
                                    DataCell(Text(vehicle.warna)),
                                  ],
                                );
                              },
                            ),
                          ),
                  ),
                ],
              ),
            ),
    );
  }
}
