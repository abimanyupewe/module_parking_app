// ignore_for_file: file_names

import 'package:flutter/material.dart';
import '../../../../config/colors.dart';

class OwnerHistoryCategoryFilter extends StatelessWidget {
  const OwnerHistoryCategoryFilter({
    super.key,
    required this.categories,
    required this.selectedCategory,
    required this.onSelected,
  });

  final List<String> categories;
  final String selectedCategory;
  final ValueChanged<String> onSelected;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: categories.map((category) {
          final isSelected = selectedCategory == category;
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: FilterChip(
              label: Text(category),
              selected: isSelected,
              onSelected: (_) => onSelected(category),
              backgroundColor: Colors.transparent,
              selectedColor: AppColors.primary.withValues(alpha: 0.2),
              side: BorderSide(
                color: isSelected ? AppColors.primary : AppColors.border,
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
