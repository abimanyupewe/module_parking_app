import 'package:flutter/material.dart';
import '../../../config/colors.dart';
import '../../../config/constants.dart';
import '../../../services/pdf_service.dart';
import '../../../services/database_helper.dart';
import '../../../core/preferences/app_preferences.dart';
import 'checkOut/petugasCheckoutDetailDialog.dart';
import 'checkOut/petugasCheckoutSearchAndList.dart';
import 'checkOut/petugasCheckoutStateViews.dart';

/// Petugas Check-Out Section - Pencarian dan checkout kendaraan
class PetugasCheckOutSection extends StatefulWidget {
  final VoidCallback? onCheckOutSuccess;

  const PetugasCheckOutSection({super.key, this.onCheckOutSuccess});

  @override
  State<PetugasCheckOutSection> createState() => _PetugasCheckOutSectionState();
}

class _PetugasCheckOutSectionState extends State<PetugasCheckOutSection> {
  final _searchController = TextEditingController();
  final _databaseHelper = DatabaseHelper();

  List<Map<String, dynamic>> _allTransactions = [];
  List<Map<String, dynamic>> _filteredTransactions = [];
  bool _isLoadingData = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    try {
      setState(() {
        _isLoadingData = true;
        _errorMessage = null;
      });

      final transactions = await _databaseHelper.getActiveTransactions();

      if (mounted) {
        setState(() {
          _allTransactions = transactions;
          _filteredTransactions = transactions;
          _isLoadingData = false;

          if (_allTransactions.isEmpty) {
            _errorMessage = 'Tidak ada kendaraan yang sedang parkir';
          }
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _errorMessage = 'Error loading data: $e';
          _isLoadingData = false;
        });
      }
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _filterTransactions(String query) {
    setState(() {
      if (query.isEmpty) {
        _filteredTransactions = _allTransactions;
      } else {
        _filteredTransactions = _allTransactions
            .where(
              (tx) => tx[AppConstants.colPlatNomor].toLowerCase().contains(
                query.toLowerCase(),
              ),
            )
            .toList();
      }
    });
  }

  void _showCheckoutDialog(Map<String, dynamic> transaction) {
    showPetugasCheckoutDetailDialog(
      context,
      transaction: transaction,
      formatTime: _formatTime,
      onConfirmCheckout: () {
        _handleCheckout(transaction);
      },
    );
  }

  String _formatTime(DateTime dateTime) {
    return '${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
  }

  void _handleCheckout(Map<String, dynamic> transaction) async {
    try {
      final transaksiId = transaction[AppConstants.colTransaksiId];
      final waktuMasuk =
          DateTime.tryParse(transaction[AppConstants.colWaktuMasuk] ?? '') ??
          DateTime.now();
      final waktuKeluar = DateTime.now();

      // Calculate total biaya based on actual duration
      final duration = waktuKeluar.difference(waktuMasuk);
      final jam = duration.inHours;
      final menit = duration.inMinutes % 60;
      final tarifPerJam = transaction[AppConstants.colTarifPerJam] ?? 0;

      // Hitung durasi dalam jam (minimum 1 jam)
      final durasiJam = jam + (menit > 0 ? 1 : 0);
      final durasiJam2 = durasiJam > 0 ? durasiJam : 1;
      final totalBiaya = tarifPerJam * durasiJam2;

      // Update transaksi di database
      await _databaseHelper.updateTransaksi(transaksiId, {
        AppConstants.colWaktuKeluar: waktuKeluar.toIso8601String(),
        AppConstants.colTransaksiStatus: AppConstants.statusSelesai,
        AppConstants.colTotalBiaya: totalBiaya,
      });

      // Update area capacity
      final areaId = transaction[AppConstants.colAreaId];
      final area = await _databaseHelper.getAreaParkirById(areaId);
      if (area != null) {
        final updatedArea = area.copyWith(terisi: area.terisi - 1);
        await _databaseHelper.updateAreaParkir(updatedArea);
      }

      // Get petugas name dari database
      final currentUserId = AppPreferences.getUserId() ?? 1;
      final petugas = await _databaseHelper.getUserById(currentUserId);
      final petugasName = petugas?.namaLengkap ?? 'Petugas Parkir';

      // Record activity log with petugas name
      await _databaseHelper.recordActivity(
        currentUserId, // userId dari session user
        AppConstants.logTransaksi,
        'Check-Out Kendaraan ${transaction[AppConstants.colPlatNomor]} oleh $petugasName dari Area ${area?.namaArea}',
      );

      if (mounted) {
        // Show success dialog dengan pilihan print
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Checkout Berhasil'),
            content: Text(
              'Kendaraan ${transaction[AppConstants.colPlatNomor]} telah checkout.\n\nApakah Anda ingin mencetak struk?',
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  _finishCheckout(
                    transaction,
                    waktuMasuk,
                    waktuKeluar,
                    totalBiaya,
                  );
                },
                child: const Text('Tidak'),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  _printReceipt(
                    transaction,
                    waktuMasuk,
                    waktuKeluar,
                    totalBiaya,
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                ),
                child: const Text('Print Struk'),
              ),
            ],
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error checkout: $e'),
            backgroundColor: AppColors.danger,
          ),
        );
      }
    }
  }

  void _finishCheckout(
    Map<String, dynamic> transaction,
    DateTime waktuMasuk,
    DateTime waktuKeluar,
    int totalBiaya,
  ) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Checkout berhasil untuk ${transaction[AppConstants.colPlatNomor]}',
        ),
        backgroundColor: AppColors.success,
      ),
    );

    // Refresh data untuk remove kendaraan yang sudah check-out
    _loadData();

    // Call callback to refresh area info
    widget.onCheckOutSuccess?.call();
  }

  void _printReceipt(
    Map<String, dynamic> transaction,
    DateTime waktuMasuk,
    DateTime waktuKeluar,
    int totalBiaya,
  ) async {
    try {
      final tarifPerJam = transaction[AppConstants.colTarifPerJam] ?? 0;

      await PdfService.generateParkingReceipt(
        platNomor: transaction[AppConstants.colPlatNomor],
        jenis: transaction[AppConstants.colNamaJenis] ?? 'N/A',
        merk: transaction[AppConstants.colMerk],
        warna: transaction[AppConstants.colWarna] ?? 'Tidak ada',
        area: transaction[AppConstants.colNamaArea],
        waktuMasuk: waktuMasuk,
        waktuKeluar: waktuKeluar,
        tarifPerJam: tarifPerJam,
        totalBiaya: totalBiaya,
      );

      if (mounted) {
        _finishCheckout(transaction, waktuMasuk, waktuKeluar, totalBiaya);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error cetak struk: $e'),
            backgroundColor: AppColors.danger,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // Show loading or error states
    if (_isLoadingData) {
      return const PetugasCheckoutLoadingView();
    }

    if (_errorMessage != null && _filteredTransactions.isEmpty) {
      return PetugasCheckoutErrorView(
        errorMessage: _errorMessage!,
        onRetry: _loadData,
      );
    }

    return PetugasCheckoutSearchAndList(
      searchController: _searchController,
      transactions: _filteredTransactions,
      onSearchChanged: _filterTransactions,
      onItemTap: _showCheckoutDialog,
      formatTime: _formatTime,
    );
  }
}
