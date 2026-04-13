import 'package:flutter/material.dart';
import '../../../config/colors.dart';
import '../../../core/preferences/app_preferences.dart';

/// Petugas Dashboard Page (Dummy - akan replace dengan real data nanti)
class PetugasDashboardPage extends StatefulWidget {
  const PetugasDashboardPage({Key? key}) : super(key: key);

  @override
  State<PetugasDashboardPage> createState() => _PetugasDashboardPageState();
}

class _PetugasDashboardPageState extends State<PetugasDashboardPage> {
  String? _username;

  @override
  void initState() {
    super.initState();
    _username = AppPreferences.getUsername();
  }

  void _handleLogout() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Logout'),
        content: const Text('Apakah Anda yakin ingin logout?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal'),
          ),
          TextButton(
            onPressed: () async {
              await AppPreferences.logout();
              if (mounted) {
                Navigator.of(context).pushReplacementNamed('/login');
              }
            },
            child: const Text('Logout', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Petugas Dashboard'),
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.background,
        actions: [
          PopupMenuButton<String>(
            onSelected: (value) {
              if (value == 'logout') {
                _handleLogout();
              }
            },
            itemBuilder: (context) => [
              const PopupMenuItem<String>(
                value: 'profile',
                child: Text('Profile'),
              ),
              const PopupMenuItem<String>(
                value: 'password',
                child: Text('Change Password'),
              ),
              const PopupMenuDivider(),
              const PopupMenuItem<String>(
                value: 'logout',
                child: Text('Logout'),
              ),
            ],
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.person_outline, size: 80, color: AppColors.primary),
            const SizedBox(height: 24),
            Text(
              'Petugas Dashboard',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                color: AppColors.primary,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Selamat datang, $_username!',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const SizedBox(height: 32),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.secondary,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                'Data akan dimuat dari database',
                style: Theme.of(
                  context,
                ).textTheme.bodyMedium?.copyWith(color: AppColors.primary),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
