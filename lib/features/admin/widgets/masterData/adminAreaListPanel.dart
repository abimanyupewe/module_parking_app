// ignore_for_file: file_names

import 'package:flutter/material.dart';

import '../../../../config/colors.dart';
import '../../../../models/area_parkir_model.dart';
import '../../../../widgets/widgets.dart';

class AdminAreaListPanel extends StatelessWidget {
  const AdminAreaListPanel({
    super.key,
    required this.isLoading,
    required this.errorMessage,
    required this.area,
    required this.getKategoriNama,
    required this.onAdd,
    required this.onEdit,
    required this.onDelete,
  });

  final bool isLoading;
  final String? errorMessage;
  final List<AreaParkirModel> area;
  final String Function(int idJenis) getKategoriNama;
  final VoidCallback onAdd;
  final ValueChanged<AreaParkirModel> onEdit;
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
          label: 'Tambah Area',
          onPressed: onAdd,
          width: double.infinity,
          icon: const Icon(Icons.add),
        ),
        const SizedBox(height: 16),
        Expanded(
          child: area.isEmpty
              ? const Center(
                  child: Text(
                    'Tidak ada area',
                    style: TextStyle(color: AppColors.inactive),
                  ),
                )
              : ListView.builder(
                  itemCount: area.length,
                  itemBuilder: (context, index) {
                    final ar = area[index];
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
                                  ar.namaArea,
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.primary,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  '${getKategoriNama(ar.idJenis)} • Kapasitas: ${ar.kapasitas}',
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
                                onTap: () => onEdit(ar),
                              ),
                              PopupMenuItem(
                                child: const Text('Hapus'),
                                onTap: () => onDelete(ar.idArea ?? 0),
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
