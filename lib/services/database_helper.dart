import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'dart:io';
import '../config/constants.dart';
import '../models/models.dart';

part 'database/databaseUserOps.dart';
part 'database/databaseActivityLogOps.dart';
part 'database/databaseTransactionOps.dart';
part 'database/databaseMasterDataOps.dart';
part 'database/databaseMaintenanceOps.dart';
part 'database/databaseOwnerDashboardOps.dart';

/// DatabaseHelper sederhana untuk pembelajaran SMK
/// Menggunakan SQLite dengan sqflite untuk Android/iOS
/// dan sqflite_common_ffi untuk Desktop (Windows, Linux, macOS)
class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  static Database? _database;
  static String? _dbPath;

  factory DatabaseHelper() {
    return _instance;
  }

  DatabaseHelper._internal();

  /// Getter untuk database
  Future<Database> get database async {
    _database ??= await _initDatabase();
    return _database!;
  }

  /// Getter untuk database path
  String? get databasePath => _dbPath;

  /// Get full database path
  Future<String> getDatabasePath() async {
    if (_dbPath != null) {
      return _dbPath!;
    }
    await database;
    return _dbPath ?? 'Unknown path';
  }

  /// Inisialisasi database - simple untuk pembelajaran
  Future<Database> _initDatabase() async {
    try {
      // Gunakan getDatabasesPath() - works untuk mobile & desktop dengan sqflite_ffi
      final databasesPath = await getDatabasesPath();
      final dbPath = join(databasesPath, AppConstants.databaseName);

      _dbPath = dbPath;

      return await openDatabase(
        dbPath,
        version: AppConstants.databaseVersion,
        onCreate: _createTables,
        onUpgrade: _onUpgrade,
      );
    } catch (e) {
      throw Exception('Database initialization failed: $e');
    }
  }

  /// Membuat tabel-tabel di database
  Future<void> _createTables(Database db, int version) async {
    // Tabel User
    await db.execute('''
      CREATE TABLE ${AppConstants.tableUser} (
        ${AppConstants.colUserId} INTEGER PRIMARY KEY AUTOINCREMENT,
        ${AppConstants.colNamaLengkap} VARCHAR(50) NOT NULL,
        ${AppConstants.colUsername} VARCHAR(50) NOT NULL UNIQUE,
        ${AppConstants.colPassword} VARCHAR(100) NOT NULL,
        ${AppConstants.colRole} TEXT NOT NULL DEFAULT '${AppConstants.roleAdmin}',
        ${AppConstants.colStatus} TEXT NOT NULL DEFAULT '${AppConstants.statusAktif}',
        security_question TEXT,
        security_answer TEXT,
        is_default_password BOOLEAN DEFAULT 1
      )
    ''');

    // Tabel Jenis Kendaraan
    await db.execute('''
      CREATE TABLE ${AppConstants.tableJenisKendaraan} (
        ${AppConstants.colJenisId} INTEGER PRIMARY KEY AUTOINCREMENT,
        ${AppConstants.colNamaJenis} VARCHAR(50) NOT NULL UNIQUE,
        ${AppConstants.colTarifPerJam} INTEGER NOT NULL
      )
    ''');

    // Tabel Area Parkir
    await db.execute('''
      CREATE TABLE ${AppConstants.tableAreaParkir} (
        ${AppConstants.colAreaId} INTEGER PRIMARY KEY AUTOINCREMENT,
        ${AppConstants.colNamaArea} VARCHAR(50) NOT NULL UNIQUE,
        ${AppConstants.colJenisId} INTEGER NOT NULL,
        ${AppConstants.colKapasitas} INTEGER NOT NULL,
        ${AppConstants.colTerisi} INTEGER NOT NULL DEFAULT 0,
        FOREIGN KEY (${AppConstants.colJenisId}) REFERENCES ${AppConstants.tableJenisKendaraan}(${AppConstants.colJenisId})
      )
    ''');

    // Tabel Kendaraan
    await db.execute('''
      CREATE TABLE ${AppConstants.tableKendaraan} (
        ${AppConstants.colKendaraanId} INTEGER PRIMARY KEY AUTOINCREMENT,
        ${AppConstants.colPlatNomor} VARCHAR(15) NOT NULL UNIQUE,
        ${AppConstants.colJenisId} INTEGER NOT NULL,
        ${AppConstants.colMerk} VARCHAR(50) NOT NULL,
        ${AppConstants.colWarna} VARCHAR(30) NOT NULL,
        FOREIGN KEY (${AppConstants.colJenisId}) REFERENCES ${AppConstants.tableJenisKendaraan}(${AppConstants.colJenisId})
      )
    ''');

    // Tabel Transaksi
    await db.execute('''
      CREATE TABLE ${AppConstants.tableTransaksi} (
        ${AppConstants.colTransaksiId} INTEGER PRIMARY KEY AUTOINCREMENT,
        ${AppConstants.colKendaraanId} INTEGER NOT NULL,
        ${AppConstants.colAreaId} INTEGER NOT NULL,
        ${AppConstants.colWaktuMasuk} DATETIME NOT NULL,
        ${AppConstants.colWaktuKeluar} DATETIME,
        ${AppConstants.colTransaksiStatus} TEXT NOT NULL DEFAULT '${AppConstants.statusParkir}',
        ${AppConstants.colTotalBiaya} INTEGER,
        ${AppConstants.colUserId} INTEGER NOT NULL,
        image_path TEXT,
        FOREIGN KEY (${AppConstants.colKendaraanId}) REFERENCES ${AppConstants.tableKendaraan}(${AppConstants.colKendaraanId}),
        FOREIGN KEY (${AppConstants.colAreaId}) REFERENCES ${AppConstants.tableAreaParkir}(${AppConstants.colAreaId}),
        FOREIGN KEY (${AppConstants.colUserId}) REFERENCES ${AppConstants.tableUser}(${AppConstants.colUserId})
      )
    ''');

    // Tabel Log Aktivitas
    await db.execute('''
      CREATE TABLE ${AppConstants.tableLogAktivitas} (
        ${AppConstants.colLogId} INTEGER PRIMARY KEY AUTOINCREMENT,
        ${AppConstants.colUserId} INTEGER NOT NULL,
        ${AppConstants.colKategoriLog} TEXT NOT NULL,
        ${AppConstants.colAktivitas} VARCHAR(100) NOT NULL,
        ${AppConstants.colWaktu} DATETIME NOT NULL,
        FOREIGN KEY (${AppConstants.colUserId}) REFERENCES ${AppConstants.tableUser}(${AppConstants.colUserId})
      )
    ''');

    // Seed initial data
    await _seedInitialData(db);
  }

  /// Seed data awal untuk database (kosong - tidak ada data dummy)
  Future<void> _seedInitialData(Database db) async {
    // Database dibuat kosong tanpa data dummy
    // User harus membuat/register data sendiri melalui aplikasi
  }

  /// Handle database upgrade
  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    // Untuk pembelajaran, tidak perlu complex migration
    // Tapi karena tabel Transaksi tambah image_path maka tangani di v2:
    if (oldVersion < 2) {
      try {
        await db.execute(
          'ALTER TABLE ${AppConstants.tableTransaksi} ADD COLUMN image_path TEXT',
        );
      } catch (e) {
        // Jika sudah ada (ignore error)
      }
    }

    if (oldVersion < 3) {
      try {
        await db.execute(
          'DROP TABLE IF EXISTS ${AppConstants.tableLogAktivitas}',
        );
        await db.execute('DROP TABLE IF EXISTS ${AppConstants.tableTransaksi}');
        await db.execute('DROP TABLE IF EXISTS ${AppConstants.tableKendaraan}');
        await db.execute(
          'DROP TABLE IF EXISTS ${AppConstants.tableAreaParkir}',
        );
        await db.execute(
          'DROP TABLE IF EXISTS ${AppConstants.tableJenisKendaraan}',
        );
        await db.execute('DROP TABLE IF EXISTS ${AppConstants.tableUser}');

        await _createTables(db, newVersion);
      } catch (e) {
        // Ignore errors
      }
    }
  }

  // ==================== JENIS KENDARAAN OPERATIONS ====================

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

  /// Check apakah nama jenis kendaraan sudah ada
  Future<bool> isDuplicateJenisKendaraan(String namaJenis) async {
    final db = await database;
    final result = await db.query(
      AppConstants.tableJenisKendaraan,
      where: '${AppConstants.colNamaJenis} = ?',
      whereArgs: [namaJenis],
    );
    return result.isNotEmpty;
  }

  // ==================== AREA PARKIR OPERATIONS ====================

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

  /// Check apakah nama area parkir sudah ada
  Future<bool> isDuplicateAreaParkir(String namaArea) async {
    final db = await database;
    final result = await db.query(
      AppConstants.tableAreaParkir,
      where: '${AppConstants.colNamaArea} = ?',
      whereArgs: [namaArea],
    );
    return result.isNotEmpty;
  }

  // ==================== KENDARAAN OPERATIONS ====================

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

  /// Check apakah kendaraan dengan plat nomor sedang aktif/parkir
  /// Return transaksi id jika ada transaksi aktif, null jika tidak ada
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

  // ==================== DATA CLEANUP OPERATIONS ====================

  /// Hapus semua data dari semua tabel (untuk testing/debugging)
  Future<void> clearAllData() async {
    final db = await database;
    try {
      // Hapus dengan urutan yang tepat untuk menghindari foreign key constraint
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

  /// Hapus hanya data user (keep master data)
  Future<void> clearUsers() async {
    final db = await database;
    try {
      await db.delete(AppConstants.tableUser);
    } catch (e) {
      throw Exception('Error clearing users: $e');
    }
  }

  /// Hapus hanya data transaksi
  Future<void> clearTransaksi() async {
    final db = await database;
    try {
      await db.delete(AppConstants.tableTransaksi);
    } catch (e) {
      throw Exception('Error clearing transactions: $e');
    }
  }

  /// Hapus hanya data kendaraan
  Future<void> clearKendaraan() async {
    final db = await database;
    try {
      await db.delete(AppConstants.tableKendaraan);
    } catch (e) {
      throw Exception('Error clearing vehicles: $e');
    }
  }

  /// Hapus hanya data log aktivitas
  Future<void> clearActivityLogs() async {
    final db = await database;
    try {
      await db.delete(AppConstants.tableLogAktivitas);
    } catch (e) {
      throw Exception('Error clearing activity logs: $e');
    }
  }

  /// Reset database ke state kosong (hapus semua dan recreate schema)
  Future<void> resetDatabase() async {
    final db = await database;
    try {
      // Hapus semua tabel
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

      // Recreate schema
      await _createTables(db, AppConstants.databaseVersion);
    } catch (e) {
      throw Exception('Error resetting database: $e');
    }
  }

  /// Delete entire database file
  Future<void> deleteDatabaseFile() async {
    try {
      final dbPath = await getDatabasePath();
      final file = File(dbPath);
      if (await file.exists()) {
        await file.delete();
        _database = null;
        _dbPath = null;
      }
    } catch (e) {
      throw Exception('Error deleting database file: $e');
    }
  }

  // ==================== OWNER DASHBOARD OPERATIONS ====================

  /// Get dashboard summary statistics for owner
  /// Returns: {transactionCount: total completed transactions, totalRevenue: sum of completed transactions}
  Future<Map<String, dynamic>> getOwnerDashboardSummary() async {
    final db = await database;
    try {
      // Get total count of completed transactions (waktu_keluar IS NOT NULL)
      final countResult = await db.rawQuery('''
        SELECT COUNT(*) as count FROM ${AppConstants.tableTransaksi}
        WHERE ${AppConstants.colWaktuKeluar} IS NOT NULL
      ''');

      // Get total revenue from completed transactions (status = 'Selesai')
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

  /// Get top 3 areas by occupancy percentage
  /// Returns: List of AreaParkirModel sorted by occupancy percentage (highest first)
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

  /// Get recent transactions with complete details (vehicle & area info)
  /// Returns: List of transaction maps with plat_nomor, merk, jenis, area info
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

  /// Get area parking status with pagination and optional jenis filter
  /// Parameters:
  ///   - page: pagination page (1-based)
  ///   - pageSize: items per page (default 10)
  ///   - idJenis: optional filter by jenis kendaraan (null = all)
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

  /// Get total count of areas for pagination
  /// Parameters:
  ///   - idJenis: optional filter by jenis kendaraan (null = all)
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
