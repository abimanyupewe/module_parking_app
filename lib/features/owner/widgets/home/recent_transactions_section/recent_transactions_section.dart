import 'package:flutter/material.dart';
import '../../../../../services/database_helper.dart';
import '../../../../../services/format_helper.dart';
import '../../../../../config/constants.dart';
import 'transaction_item.dart';

/// Recent Transactions Section - Displays recent parking transactions
class RecentTransactionsSection extends StatefulWidget {
  const RecentTransactionsSection({super.key});

  @override
  State<RecentTransactionsSection> createState() =>
      _RecentTransactionsSectionState();
}

class _RecentTransactionsSectionState extends State<RecentTransactionsSection> {
  late DatabaseHelper _dbHelper;
  List<Map<String, dynamic>> _transactions = [];
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _dbHelper = DatabaseHelper();
    _loadRecentTransactions();
  }

  Future<void> _loadRecentTransactions() async {
    if (!mounted) return;
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final transactions = await _dbHelper.getRecentTransactionsWithDetails(
        limit: 5,
      );
      if (mounted) {
        setState(() {
          _transactions = transactions;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _errorMessage = 'Gagal memuat transaksi terakhir: $e';
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Transaksi Terakhir',
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            TextButton(onPressed: () {}, child: const Text('Lihat Semua')),
          ],
        ),
        const SizedBox(height: 12),
        if (_isLoading)
          _buildLoadingState()
        else if (_errorMessage != null)
          _buildErrorState()
        else if (_transactions.isEmpty)
          _buildEmptyState()
        else
          _buildTransactionsList(),
      ],
    );
  }

  Widget _buildLoadingState() {
    return Column(
      children: List.generate(
        3,
        (index) => Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey[300]!),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(height: 13, width: 80, color: Colors.grey[300]),
                      const SizedBox(height: 6),
                      Container(
                        height: 11,
                        width: 150,
                        color: Colors.grey[300],
                      ),
                    ],
                  ),
                ),
                Container(height: 13, width: 60, color: Colors.grey[300]),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildErrorState() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.red),
        borderRadius: BorderRadius.circular(8),
        color: Colors.red[50],
      ),
      child: Column(
        children: [
          Text(
            _errorMessage ?? 'Terjadi kesalahan',
            style: const TextStyle(color: Colors.red, fontSize: 12),
          ),
          const SizedBox(height: 8),
          ElevatedButton(
            onPressed: _loadRecentTransactions,
            child: const Text('Coba Lagi'),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey[300]!),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Center(
        child: Text(
          'Tidak ada transaksi terakhir',
          style: TextStyle(color: Colors.grey[600]),
        ),
      ),
    );
  }

  Widget _buildTransactionsList() {
    return Column(
      children: List.generate(_transactions.length, (index) {
        final transaction = _transactions[index];
        final plate = transaction[AppConstants.colPlatNomor] ?? '-';
        final jenisKendaraan = transaction[AppConstants.colNamaJenis] ?? '-';
        final areaName = transaction[AppConstants.colNamaArea] ?? '-';
        final waktuMasuk = transaction[AppConstants.colWaktuMasuk] as String?;
        final totalBiaya = transaction[AppConstants.colTotalBiaya] as num? ?? 0;

        String formattedTime = '-';
        if (waktuMasuk != null && waktuMasuk.isNotEmpty) {
          try {
            final dateTime = DateTime.parse(waktuMasuk);
            formattedTime = FormatHelper.formatDateTime(dateTime);
          } catch (e) {
            formattedTime = waktuMasuk;
          }
        }
        final formattedFee = FormatHelper.formatRupiah(totalBiaya.toInt());

        return Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: TransactionItem(
            plate: plate,
            type: jenisKendaraan,
            area: areaName,
            time: formattedTime,
            fee: formattedFee,
          ),
        );
      }),
    );
  }
}
