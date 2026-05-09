// ignore_for_file: file_names

import 'package:flutter/material.dart';

import '../../../../config/colors.dart';
import '../../../../config/constants.dart';
import '../../../../models/user_model.dart';
import '../../../../widgets/widgets.dart';

class OwnerSdmTable extends StatelessWidget {
  const OwnerSdmTable({
    super.key,
    required this.data,
    required this.isLoading,
    required this.searchQuery,
    required this.selectedRole,
    required this.onEdit,
    required this.onToggleStatus,
    required this.onDelete,
  });

  final List<UserModel> data;
  final bool isLoading;
  final String searchQuery;
  final String? selectedRole;
  final ValueChanged<UserModel> onEdit;
  final ValueChanged<UserModel> onToggleStatus;
  final ValueChanged<UserModel> onDelete;

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (data.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 32),
          child: Text(
            searchQuery.isEmpty && selectedRole == null
                ? 'Tidak ada SDM'
                : 'SDM tidak ditemukan',
            style: const TextStyle(color: AppColors.inactive),
          ),
        ),
      );
    }

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: DataTable(
        columnSpacing: 16,
        horizontalMargin: 0,
        headingRowColor: WidgetStateProperty.all(
          AppColors.tertiary.withValues(alpha: 0.5),
        ),
        dataRowColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return AppColors.secondary.withValues(alpha: 0.5);
          }
          return AppColors.white;
        }),
        columns: const [
          DataColumn(
            label: Text(
              'Nama',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: AppColors.primary,
              ),
            ),
          ),
          DataColumn(
            label: Text(
              'Username',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: AppColors.primary,
              ),
            ),
          ),
          DataColumn(
            label: Text(
              'Role',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: AppColors.primary,
              ),
            ),
          ),
          DataColumn(
            label: Text(
              'Status',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: AppColors.primary,
              ),
            ),
          ),
          DataColumn(
            label: Text(
              'Aksi',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: AppColors.primary,
              ),
            ),
          ),
        ],
        rows: List.generate(data.length, (index) {
          final sdm = data[index];
          return DataRow(
            cells: [
              DataCell(
                Text(
                  sdm.namaLengkap,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: AppColors.primary,
                  ),
                ),
              ),
              DataCell(
                Text(sdm.username, style: const TextStyle(fontSize: 12)),
              ),
              DataCell(Text(sdm.role, style: const TextStyle(fontSize: 12))),
              DataCell(StatusBadge(status: sdm.status, fontSize: 11)),
              DataCell(
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(
                      height: 32,
                      child: OutlinedButton(
                        onPressed: () => onEdit(sdm),
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                        ),
                        child: const Text(
                          'Edit',
                          style: TextStyle(fontSize: 11),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    SizedBox(
                      height: 32,
                      child: OutlinedButton(
                        onPressed: () => onToggleStatus(sdm),
                        style: OutlinedButton.styleFrom(
                          foregroundColor:
                              sdm.status == AppConstants.statusAktif
                              ? AppColors.warning
                              : AppColors.success,
                          side: BorderSide(
                            color: sdm.status == AppConstants.statusAktif
                                ? AppColors.warning
                                : AppColors.success,
                          ),
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                        ),
                        child: Text(
                          sdm.status == AppConstants.statusAktif
                              ? 'Nonaktifkan'
                              : 'Aktifkan',
                          style: const TextStyle(fontSize: 11),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    SizedBox(
                      height: 32,
                      child: OutlinedButton(
                        onPressed: () => onDelete(sdm),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: AppColors.danger,
                          side: const BorderSide(color: AppColors.danger),
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                        ),
                        child: const Text(
                          'Hapus',
                          style: TextStyle(fontSize: 11),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        }),
      ),
    );
  }
}
