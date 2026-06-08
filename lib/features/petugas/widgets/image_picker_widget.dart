import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../../services/image_storage_service.dart';

/// Widget untuk pick image saat check-in kendaraan
/// Menampilkan preview gambar yang dipilih dan tombol untuk pick/retake image
class ImagePickerWidget extends StatefulWidget {
  final String label;
  final String? initialImagePath; // Path gambar jika ada (untuk edit/retake)
  final Function(String?)
  onImageSelected; // Callback saat gambar dipilih atau dihapus
  final bool isRequired; // Apakah gambar wajib dipilih

  const ImagePickerWidget({
    Key? key,
    this.label = 'Foto Kendaraan',
    this.initialImagePath,
    required this.onImageSelected,
    this.isRequired = true,
  }) : super(key: key);

  @override
  State<ImagePickerWidget> createState() => _ImagePickerWidgetState();
}

class _ImagePickerWidgetState extends State<ImagePickerWidget> {
  final ImagePicker _imagePicker = ImagePicker();
  String? _selectedImagePath;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    // Set initial image path jika ada
    _selectedImagePath = widget.initialImagePath;
  }

  /// Pick image dari gallery
  Future<void> _pickImage() async {
    try {
      setState(() => _isLoading = true);

      // Buka image picker gallery
      final XFile? pickedImage = await _imagePicker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 85, // Kompres gambar untuk hemat storage
      );

      if (pickedImage != null) {
        // Simpan gambar ke app documents folder
        final savedPath = await ImageStorageService.saveCheckInImage(
          pickedImage,
        );

        if (savedPath != null) {
          setState(() {
            _selectedImagePath = savedPath;
          });
          // Panggil callback
          widget.onImageSelected(savedPath);

          // Show success message
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Gambar berhasil dipilih'),
              duration: Duration(seconds: 2),
            ),
          );
        } else {
          // Show error message jika gagal simpan
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Gagal menyimpan gambar'),
              duration: Duration(seconds: 2),
            ),
          );
        }
      }
    } catch (e) {
      // Handle error
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: $e'),
          duration: const Duration(seconds: 2),
        ),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  /// Hapus gambar yang dipilih
  Future<void> _deleteImage() async {
    if (_selectedImagePath == null) return;

    // Show confirmation dialog
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Hapus Gambar'),
        content: const Text('Apakah Anda yakin ingin menghapus gambar ini?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Batal'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Hapus', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      try {
        setState(() => _isLoading = true);

        // Hapus file dari storage
        await ImageStorageService.deleteImage(_selectedImagePath!);

        setState(() {
          _selectedImagePath = null;
        });

        // Panggil callback
        widget.onImageSelected(null);

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Gambar berhasil dihapus'),
            duration: Duration(seconds: 2),
          ),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: $e'),
            duration: const Duration(seconds: 2),
          ),
        );
      } finally {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Label dengan indicator required
        Row(
          children: [
            Text(
              widget.label,
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
            ),
            if (widget.isRequired)
              const Text(' *', style: TextStyle(color: Colors.red)),
          ],
        ),
        const SizedBox(height: 12),

        // Image preview atau placeholder
        _selectedImagePath == null ? _buildPlaceholder() : _buildImagePreview(),

        const SizedBox(height: 12),

        // Tombol action
        _buildActionButtons(),
      ],
    );
  }

  /// Build placeholder saat belum ada gambar
  Widget _buildPlaceholder() {
    return Container(
      width: double.infinity,
      height: 200,
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.grey[400]!,
          width: 2,
          style: BorderStyle.solid,
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.image_not_supported, size: 48, color: Colors.grey[600]),
          const SizedBox(height: 8),
          Text(
            'Belum ada gambar',
            style: TextStyle(color: Colors.grey[600], fontSize: 14),
          ),
        ],
      ),
    );
  }

  /// Build preview gambar yang sudah dipilih
  Widget _buildImagePreview() {
    final imageFile = ImageStorageService.getImageFile(_selectedImagePath!);

    if (imageFile == null) {
      // File tidak ditemukan
      return Container(
        width: double.infinity,
        height: 200,
        decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.red[400]!, width: 2),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 48, color: Colors.red[600]),
            const SizedBox(height: 8),
            Text(
              'File tidak ditemukan',
              style: TextStyle(color: Colors.red[600], fontSize: 14),
            ),
          ],
        ),
      );
    }

    return Container(
      width: double.infinity,
      height: 200,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.green[400]!, width: 2),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: Image.file(imageFile, fit: BoxFit.cover),
      ),
    );
  }

  /// Build action buttons
  Widget _buildActionButtons() {
    return Row(
      children: [
        // Tombol Pick/Retake Image
        Expanded(
          child: ElevatedButton.icon(
            onPressed: _isLoading ? null : _pickImage,
            icon: const Icon(Icons.image),
            label: Text(
              _selectedImagePath == null ? 'Pilih Gambar' : 'Ambil Ulang',
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
              foregroundColor: Colors.white,
              disabledBackgroundColor: Colors.grey[400],
              padding: const EdgeInsets.symmetric(vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
        ),

        const SizedBox(width: 8),

        // Tombol Hapus (hanya tampil jika sudah ada gambar)
        if (_selectedImagePath != null)
          Expanded(
            child: ElevatedButton.icon(
              onPressed: _isLoading ? null : _deleteImage,
              icon: const Icon(Icons.delete),
              label: const Text('Hapus'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
                disabledBackgroundColor: Colors.grey[400],
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ),
      ],
    );
  }
}
