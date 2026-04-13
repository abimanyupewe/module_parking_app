import '../../../core/preferences/app_preferences.dart';
import '../../../models/user_model.dart';
import '../../../services/database_helper.dart';
import '../../../services/password_service.dart';

/// Controller untuk Authentication
class AuthController {
  final DatabaseHelper _dbHelper = DatabaseHelper();

  /// Login user dengan username dan password
  Future<Map<String, dynamic>> login(String username, String password) async {
    try {
      // Validasi input
      if (username.isEmpty || password.isEmpty) {
        return {
          'success': false,
          'message': 'Username dan password tidak boleh kosong',
        };
      }

      // Query user dari database
      final user = await _dbHelper.getUserByUsername(username);

      if (user == null) {
        return {'success': false, 'message': 'Username tidak ditemukan'};
      }

      // Validasi password
      final isPasswordValid = PasswordService.verifyPassword(
        password,
        user.password,
      );

      if (!isPasswordValid) {
        return {'success': false, 'message': 'Password salah'};
      }

      // Validasi status akun
      if (user.status != 'aktif') {
        return {
          'success': false,
          'message':
              'Akun Anda telah dinonaktifkan. Silakan hubungi Owner untuk informasi lebih lanjut.',
        };
      }

      // Save session
      await AppPreferences.setIsLoggedIn(
        true,
        userId: user.idUser,
        userRole: user.role,
        username: user.username,
      );

      // Record activity
      await _dbHelper.recordActivity(
        user.idUser!,
        'Otorisasi',
        'Login ke sistem',
      );

      return {'success': true, 'message': 'Login berhasil', 'user': user};
    } catch (e) {
      return {'success': false, 'message': 'Error: ${e.toString()}'};
    }
  }

  /// Logout user
  Future<void> logout() async {
    await AppPreferences.logout();
  }

  /// Validate username format
  bool validateUsername(String username) {
    if (username.length < 3) {
      return false;
    }
    return true;
  }

  /// Validate password format
  bool validatePassword(String password) {
    return PasswordService.validatePasswordStrength(password);
  }

  /// Register new Owner user (hanya Owner yang bisa register sendiri)
  Future<Map<String, dynamic>> registerOwner({
    required String namaLengkap,
    required String username,
    required String password,
  }) async {
    try {
      // Validasi input
      if (namaLengkap.isEmpty || username.isEmpty || password.isEmpty) {
        return {'success': false, 'message': 'Semua field harus diisi'};
      }

      // Validasi username panjang
      if (username.length < 3) {
        return {'success': false, 'message': 'Username minimal 3 karakter'};
      }

      // Validasi password panjang
      if (password.length < 6) {
        return {'success': false, 'message': 'Password minimal 6 karakter'};
      }

      // Check if username already exists
      final existingUser = await _dbHelper.getUserByUsername(username);
      if (existingUser != null) {
        return {'success': false, 'message': 'Username sudah terdaftar'};
      }

      // Hash password
      final hashedPassword = PasswordService.hashPassword(password);

      // Create new Owner user
      final newUser = UserModel(
        namaLengkap: namaLengkap,
        username: username,
        password: hashedPassword,
        role: 'owner',
        status: 'aktif',
      );

      // Insert ke database
      await _dbHelper.insertUser(newUser);

      return {
        'success': true,
        'message': 'Registrasi berhasil! Silakan login dengan akun Anda.',
      };
    } catch (e) {
      return {'success': false, 'message': 'Error: ${e.toString()}'};
    }
  }
}
