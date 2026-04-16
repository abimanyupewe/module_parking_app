import 'package:flutter/material.dart';
import '../../../services/database_helper.dart';
import '../../../models/jenis_kendaraan_model.dart';
import '../../../models/area_parkir_model.dart';
import 'masterData/adminMasterDataTabs.dart';
import 'masterData/adminKategoriListPanel.dart';
import 'masterData/adminAreaListPanel.dart';
import 'masterData/adminMasterDataDialogs.dart';

/// Admin Master Data Section - CRUD Kategori & Area
class AdminMasterDataSection extends StatefulWidget {
  const AdminMasterDataSection({super.key});

  @override
  State<AdminMasterDataSection> createState() => _AdminMasterDataSectionState();
}

class _AdminMasterDataSectionState extends State<AdminMasterDataSection> {
  int _selectedTabIndex = 0;
  final _databaseHelper = DatabaseHelper();

  List<JenisKendaraanModel> _kategori = [];
  List<AreaParkirModel> _area = [];
  bool _isLoadingKategori = true;
  bool _isLoadingArea = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    try {
      setState(() {
        _isLoadingKategori = true;
        _isLoadingArea = true;
        _errorMessage = null;
      });

      final kategoriList = await _databaseHelper.getAllJenisKendaraan();
      final areaList = await _databaseHelper.getAllAreaParkir();

      if (mounted) {
        setState(() {
          _kategori = kategoriList;
          _area = areaList;
          _isLoadingKategori = false;
          _isLoadingArea = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _errorMessage = 'Error loading data: $e';
          _isLoadingKategori = false;
          _isLoadingArea = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          AdminMasterDataTabs(
            selectedTabIndex: _selectedTabIndex,
            onSelectTab: (tab) => setState(() => _selectedTabIndex = tab),
          ),
          const SizedBox(height: 16),
          // Content
          Expanded(
            child: _selectedTabIndex == 0
                ? _buildKategoriList()
                : _buildAreaList(),
          ),
        ],
      ),
    );
  }

  Widget _buildKategoriList() {
    return AdminKategoriListPanel(
      isLoading: _isLoadingKategori,
      errorMessage: _errorMessage,
      kategori: _kategori,
      onAdd: () => _showKategoriDialog(null),
      onEdit: _showKategoriDialog,
      onDelete: _deleteKategori,
    );
  }

  Widget _buildAreaList() {
    return AdminAreaListPanel(
      isLoading: _isLoadingArea,
      errorMessage: _errorMessage,
      area: _area,
      getKategoriNama: _getKategoriNama,
      onAdd: () => _showAreaDialog(null),
      onEdit: _showAreaDialog,
      onDelete: _deleteArea,
    );
  }

  void _showKategoriDialog(JenisKendaraanModel? data) {
    showAdminKategoriDialog(
      context: context,
      databaseHelper: _databaseHelper,
      data: data,
      reloadData: _loadData,
    );
  }

  void _showAreaDialog(AreaParkirModel? data) {
    showAdminAreaDialog(
      context: context,
      databaseHelper: _databaseHelper,
      data: data,
      kategori: _kategori,
      reloadData: _loadData,
    );
  }

  Future<void> _deleteKategori(int idKategori) async {
    showAdminDeleteKategoriDialog(
      context: context,
      databaseHelper: _databaseHelper,
      idKategori: idKategori,
      reloadData: _loadData,
    );
  }

  Future<void> _deleteArea(int idArea) async {
    showAdminDeleteAreaDialog(
      context: context,
      databaseHelper: _databaseHelper,
      idArea: idArea,
      reloadData: _loadData,
    );
  }

  /// Get kategori nama by kategori id
  String _getKategoriNama(int idJenis) {
    try {
      final kat = _kategori.firstWhere((k) => k.idJenis == idJenis);
      return kat.namaJenis;
    } catch (e) {
      return 'Unknown';
    }
  }
}
