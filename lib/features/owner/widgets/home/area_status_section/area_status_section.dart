import 'package:flutter/material.dart';
import '../../../../../config/colors.dart';
import '../../../../../models/area_parkir_model.dart';
import '../../../../../services/database_helper.dart';
import '../../../pages/area_parking_status_page.dart';
import 'area_status_item.dart';

/// Area Status Section - Displays top 3 parking areas by occupancy from database
class AreaStatusSection extends StatefulWidget {
  const AreaStatusSection({super.key});

  @override
  State<AreaStatusSection> createState() => _AreaStatusSectionState();
}

class _AreaStatusSectionState extends State<AreaStatusSection> {
  final _dbHelper = DatabaseHelper();

  List<AreaParkirModel> _topAreas = [];
  bool _isLoading = true;
  String? _errorMessage;

  // Colors for progress indicators
  static const List<Color> _colors = [
    AppColors.primary,
    AppColors.warning,
    AppColors.success,
  ];

  @override
  void initState() {
    super.initState();
    _loadTopAreas();
  }

  Future<void> _loadTopAreas() async {
    try {
      setState(() {
        _isLoading = true;
        _errorMessage = null;
      });

      final areas = await _dbHelper.getTopAreasByOccupancy(limit: 3);

      if (mounted) {
        setState(() {
          _topAreas = areas;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _errorMessage = 'Error loading areas: $e';
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Status Area Parkir',
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const AreaParkingStatusPage(),
                  ),
                );
              },
              child: const Text('Lihat Semua'),
            ),
          ],
        ),
        const SizedBox(height: 12),
        if (_isLoading)
          Column(
            children: [
              Container(
                height: 80,
                decoration: BoxDecoration(
                  color: AppColors.tertiary,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Center(child: CircularProgressIndicator()),
              ),
              const SizedBox(height: 12),
              Container(
                height: 80,
                decoration: BoxDecoration(
                  color: AppColors.tertiary,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Center(child: CircularProgressIndicator()),
              ),
              const SizedBox(height: 12),
              Container(
                height: 80,
                decoration: BoxDecoration(
                  color: AppColors.tertiary,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Center(child: CircularProgressIndicator()),
              ),
            ],
          )
        else if (_errorMessage != null)
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.danger.withValues(alpha: 0.1),
              border: Border.all(color: AppColors.danger),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                const Icon(Icons.error_outline, color: AppColors.danger),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    _errorMessage!,
                    style: const TextStyle(color: AppColors.danger),
                  ),
                ),
                TextButton(
                  onPressed: _loadTopAreas,
                  child: const Text('Retry'),
                ),
              ],
            ),
          )
        else if (_topAreas.isEmpty)
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.tertiary,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Center(child: Text('Tidak ada area parkir')),
          )
        else
          Column(
            children: [
              for (int i = 0; i < _topAreas.length; i++)
                Padding(
                  padding: EdgeInsets.only(
                    bottom: i < _topAreas.length - 1 ? 12 : 0,
                  ),
                  child: AreaStatusItem(
                    name: _topAreas[i].namaArea,
                    occupied: _topAreas[i].terisi,
                    total: _topAreas[i].kapasitas,
                    color: _colors[i % _colors.length],
                  ),
                ),
            ],
          ),
      ],
    );
  }
}
