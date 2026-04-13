import 'package:flutter/material.dart';
import '../../../config/colors.dart';
import '../../../widgets/widgets.dart';

/// Petugas Area Info Section - Menampilkan informasi sisa slot parkir
class PetugasAreaInfoSection extends StatefulWidget {
  const PetugasAreaInfoSection({Key? key}) : super(key: key);

  @override
  State<PetugasAreaInfoSection> createState() => _PetugasAreaInfoSectionState();
}

class _PetugasAreaInfoSectionState extends State<PetugasAreaInfoSection> {
  // Mock data - nanti ganti dengan data dari DB
  final List<Map<String, dynamic>> _areaData = [
    {
      'name': 'Blok A (Motor)',
      'available': 45,
      'capacity': 50,
      'icon': Icons.two_wheeler,
    },
    {
      'name': 'Blok B (Mobil)',
      'available': 12,
      'capacity': 30,
      'icon': Icons.directions_car,
    },
    {
      'name': 'Blok C (Truk)',
      'available': 8,
      'capacity': 10,
      'icon': Icons.local_shipping,
    },
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
            height: 140,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: _areaData.length,
              itemBuilder: (context, index) {
                final area = _areaData[index];
                final percentage = (area['available'] / area['capacity'] * 100)
                    .toStringAsFixed(0);
                final isWarning = area['available'] < area['capacity'] * 0.2;

                return Container(
                  width: 160,
                  margin: EdgeInsets.only(
                    right: index != _areaData.length - 1 ? 12 : 0,
                  ),
                  padding: const EdgeInsets.all(12),
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
                      // Icon & Name
                      Row(
                        children: [
                          Icon(
                            area['icon'],
                            color: AppColors.primary,
                            size: 24,
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              area['name'],
                              style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: AppColors.primary,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      // Progress bar
                      ClipRRect(
                        borderRadius: BorderRadius.circular(4),
                        child: LinearProgressIndicator(
                          value: area['available'] / area['capacity'],
                          minHeight: 6,
                          backgroundColor: AppColors.tertiary,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            isWarning ? AppColors.danger : AppColors.success,
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      // Count
                      Text(
                        '${area['available']}/${area['capacity']} (${percentage}%)',
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
