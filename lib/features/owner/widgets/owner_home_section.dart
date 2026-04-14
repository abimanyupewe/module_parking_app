import 'package:flutter/material.dart';
import '../../../config/colors.dart';

/// Owner Home Section - Overview dan Statistik
class OwnerHomeSection extends StatefulWidget {
  const OwnerHomeSection({Key? key}) : super(key: key);

  @override
  State<OwnerHomeSection> createState() => _OwnerHomeSectionState();
}

class _OwnerHomeSectionState extends State<OwnerHomeSection> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Today's Summary Cards
          _buildSummarySection(),
          const SizedBox(height: 24),

          // Area Status
          _buildAreaStatusSection(),
          const SizedBox(height: 24),

          // Recent Transactions
          _buildRecentTransactionsSection(),
        ],
      ),
    );
  }

  /// Build summary cards section
  Widget _buildSummarySection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Ringkasan Hari Ini',
          style: Theme.of(
            context,
          ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 140,
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: [
              _buildSummaryCard(
                title: 'Total Transaksi',
                value: '45',
                subtitle: 'Kendaraan parkir',
                icon: Icons.directions_car,
              ),
              const SizedBox(width: 12),
              _buildSummaryCard(
                title: 'Total Pendapatan',
                value: 'Rp 215.000',
                subtitle: 'Dari biaya parkir',
                icon: Icons.attach_money,
                bgColor: const Color(0xFFF0F4FF),
                titleColor: AppColors.primary,
              ),
              const SizedBox(width: 12),
              _buildSummaryCard(
                title: 'Area Penuh',
                value: '3 / 4',
                subtitle: 'Area parkir',
                icon: Icons.local_parking,
                bgColor: const Color(0xFFFFF3E0),
                titleColor: const Color(0xFFF57C00),
              ),
            ],
          ),
        ),
      ],
    );
  }

  /// Build summary card widget
  Widget _buildSummaryCard({
    required String title,
    required String value,
    required String subtitle,
    required IconData icon,
    Color bgColor = const Color(0xFFEEF1F7),
    Color titleColor = AppColors.primary,
  }) {
    return Container(
      width: 160,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    fontSize: 12,
                    color: titleColor,
                    fontWeight: FontWeight.w500,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Icon(icon, color: titleColor, size: 20),
            ],
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: titleColor,
            ),
          ),
          Text(
            subtitle,
            style: TextStyle(
              fontSize: 11,
              color: titleColor.withValues(alpha: 0.7),
            ),
          ),
        ],
      ),
    );
  }

  /// Build area status section
  Widget _buildAreaStatusSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Status Area Parkir',
          style: Theme.of(
            context,
          ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        // Lantai 1 Motor
        _buildAreaStatusItem(
          name: 'Lantai 1 Motor',
          occupied: 87,
          total: 100,
          color: AppColors.primary,
        ),
        const SizedBox(height: 12),
        // Lantai 2 Mobil
        _buildAreaStatusItem(
          name: 'Lantai 2 Mobil',
          occupied: 48,
          total: 50,
          color: AppColors.warning,
        ),
        const SizedBox(height: 12),
        // Basement Motor
        _buildAreaStatusItem(
          name: 'Basement Motor',
          occupied: 45,
          total: 80,
          color: AppColors.success,
        ),
      ],
    );
  }

  /// Build area status item
  Widget _buildAreaStatusItem({
    required String name,
    required int occupied,
    required int total,
    required Color color,
  }) {
    double percentage = (occupied / total) * 100;

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.border),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                name,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                '$occupied / $total',
                style: TextStyle(
                  fontSize: 12,
                  color: AppColors.inactive,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: occupied / total,
              minHeight: 6,
              backgroundColor: color.withValues(alpha: 0.2),
              valueColor: AlwaysStoppedAnimation<Color>(color),
            ),
          ),
          const SizedBox(height: 6),
          Text(
            '${percentage.toStringAsFixed(1)}% terisi',
            style: TextStyle(fontSize: 11, color: AppColors.inactive),
          ),
        ],
      ),
    );
  }

  /// Build recent transactions section
  Widget _buildRecentTransactionsSection() {
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
        // Sample transaction items
        _buildTransactionItem(
          plate: 'H 1234 ABC',
          type: 'Motor',
          area: 'Lantai 1',
          time: '08:30',
          fee: 'Rp 5.000',
        ),
        const SizedBox(height: 8),
        _buildTransactionItem(
          plate: 'B 5678 CDE',
          type: 'Mobil',
          area: 'Lantai 2',
          time: '09:15',
          fee: 'Rp 12.000',
        ),
        const SizedBox(height: 8),
        _buildTransactionItem(
          plate: 'H 2020 XYZ',
          type: 'Motor',
          area: 'Basement',
          time: '10:00',
          fee: 'Rp 4.000',
        ),
      ],
    );
  }

  /// Build transaction item
  Widget _buildTransactionItem({
    required String plate,
    required String type,
    required String area,
    required String time,
    required String fee,
  }) {
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
            child: const Icon(Icons.directions_car, color: AppColors.primary),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  plate,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  '$type - $area - $time',
                  style: TextStyle(fontSize: 11, color: AppColors.inactive),
                ),
              ],
            ),
          ),
          Text(
            fee,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.bold,
              color: AppColors.success,
            ),
          ),
        ],
      ),
    );
  }
}
