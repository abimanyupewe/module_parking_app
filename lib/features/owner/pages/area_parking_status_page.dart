import 'package:flutter/material.dart';
import '../../../models/area_parkir_model.dart';
import '../../../models/jenis_kendaraan_model.dart';
import '../../../services/database_helper.dart';
import '../../../config/constants.dart';
import '../widgets/home/area_status_section/area_parking_status_list.dart';

/// Full Page untuk menampilkan semua status area parkir dengan pagination dan filter
class AreaParkingStatusPage extends StatefulWidget {
  const AreaParkingStatusPage({super.key});

  @override
  State<AreaParkingStatusPage> createState() => _AreaParkingStatusPageState();
}

class _AreaParkingStatusPageState extends State<AreaParkingStatusPage> {
  late DatabaseHelper _dbHelper;
  List<AreaParkirModel> _areas = [];
  List<JenisKendaraanModel> _jenisKendaraanOptions = [];

  bool _isLoading = false;
  bool _hasMore = true;
  int _currentPage = 1;
  static const int _pageSize = 10;
  int? _selectedJenisId;
  int _totalCount = 0;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _dbHelper = DatabaseHelper();
    _loadJenisKendaraanOptions();
    _loadAreas();
  }

  /// Load jenis kendaraan options untuk dropdown filter
  Future<void> _loadJenisKendaraanOptions() async {
    try {
      final options = await _dbHelper.getAllJenisKendaraan();
      if (mounted) {
        setState(() {
          _jenisKendaraanOptions = options;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _errorMessage = 'Gagal memuat jenis kendaraan: $e';
        });
      }
    }
  }

  /// Load area parking data dengan pagination dan filter
  Future<void> _loadAreas() async {
    if (_isLoading || !_hasMore) return;

    if (mounted) {
      setState(() {
        _isLoading = true;
        _errorMessage = null;
      });
    }

    try {
      // Fetch area parking status
      final newAreasData = await _dbHelper.getAreaParkingStatus(
        page: _currentPage,
        pageSize: _pageSize,
        idJenis: _selectedJenisId,
      );

      // Fetch total count untuk pagination
      final totalCount = await _dbHelper.getAreaParkingCount(
        idJenis: _selectedJenisId,
      );

      // Convert raw data to AreaParkirModel
      final newAreas = newAreasData.map((data) {
        return AreaParkirModel(
          idArea: data[AppConstants.colAreaId] as int,
          namaArea: data[AppConstants.colNamaArea] as String,
          idJenis: data[AppConstants.colJenisId] as int,
          kapasitas: data[AppConstants.colKapasitas] as int,
          terisi: data[AppConstants.colTerisi] as int,
        );
      }).toList();

      if (mounted) {
        setState(() {
          if (_currentPage == 1) {
            // Reset jika ini halaman pertama (misal karena filter berubah)
            _areas = newAreas;
          } else {
            // Append untuk pagination
            _areas.addAll(newAreas);
          }

          _totalCount = totalCount;
          _currentPage++;
          _isLoading = false;

          // Check apakah masih ada data lebih
          _hasMore = _areas.length < _totalCount;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _errorMessage = 'Gagal memuat data area: $e';
          _isLoading = false;
        });
      }
    }
  }

  /// Reset pagination dan reload dengan filter baru
  Future<void> _resetAndReload() async {
    if (mounted) {
      setState(() {
        _areas = [];
        _currentPage = 1;
        _hasMore = true;
        _totalCount = 0;
      });
    }
    await _loadAreas();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Status Area Parkir'), elevation: 0),
      body: Column(
        children: [
          // Filter dropdown
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                const Text('Filter Jenis Kendaraan:'),
                const SizedBox(width: 12),
                Expanded(
                  child: DropdownButton<int?>(
                    value: _selectedJenisId,
                    isExpanded: true,
                    items: [
                      const DropdownMenuItem(value: null, child: Text('Semua')),
                      ..._jenisKendaraanOptions.map(
                        (jenis) => DropdownMenuItem(
                          value: jenis.idJenis,
                          child: Text(jenis.namaJenis),
                        ),
                      ),
                    ],
                    onChanged: (value) {
                      setState(() {
                        _selectedJenisId = value;
                      });
                      _resetAndReload();
                    },
                  ),
                ),
              ],
            ),
          ),
          // Pagination info
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              'Menampilkan ${_areas.isEmpty ? 0 : ((_currentPage - 2) * _pageSize) + 1}-${((_currentPage - 2) * _pageSize) + _areas.length} dari $_totalCount',
              style: const TextStyle(fontSize: 12, color: Colors.grey),
            ),
          ),
          const SizedBox(height: 8),
          // Error state
          if (_errorMessage != null)
            Padding(
              padding: const EdgeInsets.all(16),
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.red),
                  borderRadius: BorderRadius.circular(8),
                  color: Colors.red[50],
                ),
                child: Column(
                  children: [
                    Text(
                      _errorMessage ?? 'Terjadi kesalahan',
                      style: const TextStyle(color: Colors.red, fontSize: 12),
                    ),
                    const SizedBox(height: 8),
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          _errorMessage = null;
                        });
                        _resetAndReload();
                      },
                      child: const Text('Coba Lagi'),
                    ),
                  ],
                ),
              ),
            )
          else
            // Main list
            Expanded(
              child: _areas.isEmpty && !_isLoading
                  ? Center(
                      child: Text(
                        'Tidak ada data area parkir',
                        style: TextStyle(color: Colors.grey[600]),
                      ),
                    )
                  : AreaParkingStatusList(
                      areas: _areas,
                      onLoadMore: _loadAreas,
                      isLoading: _isLoading,
                      hasMore: _hasMore,
                    ),
            ),
        ],
      ),
    );
  }
}
