import 'package:flutter/material.dart';
import '../../../config/colors.dart';

/// Petugas Area Info Section - Menampilkan informasi sisa slot parkir
class PetugasAreaInfoSection extends StatefulWidget {
  const PetugasAreaInfoSection({super.key});

  @override
  State<PetugasAreaInfoSection> createState() => _PetugasAreaInfoSectionState();
}

class _PetugasAreaInfoSectionState extends State<PetugasAreaInfoSection> {
  // Mock data - nanti ganti dengan data dari DB
  final List<Map<String, dynamic>> _areaData = [
    {'name': 'Blok A', 'category': 'Motor', 'available': 45, 'capacity': 50},
    {'name': 'Blok B', 'category': 'Mobil', 'available': 12, 'capacity': 30},
    {'name': 'Blok C', 'category': 'Bus', 'available': 8, 'capacity': 10},
  ];

  String _selectedCategory = 'Semua';
  final List<String> _categories = ['Semua', 'Motor', 'Mobil', 'Bus'];

  /// Get filtered areas based on selected category
  List<Map<String, dynamic>> get _filteredAreas {
    if (_selectedCategory == 'Semua') {
      return _areaData;
    }
    return _areaData
        .where((area) => area['category'] == _selectedCategory)
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
            child: _filteredAreas.isEmpty
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
                      final percentage =
                          (area['available'] / area['capacity'] * 100)
                              .toStringAsFixed(0);
                      final isWarning =
                          area['available'] < area['capacity'] * 0.2;

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
                                  area['name'],
                                  style: const TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.primary,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                Text(
                                  area['category'],
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
                                value: area['available'] / area['capacity'],
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
                              '${area['available']}/${area['capacity']} ($percentage%)',
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
}
