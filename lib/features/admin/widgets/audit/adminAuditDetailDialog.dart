// ignore_for_file: file_names

import 'package:flutter/material.dart';

import '../../../../config/colors.dart';
import '../../../../config/constants.dart';
import '../../../../services/format_helper.dart';

Future<void> showAdminAuditDetailDialog(
  BuildContext context,
  Map<String, dynamic> log,
) async {
  final rawWaktu = log[AppConstants.colWaktu] as String? ?? '';
  final waktu = rawWaktu.isNotEmpty
      ? FormatHelper.formatFullDate(
          DateTime.tryParse(rawWaktu) ?? DateTime.now(),
        )
      : '';

  await showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text('Detail Log Aktivitas'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _AdminAuditDetailRow(
            label: 'Aktivitas',
            value: log[AppConstants.colAktivitas] as String? ?? '',
          ),
          const SizedBox(height: 12),
          _AdminAuditDetailRow(
            label: 'Oleh',
            value:
                '${log[AppConstants.colUsername] ?? 'Sistem'} (${log[AppConstants.colRole] ?? '-'})',
          ),
          const SizedBox(height: 12),
          _AdminAuditDetailRow(
            label: 'Kategori',
            value: log[AppConstants.colKategoriLog] as String? ?? '',
          ),
          const SizedBox(height: 12),
          _AdminAuditDetailRow(label: 'Waktu', value: waktu),
          const SizedBox(height: 16),
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

class _AdminAuditDetailRow extends StatelessWidget {
  const _AdminAuditDetailRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
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
