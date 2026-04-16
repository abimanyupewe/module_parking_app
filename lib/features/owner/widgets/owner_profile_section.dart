import 'package:flutter/material.dart';
import '../../../config/colors.dart';
import '../../../core/preferences/app_preferences.dart';
import 'profile/ownerPasswordChangeSection.dart';
import 'profile/ownerProfileHeader.dart';
import 'profile/ownerProfileInfoSection.dart';
import 'profile/ownerProfileSettingsSection.dart';

/// Owner Profile Section - User Info dan Settings
class OwnerProfileSection extends StatefulWidget {
  const OwnerProfileSection({super.key});

  @override
  State<OwnerProfileSection> createState() => _OwnerProfileSectionState();
}

class _OwnerProfileSectionState extends State<OwnerProfileSection> {
  String? _username;
  String? _userEmail;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  void _loadUserData() async {
    _username = AppPreferences.getUsername();
    // In real app, fetch email from database
    _userEmail = '$_username@parking-system.local';
    setState(() {
      _isLoading = false;
    });
  }

  void _showSnackBar(String message, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? AppColors.danger : AppColors.success,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Profile Header
          OwnerProfileHeader(username: _username ?? 'User'),
          const SizedBox(height: 24),

          // User Information
          OwnerProfileInfoSection(
            username: _username ?? '-',
            email: _userEmail ?? '-',
          ),
          const SizedBox(height: 24),

          // Account Settings
          OwnerProfileSettingsSection(onShowMessage: _showSnackBar),
          const SizedBox(height: 24),

          // Change Password Section
          OwnerPasswordChangeSection(onShowSnackBar: _showSnackBar),
        ],
      ),
    );
  }
}
