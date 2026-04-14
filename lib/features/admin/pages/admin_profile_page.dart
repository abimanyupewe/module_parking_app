import 'package:flutter/material.dart';
import '../../../config/colors.dart';
import '../../../core/preferences/app_preferences.dart';
import '../widgets/profile/profile_header.dart';
import '../widgets/profile/profile_info_section.dart';
import '../widgets/profile/account_settings_section.dart';

/// Admin Profile Page - Profile lengkap untuk admin
class AdminProfilePage extends StatefulWidget {
  const AdminProfilePage({Key? key}) : super(key: key);

  @override
  State<AdminProfilePage> createState() => _AdminProfilePageState();
}

class _AdminProfilePageState extends State<AdminProfilePage> {
  late String _username;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  void _loadUserData() {
    _username = AppPreferences.getUsername() ?? 'User';
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        appBar: AppBar(title: const Text('Profile')),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Profile'), elevation: 0),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Profile Header
            ProfileHeader(username: _username, role: 'Admin Sistem'),
            const SizedBox(height: 24),

            // User Information
            ProfileInfoSection(
              username: _username,
              role: 'Admin Sistem',
              status: 'Aktif',
            ),
            const SizedBox(height: 24),

            // Account Settings
            const AccountSettingsSection(),
            const SizedBox(height: 24),

            // Log Activity Menu
            _buildMenuSection(
              title: 'Log Aktivitas',
              items: [
                {
                  'label': 'Activity Log',
                  'icon': Icons.history,
                  'count': '145',
                },
                {
                  'label': 'Transaksi Petugas',
                  'icon': Icons.receipt,
                  'count': '89',
                },
                {
                  'label': 'Aktivitas Kendaraan',
                  'icon': Icons.directions_car,
                  'count': '256',
                },
              ],
            ),
            const SizedBox(height: 24),

            // Kategori Transaksi Menu
            _buildMenuSection(
              title: 'Kategori Transaksi',
              items: [
                {'label': 'Masuk', 'icon': Icons.login, 'count': '128'},
                {'label': 'Keluar', 'icon': Icons.logout, 'count': '127'},
                {'label': 'Menunggu', 'icon': Icons.schedule, 'count': '1'},
              ],
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuSection({
    required String title,
    required List<Map<String, dynamic>> items,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: Theme.of(
            context,
          ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        Container(
          decoration: BoxDecoration(
            border: Border.all(color: AppColors.border),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            children: List.generate(items.length, (index) {
              final item = items[index];
              return Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(12),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: AppColors.primary.withValues(alpha: 0.1),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            item['icon'] as IconData,
                            size: 16,
                            color: AppColors.primary,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            item['label'] as String,
                            style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.primary.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            item['count'] as String,
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: AppColors.primary,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (index < items.length - 1)
                    Divider(height: 1, color: AppColors.border, indent: 40),
                ],
              );
            }),
          ),
        ),
      ],
    );
  }
}
