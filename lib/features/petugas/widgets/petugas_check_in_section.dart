import 'package:flutter/material.dart';
import '../../../config/colors.dart';
import '../../../config/constants.dart';
import '../../../models/area_parkir_model.dart';
import '../../../models/jenis_kendaraan_model.dart';
import '../../../models/kendaraan_model.dart';
import '../../../services/database_helper.dart';
import '../../../services/error_handler.dart';
import '../../../services/pdf_service.dart';
import '../../../services/format_helper.dart';
import '../../../widgets/widgets.dart';
import 'image_picker_widget.dart';

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

      // 3. Update kapasitas area parkir
      final area = await _databaseHelper.getAreaParkirById(idArea);
      if (area != null) {
        final updatedArea = area.copyWith(terisi: area.terisi + 1);
        await _databaseHelper.updateAreaParkir(updatedArea);
      }

      // 4. Record activity log
      await _databaseHelper.recordActivity(
        1, // userId (TODO: Ambil dari session user)
        AppConstants.logTransaksi,
        'Check-In Kendaraan ${_platnomorController.text} di Area ${area?.namaArea}',
      );

      // Get petugas name dari database
      final petugas = await _databaseHelper.getUserById(
        1,
      ); // TODO: Ambil dari session user
      final petugasName = petugas?.namaLengkap ?? 'Petugas Parkir';

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
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Check-In Berhasil'),
            content: const Text(
              'Kendaraan telah berhasil dicatat. '
              'Silakan cetak karcis untuk diberikan kepada pengendara.',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('OK'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  _printCheckInReceipt(
                    platNomor: platNomorToStore,
                    merk: merkToStore,
                    warna: warnaToStore,
                    totalBiaya: totalBiaya,
                    tarifPerJam: tarifPerJam,
                    petugasName: petugasName,
                  );
                },
                child: const Text('Cetak Struk'),
              ),
            ],
          ),
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
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const CircularProgressIndicator(),
            const SizedBox(height: 16),
            const Text('Memuat data...'),
          ],
        ),
      );
    }

    if (_errorMessage != null) {
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
      padding: const EdgeInsets.all(16),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Plat Nomor
            CustomTextField(
              label: 'Plat Nomor',
              hint: 'Contoh: AB 1234 CD',
              controller: _platnomorController,
              inputType: TextInputType.text,
              validator: (value) {
                if (value?.isEmpty ?? true) {
                  return 'Plat nomor harus diisi';
                }
                return null;
              },
              prefixIcon: Icon(
                Icons.confirmation_number,
                color: AppColors.primary,
              ),
            ),
            const SizedBox(height: 16),

            // Jenis Kendaraan
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Jenis Kendaraan',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: AppColors.primary,
                  ),
                ),
                const SizedBox(height: 8),
                DropdownButtonFormField<String>(
                  value: _selectedJenisKendaraanId,
                  items: _jenisKendaraanList
                      .map(
                        (jenis) => DropdownMenuItem(
                          value: jenis.idJenis.toString(),
                          child: Text(jenis.namaJenis),
                        ),
                      )
                      .toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedJenisKendaraanId = value;
                      _selectedAreaId = null; // Reset area ketika jenis berubah
                      _filterAreasByJenisKendaraan();
                    });
                  },
                  validator: (value) {
                    if (value == null) {
                      return 'Pilih jenis kendaraan';
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                    hintText: 'Pilih jenis kendaraan',
                    filled: true,
                    fillColor: AppColors.tertiary,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: const BorderSide(color: AppColors.tertiary),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: const BorderSide(color: AppColors.tertiary),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Merk
            CustomTextField(
              label: 'Merk/Tipe',
              hint: 'Contoh: Honda Vario',
              controller: _merkController,
              inputType: TextInputType.text,
              validator: (value) {
                if (value?.isEmpty ?? true) {
                  return 'Merk harus diisi';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),

            // Warna
            CustomTextField(
              label: 'Warna',
              hint: 'Contoh: Hitam',
              controller: _warnaController,
              inputType: TextInputType.text,
              validator: (value) {
                if (value?.isEmpty ?? true) {
                  return 'Warna harus diisi';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),

            // Area Parkir
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Area Parkir',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: AppColors.primary,
                  ),
                ),
                const SizedBox(height: 8),
                DropdownButtonFormField<String>(
                  value: _selectedAreaId,
                  items: _filteredAreaList.map((area) {
                    final tersedia = area.sisaKapasitas;
                    return DropdownMenuItem(
                      value: area.idArea.toString(),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(area.namaArea),
                          const SizedBox(width: 16),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: tersedia > 0
                                  ? AppColors.success.withValues(alpha: 0.1)
                                  : AppColors.danger.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              '$tersedia tersedia',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                                color: tersedia > 0
                                    ? AppColors.success
                                    : AppColors.danger,
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                  onChanged: _selectedJenisKendaraanId == null
                      ? null
                      : (value) {
                          setState(() {
                            _selectedAreaId = value;
                          });
                        },
                  validator: (value) {
                    if (value == null) {
                      return 'Pilih area parkir';
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                    hintText: _selectedJenisKendaraanId == null
                        ? 'Pilih jenis kendaraan terlebih dahulu'
                        : _filteredAreaList.isEmpty
                        ? 'Tidak ada area tersedia'
                        : 'Pilih area parkir',
                    filled: true,
                    fillColor: AppColors.tertiary,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: const BorderSide(color: AppColors.tertiary),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: const BorderSide(color: AppColors.tertiary),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Image Picker Widget - Foto Kendaraan (Opsional)
            ImagePickerWidget(
              label: 'Foto Kendaraan (Opsional)',
              initialImagePath: _selectedImagePath,
              onImageSelected: (imagePath) {
                setState(() {
                  _selectedImagePath = imagePath;
                });
              },
              isRequired: false,
            ),
            const SizedBox(height: 32),

            // Submit Button
            PrimaryButton(
              label: 'Simpan & Cetak Karcis',
              onPressed: _handleCheckIn,
              isLoading: _isLoading,
              width: double.infinity,
              icon: const Icon(Icons.check_circle),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
