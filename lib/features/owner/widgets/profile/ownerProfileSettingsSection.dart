// ignore_for_file: file_names

import 'package:flutter/material.dart';

import '../../../../config/colors.dart';

class OwnerProfileSettingsSection extends StatelessWidget {
  const OwnerProfileSettingsSection({super.key, required this.onShowMessage});

  final void Function(String message) onShowMessage;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Pengaturan Akun',
          style: Theme.of(
            context,
          ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        _OwnerProfileSettingItem(
          icon: Icons.notifications,
          title: 'Notifikasi',
          subtitle: 'Kelola notifikasi sistem',
          onTap: () {
            onShowMessage('Fitur notifikasi akan segera hadir');
          },
        ),
        const SizedBox(height: 8),
        _OwnerProfileSettingItem(
          icon: Icons.security,
          title: 'Keamanan',
          subtitle: 'Pengaturan keamanan akun',
          onTap: () {
            onShowMessage('Fitur keamanan akan segera hadir');
          },
        ),
        const SizedBox(height: 8),
        _OwnerProfileSettingItem(
          icon: Icons.language,
          title: 'Bahasa',
          subtitle: 'Bahasa: Indonesia',
          onTap: () {
            onShowMessage('Fitur pengubahan bahasa akan segera hadir');
          },
        ),
      ],
    );
  }
}

class _OwnerProfileSettingItem extends StatelessWidget {
  const _OwnerProfileSettingItem({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.border),
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        leading: Icon(icon, color: AppColors.primary),
        title: Text(
          title,
          style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
        ),
        subtitle: Text(subtitle, style: const TextStyle(fontSize: 11)),
        trailing: const Icon(Icons.chevron_right, color: AppColors.inactive),
        onTap: onTap,
      ),
    );
  }
}
