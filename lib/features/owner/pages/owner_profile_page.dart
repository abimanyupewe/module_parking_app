import 'package:flutter/material.dart';
import '../../../core/preferences/app_preferences.dart';
import '../widgets/profile/profile_header.dart';
import '../widgets/profile/profile_info_section.dart';
import '../widgets/profile/account_settings_section.dart';
import '../widgets/profile/change_password_section.dart';

/// Owner Profile Page - Profile lengkap untuk owner
class OwnerProfilePage extends StatefulWidget {
  const OwnerProfilePage({Key? key}) : super(key: key);

  @override
  State<OwnerProfilePage> createState() => _OwnerProfilePageState();
}

class _OwnerProfilePageState extends State<OwnerProfilePage> {
  late String _username;
  late String _userEmail;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  void _loadUserData() {
    _username = AppPreferences.getUsername() ?? 'User';
    _userEmail = '$_username@parking-system.local';
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
            ProfileHeader(
              username: _username,
              email: _userEmail,
              role: 'Pemilik Parkir',
            ),
            const SizedBox(height: 24),

            // User Information
            ProfileInfoSection(
              username: _username,
              email: _userEmail,
              role: 'Pemilik Parkir',
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
