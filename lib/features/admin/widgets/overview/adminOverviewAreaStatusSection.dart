// ignore_for_file: file_names

import 'package:flutter/material.dart';

import '../../../../config/colors.dart';
import '../../../../models/area_parkir_model.dart';

class AdminOverviewAreaStatusSection extends StatelessWidget {
  const AdminOverviewAreaStatusSection({
    super.key,
    required this.areaListFuture,
  });

  final Future<List<AreaParkirModel>> areaListFuture;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Status Slot Area Parkir',
          style: Theme.of(
            context,
          ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        FutureBuilder<List<AreaParkirModel>>(
          future: areaListFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            if (snapshot.hasError) {
              return Center(
                child: Text(
                  'Error: ${snapshot.error}',
                  style: const TextStyle(color: AppColors.danger),
                ),
              );
            }

            final areas = snapshot.data ?? [];

            if (areas.isEmpty) {
              return const Center(
                child: Text(
                  'Data area parkir belum tersedia',
                  style: TextStyle(color: AppColors.inactive),
                ),
              );
            }

            return Column(
              children: List.generate(areas.length, (index) {
                final area = areas[index];
                return _AreaStatusItem(area: area);
              }),
            );
          },
        ),
      ],
    );
  }
}

class _AreaStatusItem extends StatelessWidget {
  const _AreaStatusItem({required this.area});

  final AreaParkirModel area;

  @override
  Widget build(BuildContext context) {
    final occupied = area.terisi;
    final total = area.kapasitas;

    late Color color;
    final percentage = (occupied / total) * 100;
    if (percentage >= 80) {
      color = AppColors.danger;
    } else if (percentage >= 50) {
      color = AppColors.warning;
    } else {
      color = AppColors.success;
    }

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
                Expanded(
                  child: Text(
                    area.namaArea,
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
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
                value: occupied / total,
                minHeight: 6,
                backgroundColor: color.withValues(alpha: 0.2),
                valueColor: AlwaysStoppedAnimation<Color>(color),
              ),
            ),
            const SizedBox(height: 6),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
  }
}
