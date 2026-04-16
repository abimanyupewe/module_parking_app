// ignore_for_file: file_names

import 'package:flutter/material.dart';

import '../../../../config/colors.dart';
import '../../../../models/area_parkir_model.dart';
import '../../../../models/jenis_kendaraan_model.dart';
import '../../../../services/database_helper.dart';
import '../../../../services/error_handler.dart';
import '../../../../widgets/widgets.dart';

Future<void> showAdminKategoriDialog({
  required BuildContext context,
  required DatabaseHelper databaseHelper,
  required JenisKendaraanModel? data,
  required Future<void> Function() reloadData,
}) async {
  final namaController = TextEditingController(text: data?.namaJenis ?? '');
  final tarifController = TextEditingController(
    text: data?.tarifPerJam.toString() ?? '',
  );

  await showDialog(
    context: context,
    builder: (dialogContext) => AlertDialog(
      title: Text(data == null ? 'Tambah Kategori' : 'Edit Kategori'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CustomTextField(
            controller: namaController,
            label: 'Nama Kategori',
            hint: 'Misal: Motor Roda 2',
          ),
          const SizedBox(height: 12),
          CustomTextField(
            controller: tarifController,
            label: 'Tarif/Jam (Rp)',
            hint: '2000',
            inputType: TextInputType.number,
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(dialogContext),
          child: const Text('Batal'),
        ),
        ElevatedButton(
          onPressed: () async {
            final messenger = ScaffoldMessenger.of(dialogContext);

            try {
              if (namaController.text.isEmpty || tarifController.text.isEmpty) {
                messenger.showSnackBar(
                  const SnackBar(content: Text('Semua field harus diisi')),
                );
                return;
              }

              if (data == null) {
                final isDuplicate = await databaseHelper
                    .isDuplicateJenisKendaraan(namaController.text);
                if (isDuplicate) {
                  messenger.showSnackBar(
                    SnackBar(
                      content: Text(
                        'Kategori \'${namaController.text}\' sudah ada dalam database. Silakan gunakan nama yang berbeda.',
                      ),
                    ),
                  );
                  return;
                }
              }

              final tarif = int.tryParse(tarifController.text) ?? 0;
              final kategori = JenisKendaraanModel(
                idJenis: data?.idJenis,
                namaJenis: namaController.text,
                tarifPerJam: tarif,
              );

              if (data == null) {
                await databaseHelper.insertJenisKendaraan(kategori);
              } else {
                await databaseHelper.updateJenisKendaraan(kategori);
              }

              if (dialogContext.mounted) {
                Navigator.pop(dialogContext);
              }

              await reloadData();

              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      'Kategori ${namaController.text} berhasil ${data == null ? 'ditambahkan' : 'diperbarui'}',
                    ),
                  ),
                );
              }
            } catch (e) {
              final errorMsg = ErrorHandler.transformError(e);
              if (dialogContext.mounted) {
                messenger.showSnackBar(SnackBar(content: Text(errorMsg)));
              }
            }
          },
          child: const Text('Simpan'),
        ),
      ],
    ),
  );
}

