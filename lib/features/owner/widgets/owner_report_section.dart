import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../config/colors.dart';

/// Owner Report Section - Laporan dan Statistik
class OwnerReportSection extends StatefulWidget {
  const OwnerReportSection({Key? key}) : super(key: key);

  @override
  State<OwnerReportSection> createState() => _OwnerReportSectionState();
}

class _OwnerReportSectionState extends State<OwnerReportSection> {
  late DateTime _selectedDate;
  String _selectedPeriod = 'Harian'; // Harian, Mingguan, Bulanan

  @override
  void initState() {
    super.initState();
    _selectedDate = DateTime.now();
  }

  void _selectDate() async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2024),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Report Header
          _buildReportHeader(),
          const SizedBox(height: 24),

          // Period Filter
          _buildPeriodFilter(),
          const SizedBox(height: 24),

          // Revenue Statistics
          _buildRevenueStats(),
          const SizedBox(height: 24),

          // Daily Revenue Chart
          _buildDailyRevenueChart(),
          const SizedBox(height: 24),

          // Transaction Summary
          _buildTransactionSummary(),
          const SizedBox(height: 24),

          // Recent Transactions Detail
          _buildRecentTransactionDetail(),
        ],
      ),
    );
  }

  /// Build report header
  Widget _buildReportHeader() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF343858), Color(0xFF2C3548)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Laporan Pendapatan',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Ringkasan pendapatan dan transaksi parkir',
            style: TextStyle(
              fontSize: 13,
              color: Colors.white.withOpacity(0.8),
            ),
          ),
          const SizedBox(height: 12),
          InkWell(
            onTap: _selectDate,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.calendar_today,
                    color: Colors.white,
                    size: 16,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    DateFormat('dd MMM yyyy', 'id_ID').format(_selectedDate),
                    style: const TextStyle(color: Colors.white, fontSize: 13),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Build period filter
  Widget _buildPeriodFilter() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Jenis Laporan',
          style: Theme.of(
            context,
          ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 12),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: ['Harian', 'Mingguan', 'Bulanan'].map((period) {
              return Padding(
                padding: const EdgeInsets.only(right: 8),
                child: ChoiceChip(
                  label: Text(period),
                  selected: _selectedPeriod == period,
                  onSelected: (selected) {
                    setState(() {
                      _selectedPeriod = period;
                    });
                  },
                  selectedColor: AppColors.primary,
                  labelStyle: TextStyle(
                    color: _selectedPeriod == period
                        ? Colors.white
                        : AppColors.inactive,
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  /// Build revenue statistics
  Widget _buildRevenueStats() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Statistik Pendapatan',
          style: Theme.of(
            context,
          ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        GridView.count(
          crossAxisCount: 2,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          mainAxisSpacing: 12,
          crossAxisSpacing: 12,
          children: [
            _buildStatCard(
              title: 'Total Pendapatan',
              value: 'Rp 1.250.000',
              subtitle: 'Hari ini',
              color: AppColors.success,
            ),
            _buildStatCard(
              title: 'Rata-Rata Transaksi',
              value: 'Rp 27.778',
              subtitle: '45 transaksi',
              color: AppColors.primary,
            ),
            _buildStatCard(
              title: 'Total Transaksi',
              value: '125',
              subtitle: 'Kendaraan masuk',
              color: const Color(0xFFF57C00),
            ),
            _buildStatCard(
              title: 'Kendaraan Keluar',
              value: '120',
              subtitle: 'Pembayaran selesai',
              color: AppColors.warning,
            ),
          ],
        ),
      ],
    );
  }

  /// Build stat card
  Widget _buildStatCard({
    required String title,
    required String value,
    required String subtitle,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 12,
              color: color,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            subtitle,
            style: TextStyle(fontSize: 11, color: color.withOpacity(0.7)),
          ),
        ],
      ),
    );
  }

  /// Build daily revenue chart (simplified)
  Widget _buildDailyRevenueChart() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Pendapatan Harian (7 Hari Terakhir)',
          style: Theme.of(
            context,
          ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            border: Border.all(color: AppColors.border),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            children: [
              // Simple bar chart representation
              for (int i = 0; i < 7; i++)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Row(
                    children: [
                      SizedBox(
                        width: 50,
                        child: Text(
                          'Hari ${i + 1}',
                          style: const TextStyle(fontSize: 11),
                        ),
                      ),
                      Expanded(
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(4),
                          child: LinearProgressIndicator(
                            value: (0.4 + (i * 0.08)).clamp(0, 1),
                            minHeight: 20,
                            backgroundColor: AppColors.primaryLight,
                            valueColor: const AlwaysStoppedAnimation<Color>(
                              AppColors.primary,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      SizedBox(
                        width: 60,
                        child: Text(
                          'Rp ${(150000 + (i * 50000)).toStringAsFixed(0)}',
                          style: const TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w500,
                          ),
                          textAlign: TextAlign.right,
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }

  /// Build transaction summary
  Widget _buildTransactionSummary() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Ringkasan Transaksi',
          style: Theme.of(
            context,
          ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            border: Border.all(color: AppColors.border),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            children: [
              _buildTransactionSummaryRow(
                label: 'Total Transaksi Masuk',
                value: '125',
                color: AppColors.success,
              ),
              const Divider(height: 16),
              _buildTransactionSummaryRow(
                label: 'Total Transaksi Keluar',
                value: '120',
                color: AppColors.primary,
              ),
              const Divider(height: 16),
              _buildTransactionSummaryRow(
                label: 'Transaksi Pending',
                value: '5',
                color: AppColors.warning,
              ),
              const Divider(height: 16),
              _buildTransactionSummaryRow(
                label: 'Transaksi Batal',
                value: '0',
                color: AppColors.danger,
              ),
            ],
          ),
        ),
      ],
    );
  }

  /// Build transaction summary row
  Widget _buildTransactionSummaryRow({
    required String label,
    required String value,
    required Color color,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: const TextStyle(fontSize: 12)),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(6),
          ),
          child: Text(
            value,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ),
      ],
    );
  }

  /// Build recent transaction detail
  Widget _buildRecentTransactionDetail() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Detail Transaksi',
          style: Theme.of(
            context,
          ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: 5,
          separatorBuilder: (_, __) => const SizedBox(height: 8),
          itemBuilder: (context, index) {
            final times = ['08:30', '09:15', '10:00', '11:45', '13:20'];
            final plates = [
              'H 1234 ABC',
              'B 5678 CDE',
              'H 2020 XYZ',
              'B 9999 QWE',
              'H 1111 ZZZ',
            ];
            final amounts = [
              'Rp 5.000',
              'Rp 12.000',
              'Rp 4.000',
              'Rp 15.000',
              'Rp 5.000',
            ];
            return Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                border: Border.all(color: AppColors.border),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: AppColors.primaryLight,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(
                      Icons.directions_car,
                      color: AppColors.primary,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          plates[index],
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          times[index],
                          style: TextStyle(
                            fontSize: 11,
                            color: AppColors.inactive,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Text(
                    amounts[index],
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: AppColors.success,
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ],
    );
  }
}
