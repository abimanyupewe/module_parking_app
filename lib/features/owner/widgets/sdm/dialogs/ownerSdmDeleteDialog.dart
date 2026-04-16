// ignore_for_file: file_names

import 'package:flutter/material.dart';

import '../../../../../models/user_model.dart';
import '../../../../../services/database_helper.dart';
import '../../../../../services/error_handler.dart';

Future<void> showOwnerSdmDeleteDialog({
  required BuildContext context,
  required DatabaseHelper databaseHelper,
  required UserModel sdm,
  required Future<void> Function() reloadData,
}) async {
  await showDialog(
    context: context,
    builder: (dialogContext) => AlertDialog(
      title: const Text('Hapus SDM'),
      content: Text('Anda yakin ingin menghapus ${sdm.namaLengkap}?'),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(dialogContext),
          child: const Text('Batal'),
        ),
        TextButton(
          onPressed: () async {
            try {
              await databaseHelper.deleteUser(sdm.idUser ?? 0);

              if (dialogContext.mounted) {
                Navigator.pop(dialogContext);
                await reloadData();
                if (dialogContext.mounted) {
                  ScaffoldMessenger.of(dialogContext).showSnackBar(
                    SnackBar(
                      content: Text('SDM ${sdm.namaLengkap} berhasil dihapus'),
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
          style: TextButton.styleFrom(foregroundColor: Colors.red),
          child: const Text('Hapus'),
        ),
      ],
    ),
  );
}
