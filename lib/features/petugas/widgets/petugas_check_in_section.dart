import 'package:flutter/material.dart';
import '../../../config/colors.dart';
import '../../../widgets/widgets.dart';
import 'image_picker_widget.dart';

/// Petugas Check-In Section - Form input kendaraan masuk
class PetugasCheckInSection extends StatefulWidget {
  const PetugasCheckInSection({super.key});

  @override
  State<PetugasCheckInSection> createState() => _PetugasCheckInSectionState();
}

class _PetugasCheckInSectionState extends State<PetugasCheckInSection> {
  final _formKey = GlobalKey<FormState>();
  final _platnomorController = TextEditingController();
  final _merkController = TextEditingController();
  final _warnaController = TextEditingController();

  String? _selectedJenisKendaraan;
  String? _selectedArea;
  String? _selectedImagePath; // Path ke gambar yang dipilih
  bool _isLoading = false;

  // Mapping of jenis kendaraan ke category
  final Map<String, String> _jenisKendaraanMap = {
    'Motor Roda 2': 'Motor',
    'Mobil': 'Mobil',
    'Bus': 'Bus',
  };

  // Area data dengan kategori, kapasitas, dan spot tersedia
  final List<Map<String, dynamic>> _allAreas = [
    {'name': 'Blok A', 'category': 'Motor', 'kapasitas': 50, 'tersedia': 12},
    {'name': 'Blok B', 'category': 'Mobil', 'kapasitas': 40, 'tersedia': 8},
    {'name': 'Blok C', 'category': 'Bus', 'kapasitas': 10, 'tersedia': 3},
  ];

  final List<String> _jenisKendaraan = ['Motor Roda 2', 'Mobil', 'Bus'];

  /// Get filtered areas based on selected vehicle type
  List<String> get _filteredAreas {
    if (_selectedJenisKendaraan == null) {
      return [];
    }

    final category = _jenisKendaraanMap[_selectedJenisKendaraan];
    return _allAreas
        .where((area) => area['category'] == category)
        .map((area) => area['name'] as String)
        .toList();
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

    // Validasi gambar harus dipilih
    if (_selectedImagePath == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Foto kendaraan harus dipilih'),
          duration: Duration(seconds: 2),
        ),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      // Simulasi API call / Database operation
      await Future.delayed(const Duration(seconds: 1));

      if (mounted) {
        // Reset form
        _platnomorController.clear();
        _merkController.clear();
        _warnaController.clear();
        setState(() {
          _selectedJenisKendaraan = null;
          _selectedArea = null;
          _selectedImagePath = null;
          _isLoading = false;
        });

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
                  // TODO: Implement print receipt
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Cetak struk: Feature Coming Soon'),
                    ),
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
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error: $e')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
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
                  value: _selectedJenisKendaraan,
                  items: _jenisKendaraan
                      .map(
                        (jenis) =>
                            DropdownMenuItem(value: jenis, child: Text(jenis)),
                      )
                      .toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedJenisKendaraan = value;
                      _selectedArea = null; // Reset area ketika jenis berubah
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
                  value: _selectedArea,
                  items: _filteredAreas.map((areaName) {
                    final areaData = _allAreas.firstWhere(
                      (area) => area['name'] == areaName,
                      orElse: () => {'tersedia': 0},
                    );
                    final tersedia = areaData['tersedia'] ?? 0;
                    return DropdownMenuItem(
                      value: areaName,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(areaName),
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
                  onChanged: _selectedJenisKendaraan == null
                      ? null
                      : (value) {
                          setState(() {
                            _selectedArea = value;
                          });
                        },
                  validator: (value) {
                    if (value == null) {
                      return 'Pilih area parkir';
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                    hintText: _selectedJenisKendaraan == null
                        ? 'Pilih jenis kendaraan terlebih dahulu'
                        : _filteredAreas.isEmpty
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

            // Image Picker Widget - Foto Kendaraan
            ImagePickerWidget(
              label: 'Foto Kendaraan',
              initialImagePath: _selectedImagePath,
              onImageSelected: (imagePath) {
                setState(() {
                  _selectedImagePath = imagePath;
                });
              },
              isRequired: true,
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
