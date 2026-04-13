import 'package:flutter/material.dart';
import '../../../config/colors.dart';
import '../../../core/preferences/app_preferences.dart';
import '../widgets/petugas_check_in_section.dart';
import '../widgets/petugas_check_out_section.dart';
import '../widgets/petugas_history_section.dart';
import '../widgets/petugas_area_info_section.dart';

/// Petugas Dashboard Page - Kasir operasional harian
class PetugasDashboardPage extends StatefulWidget {
  const PetugasDashboardPage({Key? key}) : super(key: key);

  @override
  State<PetugasDashboardPage> createState() => _PetugasDashboardPageState();
}

class _PetugasDashboardPageState extends State<PetugasDashboardPage> {
  @override
  void initState() {
    super.initState();
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
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Petugas Operasional'),
          backgroundColor: AppColors.primary,
          foregroundColor: AppColors.white,
          elevation: 0,
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
                  child: Text('Ubah Password'),
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
        body: Column(
          children: [
            // Area Info Section
            const PetugasAreaInfoSection(),
            // Tab Bar
            Container(
              color: AppColors.white,
              child: TabBar(
                indicator: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(color: AppColors.primary, width: 3),
                  ),
                ),
                indicatorColor: AppColors.primary,
                labelColor: AppColors.primary,
                unselectedLabelColor: AppColors.inactive,
                tabs: const [
                  Tab(icon: Icon(Icons.login), text: 'Masuk'),
                  Tab(icon: Icon(Icons.logout), text: 'Keluar'),
                  Tab(icon: Icon(Icons.history), text: 'Riwayat'),
                ],
              ),
            ),
            // Tab Content
            const Expanded(
              child: TabBarView(
                children: [
                  PetugasCheckInSection(),
                  PetugasCheckOutSection(),
                  PetugasHistorySection(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
