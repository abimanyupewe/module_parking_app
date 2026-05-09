// ignore_for_file: file_names

import 'package:flutter/material.dart';

import '../../../../config/colors.dart';

class OwnerHistorySectionDateFilterBar extends StatelessWidget {
  const OwnerHistorySectionDateFilterBar({
    super.key,
    required this.selectedDate,
    required this.onSelectDate,
    required this.onClearFilter,
  });

  final DateTime? selectedDate;
  final VoidCallback onSelectDate;
  final VoidCallback onClearFilter;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        IconButton.filled(
          onPressed: onSelectDate,
          icon: const Icon(Icons.calendar_today),
          style: IconButton.styleFrom(
            backgroundColor: selectedDate != null
                ? AppColors.primary
                : Colors.grey[300],
            foregroundColor: selectedDate != null
                ? Colors.white
                : Colors.grey[600],
          ),
          tooltip: selectedDate != null
              ? '${selectedDate!.day}/${selectedDate!.month}/${selectedDate!.year}'
              : 'Pilih Tanggal',
        ),
        const SizedBox(width: 8),
        if (selectedDate != null)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(6),
              border: Border.all(color: AppColors.primary, width: 1),
            ),
            child: Text(
              '${selectedDate!.day}/${selectedDate!.month}/${selectedDate!.year}',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: AppColors.primary,
              ),
            ),
          ),
        const Spacer(),
        if (selectedDate != null)
          IconButton(
            onPressed: onClearFilter,
            icon: const Icon(Icons.close),
            iconSize: 20,
            style: IconButton.styleFrom(foregroundColor: Colors.red),
            tooltip: 'Bersihkan Filter',
          ),
      ],
    );
  }
}
