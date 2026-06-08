// ignore_for_file: file_names

import 'package:flutter/material.dart';

import '../../../../config/colors.dart';

class OwnerPasswordChangeSection extends StatefulWidget {
  const OwnerPasswordChangeSection({super.key, required this.onShowSnackBar});

  final void Function(String message, {bool isError}) onShowSnackBar;

  @override
  State<OwnerPasswordChangeSection> createState() =>
      _OwnerPasswordChangeSectionState();
}

class _OwnerPasswordChangeSectionState
    extends State<OwnerPasswordChangeSection> {
  final _oldPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _showPassword = false;
  bool _showNewPassword = false;
  bool _showConfirmPassword = false;

  void _handleChangePassword() {
    if (_newPasswordController.text.isEmpty ||
        _confirmPasswordController.text.isEmpty) {
      widget.onShowSnackBar('Password baru harus diisi', isError: true);
      return;
    }

    if (_newPasswordController.text != _confirmPasswordController.text) {
      widget.onShowSnackBar('Password konfirmasi tidak sesuai', isError: true);
      return;
    }

    if (_newPasswordController.text.length < 6) {
      widget.onShowSnackBar('Password minimal 6 karakter', isError: true);
      return;
    }

    widget.onShowSnackBar('Password berhasil diubah');
    _oldPasswordController.clear();
    _newPasswordController.clear();
    _confirmPasswordController.clear();

    setState(() {
      _showPassword = false;
      _showNewPassword = false;
      _showConfirmPassword = false;
    });
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
              _buildPasswordField(
                label: 'Password Lama',
                controller: _oldPasswordController,
                hintText: 'Masukkan password lama',
                obscureText: !_showPassword,
                onToggleVisibility: () {
                  setState(() {
                    _showPassword = !_showPassword;
                  });
                },
              ),
              const SizedBox(height: 16),
              _buildPasswordField(
                label: 'Password Baru',
                controller: _newPasswordController,
                hintText: 'Masukkan password baru',
                obscureText: !_showNewPassword,
                onToggleVisibility: () {
                  setState(() {
                    _showNewPassword = !_showNewPassword;
                  });
                },
              ),
              const SizedBox(height: 16),
              _buildPasswordField(
                label: 'Konfirmasi Password',
                controller: _confirmPasswordController,
                hintText: 'Ulangi password baru',
                obscureText: !_showConfirmPassword,
                onToggleVisibility: () {
                  setState(() {
                    _showConfirmPassword = !_showConfirmPassword;
                  });
                },
              ),
              const SizedBox(height: 16),
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

  Widget _buildPasswordField({
    required String label,
    required TextEditingController controller,
    required String hintText,
    required bool obscureText,
    required VoidCallback onToggleVisibility,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: Theme.of(context).textTheme.labelSmall),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          obscureText: obscureText,
          decoration: InputDecoration(
            hintText: hintText,
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
                obscureText ? Icons.visibility_off : Icons.visibility,
                color: AppColors.inactive,
              ),
              onPressed: onToggleVisibility,
            ),
          ),
        ),
      ],
    );
  }
}
