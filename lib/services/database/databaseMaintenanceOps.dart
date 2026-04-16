// ignore_for_file: file_names

part of '../database_helper.dart';

extension DatabaseMaintenanceOps on DatabaseHelper {
  Future<void> clearAllData() async {
    final db = await database;
    try {
      await db.delete(AppConstants.tableLogAktivitas);
      await db.delete(AppConstants.tableTransaksi);
      await db.delete(AppConstants.tableKendaraan);
      await db.delete(AppConstants.tableAreaParkir);
      await db.delete(AppConstants.tableJenisKendaraan);
      await db.delete(AppConstants.tableUser);
    } catch (e) {
      throw Exception('Error clearing data: $e');
    }
  }

  Future<void> clearUsers() async {
    final db = await database;
    try {
      await db.delete(AppConstants.tableUser);
    } catch (e) {
      throw Exception('Error clearing users: $e');
    }
  }

  Future<void> clearTransaksi() async {
    final db = await database;
    try {
      await db.delete(AppConstants.tableTransaksi);
    } catch (e) {
      throw Exception('Error clearing transactions: $e');
    }
  }

  Future<void> clearKendaraan() async {
    final db = await database;
    try {
      await db.delete(AppConstants.tableKendaraan);
    } catch (e) {
      throw Exception('Error clearing vehicles: $e');
    }
  }

  Future<void> clearActivityLogs() async {
    final db = await database;
    try {
      await db.delete(AppConstants.tableLogAktivitas);
    } catch (e) {
      throw Exception('Error clearing activity logs: $e');
    }
  }

  Future<void> resetDatabase() async {
    final db = await database;
    try {
      await db.execute(
        'DROP TABLE IF EXISTS ${AppConstants.tableLogAktivitas}',
      );
      await db.execute('DROP TABLE IF EXISTS ${AppConstants.tableTransaksi}');
      await db.execute('DROP TABLE IF EXISTS ${AppConstants.tableKendaraan}');
      await db.execute('DROP TABLE IF EXISTS ${AppConstants.tableAreaParkir}');
      await db.execute(
        'DROP TABLE IF EXISTS ${AppConstants.tableJenisKendaraan}',
      );
      await db.execute('DROP TABLE IF EXISTS ${AppConstants.tableUser}');

      await _createTables(db, AppConstants.databaseVersion);
    } catch (e) {
      throw Exception('Error resetting database: $e');
    }
  }

  Future<void> deleteDatabaseFile() async {
    try {
      final dbPath = await getDatabasePath();
      final file = File(dbPath);
      if (await file.exists()) {
        await file.delete();
        DatabaseHelper._database = null;
        DatabaseHelper._dbPath = null;
      }
    } catch (e) {
      throw Exception('Error deleting database file: $e');
    }
  }
}
