import 'package:flutter/material.dart';
import '../../../config/colors.dart';
import '../../../config/constants.dart';
import '../../../services/database_helper.dart';
import '../../../widgets/widgets.dart';
import '../../../services/pdf_service.dart';

/// Owner Audit Section - Log Transaksi & Otorisasi
class OwnerAuditSection extends StatefulWidget {
  const OwnerAuditSection({Key? key}) : super(key: key);

  @override
  State<OwnerAuditSection> createState() => _OwnerAuditSectionState();
}

class _OwnerAuditSectionState extends State<OwnerAuditSection>
    with SingleTickerProviderStateMixin {
  final _databaseHelper = DatabaseHelper();
  late TabController _tabController;

  List<Map<String, dynamic>> _logTransaksi = [];
  List<Map<String, dynamic>> _logOtorisasi = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _loadLogs();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _loadLogs() async {
    try {
      setState(() {
        _isLoading = true;
      });

      // Load transaction logs
      final transaksiLogs = await _databaseHelper.getActivityLogs(
        kategori: AppConstants.logTransaksi,
        limit: 50,
      );

      // Load authorization logs
      final otoriasLogs = await _databaseHelper.getActivityLogs(
        kategori: AppConstants.logOtorisasi,
        limit: 50,
      );

      if (mounted) {
        setState(() {
          _logTransaksi = transaksiLogs;
          _logOtorisasi = otoriasLogs;
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
        ).showSnackBar(SnackBar(content: Text('Error loading logs: $e')));
      }
    }
  }

  Future<void> _printActivityLog() async {
    try {
      final logs = _tabController.index == 0 ? _logTransaksi : _logOtorisasi;
      await PdfService.generateActivityLogReport(logs: logs);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error cetak laporan: $e'),
            backgroundColor: AppColors.danger,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          // Header dengan print button
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Audit Log',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              ElevatedButton.icon(
                onPressed: _printActivityLog,
                icon: const Icon(Icons.print, size: 18),
                label: const Text('Print'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: AppColors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          // Tab
          TabBar(
            controller: _tabController,
            labelColor: AppColors.primary,
            unselectedLabelColor: AppColors.inactive,
            indicator: UnderlineTabIndicator(
              borderSide: BorderSide(color: AppColors.primary, width: 2),
            ),
            tabs: const [
              Tab(text: 'Log Transaksi'),
              Tab(text: 'Log Otorisasi'),
            ],
          ),
          const SizedBox(height: 16),
          // Content
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : TabBarView(
                    controller: _tabController,
                    children: [_buildTransaksiLog(), _buildOtoriasLog()],
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildTransaksiLog() {
    if (_logTransaksi.isEmpty) {
      return const Center(child: Text('Tidak ada log transaksi'));
    }

    return ListView.builder(
      itemCount: _logTransaksi.length,
      itemBuilder: (context, index) {
        final log = _logTransaksi[index];
        final aktivitas = log[AppConstants.colAktivitas] as String? ?? '';
        final waktu = log[AppConstants.colWaktu] as String? ?? '';
        final username = log[AppConstants.colUsername] ?? 'Sistem';
        final role = log[AppConstants.colRole] ?? '-';

        return CompactLogTimelineTile(
          title: aktivitas,
          subtitle: 'Petugas: $username ($role)',
          timestamp: waktu,
          icon: Icons.login,
          iconColor: AppColors.success,
          isLast: index == _logTransaksi.length - 1,
        );
      },
    );
  }

  Widget _buildOtoriasLog() {
    if (_logOtorisasi.isEmpty) {
      return const Center(child: Text('Tidak ada log otorisasi'));
    }

    return ListView.builder(
      itemCount: _logOtorisasi.length,
      itemBuilder: (context, index) {
        final log = _logOtorisasi[index];
        final aktivitas = log[AppConstants.colAktivitas] as String? ?? '';
        final waktu = log[AppConstants.colWaktu] as String? ?? '';
        final username = log[AppConstants.colUsername] ?? 'Sistem';
        final role = log[AppConstants.colRole] ?? '-';

        final subtitle = 'Oleh: $username ($role)';

        return CompactLogTimelineTile(
          title: aktivitas,
          subtitle: subtitle,
          timestamp: waktu,
          icon: Icons.security,
          iconColor: AppColors.warning,
          isLast: index == _logOtorisasi.length - 1,
        );
      },
    );
  }
}
