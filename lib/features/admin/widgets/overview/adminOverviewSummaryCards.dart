// ignore_for_file: file_names

import 'package:flutter/material.dart';

import '../../../../config/colors.dart';
import 'adminOverviewSummaryCard.dart';

class AdminOverviewSummaryCards extends StatelessWidget {
  const AdminOverviewSummaryCards({
    super.key,
    required this.totalAreaFuture,
    required this.totalKendaraanFuture,
  });

  final Future<int> totalAreaFuture;
  final Future<int> totalKendaraanFuture;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: FutureBuilder<int>(
            future: totalAreaFuture,
            builder: (context, snapshot) {
              final value = snapshot.data?.toString() ?? '0';
              return AdminOverviewSummaryCard(
                title: 'Total Area Parkir',
                value: value,
                subtitle: 'Area aktif',
                icon: Icons.location_on,
                bgColor: const Color(0xFFEEF1F7),
                titleColor: AppColors.primary,
                isLoading: snapshot.connectionState == ConnectionState.waiting,
              );
            },
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: FutureBuilder<int>(
            future: totalKendaraanFuture,
            builder: (context, snapshot) {
              final value = snapshot.data?.toString() ?? '0';
              return AdminOverviewSummaryCard(
                title: 'Total Kendaraan',
                value: value,
                subtitle: 'Kendaraan terdaftar',
                icon: Icons.directions_car,
                bgColor: const Color(0xFFF0F4FF),
                titleColor: AppColors.primary,
                isLoading: snapshot.connectionState == ConnectionState.waiting,
              );
            },
          ),
        ),
      ],
    );
  }
}
