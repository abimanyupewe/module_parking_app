// ignore_for_file: file_names

import 'package:flutter/material.dart';

import '../../../../config/colors.dart';
import '../../../../config/constants.dart';
import '../../../../services/format_helper.dart';
import '../../../../widgets/widgets.dart';

class AdminAuditLogList extends StatelessWidget {
  const AdminAuditLogList({
    super.key,
    required this.logs,
    required this.onLogTap,
  });

  final List<Map<String, dynamic>> logs;
  final void Function(Map<String, dynamic> log) onLogTap;

  @override
  Widget build(BuildContext context) {
    if (logs.isEmpty) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 32),
          child: Text('Tidak ada log aktivitas'),
        ),
      );
    }

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: logs.length,
      itemBuilder: (context, index) {
        final log = logs[index];
        final kategori = log[AppConstants.colKategoriLog] as String? ?? '';
        final aktivitas = log[AppConstants.colAktivitas] as String? ?? '';
        final rawWaktu = log[AppConstants.colWaktu] as String? ?? '';
        final waktu = rawWaktu.isNotEmpty
            ? FormatHelper.formatFullDate(
                DateTime.tryParse(rawWaktu) ?? DateTime.now(),
              )
            : '';
        final username = log[AppConstants.colUsername] ?? 'Sistem';
        final role = log[AppConstants.colRole] ?? '-';

        return Padding(
          padding: EdgeInsets.only(bottom: index != logs.length - 1 ? 16 : 0),
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
            isLast: index == logs.length - 1,
            onTap: () => onLogTap(log),
          ),
        );
      },
    );
  }
}
