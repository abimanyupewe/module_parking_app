import 'package:flutter/material.dart';
import '../../../services/database_helper.dart';
import '../../../models/area_parkir_model.dart';
import 'overview/adminOverviewAreaStatusSection.dart';
import 'overview/adminOverviewHeader.dart';
import 'overview/adminOverviewSummaryCards.dart';

/// Admin Overview Section - Overview dashboard untuk admin
class AdminOverviewSection extends StatefulWidget {
  const AdminOverviewSection({super.key});

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
          const AdminOverviewHeader(),
          const SizedBox(height: 24),

          AdminOverviewSummaryCards(
            totalAreaFuture: _totalAreaFuture,
            totalKendaraanFuture: _totalKendaraanFuture,
          ),
          const SizedBox(height: 24),

          AdminOverviewAreaStatusSection(areaListFuture: _areaListFuture),
        ],
      ),
    );
  }
}
