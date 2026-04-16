// ignore_for_file: file_names

import 'package:flutter/material.dart';

import '../../../../config/colors.dart';
import '../../../../config/constants.dart';
import '../../../../models/user_model.dart';

class OwnerSdmSummary extends StatelessWidget {
  const OwnerSdmSummary({super.key, required this.allSdm});

  final List<UserModel> allSdm;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.secondary.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.tertiary),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _OwnerSdmStatCard(
            label: 'Total SDM',
            value: '${allSdm.length}',
            icon: Icons.people,
          ),
          _OwnerSdmStatCard(
            label: 'Aktif',
            value:
                '${allSdm.where((s) => s.status == AppConstants.statusAktif).length}',
            icon: Icons.check_circle,
          ),
          _OwnerSdmStatCard(
            label: 'Admin',
            value:
                '${allSdm.where((s) => s.role.toLowerCase() == AppConstants.roleAdmin.toLowerCase()).length}',
            icon: Icons.admin_panel_settings,
          ),
        ],
      ),
    );
  }
}

class _OwnerSdmStatCard extends StatelessWidget {
  const _OwnerSdmStatCard({
    required this.label,
    required this.value,
    required this.icon,
  });

  final String label;
  final String value;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, color: AppColors.primary, size: 24),
        const SizedBox(height: 8),
        Text(
          value,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: AppColors.primary,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(fontSize: 11, color: AppColors.inactive),
        ),
      ],
    );
  }
}
