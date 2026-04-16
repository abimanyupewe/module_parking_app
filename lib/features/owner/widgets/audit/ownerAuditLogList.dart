// ignore_for_file: file_names

import 'package:flutter/material.dart';

import '../../../../config/constants.dart';
import '../../../../services/format_helper.dart';
import '../../../../widgets/widgets.dart';

class OwnerAuditLogList extends StatelessWidget {
  const OwnerAuditLogList({
    super.key,
    required this.logs,
    required this.emptyMessage,
    required this.subtitlePrefix,
    required this.icon,
    required this.iconColor,
  });

  final List<Map<String, dynamic>> logs;
  final String emptyMessage;
  final String subtitlePrefix;
  final IconData icon;
  final Color iconColor;

  @override
  Widget build(BuildContext context) {
    if (logs.isEmpty) {
      return Center(child: Text(emptyMessage));
    }

    return ListView.builder(
      itemCount: logs.length,
      itemBuilder: (context, index) {
        final log = logs[index];
        final aktivitas = log[AppConstants.colAktivitas] as String? ?? '';
        final rawWaktu = log[AppConstants.colWaktu] as String? ?? '';
        final waktu = rawWaktu.isNotEmpty
            ? FormatHelper.formatFullDate(
                DateTime.tryParse(rawWaktu) ?? DateTime.now(),
              )
            : '';
        final username = log[AppConstants.colUsername] ?? 'Sistem';
        final role = log[AppConstants.colRole] ?? '-';

        return CompactLogTimelineTile(
          title: aktivitas,
          subtitle: '$subtitlePrefix: $username ($role)',
          timestamp: waktu,
          icon: icon,
          iconColor: iconColor,
          isLast: index == logs.length - 1,
        );
      },
    );
  }
}
