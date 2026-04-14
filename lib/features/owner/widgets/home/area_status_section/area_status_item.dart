import 'package:flutter/material.dart';
import '../../../../../config/colors.dart';

/// Area Status Item - Displays single parking area status with capacity indicator
class AreaStatusItem extends StatelessWidget {
  final String name;
  final int occupied;
  final int total;
  final Color color;

  const AreaStatusItem({
    Key? key,
    required this.name,
    required this.occupied,
    required this.total,
    required this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double percentage = (occupied / total) * 100;

    return Container(
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
                name,
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
    );
  }
}
