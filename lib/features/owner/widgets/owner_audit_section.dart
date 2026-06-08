import 'package:flutter/material.dart';
import '../../../config/colors.dart';
import '../../../config/constants.dart';
import '../../../services/database_helper.dart';
import '../../../services/pdf_service.dart';
import '../../../services/csv_service.dart';
import 'audit/ownerAuditHeader.dart';
import 'audit/ownerAuditLogList.dart';
import 'audit/ownerAuditTabBar.dart';

/// Owner Audit Section - Log Transaksi & Otorisasi
class OwnerAuditSection extends StatefulWidget {
  const OwnerAuditSection({super.key});

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
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Pilih Format Export'),
        content: const Text(
          'Pilih format file untuk mengekspor log aktivitas:',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal'),
          ),
          ElevatedButton.icon(
            onPressed: () {
              Navigator.pop(context);
              _exportActivityLogToCSV();
            },
            icon: const Icon(Icons.download),
            label: const Text('CSV'),
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary),
          ),
          ElevatedButton.icon(
            onPressed: () {
              Navigator.pop(context);
              _exportActivityLogToPDF();
            },
            icon: const Icon(Icons.picture_as_pdf),
            label: const Text('PDF'),
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary),
          ),
        ],
      ),
    );
  }

  Future<void> _exportActivityLogToCSV() async {
    try {
      final logs = _tabController.index == 0 ? _logTransaksi : _logOtorisasi;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const Icon(Icons.downloading, color: Colors.white),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  'Mengunduh ${logs.length} log aktivitas sebagai CSV...',
                ),
              ),
            ],
          ),
          duration: const Duration(seconds: 3),
          backgroundColor: Colors.blue[600],
        ),
      );

      await CsvService.generateActivityLogCSV(logs: logs);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                const Icon(Icons.check_circle, color: Colors.white),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Berhasil mengunduh ${logs.length} log aktivitas',
                  ),
                ),
              ],
            ),
            duration: const Duration(seconds: 2),
            backgroundColor: Colors.green[600],
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: $e'),
            backgroundColor: AppColors.danger,
          ),
        );
      }
    }
  }

  Future<void> _exportActivityLogToPDF() async {
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
          OwnerAuditHeader(onPrintPressed: _printActivityLog),
          const SizedBox(height: 16),
          OwnerAuditTabBar(controller: _tabController),
          const SizedBox(height: 16),
          // Content
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : TabBarView(
                    controller: _tabController,
                    children: [
                      OwnerAuditLogList(
                        logs: _logTransaksi,
                        emptyMessage: 'Tidak ada log transaksi',
                        subtitlePrefix: 'Petugas',
                        icon: Icons.login,
                        iconColor: AppColors.success,
                      ),
                      OwnerAuditLogList(
                        logs: _logOtorisasi,
                        emptyMessage: 'Tidak ada log otorisasi',
                        subtitlePrefix: 'Oleh',
                        icon: Icons.security,
                        iconColor: AppColors.warning,
                      ),
                    ],
                  ),
          ),
        ],
      ),
    );
  }
}
