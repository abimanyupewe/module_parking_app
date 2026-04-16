// ignore_for_file: file_names

part of '../database_helper.dart';

extension DatabaseOwnerDashboardOps on DatabaseHelper {
  Future<Map<String, dynamic>> getOwnerDashboardSummary() async {
    final db = await database;
    try {
      final countResult = await db.rawQuery('''
        SELECT COUNT(*) as count FROM ${AppConstants.tableTransaksi}
        WHERE ${AppConstants.colWaktuKeluar} IS NOT NULL
      ''');

      final revenueResult = await db.rawQuery(
        '''
        SELECT COALESCE(SUM(${AppConstants.colTotalBiaya}), 0) as revenue 
        FROM ${AppConstants.tableTransaksi}
        WHERE ${AppConstants.colTransaksiStatus} = ?
      ''',
        [AppConstants.statusSelesai],
      );

      final transactionCount =
          (countResult.isNotEmpty ? countResult.first['count'] : 0) as int;
      final totalRevenue =
          (revenueResult.isNotEmpty ? revenueResult.first['revenue'] : 0)
              as int;

      return {
        'transactionCount': transactionCount,
        'totalRevenue': totalRevenue,
      };
    } catch (e) {
      throw Exception('Error getting dashboard summary: $e');
    }
  }

  Future<List<AreaParkirModel>> getTopAreasByOccupancy({int limit = 3}) async {
    final db = await database;
    try {
      final maps = await db.rawQuery(
        '''
        SELECT *,
          CAST((${AppConstants.colTerisi} * 100.0 / ${AppConstants.colKapasitas}) AS INTEGER) as percentage
        FROM ${AppConstants.tableAreaParkir}
        ORDER BY percentage DESC
        LIMIT ?
      ''',
        [limit],
      );

      return List.generate(
        maps.length,
        (i) => AreaParkirModel.fromMap(maps[i]),
      );
    } catch (e) {
      throw Exception('Error getting top areas by occupancy: $e');
    }
  }

  Future<List<Map<String, dynamic>>> getRecentTransactionsWithDetails({
    int limit = 5,
  }) async {
    final db = await database;
    try {
      return await db.rawQuery(
        '''
        SELECT 
          t.${AppConstants.colTransaksiId},
          t.${AppConstants.colKendaraanId},
          t.${AppConstants.colAreaId},
          t.${AppConstants.colWaktuMasuk},
          t.${AppConstants.colWaktuKeluar},
          t.${AppConstants.colTransaksiStatus},
          t.${AppConstants.colTotalBiaya},
          t.${AppConstants.colUserId},
          t.image_path,
          k.${AppConstants.colPlatNomor},
          k.${AppConstants.colMerk},
          k.${AppConstants.colWarna},
          k.${AppConstants.colJenisId},
          j.${AppConstants.colNamaJenis},
          j.${AppConstants.colTarifPerJam},
          a.${AppConstants.colNamaArea},
          a.${AppConstants.colKapasitas},
          a.${AppConstants.colTerisi}
        FROM ${AppConstants.tableTransaksi} t
        LEFT JOIN ${AppConstants.tableKendaraan} k ON t.${AppConstants.colKendaraanId} = k.${AppConstants.colKendaraanId}
        LEFT JOIN ${AppConstants.tableJenisKendaraan} j ON k.${AppConstants.colJenisId} = j.${AppConstants.colJenisId}
        LEFT JOIN ${AppConstants.tableAreaParkir} a ON t.${AppConstants.colAreaId} = a.${AppConstants.colAreaId}
        WHERE t.${AppConstants.colWaktuKeluar} IS NOT NULL
        ORDER BY t.${AppConstants.colWaktuMasuk} DESC
        LIMIT ?
      ''',
        [limit],
      );
    } catch (e) {
      throw Exception('Error getting recent transactions: $e');
    }
  }

  Future<List<Map<String, dynamic>>> getAreaParkingStatus({
    int page = 1,
    int pageSize = 10,
    int? idJenis,
  }) async {
    final db = await database;
    try {
      final offset = (page - 1) * pageSize;

      List<dynamic> args = [];
      String whereClause = '';

      if (idJenis != null) {
        whereClause = 'WHERE a.${AppConstants.colJenisId} = ?';
        args.add(idJenis);
      }

      final maps = await db.rawQuery(
        '''
        SELECT 
          a.${AppConstants.colAreaId},
          a.${AppConstants.colNamaArea},
          a.${AppConstants.colJenisId},
          a.${AppConstants.colKapasitas},
          a.${AppConstants.colTerisi},
          j.${AppConstants.colNamaJenis},
          CAST((a.${AppConstants.colTerisi} * 100.0 / a.${AppConstants.colKapasitas}) AS INTEGER) as percentage
        FROM ${AppConstants.tableAreaParkir} a
        LEFT JOIN ${AppConstants.tableJenisKendaraan} j ON a.${AppConstants.colJenisId} = j.${AppConstants.colJenisId}
        $whereClause
        ORDER BY a.${AppConstants.colNamaArea} ASC
        LIMIT ? OFFSET ?
      ''',
        [...args, pageSize, offset],
      );

      return maps;
    } catch (e) {
      throw Exception('Error getting area parking status: $e');
    }
  }

  Future<int> getAreaParkingCount({int? idJenis}) async {
    final db = await database;
    try {
      List<dynamic> args = [];
      String whereClause = '';

      if (idJenis != null) {
        whereClause = 'WHERE ${AppConstants.colJenisId} = ?';
        args.add(idJenis);
      }

      final result = await db.rawQuery(
        'SELECT COUNT(*) as count FROM ${AppConstants.tableAreaParkir} $whereClause',
        args,
      );

      return (result.isNotEmpty ? result.first['count'] : 0) as int;
    } catch (e) {
      throw Exception('Error getting area parking count: $e');
    }
  }
}
