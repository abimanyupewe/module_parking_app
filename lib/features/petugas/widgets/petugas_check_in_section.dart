import 'package:flutter/material.dart';
import '../../../config/colors.dart';
import '../../../widgets/widgets.dart';

/// Petugas Check-In Section - Form input kendaraan masuk
class PetugasCheckInSection extends StatefulWidget {
  const PetugasCheckInSection({Key? key}) : super(key: key);

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

  final List<String> _jenisKendaraan = ['Motor Roda 2', 'Mobil', 'Truk'];
  final List<String> _areas = ['Blok A', 'Blok B', 'Blok C'];

  @override
  void dispose() {
    _platnomorController.dispose();
    _merkController.dispose();
    _warnaController.dispose();
    super.dispose();
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
            // Header
            Text(
              'Formulir Kendaraan Masuk',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 8),
            Text(
              'Isi data kendaraan yang masuk ke area parkir',
              style: Theme.of(context).textTheme.bodySmall,
            ),
            const SizedBox(height: 24),

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
                  items: _areas
                      .map(
                        (area) =>
                            DropdownMenuItem(value: area, child: Text(area)),
                      )
                      .toList(),
                  onChanged: (value) {
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
                    hintText: 'Pilih area parkir',
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
