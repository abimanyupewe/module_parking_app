import 'package:flutter/material.dart';
import '../../../config/colors.dart';
import '../../../services/database_helper.dart';
import '../../../services/pdf_service.dart';
import 'historySection/ownerHistorySectionHeader.dart';
import 'historySection/ownerHistorySectionDateFilterBar.dart';
import 'historySection/ownerHistorySectionSummary.dart';
import 'historySection/ownerHistorySectionTable.dart';

/// Owner History Section - Global history dengan data table
class OwnerHistorySection extends StatefulWidget {
  const OwnerHistorySection({super.key});

  @override
  State<OwnerHistorySection> createState() => _OwnerHistorySectionState();
}

class _OwnerHistorySectionState extends State<OwnerHistorySection> {
  final _databaseHelper = DatabaseHelper();
  String _searchQuery = '';
  DateTime? _selectedDate;

  List<Map<String, dynamic>> _allHistory = [];
  List<Map<String, dynamic>> _filteredHistory = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadHistory();
  }

  Future<void> _loadHistory() async {
    try {
      setState(() {
        _isLoading = true;
      });

      final transactions = await _databaseHelper.getAllTransactions();

      if (mounted) {
        setState(() {
          _allHistory = transactions;
          _filteredHistory = _allHistory;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error: $e')));
      }
    }
  }

  void _filterHistory(String query) {
    setState(() {
      _searchQuery = query;
      _applyAllFilters();
    });
  }

  void _applyAllFilters() {
    _filteredHistory = _allHistory.where((item) {
      final platNomor = item['plat_nomor'] as String? ?? '';

      // Filter berdasarkan search query (plat nomor)
      if (!platNomor.toLowerCase().contains(_searchQuery.toLowerCase())) {
        return false;
      }

      // Filter berdasarkan tanggal
      if (_selectedDate != null) {
        final waktuMasukStr = item['waktu_masuk'] as String? ?? '';
        try {
          final itemDate = DateTime.parse(waktuMasukStr);
          if (itemDate.year != _selectedDate!.year ||
              itemDate.month != _selectedDate!.month ||
              itemDate.day != _selectedDate!.day) {
            return false;
          }
        } catch (e) {
          return false;
        }
      }

      return true;
    }).toList();
  }

  void _clearFilters() {
    setState(() {
      _selectedDate = null;
      _searchQuery = '';
      _filteredHistory = _allHistory;
    });
  }

  void _onDateChanged(DateTime? value) {
    setState(() {
      _selectedDate = value;
      _applyAllFilters();
    });
  }

  Future<void> _selectDate() async {
    try {
      if (!mounted) return;

      final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: _selectedDate ?? DateTime.now(),
        firstDate: DateTime(2020),
        lastDate: DateTime.now().add(const Duration(days: 365)),
      );

      if (picked != null && mounted) {
        _onDateChanged(picked);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error memilih tanggal: $e')));
      }
    }
  }

  Future<void> _printHistory() async {
    try {
      await PdfService.generateTransactionReport(
        transactions: _filteredHistory,
        reportTitle: 'LAPORAN TRANSAKSI PARKIR',
      );
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error cetak laporan: $e'),
            backgroundColor: AppColors.danger,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final totalBiaya = _filteredHistory.fold<int>(0, (sum, item) {
      final biaya = item['total_biaya'] as int? ?? 0;
      return sum + biaya;
    });

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          OwnerHistorySectionHeader(
            onSearchChanged: _filterHistory,
            onPrintPressed: _printHistory,
          ),
          const SizedBox(height: 16),

          OwnerHistorySectionDateFilterBar(
            selectedDate: _selectedDate,
            onSelectDate: _selectDate,
            onClearFilter: _clearFilters,
          ),
          const SizedBox(height: 16),

          OwnerHistorySectionSummary(
            totalTransaksi: _filteredHistory.length,
            totalBiaya: totalBiaya,
          ),
          const SizedBox(height: 24),

          OwnerHistorySectionTable(
            data: _filteredHistory,
            searchQuery: _searchQuery,
            selectedDate: _selectedDate,
            isLoading: _isLoading,
          ),
        ],
      ),
    );
  }
}
