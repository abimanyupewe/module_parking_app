import 'package:flutter/foundation.dart';
import '../models/models.dart';

// Import database helpers berdasarkan platform
import 'database_helper.dart';
import 'web_database_helper.dart';

/// Database Manager - abstraksi untuk memilih database berdasarkan platform
/// - Desktop/Mobile: SQLite (DatabaseHelper)
/// - Web: SharedPreferences (WebDatabaseHelper)
class DatabaseManager {
  static final DatabaseManager _instance = DatabaseManager._internal();

  late Object _database;
  bool _isWeb = false;

  factory DatabaseManager() {
    return _instance;
  }

  DatabaseManager._internal();

  DatabaseHelper get _nativeDb => _database as DatabaseHelper;
  WebDatabaseHelper get _webDb => _database as WebDatabaseHelper;

  /// Initialize database sesuai platform
  Future<void> initialize() async {
    _isWeb = kIsWeb;

    if (kIsWeb) {
      _database = WebDatabaseHelper();
      await _webDb.initialize();
    } else {
      _database = DatabaseHelper();
    }
  }

  /// Proxy methods ke appropriate database helper

  // User operations
  Future<int> insertUser(UserModel user) async {
    return _isWeb
        ? await _webDb.insertUser(user)
        : await _nativeDb.insertUser(user);
  }

  Future<UserModel?> getUserByUsername(String username) async {
    return _isWeb
        ? await _webDb.getUserByUsername(username)
        : await _nativeDb.getUserByUsername(username);
  }

  Future<UserModel?> getUserById(int id) async {
    return _isWeb
        ? await _webDb.getUserById(id)
        : await _nativeDb.getUserById(id);
  }

  Future<List<UserModel>> getAllUsers() async {
    return _isWeb ? await _webDb.getAllUsers() : await _nativeDb.getAllUsers();
  }

  Future<int> updateUser(UserModel user) async {
    return _isWeb
        ? await _webDb.updateUser(user)
        : await _nativeDb.updateUser(user);
  }

  Future<int> deleteUser(int id) async {
    return _isWeb
        ? await _webDb.deleteUser(id)
        : await _nativeDb.deleteUser(id);
  }

  // Activity log operations
  Future<int> recordActivity(
    int userId,
    String kategori,
    String aktivitas,
  ) async {
    return _isWeb
        ? await _webDb.recordActivity(userId, kategori, aktivitas)
        : await _nativeDb.recordActivity(userId, kategori, aktivitas);
  }

  Future<List<Map<String, dynamic>>> getActivityLogs({
    int? userId,
    String? kategori,
    int limit = 100,
  }) async {
    return _isWeb
        ? await _webDb.getActivityLogs(
            userId: userId,
            kategori: kategori,
            limit: limit,
          )
        : await _nativeDb.getActivityLogs(
            userId: userId,
            kategori: kategori,
            limit: limit,
          );
  }

  // Transaksi operations
  Future<int> insertTransaksi(Map<String, dynamic> data) async {
    return _isWeb
        ? await _webDb.insertTransaksi(data)
        : await _nativeDb.insertTransaksi(data);
  }

  Future<List<Map<String, dynamic>>> getActiveTransactions() async {
    return _isWeb
        ? await _webDb.getActiveTransactions()
        : await _nativeDb.getActiveTransactions();
  }

  Future<List<Map<String, dynamic>>> getAllTransactions({
    int limit = 100,
  }) async {
    return _isWeb
        ? await _webDb.getAllTransactions(limit: limit)
        : await _nativeDb.getAllTransactions(limit: limit);
  }

  Future<int> updateTransaksi(
    int transaksiId,
    Map<String, dynamic> data,
  ) async {
    return _isWeb
        ? await _webDb.updateTransaksi(transaksiId, data)
        : await _nativeDb.updateTransaksi(transaksiId, data);
  }

  // Utility
  bool get isWeb => _isWeb;
  Future<String> getDatabasePath() async {
    if (_isWeb) {
      return 'Browser SharedPreferences (no file path)';
    }
    return await _nativeDb.getDatabasePath();
  }
}
