import 'package:flutter/material.dart';
import '../../../config/colors.dart';

/// Admin Overview Section - Overview dashboard untuk admin
class AdminOverviewSection extends StatelessWidget {
  const AdminOverviewSection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title
          Text(
            'Overview Sistem',
            style: Theme.of(
              context,
            ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          Text(
            'Ringkasan informasi sistem parkir',
            style: Theme.of(context).textTheme.bodySmall,
          ),
          const SizedBox(height: 24),

          // Summary Cards
          Row(
            children: [
              Expanded(
                child: _buildSummaryCard(
                  title: 'Total Area Parkir',
                  value: '12',
                  subtitle: 'Area aktif',
                  icon: Icons.location_on,
                  bgColor: const Color(0xFFEEF1F7),
                  titleColor: AppColors.primary,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildSummaryCard(
                  title: 'Total Kendaraan',
                  value: '245',
                  subtitle: 'Kendaraan terdaftar',
                  icon: Icons.directions_car,
                  bgColor: const Color(0xFFF0F4FF),
                  titleColor: AppColors.primary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),

          // Area Slot Status Section
          Text(
            'Status Slot Area Parkir',
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          _buildAreaSlotStatus(),
        ],
      ),
    );
  }

  Widget _buildSummaryCard({
    required String title,
    required String value,
    required String subtitle,
    required IconData icon,
    Color bgColor = const Color(0xFFEEF1F7),
    Color titleColor = AppColors.primary,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    fontSize: 12,
                    color: titleColor,
                    fontWeight: FontWeight.w500,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Icon(icon, color: titleColor, size: 20),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: titleColor,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            subtitle,
            style: TextStyle(
              fontSize: 11,
              color: titleColor.withValues(alpha: 0.7),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAreaSlotStatus() {
    final areas = [
      {
        'name': 'Lantai 1 Motor',
        'occupied': 87,
        'total': 100,
        'color': AppColors.primary,
      },
      {
        'name': 'Lantai 2 Mobil',
        'occupied': 48,
        'total': 50,
        'color': AppColors.warning,
      },
      {
        'name': 'Basement Motor',
        'occupied': 45,
        'total': 80,
        'color': AppColors.success,
      },
    ];

    return Column(
      children: List.generate(areas.length, (index) {
        final area = areas[index];
        final occupied = area['occupied'] as int;
        final total = area['total'] as int;
        final color = area['color'] as Color;
        final percentage = (occupied / total) * 100;

        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              border: Border.all(color: AppColors.border),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      area['name'] as String,
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      '$occupied / $total',
                      style: TextStyle(
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
                    value: occupied / total,
                    minHeight: 6,
                    backgroundColor: color.withValues(alpha: 0.2),
                    valueColor: AlwaysStoppedAnimation<Color>(color),
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  '${percentage.toStringAsFixed(1)}% terisi',
                  style: TextStyle(fontSize: 11, color: AppColors.inactive),
                ),
              ],
            ),
          ),
        );
      }),
    );
  }
}
