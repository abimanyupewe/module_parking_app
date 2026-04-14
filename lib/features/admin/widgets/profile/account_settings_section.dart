import 'package:flutter/material.dart';
import 'profile_menu_item.dart';

/// Account Settings Section - Menampilkan menu pengaturan akun
class AccountSettingsSection extends StatelessWidget {
  const AccountSettingsSection({Key? key}) : super(key: key);

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
        ProfileMenuItem(
          icon: Icons.notifications,
          title: 'Notifikasi',
          subtitle: 'Kelola notifikasi sistem',
          onTap: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Fitur notifikasi akan segera hadir'),
              ),
            );
          },
        ),
        const SizedBox(height: 8),
        ProfileMenuItem(
          icon: Icons.security,
          title: 'Keamanan',
          subtitle: 'Pengaturan keamanan akun',
          onTap: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Fitur keamanan akan segera hadir')),
            );
          },
        ),
        const SizedBox(height: 8),
        ProfileMenuItem(
          icon: Icons.language,
          title: 'Bahasa',
          subtitle: 'Bahasa: Indonesia',
          onTap: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Fitur pengubahan bahasa akan segera hadir'),
              ),
            );
          },
        ),
      ],
    );
  }
}
