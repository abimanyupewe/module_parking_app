import 'package:flutter/material.dart';
import '../../../config/colors.dart';
import '../../../widgets/widgets.dart';

/// Owner SDM Section - Manajemen SDM (penambahan, monitoring)
class OwnerSdmSection extends StatefulWidget {
  const OwnerSdmSection({Key? key}) : super(key: key);

  @override
  State<OwnerSdmSection> createState() => _OwnerSdmSectionState();
}

class _OwnerSdmSectionState extends State<OwnerSdmSection> {
  final List<Map<String, dynamic>> _sdm = [
    {
      'id': 1,
      'nama': 'Budi Santoso',
      'role': 'Petugas',
      'status': 'aktif',
      'bergabung': '2024-01-15',
    },
    {
      'id': 2,
      'nama': 'Ani Wijaya',
      'role': 'Petugas',
      'status': 'aktif',
      'bergabung': '2024-02-20',
    },
    {
      'id': 3,
      'nama': 'Roni Pratama',
      'role': 'Admin',
      'status': 'aktif',
      'bergabung': '2024-01-10',
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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Manajemen SDM',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${_sdm.length} anggota tim aktif',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
              FloatingActionButton.small(
                onPressed: () => _showAddDialog(),
                backgroundColor: AppColors.primary,
                foregroundColor: AppColors.white,
                child: const Icon(Icons.add),
              ),
            ],
          ),
          const SizedBox(height: 24),

          // Summary
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.secondary.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.tertiary),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildStatCard('Total SDM', '${_sdm.length}', Icons.people),
                _buildStatCard(
                  'Aktif',
                  '${_sdm.where((s) => s['status'] == 'aktif').length}',
                  Icons.check_circle,
                ),
                _buildStatCard(
                  'Admin',
                  '${_sdm.where((s) => s['role'] == 'Admin').length}',
                  Icons.admin_panel_settings,
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // List
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _sdm.length,
            itemBuilder: (context, index) {
              final staff = _sdm[index];
              return Container(
                margin: EdgeInsets.only(
                  bottom: index != _sdm.length - 1 ? 12 : 0,
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
                                staff['role'],
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
                    // Info
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Bergabung: ${staff['bergabung']}',
                          style: const TextStyle(
                            fontSize: 11,
                            color: AppColors.inactive,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    // Actions
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            onPressed: () => _showEditDialog(staff),
                            style: OutlinedButton.styleFrom(
                              foregroundColor: AppColors.primary,
                              side: const BorderSide(color: AppColors.primary),
                              padding: const EdgeInsets.symmetric(vertical: 8),
                            ),
                            child: const Text('Edit'),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: OutlinedButton(
                            onPressed: () => _removeSDM(index),
                            style: OutlinedButton.styleFrom(
                              foregroundColor: AppColors.danger,
                              side: const BorderSide(color: AppColors.danger),
                              padding: const EdgeInsets.symmetric(vertical: 8),
                            ),
                            child: const Text('Hapus'),
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

  Widget _buildStatCard(String label, String value, IconData icon) {
    return Column(
      children: [
        Icon(icon, color: AppColors.primary, size: 24),
        const SizedBox(height: 8),
        Text(
          value,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: AppColors.primary,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(fontSize: 11, color: AppColors.inactive),
        ),
      ],
    );
  }

  void _showAddDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Tambah SDM'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CustomTextField(label: 'Nama Lengkap', hint: 'Masukkan nama'),
            const SizedBox(height: 12),
            CustomTextField(label: 'Username', hint: 'username_unik'),
            const SizedBox(height: 12),
            CustomTextField(
              label: 'Password',
              hint: 'Masukkan password',
              obscureText: true,
            ),
            const SizedBox(height: 12),
            CustomTextField(
              label: 'Role',
              hint: 'Petugas / Admin',
              readOnly: true,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('SDM berhasil ditambahkan')),
              );
            },
            child: const Text('Tambah'),
          ),
        ],
      ),
    );
  }

  void _showEditDialog(Map<String, dynamic> staff) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Edit ${staff['nama']}: Coming Soon')),
    );
  }

  void _removeSDM(int index) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Hapus SDM'),
        content: Text('Hapus ${_sdm[index]['nama']}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              setState(() => _sdm.removeAt(index));
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(const SnackBar(content: Text('SDM dihapus')));
            },
            child: const Text('Hapus', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}
