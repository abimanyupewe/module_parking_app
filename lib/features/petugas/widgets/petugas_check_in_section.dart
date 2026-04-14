import 'package:flutter/material.dart';
import '../../../config/colors.dart';
import '../../../widgets/widgets.dart';

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

  /// Build area info card ketika area dipilih
  Widget _buildAreaInfoCard() {
    final selectedAreaData = _allAreas.firstWhere(
      (area) => area['name'] == _selectedArea,
      orElse: () => {'name': '', 'kapasitas': 0, 'tersedia': 0},
    );

    final kapasitas = selectedAreaData['kapasitas'] ?? 0;
    final tersedia = selectedAreaData['tersedia'] ?? 0;
    final terisi = kapasitas - tersedia;
    final persentaseKapasitas = (terisi / kapasitas * 100).toStringAsFixed(0);

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.primary.withValues(alpha: 0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Informasi Area',
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: AppColors.primary,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Kapasitas Total',
                      style: const TextStyle(
                        fontSize: 11,
                        color: AppColors.inactive,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '$kapasitas spot',
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: AppColors.primary,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      'Terisi',
                      style: const TextStyle(
                        fontSize: 11,
                        color: AppColors.inactive,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '$terisi spot',
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: AppColors.danger,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      'Tersedia',
                      style: const TextStyle(
                        fontSize: 11,
                        color: AppColors.inactive,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '$tersedia spot',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: tersedia > 0
                            ? AppColors.success
                            : AppColors.danger,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          // Progress bar
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: terisi / kapasitas,
              minHeight: 6,
              backgroundColor: AppColors.primary.withValues(alpha: 0.1),
              valueColor: AlwaysStoppedAnimation<Color>(
                terisi / kapasitas > 0.8
                    ? AppColors.danger
                    : terisi / kapasitas > 0.5
                    ? AppColors.warning
                    : AppColors.success,
              ),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            '$persentaseKapasitas% kapasitas terpakai',
            style: const TextStyle(fontSize: 11, color: AppColors.inactive),
          ),
        ],
      ),
    );
  }

  void _handleCheckIn() async {
    if (!_formKey.currentState!.validate()) return;

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
            const SizedBox(height: 16),

            // Area Info Card (tampil ketika area sudah dipilih)
            if (_selectedArea != null)
              _buildAreaInfoCard()
            else
              const SizedBox.shrink(),
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
