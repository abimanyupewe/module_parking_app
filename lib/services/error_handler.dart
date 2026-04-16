/// Error Handler - Transform database errors menjadi user-friendly messages
class ErrorHandler {
  /// Transform database error message menjadi user-friendly message
  static String transformError(dynamic error) {
    final errorString = error.toString().toLowerCase();

    // Username duplicate
    if (errorString.contains('unique constraint failed') &&
        errorString.contains('username')) {
      // Extract username dari error message jika mungkin
      return 'Username sudah terdaftar. Silakan gunakan username lain.';
    }

    // Jenis Kendaraan duplicate
    if (errorString.contains('unique constraint failed') &&
        errorString.contains('nama_jenis')) {
      return 'Kategori sudah ada dalam database. Silakan gunakan nama yang berbeda.';
    }

    // Area Parkir duplicate
    if (errorString.contains('unique constraint failed') &&
        errorString.contains('nama_area')) {
      return 'Area parkir sudah ada dalam database. Silakan gunakan nama yang berbeda.';
    }

    // Kendaraan duplicate
    if (errorString.contains('unique constraint failed') &&
        errorString.contains('plat_nomor')) {
      return 'Kendaraan dengan plat nomor ini sudah terdaftar. Gunakan plat nomor yang berbeda.';
    }

    // Foreign key constraint
    if (errorString.contains('foreign key constraint')) {
      return 'Data yang direferensi tidak ditemukan. Silakan coba lagi.';
    }

    // Database locked
    if (errorString.contains('database is locked')) {
      return 'Database sedang diakses, silakan coba lagi.';
    }

    // Default error message
    return 'Terjadi kesalahan: ${error.toString()}';
  }

  /// Check apakah error adalah duplicate constraint error
  static bool isDuplicateError(dynamic error) {
    final errorString = error.toString().toLowerCase();
    return errorString.contains('unique constraint failed');
  }

  /// Check apakah error adalah foreign key error
  static bool isForeignKeyError(dynamic error) {
    final errorString = error.toString().toLowerCase();
    return errorString.contains('foreign key constraint');
  }

  /// Check apakah error adalah database locked error
  static bool isDatabaseLockedError(dynamic error) {
    final errorString = error.toString().toLowerCase();
    return errorString.contains('database is locked');
  }
}
