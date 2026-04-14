import 'package:flutter/material.dart';
import '../../../../../config/colors.dart';

/// Profile Info Section - Menampilkan informasi user dalam section
class ProfileInfoSection extends StatelessWidget {
  final String username;
  final String email;
  final String role;
  final String status;

  const ProfileInfoSection({
    Key? key,
    required this.username,
    required this.email,
    required this.role,
    required this.status,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
              _buildInfoRow('Username', username),
              const Divider(height: 16),
              _buildInfoRow('Email', email),
              const Divider(height: 16),
              _buildInfoRow('Role', role),
              const Divider(height: 16),
              _buildInfoRow('Status', status),
            ],
          ),
        ),
      ],
    );
  }

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
}
