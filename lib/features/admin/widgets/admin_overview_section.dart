import 'package:flutter/material.dart';
import '../../../config/colors.dart';
import '../../../services/database_helper.dart';
import '../../../models/area_parkir_model.dart';

/// Admin Overview Section - Overview dashboard untuk admin
class AdminOverviewSection extends StatefulWidget {
  const AdminOverviewSection({Key? key}) : super(key: key);

  @override
  State<AdminOverviewSection> createState() => _AdminOverviewSectionState();
}

class _AdminOverviewSectionState extends State<AdminOverviewSection> {
  final _databaseHelper = DatabaseHelper();

  late Future<int> _totalAreaFuture;
  late Future<int> _totalKendaraanFuture;
  late Future<List<AreaParkirModel>> _areaListFuture;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  void _loadData() {
    _totalAreaFuture = _getTotalArea();
    _totalKendaraanFuture = _getTotalKendaraan();
    _areaListFuture = _databaseHelper.getAllAreaParkir();
  }

  Future<int> _getTotalArea() async {
    try {
      final areas = await _databaseHelper.getAllAreaParkir();
      return areas.length;
    } catch (e) {
      return 0;
    }
  }

  Future<int> _getTotalKendaraan() async {
    try {
      final kendaraan = await _databaseHelper.getAllKendaraan();
      return kendaraan.length;
    } catch (e) {
      return 0;
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title
          Text(
            'Overview Sistem',
            style: Theme.of(
              context,
            ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          Text(
            'Ringkasan informasi sistem parkir',
            style: Theme.of(context).textTheme.bodySmall,
          ),
          const SizedBox(height: 24),

          // Summary Cards
          Row(
            children: [
              Expanded(
                child: FutureBuilder<int>(
                  future: _totalAreaFuture,
                  builder: (context, snapshot) {
                    final value = snapshot.data?.toString() ?? '0';
                    return _buildSummaryCard(
                      title: 'Total Area Parkir',
                      value: value,
                      subtitle: 'Area aktif',
                      icon: Icons.location_on,
                      bgColor: const Color(0xFFEEF1F7),
                      titleColor: AppColors.primary,
                      isLoading:
                          snapshot.connectionState == ConnectionState.waiting,
                    );
                  },
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: FutureBuilder<int>(
                  future: _totalKendaraanFuture,
                  builder: (context, snapshot) {
                    final value = snapshot.data?.toString() ?? '0';
                    return _buildSummaryCard(
                      title: 'Total Kendaraan',
                      value: value,
                      subtitle: 'Kendaraan terdaftar',
                      icon: Icons.directions_car,
                      bgColor: const Color(0xFFF0F4FF),
                      titleColor: AppColors.primary,
                      isLoading:
                          snapshot.connectionState == ConnectionState.waiting,
                    );
                  },
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),

          // Area Slot Status Section
          Text(
            'Status Slot Area Parkir',
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          _buildAreaSlotStatus(),
        ],
      ),
    );
  }

  Widget _buildSummaryCard({
    required String title,
    required String value,
    required String subtitle,
    required IconData icon,
    Color bgColor = const Color(0xFFEEF1F7),
    Color titleColor = AppColors.primary,
    bool isLoading = false,
  }) {
    return Container(
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
          const SizedBox(height: 8),
          if (isLoading)
            SizedBox(
              height: 20,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation<Color>(titleColor),
              ),
            )
          else
            Text(
              value,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: titleColor,
              ),
            ),
          const SizedBox(height: 4),
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

  Widget _buildAreaSlotStatus() {
    return FutureBuilder<List<AreaParkirModel>>(
      future: _areaListFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(
            child: Text(
              'Error: ${snapshot.error}',
              style: const TextStyle(color: AppColors.danger),
            ),
          );
        }

        final areas = snapshot.data ?? [];

        if (areas.isEmpty) {
          return const Center(
            child: Text(
              'Data area parkir belum tersedia',
              style: TextStyle(color: AppColors.inactive),
            ),
          );
        }

        return Column(
          children: List.generate(areas.length, (index) {
            final area = areas[index];
            final occupied = area.terisi;
            final total = area.kapasitas;

            // Determine color based on percentage
            late Color color;
            final percentage = (occupied / total) * 100;
            if (percentage >= 80) {
              color = AppColors.danger;
            } else if (percentage >= 50) {
              color = AppColors.warning;
            } else {
              color = AppColors.success;
            }

            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Container(
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
                        Expanded(
                          child: Text(
                            area.namaArea,
                            style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
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
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '${percentage.toStringAsFixed(1)}% terisi',
                          style: TextStyle(
                            fontSize: 11,
                            color: AppColors.inactive,
                          ),
                        ),
                        Text(
                          'Sisa: ${area.sisaKapasitas}',
                          style: TextStyle(
                            fontSize: 11,
                            color: color,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          }),
        );
      },
    );
  }
}
