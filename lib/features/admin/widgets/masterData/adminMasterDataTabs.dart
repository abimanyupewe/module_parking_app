// ignore_for_file: file_names

import 'package:flutter/material.dart';

import '../../../../config/colors.dart';

class AdminMasterDataTabs extends StatelessWidget {
  const AdminMasterDataTabs({
    super.key,
    required this.selectedTabIndex,
    required this.onSelectTab,
  });

  final int selectedTabIndex;
  final ValueChanged<int> onSelectTab;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: GestureDetector(
            onTap: () => onSelectTab(0),
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 12),
              decoration: BoxDecoration(
                color: selectedTabIndex == 0
                    ? AppColors.primary
                    : AppColors.tertiary,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(8),
                  bottomLeft: Radius.circular(8),
                ),
              ),
              child: Center(
                child: Text(
                  'Kategori',
                  style: TextStyle(
                    color: selectedTabIndex == 0
                        ? AppColors.white
                        : AppColors.inactive,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ),
        ),
        Expanded(
          child: GestureDetector(
            onTap: () => onSelectTab(1),
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 12),
              decoration: BoxDecoration(
                color: selectedTabIndex == 1
                    ? AppColors.primary
                    : AppColors.tertiary,
                borderRadius: const BorderRadius.only(
                  topRight: Radius.circular(8),
                  bottomRight: Radius.circular(8),
                ),
              ),
              child: Center(
                child: Text(
                  'Area',
                  style: TextStyle(
                    color: selectedTabIndex == 1
                        ? AppColors.white
                        : AppColors.inactive,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
