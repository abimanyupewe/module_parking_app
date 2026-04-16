import 'package:flutter/material.dart';
import '../../../config/colors.dart';
import '../../../config/constants.dart';
import '../../../models/area_parkir_model.dart';
import '../../../models/jenis_kendaraan_model.dart';
import '../../../models/kendaraan_model.dart';
import '../../../services/database_helper.dart';
import '../../../services/error_handler.dart';
import '../../../services/pdf_service.dart';
import 'checkIn/petugasCheckinForm.dart';
import 'checkIn/petugasCheckinStateViews.dart';
import 'checkIn/petugasCheckinSuccessDialog.dart';

/// Petugas Check-In Section - Form input kendaraan masuk
class PetugasCheckInSection extends StatefulWidget {
  final VoidCallback? onCheckInSuccess;

  const PetugasCheckInSection({super.key, this.onCheckInSuccess});

  @override
  State<PetugasCheckInSection> createState() => _PetugasCheckInSectionState();
}

class _PetugasCheckInSectionState extends State<PetugasCheckInSection> {
  final _formKey = GlobalKey<FormState>();
  final _platnomorController = TextEditingController();
  final _merkController = TextEditingController();
  final _warnaController = TextEditingController();
  final _databaseHelper = DatabaseHelper();

  String? _selectedJenisKendaraanId;
  String? _selectedAreaId;
  String? _selectedImagePath; // Path ke gambar yang dipilih
  bool _isLoading = false;
  bool _isLoadingData = true;
  String? _errorMessage;

  // For storing data for print receipt
  String? _lastJenisKendaraanName;
  String? _lastAreaName;

  List<JenisKendaraanModel> _jenisKendaraanList = [];
  List<AreaParkirModel> _areaList = [];
  List<AreaParkirModel> _filteredAreaList = [];

  /// Get filtered areas based on selected vehicle type
  void _filterAreasByJenisKendaraan() {
    if (_selectedJenisKendaraanId == null) {
      _filteredAreaList = [];
      return;
    }

    final selectedJenisId = int.tryParse(_selectedJenisKendaraanId ?? '');
    if (selectedJenisId == null) {
      _filteredAreaList = [];
      return;
    }

    _filteredAreaList = _areaList
        .where((area) => area.idJenis == selectedJenisId)
        .toList();
  }

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

      final jenisKendaraanList = await _databaseHelper.getAllJenisKendaraan();
      final areaList = await _databaseHelper.getAllAreaParkir();

