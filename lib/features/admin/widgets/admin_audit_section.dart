import 'package:flutter/material.dart';
import '../../../config/colors.dart';
import '../../../widgets/widgets.dart';

/// Admin Audit Section - Log aktivitas (Read-Only)
class AdminAuditSection extends StatefulWidget {
  const AdminAuditSection({Key? key}) : super(key: key);

  @override
  State<AdminAuditSection> createState() => _AdminAuditSectionState();
}

class _AdminAuditSectionState extends State<AdminAuditSection> {
  final List<Map<String, dynamic>> _logs = [
    {
      'id': 1,
      'username': 'budi_s',
      'aktivitas': 'Check-In Kendaraan',
      'kategori': 'Transaksi',
      'waktu': '10:45',
      'detail': 'Plat: AB 1234 CD',
    },
    {
      'id': 2,
      'username': 'ani_w',
      'aktivitas': 'Check-Out Kendaraan',
      'kategori': 'Transaksi',
      'waktu': '10:30',
      'detail': 'Plat: DE 5678 FG',
    },
    {
      'id': 3,
      'username': 'admin_user',
      'aktivitas': 'Disable Petugas',
      'kategori': 'Otorisasi',
      'waktu': '09:15',
      'detail': 'Username: roni_p',
    },
  ];

  int _selectedFilter = 0;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Text(
              'Log Aktivitas Sistem',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 8),
            Text(
              'Riwayat semua aktivitas petugas (Read-Only)',
              style: Theme.of(context).textTheme.bodySmall,
            ),
            const SizedBox(height: 24),

            // Filter
            Row(
              children: [
                _buildFilterButton('Semua', 0),
                const SizedBox(width: 8),
                _buildFilterButton('Transaksi', 1),
                const SizedBox(width: 8),
                _buildFilterButton('Otorisasi', 2),
              ],
            ),
            const SizedBox(height: 24),

            // List using LogTimelineTile
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _logs.length,
              itemBuilder: (context, index) {
                final log = _logs[index];
                return Padding(
                  padding: EdgeInsets.only(
                    bottom: index != _logs.length - 1 ? 16 : 0,
                  ),
                  child: LogTimelineTile(
                    title: log['aktivitas'],
                    subtitle: 'Oleh: ${log['username']}',
                    timestamp: log['waktu'],
                    category: log['kategori'],
                    icon: log['kategori'] == 'Transaksi'
                        ? Icons.car_rental
                        : Icons.security,
                    iconColor: log['kategori'] == 'Transaksi'
                        ? AppColors.info
                        : AppColors.warning,
                    isLast: index == _logs.length - 1,
                    onTap: () => _showLogDetail(log),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterButton(String label, int index) {
    final isSelected = _selectedFilter == index;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedFilter = index;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : AppColors.tertiary,
          borderRadius: BorderRadius.circular(6),
          border: Border.all(
            color: isSelected ? AppColors.primary : AppColors.tertiary,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: isSelected ? AppColors.white : AppColors.inactive,
          ),
        ),
      ),
    );
  }

  void _showLogDetail(Map<String, dynamic> log) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Detail Log Aktivitas'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildLogDetailRow('Aktivitas', log['aktivitas']),
            const SizedBox(height: 12),
            _buildLogDetailRow('Petugas', log['username']),
            const SizedBox(height: 12),
            _buildLogDetailRow('Kategori', log['kategori']),
            const SizedBox(height: 12),
            _buildLogDetailRow('Waktu', log['waktu']),
            const SizedBox(height: 12),
            _buildLogDetailRow('Detail', log['detail']),
            const SizedBox(height: 16),
            // Note
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.secondary.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: AppColors.secondary),
              ),
              child: const Text(
                'Log ini bersifat read-only dan tidak dapat diedit atau dihapus.',
                style: TextStyle(
                  fontSize: 12,
                  color: AppColors.primary,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Tutup'),
          ),
        ],
      ),
    );
  }

  Widget _buildLogDetailRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 13, color: AppColors.inactive),
        ),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: AppColors.primary,
            ),
            textAlign: TextAlign.right,
          ),
        ),
      ],
    );
  }
}
