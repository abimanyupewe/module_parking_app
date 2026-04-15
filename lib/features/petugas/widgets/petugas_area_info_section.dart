import 'package:flutter/material.dart';
import '../../../config/colors.dart';
import '../../../services/database_helper.dart';
import '../../../models/area_parkir_model.dart';
import '../../../models/jenis_kendaraan_model.dart';

/// Petugas Area Info Section - Menampilkan informasi sisa slot parkir
class PetugasAreaInfoSection extends StatefulWidget {
  const PetugasAreaInfoSection({super.key});

  @override
  State<PetugasAreaInfoSection> createState() => _PetugasAreaInfoSectionState();
}

class _PetugasAreaInfoSectionState extends State<PetugasAreaInfoSection> {
  final _databaseHelper = DatabaseHelper();

  List<AreaParkirModel> _areaData = [];
  Map<int, String> _jenisKendaraanMap = {};
  bool _isLoading = true;
  String? _errorMessage;

  String _selectedCategory = 'Semua';
  List<String> _categories = ['Semua'];

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    try {
      setState(() {
        _isLoading = true;
        _errorMessage = null;
      });

      final areaData = await _databaseHelper.getAllAreaParkir();
      final jenisData = await _databaseHelper.getAllJenisKendaraan();

      if (mounted) {
        setState(() {
          _areaData = areaData;
          _jenisKendaraanMap = {
            for (var j in jenisData) j.idJenis!: j.namaJenis,
          };
          _categories = [
            'Semua',
            ...jenisData.map((j) => j.namaJenis).toList(),
          ];
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _errorMessage = 'Error loading data: $e';
          _isLoading = false;
        });
      }
    }
  }

  /// Get filtered areas based on selected category
  List<AreaParkirModel> get _filteredAreas {
    if (_selectedCategory == 'Semua') {
      return _areaData;
    }
    return _areaData
        .where((area) => _jenisKendaraanMap[area.idJenis] == _selectedCategory)
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      color: AppColors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title
          Text(
            'Informasi Area Parkir',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 12),

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
                    },
                    backgroundColor: Colors.transparent,
                    selectedColor: AppColors.primary.withValues(alpha: 0.2),
                    side: BorderSide(
                      color: isSelected ? AppColors.primary : AppColors.border,
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
          const SizedBox(height: 12),

          // Area cards
          _isLoading
              ? const Center(child: CircularProgressIndicator())
              : _errorMessage != null
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.error_outline,
                        color: AppColors.danger,
                        size: 32,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        _errorMessage!,
                        style: const TextStyle(
                          color: AppColors.danger,
                          fontSize: 12,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                )
              : _filteredAreas.isEmpty
              ? Center(
                  child: Text(
                    'Tidak ada area untuk kategori ini',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                )
              : SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: List.generate(_filteredAreas.length, (index) {
                      final area = _filteredAreas[index];
                      final occupied = area.terisi;
                      final total = area.kapasitas;
                      final vehicleType =
                          _jenisKendaraanMap[area.idJenis] ?? 'Unknown';

                      // Determine color based on percentage
                      late Color color;
                      final percentage = total > 0
                          ? (occupied / total) * 100
                          : 0.0;
                      if (percentage >= 80) {
                        color = AppColors.danger;
                      } else if (percentage >= 50) {
                        color = AppColors.warning;
                      } else {
                        color = AppColors.success;
                      }

                      return Padding(
                        padding: EdgeInsets.only(
                          right: index != _filteredAreas.length - 1 ? 12 : 0,
                        ),
                        child: Container(
                          width: 250,
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            border: Border.all(color: AppColors.border),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          area.namaArea,
                                          style: const TextStyle(
                                            fontSize: 13,
                                            fontWeight: FontWeight.w600,
                                          ),
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        Text(
                                          vehicleType,
                                          style: TextStyle(
                                            fontSize: 11,
                                            fontWeight: FontWeight.w400,
                                            color: Colors.grey[600],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Text(
                                    '$occupied / $total',
                                    style: const TextStyle(
                                      fontSize: 12,
                                      color: AppColors.inactive,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              ClipRRect(
                                borderRadius: BorderRadius.circular(4),
                                child: LinearProgressIndicator(
                                  value: total > 0 ? occupied / total : 0,
                                  minHeight: 6,
                                  backgroundColor: color.withValues(alpha: 0.2),
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    color,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 6),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    '${percentage.toStringAsFixed(1)}% terisi',
                                    style: const TextStyle(
                                      fontSize: 11,
                                      color: AppColors.inactive,
                                    ),
                                  ),
                                  Text(
                                    'Sisa: ${area.sisaKapasitas}',
                                    style: TextStyle(
                                      fontSize: 11,
                                      color: color,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    }),
                  ),
                ),
        ],
      ),
    );
  }
}
