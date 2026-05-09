// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../../config/colors.dart';

class OwnerHistoryDateFilterBar extends StatelessWidget {
  const OwnerHistoryDateFilterBar({
    super.key,
    required this.startDate,
    required this.endDate,
    required this.onSelectStartDate,
    required this.onSelectEndDate,
    required this.onResetFilter,
  });

  final DateTime? startDate;
  final DateTime? endDate;
  final VoidCallback onSelectStartDate;
  final VoidCallback onSelectEndDate;
  final VoidCallback onResetFilter;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        IconButton.filled(
          onPressed: onSelectStartDate,
          icon: const Icon(Icons.calendar_today),
          style: IconButton.styleFrom(
            backgroundColor: startDate != null
                ? AppColors.primary
                : Colors.grey[300],
            foregroundColor: startDate != null
                ? Colors.white
                : Colors.grey[600],
          ),
          tooltip: startDate != null
              ? DateFormat('dd/MM/yyyy').format(startDate!)
              : 'Tanggal Mulai',
        ),
        const SizedBox(width: 8),
        if (startDate != null)
          _DateBadge(date: startDate!, color: AppColors.primary),
        const SizedBox(width: 8),
        IconButton.filled(
          onPressed: onSelectEndDate,
          icon: const Icon(Icons.calendar_today),
          style: IconButton.styleFrom(
            backgroundColor: endDate != null
                ? AppColors.primary
                : Colors.grey[300],
            foregroundColor: endDate != null ? Colors.white : Colors.grey[600],
          ),
          tooltip: endDate != null
              ? DateFormat('dd/MM/yyyy').format(endDate!)
              : 'Tanggal Akhir',
        ),
        const SizedBox(width: 8),
        if (endDate != null)
          _DateBadge(date: endDate!, color: AppColors.primary),
        const Spacer(),
        if (startDate != null || endDate != null)
          IconButton(
            onPressed: onResetFilter,
            icon: const Icon(Icons.close),
            iconSize: 20,
            style: IconButton.styleFrom(foregroundColor: Colors.red),
            tooltip: 'Bersihkan Filter',
          ),
      ],
    );
  }
}

class _DateBadge extends StatelessWidget {
  const _DateBadge({required this.date, required this.color});

  final DateTime date;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: color, width: 1),
      ),
      child: Text(
        DateFormat('dd/MM/yy').format(date),
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: color,
        ),
      ),
    );
  }
}
