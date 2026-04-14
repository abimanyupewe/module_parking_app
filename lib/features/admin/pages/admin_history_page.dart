import 'package:flutter/material.dart';
import '../../../config/colors.dart';
import '../../../models/kendaraan_model.dart';

/// Admin History Page - Menampilkan riwayat kendaraan dalam DataTable
class AdminHistoryPage extends StatefulWidget {
  const AdminHistoryPage({Key? key}) : super(key: key);

  @override
  State<AdminHistoryPage> createState() => _AdminHistoryPageState();
}

class _AdminHistoryPageState extends State<AdminHistoryPage> {
  late List<KendaraanModel> _vehicles = [];
  bool _isLoading = false;

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
          _vehicles = vehicles;
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Riwayat Kendaraan'), elevation: 0),
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
                    'Total: ${_vehicles.length} kendaraan',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  const SizedBox(height: 16),

                  // Data Table
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: DataTable(
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
                      rows: List<DataRow>.generate(_vehicles.length, (index) {
                        final vehicle = _vehicles[index];
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
                            DataCell(Text(_getJenisKendaraan(vehicle.idJenis))),
                            DataCell(Text(vehicle.merk)),
                            DataCell(Text(vehicle.warna)),
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
