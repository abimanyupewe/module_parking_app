import 'package:flutter/material.dart';
import '../config/colors.dart';

/// Custom data table widget untuk menampilkan data dalam format tabel
class CustomDataTable extends StatelessWidget {
  final List<String> columns;
  final List<List<String>> rows;
  final List<Color>? columnBackgroundColors;
  final bool showAlternateRowColors;
  final double rowHeight;
  final VoidCallback? onRowTap;
  final int? selectedRowIndex;
  final bool isLoading;
  final String? emptyMessage;
  final EdgeInsets cellPadding;

  const CustomDataTable({
    Key? key,
    required this.columns,
    required this.rows,
    this.columnBackgroundColors,
    this.showAlternateRowColors = true,
    this.rowHeight = 48,
    this.onRowTap,
    this.selectedRowIndex,
    this.isLoading = false,
    this.emptyMessage = 'Tidak ada data',
    this.cellPadding = const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            CircularProgressIndicator(),
            SizedBox(height: 16),
            Text('Memuat data...'),
          ],
        ),
      );
    }

    if (rows.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.inbox_outlined, size: 64, color: AppColors.inactive),
              const SizedBox(height: 16),
              Text(
                emptyMessage ?? 'Tidak ada data',
                style: const TextStyle(fontSize: 16, color: AppColors.inactive),
              ),
            ],
          ),
        ),
      );
    }

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: DataTable(
        columnSpacing: 12,
        horizontalMargin: 0,
        headingRowColor: MaterialStateProperty.all(
          AppColors.tertiary.withValues(alpha: 0.5),
        ),
        dataRowColor: MaterialStateProperty.resolveWith((states) {
          if (states.contains(MaterialState.selected)) {
            return AppColors.secondary.withValues(alpha: 0.5);
          }
          if (showAlternateRowColors &&
              rows.indexOf(rows.firstWhere((element) => element == element)) %
                      2 ==
                  1) {
            return AppColors.surface;
          }
          return AppColors.white;
        }),
        columns: columns
            .map(
              (column) => DataColumn(
                label: Text(
                  column,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: AppColors.primary,
                  ),
                ),
              ),
            )
            .toList(),
        rows: List.generate(
          rows.length,
          (index) => DataRow(
            selected: selectedRowIndex == index,
            onSelectChanged: (_) => onRowTap?.call(),
            cells: rows[index]
                .map(
                  (cell) => DataCell(
                    Text(
                      cell,
                      style: const TextStyle(
                        fontSize: 12,
                        color: AppColors.black,
                      ),
                    ),
                  ),
                )
                .toList(),
          ),
        ),
      ),
    );
  }
}
