import 'dart:io';
import 'package:flutter/material.dart';
import 'dart:async';
import '../../../config/colors.dart';
import '../../../config/constants.dart';
import '../../../services/format_helper.dart';
import '../../../services/database_helper.dart';

/// Petugas History Section - Riwayat transaksi
class PetugasHistorySection extends StatefulWidget {
  const PetugasHistorySection({super.key});

  @override
  State<PetugasHistorySection> createState() => _PetugasHistorySectionState();
}

class _PetugasHistorySectionState extends State<PetugasHistorySection>
    with TickerProviderStateMixin {
  final _databaseHelper = DatabaseHelper();

  List<Map<String, dynamic>> _completedData = [];
  List<Map<String, dynamic>> _ongoingData = [];
  bool _isLoading = true;
  String? _errorMessage;

  // Pagination
  int _itemsPerPage = 10;
  int _currentPageCompleted = 0;
  int _currentPageOngoing = 0;

  late TabController _tabController;
  Timer? _refreshTimer;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _loadData();
    // Refresh ongoing data every 5 seconds for real-time durasi
    _startAutoRefresh();
  }

  void _startAutoRefresh() {
    _refreshTimer = Timer.periodic(Duration(seconds: 5), (_) {
      if (mounted) {
        _loadData(silent: true);
      }
    });
  }

  Future<void> _loadData({bool silent = false}) async {
    try {
      if (!silent) {
        setState(() {
          _isLoading = true;
          _errorMessage = null;
        });
      }

      final completedData = await _databaseHelper.getCompletedTransactions();
      final ongoingData = await _databaseHelper.getOngoingTransactions();

      if (mounted) {
        setState(() {
          _completedData = completedData;
          _ongoingData = ongoingData;
          if (!silent) {
            _isLoading = false;
          }
        });
      }
    } catch (e) {
      if (mounted && !silent) {
        setState(() {
          _errorMessage = 'Error loading data: $e';
          _isLoading = false;
        });
      }
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    _refreshTimer?.cancel();
    super.dispose();
  }

  Widget _buildTabContent(List<Map<String, dynamic>> data, bool isCompleted) {
    final displayData = data;
    final totalBiaya = displayData.fold<int>(
      0,
      (sum, item) => sum + (item[AppConstants.colTotalBiaya] as int? ?? 0),
    );

    // Calculate pagination
    final totalPages = (displayData.length / _itemsPerPage).ceil();
    final currentPage = isCompleted
        ? _currentPageCompleted
        : _currentPageOngoing;
    final startIndex = currentPage * _itemsPerPage;
    final endIndex = (startIndex + _itemsPerPage).clamp(0, displayData.length);
    final paginatedData = displayData.sublist(startIndex, endIndex);

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
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
                        isCompleted
                            ? 'Tidak ada transaksi selesai untuk periode ini'
                            : 'Tidak ada kendaraan sedang parkir',
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
                  columns: [
                    const DataColumn(label: Text('Foto')),
                    const DataColumn(label: Text('Plat Nomor')),
                    const DataColumn(label: Text('Jenis')),
                    const DataColumn(label: Text('Masuk')),
                    if (isCompleted) const DataColumn(label: Text('Keluar')),
                    const DataColumn(label: Text('Durasi')),
                    const DataColumn(label: Text('Biaya'), numeric: true),
                  ],
                  rows: paginatedData.map((history) {
                    final waktuMasuk = DateTime.tryParse(
                      history[AppConstants.colWaktuMasuk] ?? '',
                    );
                    final waktuKeluar = DateTime.tryParse(
                      history[AppConstants.colWaktuKeluar] ?? '',
                    );

                    String durasiText = 'N/A';
                    if (isCompleted &&
                        waktuMasuk != null &&
                        waktuKeluar != null) {
                      final durasi = waktuKeluar.difference(waktuMasuk);
                      durasiText = durasi.inHours > 0
                          ? '${durasi.inHours}h ${durasi.inMinutes % 60}m'
                          : '${durasi.inMinutes}m';
                    } else if (!isCompleted && waktuMasuk != null) {
                      // Real-time durasi for ongoing transactions
                      final durasi = DateTime.now().difference(waktuMasuk);
                      durasiText = durasi.inHours > 0
                          ? '${durasi.inHours}h ${durasi.inMinutes % 60}m'
                          : '${durasi.inMinutes}m';
                    }

                    final String? imagePath = history['image_path'] as String?;

                    return DataRow(
                      cells: [
                        DataCell(
                          imagePath != null && imagePath.isNotEmpty
                              ? Container(
                                  width: 40,
                                  height: 40,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(4),
                                    image: DecorationImage(
                                      image: FileImage(File(imagePath)),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                )
                              : Container(
                                  width: 40,
                                  height: 40,
                                  decoration: BoxDecoration(
                                    color: AppColors.tertiary,
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  child: const Icon(
                                    Icons.broken_image,
                                    size: 20,
                                    color: AppColors.inactive,
                                  ),
                                ),
                        ),
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
                        if (isCompleted)
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
            const SizedBox(height: 24),

            // Pagination Controls - Simple
            if (displayData.isNotEmpty)
              Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextButton(
                      onPressed: currentPage > 0
                          ? () {
                              setState(() {
                                if (isCompleted) {
                                  _currentPageCompleted--;
                                } else {
                                  _currentPageOngoing--;
                                }
                              });
                            }
                          : null,
                      child: const Text('← Sebelumnya'),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: Text(
                        '${currentPage + 1}/${totalPages > 0 ? totalPages : 1}',
                        style: const TextStyle(
                          fontSize: 13,
                          color: AppColors.inactive,
                        ),
                      ),
                    ),
                    TextButton(
                      onPressed: currentPage < totalPages - 1
                          ? () {
                              setState(() {
                                if (isCompleted) {
                                  _currentPageCompleted++;
                                } else {
                                  _currentPageOngoing++;
                                }
                              });
                            }
                          : null,
                      child: const Text('Berikutnya →'),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
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
              onPressed: () => _loadData(),
              child: const Text('Coba Lagi'),
            ),
          ],
        ),
      );
    }

    return Column(
      children: [
        // Header
        Padding(
          padding: const EdgeInsets.all(16),
          child: Text(
            'Riwayat Transaksi',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
        ),

        // Tab Bar
        Container(
          color: AppColors.white,
          child: TabBar(
            controller: _tabController,
            indicator: BoxDecoration(
              border: Border(
                bottom: BorderSide(color: AppColors.primary, width: 3),
              ),
            ),
            indicatorColor: AppColors.primary,
            labelColor: AppColors.primary,
            unselectedLabelColor: AppColors.inactive,
            tabs: [
              Tab(text: 'Selesai (${_completedData.length})'),
              Tab(text: 'Sedang Parkir (${_ongoingData.length})'),
            ],
          ),
        ),

        // Tab Content
        Expanded(
          child: TabBarView(
            controller: _tabController,
            children: [
              _buildTabContent(_completedData, true),
              _buildTabContent(_ongoingData, false),
            ],
          ),
        ),
      ],
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
      return FormatHelper.formatFullDate(dateTime);
    } catch (e) {
      return 'N/A';
    }
  }
}
