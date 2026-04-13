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

  late dynamic _database;
  bool _isWeb = false;

  factory DatabaseManager() {
    return _instance;
  }

  DatabaseManager._internal();

  /// Initialize database sesuai platform
  Future<void> initialize() async {
    _isWeb = kIsWeb;

    if (kIsWeb) {
      _database = WebDatabaseHelper();
      await _database.initialize();
    } else {
      _database = DatabaseHelper();
    }
  }

  /// Proxy methods ke appropriate database helper

  // User operations
  Future<int> insertUser(UserModel user) async {
    return await _database.insertUser(user);
  }

  Future<UserModel?> getUserByUsername(String username) async {
    return await _database.getUserByUsername(username);
  }

  Future<UserModel?> getUserById(int id) async {
    return await _database.getUserById(id);
  }

  Future<List<UserModel>> getAllUsers() async {
    return await _database.getAllUsers();
  }

  Future<int> updateUser(UserModel user) async {
    return await _database.updateUser(user);
  }

  Future<int> deleteUser(int id) async {
    return await _database.deleteUser(id);
  }

  // Activity log operations
  Future<int> recordActivity(
    int userId,
    String kategori,
    String aktivitas,
  ) async {
    return await _database.recordActivity(userId, kategori, aktivitas);
  }

  Future<List<Map<String, dynamic>>> getActivityLogs({
    int? userId,
    String? kategori,
    int limit = 100,
  }) async {
    return await _database.getActivityLogs(
      userId: userId,
      kategori: kategori,
      limit: limit,
    );
  }

  // Transaksi operations
  Future<int> insertTransaksi(Map<String, dynamic> data) async {
    return await _database.insertTransaksi(data);
  }

  Future<List<Map<String, dynamic>>> getActiveTransactions() async {
    return await _database.getActiveTransactions();
  }

  Future<List<Map<String, dynamic>>> getAllTransactions({
    int limit = 100,
  }) async {
    return await _database.getAllTransactions(limit: limit);
  }

  Future<int> updateTransaksi(
    int transaksiId,
    Map<String, dynamic> data,
  ) async {
    return await _database.updateTransaksi(transaksiId, data);
  }

  // Utility
  bool get isWeb => _isWeb;
  Future<String> getDatabasePath() async {
    if (_isWeb) {
      return 'Browser SharedPreferences (no file path)';
    }
    return await (_database as DatabaseHelper).getDatabasePath();
  }
}
