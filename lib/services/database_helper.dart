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
}
