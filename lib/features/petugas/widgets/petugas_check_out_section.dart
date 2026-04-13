import 'package:flutter/material.dart';
import '../../../config/colors.dart';
import '../../../widgets/widgets.dart';
import '../../../services/format_helper.dart';
import '../../../services/pdf_service.dart';

/// Petugas Check-Out Section - Pencarian dan checkout kendaraan
class PetugasCheckOutSection extends StatefulWidget {
  const PetugasCheckOutSection({Key? key}) : super(key: key);

  @override
  State<PetugasCheckOutSection> createState() => _PetugasCheckOutSectionState();
}

class _PetugasCheckOutSectionState extends State<PetugasCheckOutSection> {
  final _searchController = TextEditingController();

  // Mock data - nanti ganti dengan data dari DB
  final List<Map<String, dynamic>> _allTransactions = [
    {
      'id': 1,
      'platNomor': 'AB 1234 CD',
      'jenis': 'Motor',
      'merk': 'Honda Vario',
      'waktuMasuk': '08:30',
      'area': 'Blok A',
      'durasi': '2 jam',
      'biaya': 4000,
    },
    {
      'id': 2,
      'platNomor': 'DE 5678 FG',
      'jenis': 'Mobil',
      'merk': 'Toyota Avanza',
      'waktuMasuk': '09:15',
      'area': 'Blok B',
      'durasi': '1.5 jam',
      'biaya': 9000,
    },
    {
      'id': 3,
      'platNomor': 'HI 9012 JK',
      'jenis': 'Motor',
      'merk': 'Yamaha Nmax',
      'waktuMasuk': '10:00',
      'area': 'Blok A',
      'durasi': '1 jam',
      'biaya': 2000,
    },
  ];

  late List<Map<String, dynamic>> _filteredTransactions;

  @override
  void initState() {
    super.initState();
    _filteredTransactions = _allTransactions;
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
              (tx) =>
                  tx['platNomor'].toLowerCase().contains(query.toLowerCase()),
            )
            .toList();
      }
    });
  }

  void _showCheckoutDialog(Map<String, dynamic> transaction) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Konfirmasi Checkout'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildCheckoutDetail('Plat Nomor', transaction['platNomor']),
            const SizedBox(height: 12),
            _buildCheckoutDetail('Jenis Kendaraan', transaction['jenis']),
            const SizedBox(height: 12),
            _buildCheckoutDetail('Merk', transaction['merk']),
            const SizedBox(height: 12),
            _buildCheckoutDetail('Waktu Masuk', transaction['waktuMasuk']),
            const SizedBox(height: 12),
            _buildCheckoutDetail('Area', transaction['area']),
            const SizedBox(height: 12),
            _buildCheckoutDetail('Durasi', transaction['durasi']),
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
                    FormatHelper.formatRupiah(transaction['biaya']),
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

  void _handleCheckout(Map<String, dynamic> transaction) {
    // Show dialog untuk konfirmasi print struk
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Checkout Berhasil'),
        content: Text(
          'Kendaraan ${transaction['platNomor']} telah checkout.\n\nApakah Anda ingin mencetak struk?',
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _finishCheckout(transaction);
            },
            child: const Text('Tidak'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _printReceipt(transaction);
            },
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary),
            child: const Text('Print Struk'),
          ),
        ],
      ),
    );
  }

  void _finishCheckout(Map<String, dynamic> transaction) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Checkout berhasil untuk ${transaction['platNomor']}'),
        backgroundColor: AppColors.success,
      ),
    );

    // Hapus dari list
    setState(() {
      _filteredTransactions.removeWhere((tx) => tx['id'] == transaction['id']);
      _allTransactions.removeWhere((tx) => tx['id'] == transaction['id']);
    });
  }

  void _printReceipt(Map<String, dynamic> transaction) async {
    try {
      // Format data untuk PDF
      final waktuMasuk = DateTime.now().subtract(
        const Duration(hours: 2),
      ); // Mock waktu masuk 2 jam lalu
      final waktuKeluar = DateTime.now();

      await PdfService.generateParkingReceipt(
        platNomor: transaction['platNomor'],
        jenis: transaction['jenis'],
        merk: transaction['merk'],
        warna: transaction['warna'] ?? 'Tidak ada',
        area: transaction['area'],
        waktuMasuk: waktuMasuk,
        waktuKeluar: waktuKeluar,
        totalBiaya: transaction['biaya'],
        petugas: 'Petugas Parkir',
      );

      if (mounted) {
        _finishCheckout(transaction);
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error cetak struk: $e'),
          backgroundColor: AppColors.danger,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Text(
              'Kendaraan Keluar',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 8),
            Text(
              'Cari plat nomor kendaraan yang akan keluar',
              style: Theme.of(context).textTheme.bodySmall,
            ),
            const SizedBox(height: 24),

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
                                    tx['platNomor'],
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.primary,
                                      letterSpacing: 2,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    tx['merk'],
                                    style: const TextStyle(
                                      fontSize: 12,
                                      color: AppColors.inactive,
                                    ),
                                  ),
                                ],
                              ),
                              StatusBadge(status: tx['jenis'], fontSize: 11),
                            ],
                          ),
                          const SizedBox(height: 12),
                          // Info detail
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Masuk: ${tx['waktuMasuk']}',
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: AppColors.inactive,
                                ),
                              ),
                              Text(
                                'Area: ${tx['area']}',
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
                                'Durasi: ${tx['durasi']}',
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
                                  FormatHelper.formatRupiah(tx['biaya']),
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
