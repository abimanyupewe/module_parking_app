import 'package:bcrypt/bcrypt.dart';

/// Service untuk mengelola password hashing dan validasi
class PasswordService {
  /// Hash password menggunakan bcrypt
  static String hashPassword(String password) {
    return BCrypt.hashpw(password, BCrypt.gensalt());
  }

  /// Verifikasi password dengan hash
  static bool verifyPassword(String password, String hash) {
    return BCrypt.checkpw(password, hash);
  }

  /// Generate default password untuk akun baru
  static String generateDefaultPassword() {
    return 'password123';
  }

  /// Validasi kekuatan password
  /// Requirement: minimal 6 karakter, mengandung huruf dan angka
  static bool validatePasswordStrength(String password) {
    if (password.length < 6) return false;
    if (!RegExp(r'[a-zA-Z]').hasMatch(password)) return false;
    if (!RegExp(r'[0-9]').hasMatch(password)) return false;
    return true;
  }

  /// Get password requirement message
  static String getPasswordRequirements() {
    return 'Password minimal 6 karakter, mengandung huruf dan angka';
  }

  /// Validate password match
  static bool validatePasswordMatch(String password, String confirmPassword) {
    return password == confirmPassword;
  }
}
