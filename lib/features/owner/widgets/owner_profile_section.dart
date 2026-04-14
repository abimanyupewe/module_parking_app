import 'package:flutter/material.dart';
import '../../../config/colors.dart';
import '../../../core/preferences/app_preferences.dart';

/// Owner Profile Section - User Info dan Settings
class OwnerProfileSection extends StatefulWidget {
  const OwnerProfileSection({Key? key}) : super(key: key);

  @override
  State<OwnerProfileSection> createState() => _OwnerProfileSectionState();
}

class _OwnerProfileSectionState extends State<OwnerProfileSection> {
  String? _username;
  String? _userEmail;
  bool _isLoading = true;
  bool _showPassword = false;
  bool _showNewPassword = false;
  bool _showConfirmPassword = false;

  final _oldPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

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

  void _handleChangePassword() {
    if (_newPasswordController.text.isEmpty ||
        _confirmPasswordController.text.isEmpty) {
      _showSnackBar('Password baru harus diisi', isError: true);
      return;
    }

    if (_newPasswordController.text != _confirmPasswordController.text) {
      _showSnackBar('Password konfirmasi tidak sesuai', isError: true);
      return;
    }

    if (_newPasswordController.text.length < 6) {
      _showSnackBar('Password minimal 6 karakter', isError: true);
      return;
    }

    // Show success message
    _showSnackBar('Password berhasil diubah');
    _oldPasswordController.clear();
    _newPasswordController.clear();
    _confirmPasswordController.clear();
    setState(() {
      _showPassword = false;
      _showNewPassword = false;
      _showConfirmPassword = false;
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
  void dispose() {
    _oldPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
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
          _buildProfileHeader(),
          const SizedBox(height: 24),

          // User Information
          _buildUserInfoSection(),
          const SizedBox(height: 24),

          // Account Settings
          _buildAccountSettingsSection(),
          const SizedBox(height: 24),

          // Change Password Section
          _buildChangePasswordSection(),
        ],
      ),
    );
  }

  /// Build profile header
  Widget _buildProfileHeader() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF343858), Color(0xFF2C3548)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.person, color: Colors.white, size: 32),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _username ?? 'User',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Pemilik Parkir',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.white.withValues(alpha: 0.8),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Build user information section
  Widget _buildUserInfoSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Informasi Akun',
          style: Theme.of(
            context,
          ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            border: Border.all(color: AppColors.border),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildInfoRow('Username', _username ?? '-'),
              const Divider(height: 16),
              _buildInfoRow('Email', _userEmail ?? '-'),
              const Divider(height: 16),
              _buildInfoRow('Role', 'Pemilik Parkir'),
              const Divider(height: 16),
              _buildInfoRow('Status', 'Aktif'),
            ],
          ),
        ),
      ],
    );
  }

  /// Build info row
  Widget _buildInfoRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 13, color: AppColors.inactive),
        ),
        Text(
          value,
          style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
        ),
      ],
    );
  }

  /// Build account settings section
  Widget _buildAccountSettingsSection() {
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
        _buildSettingItem(
          icon: Icons.notifications,
          title: 'Notifikasi',
          subtitle: 'Kelola notifikasi sistem',
          onTap: () {
            _showSnackBar('Fitur notifikasi akan segera hadir');
          },
        ),
        const SizedBox(height: 8),
        _buildSettingItem(
          icon: Icons.security,
          title: 'Keamanan',
          subtitle: 'Pengaturan keamanan akun',
          onTap: () {
            _showSnackBar('Fitur keamanan akan segera hadir');
          },
        ),
        const SizedBox(height: 8),
        _buildSettingItem(
          icon: Icons.language,
          title: 'Bahasa',
          subtitle: 'Bahasa: Indonesia',
          onTap: () {
            _showSnackBar('Fitur pengubahan bahasa akan segera hadir');
          },
        ),
      ],
    );
  }

  /// Build setting item
  Widget _buildSettingItem({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
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

  /// Build change password section
  Widget _buildChangePasswordSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Ubah Password',
          style: Theme.of(
            context,
          ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            border: Border.all(color: AppColors.border),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Old Password
              Text(
                'Password Lama',
                style: Theme.of(context).textTheme.labelSmall,
              ),
              const SizedBox(height: 8),
              TextField(
                controller: _oldPasswordController,
                obscureText: !_showPassword,
                decoration: InputDecoration(
                  hintText: 'Masukkan password lama',
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 10,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(color: AppColors.border),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(color: AppColors.border),
                  ),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _showPassword ? Icons.visibility : Icons.visibility_off,
                      color: AppColors.inactive,
                    ),
                    onPressed: () {
                      setState(() {
                        _showPassword = !_showPassword;
                      });
                    },
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // New Password
              Text(
                'Password Baru',
                style: Theme.of(context).textTheme.labelSmall,
              ),
              const SizedBox(height: 8),
              TextField(
                controller: _newPasswordController,
                obscureText: !_showNewPassword,
                decoration: InputDecoration(
                  hintText: 'Masukkan password baru',
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 10,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(color: AppColors.border),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(color: AppColors.border),
                  ),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _showNewPassword
                          ? Icons.visibility
                          : Icons.visibility_off,
                      color: AppColors.inactive,
                    ),
                    onPressed: () {
                      setState(() {
                        _showNewPassword = !_showNewPassword;
                      });
                    },
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Confirm Password
              Text(
                'Konfirmasi Password',
                style: Theme.of(context).textTheme.labelSmall,
              ),
              const SizedBox(height: 8),
              TextField(
                controller: _confirmPasswordController,
                obscureText: !_showConfirmPassword,
                decoration: InputDecoration(
                  hintText: 'Ulangi password baru',
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 10,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(color: AppColors.border),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(color: AppColors.border),
                  ),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _showConfirmPassword
                          ? Icons.visibility
                          : Icons.visibility_off,
                      color: AppColors.inactive,
                    ),
                    onPressed: () {
                      setState(() {
                        _showConfirmPassword = !_showConfirmPassword;
                      });
                    },
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Update Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onPressed: _handleChangePassword,
                  child: const Text('Perbarui Password'),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
