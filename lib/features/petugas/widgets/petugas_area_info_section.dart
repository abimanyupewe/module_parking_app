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
    {'name': 'Blok A', 'available': 45, 'capacity': 50},
    {'name': 'Blok B', 'available': 12, 'capacity': 30},
    {'name': 'Blok C', 'available': 8, 'capacity': 10},
  ];

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
          const SizedBox(height: 16),
          // Area cards
          SizedBox(
            height: 100,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: _areaData.length,
              itemBuilder: (context, index) {
                final area = _areaData[index];
                final percentage = (area['available'] / area['capacity'] * 100)
                    .toStringAsFixed(0);
                final isWarning = area['available'] < area['capacity'] * 0.2;

                return Container(
                  width: 150,
                  margin: EdgeInsets.only(
                    right: index != _areaData.length - 1 ? 12 : 0,
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
                      // Name only
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
                      const SizedBox(height: 8),
                      // Progress bar
                      ClipRRect(
                        borderRadius: BorderRadius.circular(3),
                        child: LinearProgressIndicator(
                          value: area['available'] / area['capacity'],
                          minHeight: 5,
                          backgroundColor: AppColors.tertiary,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            isWarning ? AppColors.danger : AppColors.success,
                          ),
                        ),
                      ),
                      const SizedBox(height: 6),
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
