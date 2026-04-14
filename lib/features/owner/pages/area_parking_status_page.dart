import 'package:flutter/material.dart';
import '../../../models/area_parkir_model.dart';
import '../widgets/home/area_status_section/area_parking_status_list.dart';

/// Full Page untuk menampilkan semua status area parkir
class AreaParkingStatusPage extends StatefulWidget {
  const AreaParkingStatusPage({Key? key}) : super(key: key);

  @override
  State<AreaParkingStatusPage> createState() => _AreaParkingStatusPageState();
}

class _AreaParkingStatusPageState extends State<AreaParkingStatusPage> {
  late List<AreaParkirModel> _areas = [];
  bool _isLoading = false;
  bool _hasMore = true;
  int _currentPage = 0;
  static const int _itemsPerPage = 10;

  @override
  void initState() {
    super.initState();
    _loadAreas();
  }

  /// Load area data (dengan pagination)
  Future<void> _loadAreas() async {
    if (_isLoading || !_hasMore) return;

    if (mounted) {
      setState(() {
        _isLoading = true;
      });
    }

    try {
      // Simulasi loading delay
      await Future.delayed(const Duration(milliseconds: 500));

      // Generate mock data
      final newAreas = _generateMockAreas(
        startIndex: _currentPage * _itemsPerPage,
        count: _itemsPerPage,
      );

      if (mounted) {
        setState(() {
          _areas.addAll(newAreas);
          _currentPage++;
          _isLoading = false;
          // Stop loading jika data sudah cukup (simulasi limit)
          if (_areas.length >= 50) {
            _hasMore = false;
          }
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

  /// Generate mock data area parkir
  List<AreaParkirModel> _generateMockAreas({
    required int startIndex,
    required int count,
  }) {
    final areas = <AreaParkirModel>[];
    final jenisArea = ['Motor', 'Mobil', 'Bus'];
    final lantai = ['Lantai 1', 'Lantai 2', 'Lantai 3', 'Basement'];

    for (int i = startIndex; i < startIndex + count; i++) {
      final jenis = jenisArea[i % jenisArea.length];
      final floor = lantai[i % lantai.length];
      final namaArea = '$floor $jenis';

      // Generate random capacity dan terisi
      final kapasitas = ((i % 3) + 1) * 50; // 50, 100, 150
      final terisi = (kapasitas * (0.3 + (i % 7) * 0.1)).toInt(); // 30-90%

      areas.add(
        AreaParkirModel(
          idArea: i + 1,
          namaArea: namaArea,
          idJenis: i % 3,
          kapasitas: kapasitas,
          terisi: terisi,
        ),
      );
    }

    return areas;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Status Area Parkir'), elevation: 0),
      body: AreaParkingStatusList(
        areas: _areas,
        onLoadMore: _loadAreas,
        isLoading: _isLoading,
        hasMore: _hasMore,
      ),
    );
  }
}
