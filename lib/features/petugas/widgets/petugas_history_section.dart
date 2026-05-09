import 'dart:io';
import 'package:flutter/material.dart';
import 'dart:async';
import '../../../config/colors.dart';
import '../../../services/format_helper.dart';
import '../../../services/database_helper.dart';
import 'history/petugasHistoryTabContent.dart';

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
  final int _itemsPerPage = 10;
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
    final currentPage = isCompleted
        ? _currentPageCompleted
        : _currentPageOngoing;

    final totalPages = (data.length / _itemsPerPage).ceil();

    return PetugasHistoryTabContent(
      data: data,
      isCompleted: isCompleted,
      itemsPerPage: _itemsPerPage,
      currentPage: currentPage,
      onPrevious: currentPage > 0
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
      onNext: currentPage < totalPages - 1
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
      formatDateTime: _formatDateTime,
      formatDuration: _formatDuration,
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

  String _formatDuration({
    required bool isCompleted,
    required DateTime? waktuMasuk,
    required DateTime? waktuKeluar,
  }) {
    if (isCompleted && waktuMasuk != null && waktuKeluar != null) {
      final durasi = waktuKeluar.difference(waktuMasuk);
      return durasi.inHours > 0
          ? '${durasi.inHours}h ${durasi.inMinutes % 60}m'
          : '${durasi.inMinutes}m';
    }

    if (!isCompleted && waktuMasuk != null) {
      final durasi = DateTime.now().difference(waktuMasuk);
      return durasi.inHours > 0
          ? '${durasi.inHours}h ${durasi.inMinutes % 60}m'
          : '${durasi.inMinutes}m';
    }

    return 'N/A';
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
