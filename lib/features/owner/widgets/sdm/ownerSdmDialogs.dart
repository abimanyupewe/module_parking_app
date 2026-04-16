// ignore_for_file: file_names

import 'package:flutter/material.dart';

import '../../../../config/colors.dart';
import '../../../../config/constants.dart';
import '../../../../models/user_model.dart';
import '../../../../services/database_helper.dart';
import '../../../../services/error_handler.dart';
import '../../../../services/password_service.dart';
import '../../../../widgets/widgets.dart';

Future<void> showOwnerSdmAddDialog({
  required BuildContext context,
  required DatabaseHelper databaseHelper,
  required List<String> roles,
  required Future<void> Function() reloadData,
}) async {
  final namaController = TextEditingController();
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();
  String? selectedRole;

  await showDialog(
    context: context,
    builder: (dialogContext) => StatefulBuilder(
      builder: (dialogContext, setDialogState) => AlertDialog(
        title: const Text('Tambah SDM Baru'),
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
                label: 'Password',
                hint: 'Masukkan password',
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
                      hint: const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 12),
                        child: Text('Pilih Role'),
                      ),
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
              if (passwordController.text.isEmpty) {
                ScaffoldMessenger.of(dialogContext).showSnackBar(
                  const SnackBar(content: Text('Password tidak boleh kosong')),
                );
                return;
              }
              if (selectedRole == null) {
                ScaffoldMessenger.of(dialogContext).showSnackBar(
                  const SnackBar(content: Text('Pilih role terlebih dahulu')),
                );
                return;
              }

              try {
                final isDuplicate = await databaseHelper.isDuplicateUsername(
                  usernameController.text,
                );
                if (isDuplicate) {
                  if (dialogContext.mounted) {
                    ScaffoldMessenger.of(dialogContext).showSnackBar(
                      SnackBar(
                        content: Text(
                          'Username \'${usernameController.text}\' sudah terdaftar. Silakan gunakan username lain.',
                        ),
                      ),
                    );
                  }
                  return;
                }

                final hashedPassword = PasswordService.hashPassword(
                  passwordController.text,
                );

                final user = UserModel(
                  namaLengkap: namaController.text,
                  username: usernameController.text,
                  password: hashedPassword,
                  role: selectedRole!.toLowerCase(),
                  status: AppConstants.statusAktif,
                );

                await databaseHelper.insertUser(user);

                if (dialogContext.mounted) {
                  Navigator.pop(dialogContext);
                  await reloadData();
                  if (dialogContext.mounted) {
                    ScaffoldMessenger.of(dialogContext).showSnackBar(
                      SnackBar(
                        content: Text(
                          'SDM ${namaController.text} berhasil ditambahkan',
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
            child: const Text('Tambah'),
          ),
        ],
      ),
    ),
  );
}

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
