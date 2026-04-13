import 'package:flutter/material.dart';
import '../../../config/colors.dart';
import '../../../widgets/widgets.dart';
import '../../../services/pdf_service.dart';

/// Admin Monitoring Section - List kendaraan yang sedang parkir
class AdminMonitoringSection extends StatefulWidget {
  const AdminMonitoringSection({Key? key}) : super(key: key);

  @override
  State<AdminMonitoringSection> createState() => _AdminMonitoringSectionState();
}

class _AdminMonitoringSectionState extends State<AdminMonitoringSection> {
  // Mock data - nanti ganti dengan data dari DB
  final List<Map<String, dynamic>> _parkingData = [
    {
      'id': 1,
      'platNomor': 'AB 1234 CD',
      'jenis': 'Motor',
      'merk': 'Honda Vario',
      'waktuMasuk': '08:30',
      'area': 'Blok A',
      'status': 'Parkir',
      'durasiJam': 2,
    },
    {
      'id': 2,
      'platNomor': 'DE 5678 FG',
      'jenis': 'Mobil',
      'merk': 'Toyota Avanza',
      'waktuMasuk': '09:15',
      'area': 'Blok B',
      'status': 'Parkir',
      'durasiJam': 1,
    },
    {
      'id': 3,
      'platNomor': 'HI 9012 JK',
      'jenis': 'Motor',
      'merk': 'Yamaha Nmax',
      'waktuMasuk': '10:00',
      'area': 'Blok A',
      'status': 'Parkir',
      'durasiJam': 0,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header dengan print button
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Monitoring Parkir Real-Time',
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Kendaraan yang sedang parkir saat ini',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
              ),
              ElevatedButton.icon(
                onPressed: _printParkedVehicles,
                icon: const Icon(Icons.print, size: 18),
                label: const Text('Print'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: AppColors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 10,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),

          // Summary
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.secondary.withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.tertiary),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildSummaryItem(
                  'Total Parkir',
                  '${_parkingData.length}',
                  Icons.car_rental,
                ),
                _buildSummaryItem('Motor', '2', Icons.two_wheeler),
                _buildSummaryItem('Mobil', '1', Icons.directions_car),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // List
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _parkingData.length,
            itemBuilder: (context, index) {
              final data = _parkingData[index];
              return Container(
                margin: EdgeInsets.only(
                  bottom: index != _parkingData.length - 1 ? 12 : 0,
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
                    // Header
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              data['platNomor'],
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: AppColors.primary,
                                letterSpacing: 2,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              data['merk'],
                              style: const TextStyle(
                                fontSize: 12,
                                color: AppColors.inactive,
                              ),
                            ),
                          ],
                        ),
                        StatusBadge(status: data['status'], fontSize: 11),
                      ],
                    ),
                    const SizedBox(height: 12),
                    // Detail
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Area',
                                style: TextStyle(
                                  fontSize: 11,
                                  color: AppColors.inactive,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                data['area'],
                                style: const TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.primary,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Masuk',
                                style: TextStyle(
                                  fontSize: 11,
                                  color: AppColors.inactive,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                data['waktuMasuk'],
                                style: const TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.primary,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Durasi',
                                style: TextStyle(
                                  fontSize: 11,
                                  color: AppColors.inactive,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                '${data['durasiJam']}j',
                                style: const TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.primary,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    // Action buttons
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: () {
                              // TODO: Edit transaksi
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Edit: Coming Soon'),
                                ),
                              );
                            },
                            icon: const Icon(Icons.edit, size: 16),
                            label: const Text('Edit'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primary,
                              foregroundColor: AppColors.white,
                              padding: const EdgeInsets.symmetric(vertical: 8),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: OutlinedButton.icon(
                            onPressed: () {
                              // TODO: View detail
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Detail: Coming Soon'),
                                ),
                              );
                            },
                            icon: const Icon(Icons.info_outline, size: 16),
                            label: const Text('Detail'),
                            style: OutlinedButton.styleFrom(
                              foregroundColor: AppColors.primary,
                              side: const BorderSide(color: AppColors.primary),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            },
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _buildSummaryItem(String label, String value, IconData icon) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Icon(icon, color: AppColors.primary, size: 28),
        const SizedBox(height: 8),
        Text(
          value,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: AppColors.primary,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(fontSize: 12, color: AppColors.inactive),
        ),
      ],
    );
  }

  Future<void> _printParkedVehicles() async {
    try {
      await PdfService.generateParkedVehiclesReport(vehicles: _parkingData);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error cetak laporan: $e'),
          backgroundColor: AppColors.danger,
        ),
      );
    }
  }
}
