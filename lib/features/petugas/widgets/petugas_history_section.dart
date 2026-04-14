import 'package:flutter/material.dart';
import '../../../config/colors.dart';
import '../../../config/constants.dart';
import '../../../widgets/widgets.dart';
import '../../../services/format_helper.dart';
import '../../../services/database_helper.dart';

/// Petugas History Section - Riwayat transaksi
class PetugasHistorySection extends StatefulWidget {
  const PetugasHistorySection({super.key});

  @override
  State<PetugasHistorySection> createState() => _PetugasHistorySectionState();
}

class _PetugasHistorySectionState extends State<PetugasHistorySection> {
  final _databaseHelper = DatabaseHelper();

  List<Map<String, dynamic>> _historyData = [];
  bool _isLoading = true;
  String? _errorMessage;

  int _selectedFilterIndex = 0;
  final List<String> _filters = [
    'Semua',
    'Hari Ini',
    'Minggu Ini',
    'Bulan Ini',
  ];

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    try {
      setState(() {
        _isLoading = true;
        _errorMessage = null;
      });

      final historyData = await _databaseHelper.getAllTransactions();

      if (mounted) {
        setState(() {
          _historyData = historyData;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _errorMessage = 'Error loading data: $e';
          _isLoading = false;
        });
      }
    }
  }

  /// Calculate filtered history data based on selected filter
  List<Map<String, dynamic>> get _filteredHistoryData {
    if (_selectedFilterIndex == 0) {
      // Semua
      return _historyData;
    }

    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final weekAgo = today.subtract(
      Duration(days: today.weekday - 1),
    ); // Monday of this week
    final monthAgo = DateTime(now.year, now.month, 1); // First day of month

    return _historyData.where((item) {
      final waktuMasuk = DateTime.tryParse(
        item[AppConstants.colWaktuMasuk] ?? '',
      );
      if (waktuMasuk == null) return false;

      final itemDate = DateTime(
        waktuMasuk.year,
        waktuMasuk.month,
        waktuMasuk.day,
      );

      switch (_selectedFilterIndex) {
        case 1: // Hari Ini
          return itemDate.isAtSameMomentAs(today);
        case 2: // Minggu Ini
          return waktuMasuk.isAfter(weekAgo) &&
              waktuMasuk.isBefore(today.add(Duration(days: 1)));
        case 3: // Bulan Ini
          return waktuMasuk.isAfter(monthAgo) &&
              waktuMasuk.isBefore(now.add(Duration(days: 1)));
        default:
          return true;
      }
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    // Show loading or error states
    if (_isLoading) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const CircularProgressIndicator(),
            const SizedBox(height: 16),
            const Text('Memuat riwayat transaksi...'),
          ],
        ),
      );
    }

    if (_errorMessage != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, color: AppColors.danger, size: 48),
            const SizedBox(height: 16),
            Text(
              _errorMessage!,
              textAlign: TextAlign.center,
              style: const TextStyle(color: AppColors.danger),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _loadData,
              child: const Text('Coba Lagi'),
            ),
          ],
        ),
      );
    }

    final displayData = _filteredHistoryData;
    final totalBiaya = displayData.fold<int>(
      0,
      (sum, item) => sum + (item[AppConstants.colTotalBiaya] as int? ?? 0),
    );

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Text(
              'Riwayat Transaksi',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 16),

            // Filter chips
            SizedBox(
              height: 40,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: _filters.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: EdgeInsets.only(
                      right: index != _filters.length - 1 ? 8 : 0,
                    ),
                    child: CustomFilterChip(
                      label: _filters[index],
                      isSelected: _selectedFilterIndex == index,
                      onTap: () {
                        setState(() {
                          _selectedFilterIndex = index;
                        });
                      },
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 24),

            // Summary
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildSummaryItem('Total Transaksi', '${displayData.length}'),
                _buildSummaryItem(
                  'Total Pendapatan',
                  FormatHelper.formatRupiah(totalBiaya),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Table
            if (displayData.isEmpty)
              Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 32),
                  child: Column(
                    children: [
                      Icon(
                        Icons.inbox_outlined,
                        size: 64,
                        color: AppColors.inactive,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Tidak ada transaksi untuk periode ini',
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 14,
                          color: AppColors.inactive,
                        ),
                      ),
                    ],
                  ),
                ),
              )
            else
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: DataTable(
                  columnSpacing: 16,
                  dataRowMinHeight: 56,
                  dataRowMaxHeight: 56,
                  headingRowHeight: 48,
                  showCheckboxColumn: false,
                  columns: const [
                    DataColumn(label: Text('Plat Nomor')),
                    DataColumn(label: Text('Jenis')),
                    DataColumn(label: Text('Masuk')),
                    DataColumn(label: Text('Keluar')),
                    DataColumn(label: Text('Durasi')),
                    DataColumn(label: Text('Biaya'), numeric: true),
                  ],
                  rows: displayData.map((history) {
                    final waktuMasuk = DateTime.tryParse(
                      history[AppConstants.colWaktuMasuk] ?? '',
                    );
                    final waktuKeluar = DateTime.tryParse(
                      history[AppConstants.colWaktuKeluar] ?? '',
                    );
                    final durasi = waktuMasuk != null && waktuKeluar != null
                        ? waktuKeluar.difference(waktuMasuk)
                        : Duration.zero;
                    final durasiText = durasi.inHours > 0
                        ? '${durasi.inHours}h ${durasi.inMinutes % 60}m'
                        : '${durasi.inMinutes}m';

                    return DataRow(
                      cells: [
                        DataCell(
                          Text(
                            history[AppConstants.colPlatNomor],
                            style: const TextStyle(fontWeight: FontWeight.w600),
                          ),
                        ),
                        DataCell(
                          Text(history[AppConstants.colNamaJenis] ?? 'N/A'),
                        ),
                        DataCell(
                          Text(
                            _formatDateTime(
                              history[AppConstants.colWaktuMasuk],
                            ),
                          ),
                        ),
                        DataCell(
                          Text(
                            _formatDateTime(
                              history[AppConstants.colWaktuKeluar],
                            ),
                          ),
                        ),
                        DataCell(Text(durasiText)),
                        DataCell(
                          Text(
                            FormatHelper.formatRupiah(
                              history[AppConstants.colTotalBiaya] ?? 0,
                            ),
                            style: const TextStyle(
                              fontWeight: FontWeight.w600,
                              color: AppColors.primary,
                            ),
                          ),
                        ),
                      ],
                    );
                  }).toList(),
                ),
              ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryItem(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 12, color: AppColors.inactive),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: AppColors.primary,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  String _formatDateTime(String? dateTimeStr) {
    if (dateTimeStr == null || dateTimeStr.isEmpty) return 'N/A';
    try {
      final dateTime = DateTime.parse(dateTimeStr);
      return '${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
    } catch (e) {
      return 'N/A';
    }
  }
}
