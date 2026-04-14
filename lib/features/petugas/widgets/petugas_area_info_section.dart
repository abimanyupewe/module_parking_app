import 'package:flutter/material.dart';
import '../../../config/colors.dart';
import '../../../services/database_helper.dart';
import '../../../models/area_parkir_model.dart';

/// Petugas Area Info Section - Menampilkan informasi sisa slot parkir
class PetugasAreaInfoSection extends StatefulWidget {
  const PetugasAreaInfoSection({super.key});

  @override
  State<PetugasAreaInfoSection> createState() => _PetugasAreaInfoSectionState();
}

class _PetugasAreaInfoSectionState extends State<PetugasAreaInfoSection> {
  final _databaseHelper = DatabaseHelper();

  List<AreaParkirModel> _areaData = [];
  bool _isLoading = true;
  String? _errorMessage;

  String _selectedCategory = 'Semua';
  final List<String> _categories = ['Semua', 'Motor', 'Mobil', 'Bus'];

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

      if (mounted) {
        setState(() {
          _areaData = areaData;
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
        .where((area) => area.namaArea.contains(_selectedCategory))
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
          SizedBox(
            height: 110,
            child: _isLoading
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
                : ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: _filteredAreas.length,
                    itemBuilder: (context, index) {
                      final area = _filteredAreas[index];
                      final available = area.sisaKapasitas;
                      final capacity = area.kapasitas;
                      final percentage = (available / capacity * 100)
                          .toStringAsFixed(0);
                      final isWarning = available < capacity * 0.2;

                      return Container(
                        width: 160,
                        margin: EdgeInsets.only(
                          right: index != _filteredAreas.length - 1 ? 12 : 0,
                        ),
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: isWarning
                              ? AppColors.danger.withValues(alpha: 0.1)
                              : AppColors.secondary.withValues(alpha: 0.3),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: isWarning
                                ? AppColors.danger.withValues(alpha: 0.3)
                                : AppColors.tertiary,
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Name with category
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  area.namaArea,
                                  style: const TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.primary,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                Text(
                                  _getCategoryFromId(area.idJenis),
                                  style: TextStyle(
                                    fontSize: 10,
                                    fontWeight: FontWeight.w400,
                                    color: Colors.grey[500],
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 6),
                            // Progress bar
                            ClipRRect(
                              borderRadius: BorderRadius.circular(3),
                              child: LinearProgressIndicator(
                                value: available / capacity,
                                minHeight: 5,
                                backgroundColor: AppColors.tertiary,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  isWarning
                                      ? AppColors.danger
                                      : AppColors.success,
                                ),
                              ),
                            ),
                            const SizedBox(height: 5),
                            // Count - compact format
                            Text(
                              '$available/$capacity ($percentage%)',
                              style: const TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w500,
                                color: AppColors.inactive,
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  /// Get category name from jenis_id
  /// Note: This is a simple mapping. In production, you might want to fetch
  /// jenis_kendaraan data from database if needed
  String _getCategoryFromId(int idJenis) {
    // Map based on typical IDs - adjust based on your actual data
    switch (idJenis) {
      case 1:
        return 'Motor';
      case 2:
        return 'Mobil';
      case 3:
        return 'Bus';
      default:
        return 'Lainnya';
    }
  }
}
