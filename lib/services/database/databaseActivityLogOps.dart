// ignore_for_file: file_names

part of '../database_helper.dart';

extension DatabaseActivityLogOps on DatabaseHelper {
  Future<int> recordActivity(
    int userId,
    String kategori,
    String aktivitas,
  ) async {
    final db = await database;
    final now = DateTime.now();

    return await db.insert(AppConstants.tableLogAktivitas, {
      AppConstants.colUserId: userId,
      AppConstants.colKategoriLog: kategori,
      AppConstants.colAktivitas: aktivitas,
      AppConstants.colWaktu: now.toIso8601String(),
    });
  }

  Future<List<Map<String, dynamic>>> getActivityLogs({
    int? userId,
    String? kategori,
    int limit = 100,
  }) async {
    final db = await database;
    String where = '';
    List<dynamic> whereArgs = [];

    if (userId != null) {
      where = 'l.${AppConstants.colUserId} = ?';
      whereArgs.add(userId);
    }
    if (kategori != null) {
      if (where.isNotEmpty) where += ' AND ';
      where += 'l.${AppConstants.colKategoriLog} = ?';
      whereArgs.add(kategori);
    }

    final whereClause = where.isEmpty ? '' : 'WHERE $where';

    return await db.rawQuery(
      '''
      SELECT l.*, u.${AppConstants.colRole}, u.${AppConstants.colNamaLengkap}, u.${AppConstants.colUsername}
      FROM ${AppConstants.tableLogAktivitas} l
      LEFT JOIN ${AppConstants.tableUser} u ON l.${AppConstants.colUserId} = u.${AppConstants.colUserId}
      $whereClause
      ORDER BY l.${AppConstants.colWaktu} DESC
      LIMIT ?
    ''',
      [...whereArgs, limit],
    );
  }
}