Future<void> showAdminAreaDialog({
  required BuildContext context,
  required DatabaseHelper databaseHelper,
  required AreaParkirModel? data,
  required List<JenisKendaraanModel> kategori,
  required Future<void> Function() reloadData,
}) async {
  int? selectedKategoriId = data?.idJenis;
  final namaController = TextEditingController(text: data?.namaArea ?? '');
  final kapasitasController = TextEditingController(
    text: data?.kapasitas.toString() ?? '',
  );

  await showDialog(
    context: context,
    builder: (dialogContext) => StatefulBuilder(
      builder: (dialogContext, setDialogState) => AlertDialog(
        title: Text(data == null ? 'Tambah Area' : 'Edit Area'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CustomTextField(
              controller: namaController,
              label: 'Nama Area',
              hint: 'Misal: Blok A',
            ),
            const SizedBox(height: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Kategori',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                ),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  decoration: BoxDecoration(
                    border: Border.all(color: AppColors.border),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: DropdownButton<int?>(
                    value: selectedKategoriId,
                    isExpanded: true,
                    underline: const SizedBox(),
                    hint: const Text('Pilih Kategori'),
                    items: kategori.map((kat) {
                      return DropdownMenuItem<int?>(
                        value: kat.idJenis,
                        child: Text(kat.namaJenis),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setDialogState(() {
                        selectedKategoriId = value;
                      });
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            CustomTextField(
              controller: kapasitasController,
              label: 'Kapasitas',
              hint: '50',
              inputType: TextInputType.number,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () async {
              final messenger = ScaffoldMessenger.of(dialogContext);

              try {
                if (namaController.text.isEmpty) {
                  messenger.showSnackBar(
                    const SnackBar(content: Text('Nama area harus diisi')),
                  );
                  return;
                }

                if (selectedKategoriId == null) {
                  messenger.showSnackBar(
                    const SnackBar(
                      content: Text('Pilih kategori terlebih dahulu'),
                    ),
                  );
                  return;
                }

                if (data == null) {
                  final isDuplicate = await databaseHelper
                      .isDuplicateAreaParkir(namaController.text);
                  if (isDuplicate) {
                    messenger.showSnackBar(
                      SnackBar(
                        content: Text(
                          'Area \'${namaController.text}\' sudah ada dalam database. Silakan gunakan nama yang berbeda.',
                        ),
                      ),
                    );
                    return;
                  }
                }

                final kapasitas = int.tryParse(kapasitasController.text) ?? 0;
                final area = AreaParkirModel(
                  idArea: data?.idArea,
                  namaArea: namaController.text,
                  idJenis: selectedKategoriId ?? 0,
                  kapasitas: kapasitas,
                  terisi: data?.terisi ?? 0,
                );

                if (data == null) {
                  await databaseHelper.insertAreaParkir(area);
                } else {
                  await databaseHelper.updateAreaParkir(area);
                }

                if (dialogContext.mounted) {
                  Navigator.pop(dialogContext);
                }

                await reloadData();

                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        'Area ${namaController.text} berhasil ${data == null ? 'ditambahkan' : 'diperbarui'}',
                      ),
                    ),
                  );
                }
              } catch (e) {
                final errorMsg = ErrorHandler.transformError(e);
                if (dialogContext.mounted) {
                  messenger.showSnackBar(SnackBar(content: Text(errorMsg)));
                }
              }
            },
            child: const Text('Simpan'),
          ),
        ],
      ),
    ),
  );
}

Future<void> showAdminDeleteKategoriDialog({
  required BuildContext context,
  required DatabaseHelper databaseHelper,
  required int idKategori,
  required Future<void> Function() reloadData,
}) async {
  await showDialog(
    context: context,
    builder: (dialogContext) => AlertDialog(
      title: const Text('Konfirmasi Hapus'),
      content: const Text('Anda yakin ingin menghapus kategori ini?'),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(dialogContext),
          child: const Text('Batal'),
        ),
        TextButton(
          onPressed: () async {
            try {
              if (dialogContext.mounted) {
                Navigator.pop(dialogContext);
              }
              await databaseHelper.deleteJenisKendaraan(idKategori);
              await reloadData();
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Kategori dihapus')),
                );
              }
            } catch (e) {
              final errorMsg = ErrorHandler.transformError(e);
              if (context.mounted) {
                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(SnackBar(content: Text(errorMsg)));
              }
            }
          },
          style: TextButton.styleFrom(foregroundColor: AppColors.danger),
          child: const Text('Hapus'),
        ),
      ],
    ),
  );
}

Future<void> showAdminDeleteAreaDialog({
  required BuildContext context,
  required DatabaseHelper databaseHelper,
  required int idArea,
  required Future<void> Function() reloadData,
}) async {
  await showDialog(
    context: context,
    builder: (dialogContext) => AlertDialog(
      title: const Text('Konfirmasi Hapus'),
      content: const Text('Anda yakin ingin menghapus area ini?'),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(dialogContext),
          child: const Text('Batal'),
        ),
        TextButton(
          onPressed: () async {
            try {
              if (dialogContext.mounted) {
                Navigator.pop(dialogContext);
              }
              await databaseHelper.deleteAreaParkir(idArea);
              await reloadData();
              if (context.mounted) {
                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(const SnackBar(content: Text('Area dihapus')));
              }
            } catch (e) {
              final errorMsg = ErrorHandler.transformError(e);
              if (context.mounted) {
                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(SnackBar(content: Text(errorMsg)));
              }
            }
          },
          style: TextButton.styleFrom(foregroundColor: AppColors.danger),
          child: const Text('Hapus'),
        ),
      ],
    ),
  );
}
