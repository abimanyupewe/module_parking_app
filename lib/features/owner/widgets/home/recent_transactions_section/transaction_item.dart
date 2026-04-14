import 'package:flutter/material.dart';
import '../../../../../config/colors.dart';

/// Transaction Item - Displays single transaction in recent transactions list
class TransactionItem extends StatelessWidget {
  final String plate;
  final String type;
  final String area;
  final String time;
  final String fee;

  const TransactionItem({
    Key? key,
    required this.plate,
    required this.type,
    required this.area,
    required this.time,
    required this.fee,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.border),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: AppColors.primaryLight,
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(Icons.directions_car, color: AppColors.primary),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  plate,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  '$type - $area - $time',
                  style: TextStyle(fontSize: 11, color: AppColors.inactive),
                ),
              ],
            ),
          ),
          Text(
            fee,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.bold,
              color: AppColors.success,
            ),
          ),
        ],
      ),
    );
  }
}
