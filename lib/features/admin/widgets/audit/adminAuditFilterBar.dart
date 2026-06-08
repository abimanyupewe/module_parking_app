// ignore_for_file: file_names

import 'package:flutter/material.dart';

import '../../../../config/colors.dart';

class AdminAuditFilterBar extends StatelessWidget {
  const AdminAuditFilterBar({
    super.key,
    required this.selectedFilter,
    required this.onFilterChanged,
  });

  final int selectedFilter;
  final ValueChanged<int> onFilterChanged;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _AdminAuditFilterButton(
          label: 'Semua',
          index: 0,
          selectedFilter: selectedFilter,
          onTap: onFilterChanged,
        ),
        const SizedBox(width: 8),
        _AdminAuditFilterButton(
          label: 'Transaksi',
          index: 1,
          selectedFilter: selectedFilter,
          onTap: onFilterChanged,
        ),
        const SizedBox(width: 8),
        _AdminAuditFilterButton(
          label: 'Otorisasi',
          index: 2,
          selectedFilter: selectedFilter,
          onTap: onFilterChanged,
        ),
      ],
    );
  }
}

class _AdminAuditFilterButton extends StatelessWidget {
  const _AdminAuditFilterButton({
    required this.label,
    required this.index,
    required this.selectedFilter,
    required this.onTap,
  });

  final String label;
  final int index;
  final int selectedFilter;
  final ValueChanged<int> onTap;

  @override
  Widget build(BuildContext context) {
    final isSelected = selectedFilter == index;

    return GestureDetector(
      onTap: () => onTap(index),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : AppColors.tertiary,
          borderRadius: BorderRadius.circular(6),
          border: Border.all(
            color: isSelected ? AppColors.primary : AppColors.tertiary,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: isSelected ? AppColors.white : AppColors.inactive,
          ),
        ),
      ),
    );
  }
}
