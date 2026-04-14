import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:image_picker/image_picker.dart';

/// Service untuk menyimpan dan mengelola gambar check-in kendaraan
/// Menyimpan file ke app documents folder untuk pembelajaran SMK
class ImageStorageService {
  static const String imageFolderName = 'parking_images';

  /// Simpan gambar dari XFile (hasil image picker) ke app documents folder
  /// Menggunakan format: parking_{timestamp}.jpg
  /// Return: path ke file yang disimpan
  static Future<String?> saveCheckInImage(XFile pickedImage) async {
    try {
      // Dapatkan app documents directory
      final appDocDir = await getApplicationDocumentsDirectory();

      // Buat folder untuk gambar jika belum ada
      final imageFolder = Directory('${appDocDir.path}/$imageFolderName');
      if (!await imageFolder.exists()) {
        await imageFolder.create(recursive: true);
      }

      // Buat nama file unik berdasarkan timestamp
      final fileName = 'parking_${DateTime.now().millisecondsSinceEpoch}.jpg';
      final filePath = '${imageFolder.path}/$fileName';

      // Copy file dari cache ke documents folder
      final imageFile = File(pickedImage.path);
      final savedFile = await imageFile.copy(filePath);

      // Return path untuk disimpan ke database
      return savedFile.path;
    } catch (e) {
      print('Error saving image: $e');
      return null;
    }
  }

  /// Hapus gambar dari storage
  static Future<bool> deleteImage(String imagePath) async {
    try {
      final file = File(imagePath);
      if (await file.exists()) {
        await file.delete();
        return true;
      }
      return false;
    } catch (e) {
      print('Error deleting image: $e');
      return false;
    }
  }

  /// Cek apakah file gambar masih ada
  static Future<bool> imageExists(String imagePath) async {
    try {
      return await File(imagePath).exists();
    } catch (e) {
      return false;
    }
  }

  /// Dapatkan File object dari path (untuk display menggunakan Image.file)
  static File? getImageFile(String imagePath) {
    try {
      final file = File(imagePath);
      if (file.existsSync()) {
        return file;
      }
      return null;
    } catch (e) {
      return null;
    }
  }
}