      if (mounted) {
        setState(() {
          _jenisKendaraanList = jenisKendaraanList;
          _areaList = areaList;
          _isLoadingData = false;

          // Validate that data exists
          if (_jenisKendaraanList.isEmpty) {
            _errorMessage = 'Tidak ada data jenis kendaraan di database';
          } else if (_areaList.isEmpty) {
            _errorMessage = 'Tidak ada data area parkir di database';
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
    _platnomorController.dispose();
    _merkController.dispose();
    _warnaController.dispose();
    super.dispose();
  }

  void _handleCheckIn() async {
    if (!_formKey.currentState!.validate()) return;

    // Validasi area harus dipilih
    if (_selectedAreaId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Area parkir harus dipilih'),
          duration: Duration(seconds: 2),
        ),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final idJenis = int.tryParse(_selectedJenisKendaraanId ?? '0') ?? 0;
      final idArea = int.tryParse(_selectedAreaId ?? '0') ?? 0;

      // Validasi: Cek apakah kendaraan dengan plat nomor yang sama sedang parkir
      final activeTransactionId = await _databaseHelper
          .getActiveTransactionByPlate(_platnomorController.text);
      if (activeTransactionId != null) {
        if (mounted) {
          setState(() {
            _isLoading = false;
          });
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'Kendaraan dengan plat nomor \'${_platnomorController.text}\' sedang parkir. Silakan lakukan check-out terlebih dahulu sebelum check-in kembali.',
              ),
              duration: const Duration(seconds: 4),
            ),
          );
        }
        return;
      }

      // 1. Insert Kendaraan ke database
      final kendaraan = KendaraanModel(
        platNomor: _platnomorController.text,
        idJenis: idJenis,
        merk: _merkController.text,
        warna: _warnaController.text,
      );

      final idKendaraan = await _databaseHelper.insertKendaraan(kendaraan);

      // Get tarif per jam dari jenis kendaraan
      final selectedJenis = _jenisKendaraanList.firstWhere(
        (j) => j.idJenis == idJenis,
        orElse: () => JenisKendaraanModel(namaJenis: 'N/A', tarifPerJam: 0),
      );
      final tarifPerJam = selectedJenis.tarifPerJam;

      // Calculate total biaya: minimum 1 jam
      final totalBiaya = tarifPerJam * 1;

      // 2. Insert Transaksi ke database
      final transaksi = {
        AppConstants.colKendaraanId: idKendaraan,
        AppConstants.colAreaId: idArea,
        AppConstants.colWaktuMasuk: DateTime.now().toIso8601String(),
        AppConstants.colTransaksiStatus: AppConstants.statusParkir,
        AppConstants.colUserId: 1, // TODO: Ambil dari session user
        AppConstants.colTotalBiaya: totalBiaya,
        'image_path': _selectedImagePath,
      };

      await _databaseHelper.insertTransaksi(transaksi);

      // 3. Get petugas name dari database
      final petugas = await _databaseHelper.getUserById(
        1,
      ); // TODO: Ambil dari session user
      final petugasName = petugas?.namaLengkap ?? 'Petugas Parkir';

      // 4. Update kapasitas area parkir
      final area = await _databaseHelper.getAreaParkirById(idArea);
      if (area != null) {
        final updatedArea = area.copyWith(terisi: area.terisi + 1);
        await _databaseHelper.updateAreaParkir(updatedArea);
      }

      // 5. Record activity log with petugas name
      await _databaseHelper.recordActivity(
        1, // userId (TODO: Ambil dari session user)
        AppConstants.logTransaksi,
        'Check-In Kendaraan ${_platnomorController.text} oleh $petugasName di Area ${area?.namaArea}',
      );

      // Store data for print receipt BEFORE clearing form
      final platNomorToStore = _platnomorController.text;
      final merkToStore = _merkController.text;
      final warnaToStore = _warnaController.text;

      _lastJenisKendaraanName = _jenisKendaraanList
          .firstWhere(
            (j) => j.idJenis == idJenis,
            orElse: () => JenisKendaraanModel(namaJenis: 'N/A', tarifPerJam: 0),
          )
          .namaJenis;
      _lastAreaName = area?.namaArea ?? 'N/A';

      if (mounted) {
        // Reset form
        _platnomorController.clear();
        _merkController.clear();
        _warnaController.clear();
        setState(() {
          _selectedJenisKendaraanId = null;
          _selectedAreaId = null;
          _selectedImagePath = null;
          _isLoading = false;
        });

        // Call refresh callback to update area info
        widget.onCheckInSuccess?.call();

        // Show success dialog
        showPetugasCheckinSuccessDialog(
          context,
          onPrintPressed: () {
            _printCheckInReceipt(
              platNomor: platNomorToStore,
              merk: merkToStore,
              warna: warnaToStore,
              totalBiaya: totalBiaya,
              tarifPerJam: tarifPerJam,
              petugasName: petugasName,
            );
          },
        );
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
        final errorMsg = ErrorHandler.transformError(e);
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(errorMsg)));
      }
    }
  }

  /// Print check-in receipt
  Future<void> _printCheckInReceipt({
    required String platNomor,
    required String merk,
    required String warna,
    required int totalBiaya,
    required int tarifPerJam,
    required String petugasName,
  }) async {
    try {
      final jenis = _lastJenisKendaraanName ?? 'N/A';
      final area = _lastAreaName ?? 'N/A';

      await PdfService.generateCheckInReceipt(
        platNomor: platNomor,
        jenis: jenis,
        merk: merk,
        warna: warna,
        area: area,
        waktuMasuk: DateTime.now(),
        totalBiaya: totalBiaya,
        tarifPerJam: tarifPerJam,
      );
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
      return const PetugasCheckinLoadingView();
    }

    if (_errorMessage != null) {
      return PetugasCheckinErrorView(
        errorMessage: _errorMessage!,
        onRetry: _loadData,
      );
    }

    return PetugasCheckinForm(
      formKey: _formKey,
      platNomorController: _platnomorController,
      merkController: _merkController,
      warnaController: _warnaController,
      selectedJenisKendaraanId: _selectedJenisKendaraanId,
      selectedAreaId: _selectedAreaId,
      selectedImagePath: _selectedImagePath,
      jenisKendaraanList: _jenisKendaraanList,
      filteredAreaList: _filteredAreaList,
      isLoading: _isLoading,
      onJenisChanged: (value) {
        setState(() {
          _selectedJenisKendaraanId = value;
          _selectedAreaId = null;
          _filterAreasByJenisKendaraan();
        });
      },
      onAreaChanged: (value) {
        setState(() {
          _selectedAreaId = value;
        });
      },
      onImageSelected: (imagePath) {
        setState(() {
          _selectedImagePath = imagePath;
        });
      },
      onSubmit: _handleCheckIn,
    );
  }
}
