// ignore_for_file: file_names

import 'package:flutter/material.dart';

import '../../../../../config/colors.dart';
import '../../../../../config/constants.dart';
import '../../../../../models/user_model.dart';
import '../../../../../services/database_helper.dart';
import '../../../../../services/error_handler.dart';

Future<void> showOwnerSdmToggleStatusDialog({
  required BuildContext context,
  required DatabaseHelper databaseHelper,
  required UserModel sdm,
  required Future<void> Function() reloadData,
}) async {
  final isAktif = sdm.status == AppConstants.statusAktif;
  final action = isAktif ? 'dinonaktifkan' : 'diaktifkan';

  await showDialog(
    context: context,
    builder: (dialogContext) => AlertDialog(
      title: Text(isAktif ? 'Nonaktifkan SDM' : 'Aktifkan SDM'),
      content: Text(
        isAktif
            ? 'Apakah Anda yakin ingin menonaktifkan ${sdm.namaLengkap}? SDM tidak akan bisa login ke sistem.'
            : 'Apakah Anda yakin ingin mengaktifkan kembali ${sdm.namaLengkap}?',
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(dialogContext),
          child: const Text('Batal'),
        ),
        ElevatedButton(
          onPressed: () async {
            Navigator.pop(dialogContext);
            try {
              final updatedUser = sdm.copyWith(
                status: isAktif
                    ? AppConstants.statusNonaktif
                    : AppConstants.statusAktif,
              );

              await databaseHelper.updateUser(updatedUser);

              if (dialogContext.mounted) {
                await reloadData();
                if (dialogContext.mounted) {
                  ScaffoldMessenger.of(dialogContext).showSnackBar(
                    SnackBar(
                      content: Text('SDM ${sdm.namaLengkap} berhasil $action'),
                    ),
                  );
                }
              }
            } catch (e) {
              if (dialogContext.mounted) {
                final errorMsg = ErrorHandler.transformError(e);
                ScaffoldMessenger.of(
                  dialogContext,
                ).showSnackBar(SnackBar(content: Text(errorMsg)));
              }
            }
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: isAktif ? AppColors.danger : AppColors.success,
          ),
          child: Text(isAktif ? 'Nonaktifkan' : 'Aktifkan'),
        ),
      ],
    ),
  );
}
