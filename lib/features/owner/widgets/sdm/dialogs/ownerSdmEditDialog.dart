// ignore_for_file: file_names

import 'package:flutter/material.dart';

import '../../../../../config/colors.dart';
import '../../../../../models/user_model.dart';
import '../../../../../services/database_helper.dart';
import '../../../../../services/error_handler.dart';
import '../../../../../services/password_service.dart';
import '../../../../../widgets/widgets.dart';

Future<void> showOwnerSdmEditDialog({
  required BuildContext context,
  required DatabaseHelper databaseHelper,
  required UserModel staff,
  required List<String> roles,
  required Future<void> Function() reloadData,
}) async {
  final namaController = TextEditingController(text: staff.namaLengkap);
  final usernameController = TextEditingController(text: staff.username);
  final passwordController = TextEditingController();
  String? selectedRole = staff.role;

  await showDialog(
    context: context,
    builder: (dialogContext) => StatefulBuilder(
      builder: (dialogContext, setDialogState) => AlertDialog(
        title: const Text('Edit SDM'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CustomTextField(
                controller: namaController,
                label: 'Nama Lengkap',
                hint: 'Masukkan nama lengkap',
              ),
              const SizedBox(height: 12),
              CustomTextField(
                controller: usernameController,
                label: 'Username',
                hint: 'username_unik',
              ),
              const SizedBox(height: 12),
              CustomTextField(
                controller: passwordController,
                label: 'Password Baru (Kosongkan jika tidak ingin diubah)',
                hint: 'Masukkan password baru',
                obscureText: true,
              ),
              const SizedBox(height: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Role',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: AppColors.primary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: AppColors.tertiary),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: DropdownButton<String>(
                      isExpanded: true,
                      underline: const SizedBox(),
                      value: selectedRole,
                      items: roles.map((role) {
                        return DropdownMenuItem<String>(
                          value: role,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 12),
                            child: Text(role),
                          ),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setDialogState(() {
                          selectedRole = value;
                        });
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () async {
              if (namaController.text.isEmpty) {
                ScaffoldMessenger.of(dialogContext).showSnackBar(
                  const SnackBar(content: Text('Nama tidak boleh kosong')),
                );
                return;
              }
              if (usernameController.text.isEmpty) {
                ScaffoldMessenger.of(dialogContext).showSnackBar(
                  const SnackBar(content: Text('Username tidak boleh kosong')),
                );
                return;
              }

              try {
                final String computedPassword =
                    passwordController.text.isNotEmpty
                    ? PasswordService.hashPassword(passwordController.text)
                    : staff.password;

                final updatedUser = staff.copyWith(
                  namaLengkap: namaController.text,
                  username: usernameController.text,
                  password: computedPassword,
                  role: selectedRole != null
                      ? selectedRole!.toLowerCase()
                      : staff.role,
                );

                await databaseHelper.updateUser(updatedUser);

                if (dialogContext.mounted) {
                  Navigator.pop(dialogContext);
                  await reloadData();
                  if (dialogContext.mounted) {
                    ScaffoldMessenger.of(dialogContext).showSnackBar(
                      SnackBar(
                        content: Text(
                          'SDM ${namaController.text} berhasil diperbarui',
                        ),
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
            child: const Text('Perbarui'),
          ),
        ],
      ),
    ),
  );
}
