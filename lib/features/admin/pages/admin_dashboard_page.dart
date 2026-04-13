import 'package:flutter/material.dart';
import '../../../config/colors.dart';
import '../../../core/preferences/app_preferences.dart';
import '../widgets/admin_monitoring_section.dart';
import '../widgets/admin_master_data_section.dart';
import '../widgets/admin_staff_management_section.dart';
import '../widgets/admin_audit_section.dart';

/// Admin Dashboard Page - Manajer operasional
class AdminDashboardPage extends StatefulWidget {
  const AdminDashboardPage({Key? key}) : super(key: key);

  @override
  State<AdminDashboardPage> createState() => _AdminDashboardPageState();
}

class _AdminDashboardPageState extends State<AdminDashboardPage> {
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
      length: 4,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Admin Dashboard'),
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
            // Tab Bar
            Container(
              color: AppColors.white,
              child: TabBar(
                isScrollable: true,
                indicator: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(color: AppColors.primary, width: 3),
                  ),
                ),
                indicatorColor: AppColors.primary,
                labelColor: AppColors.primary,
                unselectedLabelColor: AppColors.inactive,
                tabs: const [
                  Tab(icon: Icon(Icons.dashboard), text: 'Monitoring'),
                  Tab(icon: Icon(Icons.category), text: 'Master Data'),
                  Tab(icon: Icon(Icons.people), text: 'Petugas'),
                  Tab(icon: Icon(Icons.history), text: 'Audit Log'),
                ],
              ),
            ),
            // Tab Content
            const Expanded(
              child: TabBarView(
                children: [
                  AdminMonitoringSection(),
                  AdminMasterDataSection(),
                  AdminStaffManagementSection(),
                  AdminAuditSection(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
