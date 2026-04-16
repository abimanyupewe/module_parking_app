// ignore_for_file: file_names, deprecated_member_use

import 'package:flutter/material.dart';

import '../../../../config/colors.dart';
import '../../../../models/area_parkir_model.dart';
import '../../../../models/jenis_kendaraan_model.dart';
import '../../../../widgets/widgets.dart';
import '../image_picker_widget.dart';

class PetugasCheckinForm extends StatelessWidget {
  const PetugasCheckinForm({
    super.key,
    required this.formKey,
    required this.platNomorController,
    required this.merkController,
    required this.warnaController,
    required this.selectedJenisKendaraanId,
    required this.selectedAreaId,
    required this.selectedImagePath,
    required this.jenisKendaraanList,
    required this.filteredAreaList,
    required this.isLoading,
    required this.onJenisChanged,
    required this.onAreaChanged,
    required this.onImageSelected,
    required this.onSubmit,
  });

  final GlobalKey<FormState> formKey;
  final TextEditingController platNomorController;
  final TextEditingController merkController;
  final TextEditingController warnaController;
  final String? selectedJenisKendaraanId;
  final String? selectedAreaId;
  final String? selectedImagePath;
  final List<JenisKendaraanModel> jenisKendaraanList;
  final List<AreaParkirModel> filteredAreaList;
  final bool isLoading;
  final ValueChanged<String?> onJenisChanged;
  final ValueChanged<String?> onAreaChanged;
  final ValueChanged<String?> onImageSelected;
  final VoidCallback onSubmit;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Form(
        key: formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomTextField(
              label: 'Plat Nomor',
              hint: 'Contoh: AB 1234 CD',
              controller: platNomorController,
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
                  value: selectedJenisKendaraanId,
                  items: jenisKendaraanList
                      .map(
                        (jenis) => DropdownMenuItem(
                          value: jenis.idJenis.toString(),
                          child: Text(jenis.namaJenis),
                        ),
                      )
                      .toList(),
                  onChanged: onJenisChanged,
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
            CustomTextField(
              label: 'Merk/Tipe',
              hint: 'Contoh: Honda Vario',
              controller: merkController,
              inputType: TextInputType.text,
              validator: (value) {
                if (value?.isEmpty ?? true) {
                  return 'Merk harus diisi';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            CustomTextField(
              label: 'Warna',
              hint: 'Contoh: Hitam',
              controller: warnaController,
              inputType: TextInputType.text,
              validator: (value) {
                if (value?.isEmpty ?? true) {
                  return 'Warna harus diisi';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
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
                  value: selectedAreaId,
                  items: filteredAreaList.map((area) {
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
                  onChanged: selectedJenisKendaraanId == null
                      ? null
                      : onAreaChanged,
                  validator: (value) {
                    if (value == null) {
                      return 'Pilih area parkir';
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                    hintText: selectedJenisKendaraanId == null
                        ? 'Pilih jenis kendaraan terlebih dahulu'
                        : filteredAreaList.isEmpty
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
            ImagePickerWidget(
              label: 'Foto Kendaraan (Opsional)',
              initialImagePath: selectedImagePath,
              onImageSelected: onImageSelected,
              isRequired: false,
            ),
            const SizedBox(height: 32),
            PrimaryButton(
              label: 'Simpan & Cetak Karcis',
              onPressed: onSubmit,
              isLoading: isLoading,
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
