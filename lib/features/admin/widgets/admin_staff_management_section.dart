import 'package:flutter/material.dart';
import '../../../config/colors.dart';
import '../../../widgets/widgets.dart';

/// Admin Staff Management Section - Manage petugas (enable/disable)
class AdminStaffManagementSection extends StatefulWidget {
  const AdminStaffManagementSection({Key? key}) : super(key: key);

  @override
  State<AdminStaffManagementSection> createState() =>
      _AdminStaffManagementSectionState();
}

class _AdminStaffManagementSectionState
    extends State<AdminStaffManagementSection> {
  final List<Map<String, dynamic>> _staff = [
    {'id': 1, 'nama': 'Budi Santoso', 'username': 'budi_s', 'status': 'aktif'},
    {'id': 2, 'nama': 'Ani Wijaya', 'username': 'ani_w', 'status': 'aktif'},
    {
      'id': 3,
      'nama': 'Roni Pratama',
      'username': 'roni_p',
      'status': 'nonaktif',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Text(
            'Manajemen Petugas',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 8),
          Text(
            'Kelola status dan izin akses petugas parkir',
            style: Theme.of(context).textTheme.bodySmall,
          ),
          const SizedBox(height: 24),

          // List
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _staff.length,
            itemBuilder: (context, index) {
              final staff = _staff[index];
              final isActive = staff['status'] == 'aktif';
              return Container(
                margin: EdgeInsets.only(
                  bottom: index != _staff.length - 1 ? 12 : 0,
                ),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.tertiary),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                staff['nama'],
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.primary,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                '@${staff['username']}',
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: AppColors.inactive,
                                ),
                              ),
                            ],
                          ),
                        ),
                        StatusBadge(status: staff['status'], fontSize: 11),
                      ],
                    ),
                    const SizedBox(height: 12),
                    // Actions
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () {
                              setState(() {
                                staff['status'] = isActive
                                    ? 'nonaktif'
                                    : 'aktif';
                              });
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: isActive
                                  ? AppColors.danger
                                  : AppColors.success,
                              foregroundColor: AppColors.white,
                              padding: const EdgeInsets.symmetric(vertical: 8),
                            ),
                            child: Text(isActive ? 'Nonaktifkan' : 'Aktifkan'),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: OutlinedButton(
                            onPressed: () {
                              // TODO: View detail
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Detail Petugas: Coming Soon'),
                                ),
                              );
                            },
                            style: OutlinedButton.styleFrom(
                              foregroundColor: AppColors.primary,
                              side: const BorderSide(color: AppColors.primary),
                            ),
                            child: const Text('Detail'),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
