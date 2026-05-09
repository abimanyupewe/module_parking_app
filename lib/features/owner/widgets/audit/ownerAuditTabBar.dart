// ignore_for_file: file_names

import 'package:flutter/material.dart';

import '../../../../config/colors.dart';

class OwnerAuditTabBar extends StatelessWidget {
  const OwnerAuditTabBar({super.key, required this.controller});

  final TabController controller;

  @override
  Widget build(BuildContext context) {
    return TabBar(
      controller: controller,
      labelColor: AppColors.primary,
      unselectedLabelColor: AppColors.inactive,
      indicator: const UnderlineTabIndicator(
        borderSide: BorderSide(color: AppColors.primary, width: 2),
      ),
      tabs: const [
        Tab(text: 'Log Transaksi'),
        Tab(text: 'Log Otorisasi'),
      ],
    );
  }
}
