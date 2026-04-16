import 'package:shared_preferences/shared_preferences.dart';

/// Helper untuk mengelola SharedPreferences
class AppPreferences {
  static late SharedPreferences _prefs;

  /// Inisialisasi SharedPreferences
  static Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  // ============= ONBOARDING =============

  /// Set flag is_first_run
  static Future<bool> setIsFirstRun(bool value) {
    return _prefs.setBool('is_first_run', value);
  }

  /// Get flag is_first_run
  static Future<bool> isFirstRun() async {
    // Default true untuk pertama kali (belum pernah set)
    return _prefs.getBool('is_first_run') ?? true;
  }

  // ============= LOGIN SESSION =============

  /// Set user sudah login
  static Future<bool> setIsLoggedIn(
    bool value, {
    int? userId,
    String? userRole,
    String? username,
    String? namaLengkap,
  }) async {
    bool result = await _prefs.setBool('is_logged_in', value);

    if (value && userId != null && userRole != null && username != null) {
      await _prefs.setInt('user_id', userId);
      await _prefs.setString('user_role', userRole);
      await _prefs.setString('username', username);
      if (namaLengkap != null) {
        await _prefs.setString('nama_lengkap', namaLengkap);
      }
    }

    return result;
  }

  /// Get flag is_logged_in
  static bool isLoggedIn() {
    return _prefs.getBool('is_logged_in') ?? false;
  }

  /// Get user ID dari session
  static int? getUserId() {
    return _prefs.getInt('user_id');
  }

  /// Get user role dari session
  static String? getUserRole() {
    return _prefs.getString('user_role');
  }

  /// Get username dari session
  static String? getUsername() {
    return _prefs.getString('username');
  }

  /// Get nama lengkap dari session
  static String? getNamaLengkap() {
    return _prefs.getString('nama_lengkap');
  }

  /// Get logged in user data
  static Map<String, dynamic>? getLoggedInUser() {
    int? userId = getUserId();
    String? role = getUserRole();
    String? username = getUsername();
    String? namaLengkap = getNamaLengkap();

    if (userId == null || role == null || username == null) {
      return null;
    }

    return {
      'user_id': userId,
      'user_role': role,
      'username': username,
      'nama_lengkap': namaLengkap,
    };
  }

  /// Clear session (logout)
  static Future<bool> logout() async {
    await _prefs.remove('is_logged_in');
    await _prefs.remove('user_id');
    await _prefs.remove('user_role');
    await _prefs.remove('username');
    await _prefs.remove('nama_lengkap');
    return true;
  }

  /// Clear all preferences
  static Future<bool> clearAll() {
    return _prefs.clear();
  }
}
