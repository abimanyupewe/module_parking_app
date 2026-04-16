// ignore_for_file: file_names

part of '../database_helper.dart';

extension DatabaseMasterDataOps on DatabaseHelper {
  Future<int> insertJenisKendaraan(JenisKendaraanModel jenis) async {
    final db = await database;
    return await db.insert(AppConstants.tableJenisKendaraan, jenis.toMap());
  }

  Future<List<JenisKendaraanModel>> getAllJenisKendaraan() async {
    final db = await database;
    final maps = await db.query(AppConstants.tableJenisKendaraan);
    return List.generate(
      maps.length,
      (i) => JenisKendaraanModel.fromMap(maps[i]),
    );
  }

  Future<JenisKendaraanModel?> getJenisKendaraanById(int id) async {
    final db = await database;
    final maps = await db.query(
      AppConstants.tableJenisKendaraan,
      where: '${AppConstants.colJenisId} = ?',
      whereArgs: [id],
    );
    if (maps.isNotEmpty) return JenisKendaraanModel.fromMap(maps.first);
    return null;
  }

  Future<int> updateJenisKendaraan(JenisKendaraanModel jenis) async {
    final db = await database;
    return await db.update(
      AppConstants.tableJenisKendaraan,
      jenis.toMap(),
      where: '${AppConstants.colJenisId} = ?',
      whereArgs: [jenis.idJenis],
    );
  }

  Future<int> deleteJenisKendaraan(int idJenis) async {
    final db = await database;
    return await db.delete(
      AppConstants.tableJenisKendaraan,
      where: '${AppConstants.colJenisId} = ?',
      whereArgs: [idJenis],
    );
  }

  Future<bool> isDuplicateJenisKendaraan(String namaJenis) async {
    final db = await database;
    final result = await db.query(
      AppConstants.tableJenisKendaraan,
      where: '${AppConstants.colNamaJenis} = ?',
      whereArgs: [namaJenis],
    );
    return result.isNotEmpty;
  }

  Future<int> insertAreaParkir(AreaParkirModel area) async {
    final db = await database;
    return await db.insert(AppConstants.tableAreaParkir, area.toMap());
  }

  Future<List<AreaParkirModel>> getAllAreaParkir() async {
    final db = await database;
    final maps = await db.query(AppConstants.tableAreaParkir);
    return List.generate(maps.length, (i) => AreaParkirModel.fromMap(maps[i]));
  }

  Future<List<AreaParkirModel>> getAreaParkirByJenis(int idJenis) async {
    final db = await database;
    final maps = await db.query(
      AppConstants.tableAreaParkir,
      where: '${AppConstants.colJenisId} = ?',
      whereArgs: [idJenis],
    );
    return List.generate(maps.length, (i) => AreaParkirModel.fromMap(maps[i]));
  }

  Future<AreaParkirModel?> getAreaParkirById(int id) async {
    final db = await database;
    final maps = await db.query(
      AppConstants.tableAreaParkir,
      where: '${AppConstants.colAreaId} = ?',
      whereArgs: [id],
    );
    if (maps.isNotEmpty) return AreaParkirModel.fromMap(maps.first);
    return null;
  }

  Future<int> updateAreaParkir(AreaParkirModel area) async {
    final db = await database;
    return await db.update(
      AppConstants.tableAreaParkir,
      area.toMap(),
      where: '${AppConstants.colAreaId} = ?',
      whereArgs: [area.idArea],
    );
  }

  Future<int> deleteAreaParkir(int idArea) async {
    final db = await database;
    return await db.delete(
      AppConstants.tableAreaParkir,
      where: '${AppConstants.colAreaId} = ?',
      whereArgs: [idArea],
    );
  }

  Future<bool> isDuplicateAreaParkir(String namaArea) async {
    final db = await database;
    final result = await db.query(
      AppConstants.tableAreaParkir,
      where: '${AppConstants.colNamaArea} = ?',
      whereArgs: [namaArea],
    );
    return result.isNotEmpty;
  }

  Future<int> insertKendaraan(KendaraanModel kendaraan) async {
    final db = await database;
    return await db.insert(AppConstants.tableKendaraan, kendaraan.toMap());
  }

  Future<List<KendaraanModel>> getAllKendaraan() async {
    final db = await database;
    final maps = await db.query(AppConstants.tableKendaraan);
    return List.generate(maps.length, (i) => KendaraanModel.fromMap(maps[i]));
  }

  Future<KendaraanModel?> getKendaraanByPlatNomor(String platNomor) async {
    final db = await database;
    final maps = await db.query(
      AppConstants.tableKendaraan,
      where: '${AppConstants.colPlatNomor} = ?',
      whereArgs: [platNomor],
    );
    if (maps.isNotEmpty) return KendaraanModel.fromMap(maps.first);
    return null;
  }

  Future<KendaraanModel?> getKendaraanById(int id) async {
    final db = await database;
    final maps = await db.query(
      AppConstants.tableKendaraan,
      where: '${AppConstants.colKendaraanId} = ?',
      whereArgs: [id],
    );
    if (maps.isNotEmpty) return KendaraanModel.fromMap(maps.first);
    return null;
  }

  Future<int?> getActiveTransactionByPlate(String platNomor) async {
    final db = await database;
    final result = await db.rawQuery(
      '''
      SELECT t.${AppConstants.colTransaksiId}
      FROM ${AppConstants.tableTransaksi} t
      JOIN ${AppConstants.tableKendaraan} k ON t.${AppConstants.colKendaraanId} = k.${AppConstants.colKendaraanId}
      WHERE k.${AppConstants.colPlatNomor} = ? 
      AND t.${AppConstants.colTransaksiStatus} = ?
      LIMIT 1
    ''',
      [platNomor, AppConstants.statusParkir],
    );

    if (result.isNotEmpty) {
      return result.first[AppConstants.colTransaksiId] as int?;
    }
    return null;
  }
}
