import 'package:flutter/material.dart';
import '../../../config/colors.dart';
import '../../../config/constants.dart';
import '../../../widgets/widgets.dart';
import '../../../services/format_helper.dart';
import '../../../services/pdf_service.dart';
import '../../../services/database_helper.dart';

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
    final waktuMasuk =
        DateTime.tryParse(transaction[AppConstants.colWaktuMasuk] ?? '') ??
        DateTime.now();
    final durasi = DateTime.now().difference(waktuMasuk);
    final durasiText = '${durasi.inHours}h ${durasi.inMinutes % 60}m';

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Konfirmasi Checkout'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildCheckoutDetail(
              'Plat Nomor',
              transaction[AppConstants.colPlatNomor],
            ),
            const SizedBox(height: 12),
            _buildCheckoutDetail(
              'Jenis Kendaraan',
              transaction[AppConstants.colNamaJenis] ?? 'N/A',
            ),
            const SizedBox(height: 12),
            _buildCheckoutDetail('Merk', transaction[AppConstants.colMerk]),
            const SizedBox(height: 12),
            _buildCheckoutDetail('Waktu Masuk', _formatTime(waktuMasuk)),
            const SizedBox(height: 12),
            _buildCheckoutDetail('Area', transaction[AppConstants.colNamaArea]),
            const SizedBox(height: 12),
            _buildCheckoutDetail('Durasi', durasiText),
            const SizedBox(height: 16),
            // Total biaya dengan highlight
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: AppColors.primary),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Total Biaya',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: AppColors.primary,
                    ),
                  ),
                  Text(
                    FormatHelper.formatRupiah(
                      transaction[AppConstants.colTotalBiaya] ?? 0,
                    ),
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primary,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _handleCheckout(transaction);
            },
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary),
            child: const Text('Konfirmasi Checkout'),
          ),
        ],
      ),
    );
  }

  Widget _buildCheckoutDetail(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 13, color: AppColors.inactive),
        ),
        Text(
          value,
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: AppColors.primary,
          ),
        ),
      ],
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

      // Record activity log
      await _databaseHelper.recordActivity(
        1, // userId (TODO: Ambil dari session user)
        AppConstants.logTransaksi,
        'Check-Out Kendaraan ${transaction[AppConstants.colPlatNomor]} dari Area ${area?.namaArea}',
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
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const CircularProgressIndicator(),
            const SizedBox(height: 16),
            const Text('Memuat data transaksi...'),
          ],
        ),
      );
    }

    if (_errorMessage != null && _filteredTransactions.isEmpty) {
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

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Search Bar
            CustomSearchBar(
              hintText: 'Cari plat nomor... (3+ karakter)',
              onChanged: _filterTransactions,
              controller: _searchController,
              prefixIcon: Icons.search,
              backgroundColor: AppColors.tertiary,
            ),
            const SizedBox(height: 24),

            // List
            if (_filteredTransactions.isEmpty)
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
                        _searchController.text.isEmpty
                            ? 'Tidak ada kendaraan yang sedang parkir'
                            : 'Kendaraan tidak ditemukan',
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
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: _filteredTransactions.length,
                itemBuilder: (context, index) {
                  final tx = _filteredTransactions[index];
                  final waktuMasuk =
                      DateTime.tryParse(tx[AppConstants.colWaktuMasuk] ?? '') ??
                      DateTime.now();
                  final durasi = DateTime.now().difference(waktuMasuk);
                  final durasiText =
                      '${durasi.inHours}h ${durasi.inMinutes % 60}m';

                  return GestureDetector(
                    onTap: () => _showCheckoutDialog(tx),
                    child: Container(
                      margin: EdgeInsets.only(
                        bottom: index != _filteredTransactions.length - 1
                            ? 12
                            : 0,
                      ),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: AppColors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: AppColors.tertiary),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.black.withValues(alpha: 0.05),
                            blurRadius: 4,
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Plat nomor & jenis
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    tx[AppConstants.colPlatNomor],
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.primary,
                                      letterSpacing: 2,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    tx[AppConstants.colMerk],
                                    style: const TextStyle(
                                      fontSize: 12,
                                      color: AppColors.inactive,
                                    ),
                                  ),
                                ],
                              ),
                              StatusBadge(
                                status: tx[AppConstants.colNamaJenis] ?? 'N/A',
                                fontSize: 11,
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          // Info detail
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Masuk: ${_formatTime(waktuMasuk)}',
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: AppColors.inactive,
                                ),
                              ),
                              Text(
                                'Area: ${tx[AppConstants.colNamaArea]}',
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: AppColors.inactive,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          // Durasi & Biaya
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Durasi: $durasiText',
                                style: const TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.primary,
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: AppColors.primary.withValues(
                                    alpha: 0.1,
                                  ),
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Text(
                                  FormatHelper.formatRupiah(
                                    tx[AppConstants.colTotalBiaya] ?? 0,
                                  ),
                                  style: const TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.primary,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
