import 'package:flutter/material.dart';
import '../../../core/preferences/app_preferences.dart';
import '../widgets/profile/profile_header.dart';
import '../widgets/profile/profile_info_section.dart';
import '../widgets/profile/account_settings_section.dart';
import '../widgets/profile/change_password_section.dart';

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

            // Change Password Section
            ChangePasswordSection(
              onPasswordChanged: () {
                // Handle password change if needed
              },
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}
