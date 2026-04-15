import 'package:flutter/material.dart';
import '../../../config/colors.dart';
import '../../../config/constants.dart';
import '../../../services/database_helper.dart';
import '../../../widgets/widgets.dart';

/// Admin Audit Section - Log aktivitas (Read-Only)
class AdminAuditSection extends StatefulWidget {
  const AdminAuditSection({Key? key}) : super(key: key);

  @override
  State<AdminAuditSection> createState() => _AdminAuditSectionState();
}

class _AdminAuditSectionState extends State<AdminAuditSection> {
  final _databaseHelper = DatabaseHelper();
  List<Map<String, dynamic>> _logs = [];
  bool _isLoading = true;
  int _selectedFilter = 0;

  @override
  void initState() {
    super.initState();
    _loadLogs();
  }

  Future<void> _loadLogs() async {
    try {
      setState(() {
        _isLoading = true;
      });

      final logs = await _databaseHelper.getActivityLogs(limit: 100);

      if (mounted) {
        setState(() {
          _logs = logs;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error: $e')));
      }
    }
  }

  List<Map<String, dynamic>> _getFilteredLogs() {
    if (_selectedFilter == 0) return _logs;
    if (_selectedFilter == 1) {
      return _logs
          .where(
            (log) =>
                log[AppConstants.colKategoriLog] == AppConstants.logTransaksi,
          )
          .toList();
    }
    if (_selectedFilter == 2) {
      return _logs
          .where(
            (log) =>
                log[AppConstants.colKategoriLog] == AppConstants.logOtorisasi,
          )
          .toList();
    }
    return _logs;
  }

  @override
  Widget build(BuildContext context) {
    final filteredLogs = _getFilteredLogs();

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

            // Loading state
            if (_isLoading)
              const Center(child: CircularProgressIndicator())
            else if (filteredLogs.isEmpty)
              const Center(
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 32),
                  child: Text('Tidak ada log aktivitas'),
                ),
              )
            else
              // List using LogTimelineTile
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: filteredLogs.length,
                itemBuilder: (context, index) {
                  final log = filteredLogs[index];
                  final kategori =
                      log[AppConstants.colKategoriLog] as String? ?? '';
                  final aktivitas =
                      log[AppConstants.colAktivitas] as String? ?? '';
                  final waktu = log[AppConstants.colWaktu] as String? ?? '';
                  final username = log[AppConstants.colUsername] ?? 'Sistem';
                  final role = log[AppConstants.colRole] ?? '-';

                  return Padding(
                    padding: EdgeInsets.only(
                      bottom: index != filteredLogs.length - 1 ? 16 : 0,
                    ),
                    child: LogTimelineTile(
                      title: aktivitas,
                      subtitle: 'Oleh: $username ($role)',
                      timestamp: waktu,
                      category: kategori,
                      icon: kategori == AppConstants.logTransaksi
                          ? Icons.car_rental
                          : Icons.security,
                      iconColor: kategori == AppConstants.logTransaksi
                          ? AppColors.info
                          : AppColors.warning,
                      isLast: index == filteredLogs.length - 1,
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
            _buildLogDetailRow(
              'Aktivitas',
              log[AppConstants.colAktivitas] as String? ?? '',
            ),
            const SizedBox(height: 12),
            _buildLogDetailRow(
              'Oleh',
              '${log[AppConstants.colUsername] ?? 'Sistem'} (${log[AppConstants.colRole] ?? '-'})',
            ),
            const SizedBox(height: 12),
            _buildLogDetailRow(
              'Kategori',
              log[AppConstants.colKategoriLog] as String? ?? '',
            ),
            const SizedBox(height: 12),
            _buildLogDetailRow(
              'Waktu',
              log[AppConstants.colWaktu] as String? ?? '',
            ),
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
