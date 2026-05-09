// ignore_for_file: file_names

part of '../database_helper.dart';

extension DatabaseTransactionOps on DatabaseHelper {
  Future<int> insertTransaksi(Map<String, dynamic> data) async {
    final db = await database;
    return await db.insert(AppConstants.tableTransaksi, data);
  }

  Future<List<Map<String, dynamic>>> getActiveTransactions() async {
    final db = await database;
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
      WHERE t.${AppConstants.colTransaksiStatus} = ?
      ORDER BY t.${AppConstants.colWaktuMasuk} DESC
    ''',
      [AppConstants.statusParkir],
    );
  }

  Future<List<Map<String, dynamic>>> getAllTransactions({
    int limit = 100,
  }) async {
    final db = await database;
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
      ORDER BY t.${AppConstants.colWaktuMasuk} DESC
      LIMIT ?
    ''',
      [limit],
    );
  }

  Future<List<Map<String, dynamic>>> getCompletedTransactions({
    int limit = 100,
  }) async {
    final db = await database;
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
  }

  Future<List<Map<String, dynamic>>> getOngoingTransactions({
    int limit = 100,
  }) async {
    final db = await database;
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
      WHERE t.${AppConstants.colWaktuKeluar} IS NULL
      ORDER BY t.${AppConstants.colWaktuMasuk} DESC
      LIMIT ?
    ''',
      [limit],
    );
  }

  Future<int> updateTransaksi(
    int transaksiId,
    Map<String, dynamic> data,
  ) async {
    final db = await database;
    return await db.update(
      AppConstants.tableTransaksi,
      data,
      where: '${AppConstants.colTransaksiId} = ?',
      whereArgs: [transaksiId],
    );
  }
}
