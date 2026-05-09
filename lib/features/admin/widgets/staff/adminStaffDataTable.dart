// ignore_for_file: file_names

import 'package:flutter/material.dart';

import '../../../../config/colors.dart';
import '../../../../config/constants.dart';
import '../../../../models/user_model.dart';

class AdminStaffDataTable extends StatelessWidget {
  const AdminStaffDataTable({
    super.key,
    required this.staff,
    required this.statusColorBuilder,
    required this.onDeactivatePressed,
    required this.onActivatePressed,
  });

  final List<UserModel> staff;
  final Color Function(String status) statusColorBuilder;
  final void Function(UserModel staff) onDeactivatePressed;
  final Future<void> Function(UserModel staff) onActivatePressed;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: staff.isEmpty
          ? Center(
              child: Padding(
                padding: const EdgeInsets.all(32),
                child: Text(
                  'Tidak ada data petugas',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ),
            )
          : DataTable(
              columns: const [
                DataColumn(
                  label: Text(
                    'No',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                DataColumn(
                  label: Text(
                    'Nama',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                DataColumn(
                  label: Text(
                    'Username',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                DataColumn(
                  label: Text(
                    'Status',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                DataColumn(
                  label: Text(
                    'Aksi',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ],
              rows: List<DataRow>.generate(staff.length, (index) {
                final item = staff[index];
                final isActive = item.status == AppConstants.statusAktif;
                final statusColor = statusColorBuilder(item.status);

                return DataRow(
                  cells: [
                    DataCell(Text('${index + 1}')),
                    DataCell(
                      Text(
                        item.namaLengkap,
                        style: const TextStyle(fontWeight: FontWeight.w600),
                      ),
                    ),
                    DataCell(Text('@${item.username}')),
                    DataCell(
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: statusColor.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          item.status,
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: statusColor,
                          ),
                        ),
                      ),
                    ),
                    DataCell(
                      isActive
                          ? ElevatedButton(
                              onPressed: () {
                                onDeactivatePressed(item);
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.danger,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 8,
                                ),
                              ),
                              child: const Text(
                                'Nonaktifkan',
                                style: TextStyle(fontSize: 11),
                              ),
                            )
                          : ElevatedButton(
                              onPressed: () async {
                                await onActivatePressed(item);
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.success,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 8,
                                ),
                              ),
                              child: const Text(
                                'Aktifkan',
                                style: TextStyle(fontSize: 11),
                              ),
                            ),
                    ),
                  ],
                );
              }),
            ),
    );
  }
}
