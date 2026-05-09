// ignore_for_file: file_names

import 'package:flutter/material.dart';

import '../../../../config/colors.dart';
import '../../../../models/jenis_kendaraan_model.dart';
import '../../../../widgets/widgets.dart';

class AdminKategoriListPanel extends StatelessWidget {
  const AdminKategoriListPanel({
    super.key,
    required this.isLoading,
    required this.errorMessage,
    required this.kategori,
    required this.onAdd,
    required this.onEdit,
    required this.onDelete,
  });

  final bool isLoading;
  final String? errorMessage;
  final List<JenisKendaraanModel> kategori;
  final VoidCallback onAdd;
  final ValueChanged<JenisKendaraanModel> onEdit;
  final ValueChanged<int> onDelete;

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (errorMessage != null) {
      return Center(
        child: Text(
          'Error: $errorMessage',
          style: const TextStyle(color: AppColors.danger),
        ),
      );
    }

    return Column(
      children: [
        PrimaryButton(
          label: 'Tambah Kategori',
          onPressed: onAdd,
          width: double.infinity,
          icon: const Icon(Icons.add),
        ),
        const SizedBox(height: 16),
        Expanded(
          child: kategori.isEmpty
              ? const Center(
                  child: Text(
                    'Tidak ada kategori',
                    style: TextStyle(color: AppColors.inactive),
                  ),
                )
              : ListView.builder(
                  itemCount: kategori.length,
                  itemBuilder: (context, index) {
                    final kat = kategori[index];
                    return Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: AppColors.white,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: AppColors.tertiary),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  kat.namaJenis,
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.primary,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'Rp ${kat.tarifPerJam}/jam',
                                  style: const TextStyle(
                                    fontSize: 12,
                                    color: AppColors.inactive,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          PopupMenuButton(
                            itemBuilder: (context) => [
                              PopupMenuItem(
                                child: const Text('Edit'),
                                onTap: () => onEdit(kat),
                              ),
                              PopupMenuItem(
                                child: const Text('Hapus'),
                                onTap: () => onDelete(kat.idJenis ?? 0),
                              ),
                            ],
                          ),
                        ],
                      ),
                    );
                  },
                ),
        ),
      ],
    );
  }
}
