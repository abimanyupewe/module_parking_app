import 'package:flutter/material.dart';
import '../../../config/colors.dart';
import '../../../widgets/widgets.dart';

/// Owner Audit Section - Log Transaksi & Otorisasi
class OwnerAuditSection extends StatefulWidget {
  const OwnerAuditSection({Key? key}) : super(key: key);

  @override
  State<OwnerAuditSection> createState() => _OwnerAuditSectionState();
}

class _OwnerAuditSectionState extends State<OwnerAuditSection>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  final List<Map<String, dynamic>> _logTransaksi = [
    {
      'waktu': '10:45',
      'jenis': 'Check-In',
      'plat': 'AB 1234 CD',
      'petugas': 'Budi',
    },
    {
      'waktu': '10:30',
      'jenis': 'Check-Out',
      'plat': 'DE 5678 FG',
      'petugas': 'Ani',
    },
    {
      'waktu': '10:15',
      'jenis': 'Check-In',
      'plat': 'HI 9012 JK',
      'petugas': 'Roni',
    },
  ];

  final List<Map<String, dynamic>> _logOtorisasi = [
    {'waktu': '09:00', 'aktivitas': 'Disable Petugas', 'target': 'roni_p'},
    {'waktu': '08:30', 'aktivitas': 'Edit Kategori', 'target': 'Motor Roda 2'},
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
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
            child: TabBarView(
              controller: _tabController,
              children: [_buildTransaksiLog(), _buildOtoriasLog()],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTransaksiLog() {
    return ListView.builder(
      itemCount: _logTransaksi.length,
      itemBuilder: (context, index) {
        final log = _logTransaksi[index];
        return CompactLogTimelineTile(
          title: '${log['jenis']}: ${log['plat']}',
          timestamp: '${log['waktu']} oleh ${log['petugas']}',
          icon: log['jenis'] == 'Check-In' ? Icons.login : Icons.logout,
          iconColor: log['jenis'] == 'Check-In'
              ? AppColors.success
              : AppColors.warning,
          isLast: index == _logTransaksi.length - 1,
        );
      },
    );
  }

  Widget _buildOtoriasLog() {
    return ListView.builder(
      itemCount: _logOtorisasi.length,
      itemBuilder: (context, index) {
        final log = _logOtorisasi[index];
        return CompactLogTimelineTile(
          title: log['aktivitas'],
          timestamp: '${log['waktu']} • ${log['target']}',
          icon: Icons.security,
          iconColor: AppColors.warning,
          isLast: index == _logOtorisasi.length - 1,
        );
      },
    );
  }
}
