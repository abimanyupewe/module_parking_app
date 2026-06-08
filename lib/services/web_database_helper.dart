import 'package:flutter/foundation.dart';
import '../models/models.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

/// Web Database Helper - Simple implementation using SharedPreferences
/// Untuk web platform, gunakan SharedPreferences sebagai "database"
class WebDatabaseHelper {
  static final WebDatabaseHelper _instance = WebDatabaseHelper._internal();
  late SharedPreferences _prefs;
  bool _initialized = false;

  factory WebDatabaseHelper() {
    return _instance;
  }

  WebDatabaseHelper._internal();

  /// Initialize SharedPreferences
  Future<void> initialize() async {
    if (_initialized) return;
    _prefs = await SharedPreferences.getInstance();
    _initialized = true;
    _initializeDefaultData();
  }

  /// Initialize default data jika belum ada
  void _initializeDefaultData() {
    // Database dibuat kosong tanpa data dummy
    // User harus membuat/register data sendiri melalui aplikasi
  }

  // ==================== USER OPERATIONS ====================

  Future<int> insertUser(UserModel user) async {
    final usersJson = _prefs.getString('users') ?? '[]';
    final usersList = List<Map<String, dynamic>>.from(jsonDecode(usersJson));

    final nextId = _prefs.getInt('nextUserId') ?? 1;
    final userData = user.toMap();
    userData['idUser'] = nextId;
    usersList.add(userData);

    await _prefs.setString('users', jsonEncode(usersList));
    await _prefs.setInt('nextUserId', nextId + 1);
    return nextId;
  }

  Future<UserModel?> getUserByUsername(String username) async {
    final usersJson = _prefs.getString('users') ?? '[]';
    final usersList = List<Map<String, dynamic>>.from(jsonDecode(usersJson));

    try {
      final userData = usersList.firstWhere(
        (user) => user['username'] == username,
      );
      return UserModel.fromMap(userData);
    } catch (e) {
      return null;
    }
  }

  Future<UserModel?> getUserById(int id) async {
    final usersJson = _prefs.getString('users') ?? '[]';
    final usersList = List<Map<String, dynamic>>.from(jsonDecode(usersJson));

    try {
      final userData = usersList.firstWhere((user) => user['idUser'] == id);
      return UserModel.fromMap(userData);
    } catch (e) {
      return null;
    }
  }

  Future<List<UserModel>> getAllUsers() async {
    final usersJson = _prefs.getString('users') ?? '[]';
    final usersList = List<Map<String, dynamic>>.from(jsonDecode(usersJson));

    return usersList.map((data) => UserModel.fromMap(data)).toList();
  }

  Future<int> updateUser(UserModel user) async {
    final usersJson = _prefs.getString('users') ?? '[]';
    final usersList = List<Map<String, dynamic>>.from(jsonDecode(usersJson));

    final index = usersList.indexWhere((u) => u['idUser'] == user.idUser);
    if (index >= 0) {
      usersList[index] = user.toMap();
      await _prefs.setString('users', jsonEncode(usersList));
      return 1;
    }
    return 0;
  }

  Future<int> deleteUser(int id) async {
    final usersJson = _prefs.getString('users') ?? '[]';
    final usersList = List<Map<String, dynamic>>.from(jsonDecode(usersJson));

    final initialLength = usersList.length;
    usersList.removeWhere((user) => user['idUser'] == id);

    await _prefs.setString('users', jsonEncode(usersList));
    return initialLength - usersList.length;
  }

  // ==================== ACTIVITY LOG OPERATIONS ====================

  Future<int> recordActivity(
    int userId,
    String kategori,
    String aktivitas,
  ) async {
    final logsJson = _prefs.getString('activity_logs') ?? '[]';
    final logsList = List<Map<String, dynamic>>.from(jsonDecode(logsJson));

    final nextId = _prefs.getInt('nextLogId') ?? 1;
    final now = DateTime.now();

    logsList.add({
      'idLog': nextId,
      'userId': userId,
      'kategori': kategori,
      'aktivitas': aktivitas,
      'waktu': now.toIso8601String(),
    });

    await _prefs.setString('activity_logs', jsonEncode(logsList));
    await _prefs.setInt('nextLogId', nextId + 1);
    return nextId;
  }

  Future<List<Map<String, dynamic>>> getActivityLogs({
    int? userId,
    String? kategori,
    int limit = 100,
  }) async {
    final logsJson = _prefs.getString('activity_logs') ?? '[]';
    final logsList = List<Map<String, dynamic>>.from(jsonDecode(logsJson));

    var filtered = logsList;

    if (userId != null) {
      filtered = filtered.where((log) => log['userId'] == userId).toList();
    }
    if (kategori != null) {
      filtered = filtered.where((log) => log['kategori'] == kategori).toList();
    }

    filtered.sort(
      (a, b) =>
          DateTime.parse(b['waktu']).compareTo(DateTime.parse(a['waktu'])),
    );

    return filtered.take(limit).toList();
  }

  // ==================== TRANSAKSI OPERATIONS ====================

  Future<int> insertTransaksi(Map<String, dynamic> data) async {
    final transaksisJson = _prefs.getString('transaksis') ?? '[]';
    final transaksisList = List<Map<String, dynamic>>.from(
      jsonDecode(transaksisJson),
    );

    final nextId = _prefs.getInt('nextTransaksiId') ?? 1;
    data['idTransaksi'] = nextId;
    transaksisList.add(data);

    await _prefs.setString('transaksis', jsonEncode(transaksisList));
    await _prefs.setInt('nextTransaksiId', nextId + 1);
    return nextId;
  }

  Future<List<Map<String, dynamic>>> getActiveTransactions() async {
    final transaksisJson = _prefs.getString('transaksis') ?? '[]';
    final transaksisList = List<Map<String, dynamic>>.from(
      jsonDecode(transaksisJson),
    );

    return transaksisList.where((t) => t['status'] == 'parkir').toList();
  }

  Future<List<Map<String, dynamic>>> getAllTransactions({
    int limit = 100,
  }) async {
    final transaksisJson = _prefs.getString('transaksis') ?? '[]';
    final transaksisList = List<Map<String, dynamic>>.from(
      jsonDecode(transaksisJson),
    );

    transaksisList.sort((a, b) {
      final timeA = DateTime.parse(a['waktuMasuk'] ?? '');
      final timeB = DateTime.parse(b['waktuMasuk'] ?? '');
      return timeB.compareTo(timeA);
    });

    return transaksisList.take(limit).toList();
  }

  Future<int> updateTransaksi(
    int transaksiId,
    Map<String, dynamic> data,
  ) async {
    final transaksisJson = _prefs.getString('transaksis') ?? '[]';
    final transaksisList = List<Map<String, dynamic>>.from(
      jsonDecode(transaksisJson),
    );

    final index = transaksisList.indexWhere(
      (t) => t['idTransaksi'] == transaksiId,
    );
    if (index >= 0) {
      transaksisList[index].addAll(data);
      await _prefs.setString('transaksis', jsonEncode(transaksisList));
      return 1;
    }
    return 0;
  }

  // ==================== Utility ====================

  Future<void> clearAllData() async {
    await _prefs.clear();
    _initialized = false;
    _initializeDefaultData();
  }
}
