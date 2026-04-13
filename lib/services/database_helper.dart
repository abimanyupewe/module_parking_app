import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import '../config/constants.dart';
import '../models/models.dart';
import 'password_service.dart';

/// DatabaseHelper untuk mengelola semua operasi database SQLite
class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  static Database? _database;

  factory DatabaseHelper() {
    return _instance;
  }

  DatabaseHelper._internal();

  /// Getter untuk database
  Future<Database> get database async {
    _database ??= await _initDatabase();
    return _database!;
  }

  /// Inisialisasi database dengan custom path di project folder
  Future<Database> _initDatabase() async {
    // Try multiple approaches untuk mendapatkan correct path

    String dbPath;

    // Approach 1: Try getDatabasesPath() first (standard SQLite location)
    try {
      final systemDbPath = await getDatabasesPath();

      // Buat subfolder 'parking_app' di dalam system databases path
      final appDbDir = Directory(join(systemDbPath, 'parking_app'));

      if (!await appDbDir.exists()) {
        await appDbDir.create(recursive: true);
        print('DEBUG: Created database directory at: ${appDbDir.path}');
      }

      dbPath = join(appDbDir.path, AppConstants.databaseName);
      print('DEBUG: Using standard database path: $dbPath');
    } catch (e) {
      // Fallback: Use application documents directory
      print('DEBUG: Standard path failed, using fallback: $e');

      final appDocDir = await getApplicationDocumentsDirectory();
      final dbDir = Directory(join(appDocDir.path, 'databases'));

      if (!await dbDir.exists()) {
        await dbDir.create(recursive: true);
      }

      dbPath = join(dbDir.path, AppConstants.databaseName);
      print('DEBUG: Using fallback database path: $dbPath');
    }

    print('DEBUG: Full Database File: $dbPath');

    return await openDatabase(
      dbPath,
      version: AppConstants.databaseVersion,
      onCreate: _createTables,
      onUpgrade: _onUpgrade,
    );
  }

  /// Membuat semua tabel
  Future<void> _createTables(Database db, int version) async {
    print('DEBUG: _createTables called - creating tables for database...');
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

    // Insert default data
    await _insertDefaultData(db);
  }

  /// Handle upgrade database
  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    // Implementasi upgrade logic jika ada perubahan schema
  }

  /// Insert default data
  Future<void> _insertDefaultData(Database db) async {
    // Insert default jenis kendaraan
    await db.insert(
      AppConstants.tableJenisKendaraan,
      {AppConstants.colNamaJenis: 'Motor', AppConstants.colTarifPerJam: 2000},
      conflictAlgorithm: ConflictAlgorithm.ignore,
    );

    await db.insert(
      AppConstants.tableJenisKendaraan,
      {AppConstants.colNamaJenis: 'Mobil', AppConstants.colTarifPerJam: 5000},
      conflictAlgorithm: ConflictAlgorithm.ignore,
    );

    // Insert default users untuk testing (semua password: 123456)
    final hashedPassword = PasswordService.hashPassword('123456');
    final hashedAnswer = PasswordService.hashPassword('jawaban');

    // User 1: Owner
    await db.insert(AppConstants.tableUser, {
      AppConstants.colNamaLengkap: 'Owner Parkir',
      AppConstants.colUsername: 'owner',
      AppConstants.colPassword: hashedPassword,
      AppConstants.colRole: AppConstants.roleOwner,
      AppConstants.colStatus: AppConstants.statusAktif,
      'security_question': 'Apa nama perusahaan Anda?',
      'security_answer': hashedAnswer,
      'is_default_password': 0,
    }, conflictAlgorithm: ConflictAlgorithm.ignore);

    // User 2: Admin
    await db.insert(AppConstants.tableUser, {
      AppConstants.colNamaLengkap: 'Admin Sistem',
      AppConstants.colUsername: 'admin1',
      AppConstants.colPassword: hashedPassword,
      AppConstants.colRole: AppConstants.roleAdmin,
      AppConstants.colStatus: AppConstants.statusAktif,
      'security_question': 'Siapa nama manajer?',
      'security_answer': hashedAnswer,
      'is_default_password': 0,
    }, conflictAlgorithm: ConflictAlgorithm.ignore);

    // User 3: Petugas
    await db.insert(AppConstants.tableUser, {
      AppConstants.colNamaLengkap: 'Petugas Parkir',
      AppConstants.colUsername: 'petugas1',
      AppConstants.colPassword: hashedPassword,
      AppConstants.colRole: AppConstants.rolePetugas,
      AppConstants.colStatus: AppConstants.statusAktif,
      'security_question': 'Nomor identitas?',
      'security_answer': hashedAnswer,
      'is_default_password': 0,
    }, conflictAlgorithm: ConflictAlgorithm.ignore);
  }

  // ==================== USER OPERATIONS ====================

  /// Insert user baru
  Future<int> insertUser(UserModel user) async {
    final db = await database;
    print('DEBUG INSERT: About to insert user: ${user.toString()}');
    print('DEBUG INSERT: User map: ${user.toMap()}');
    try {
      final result = await db.insert(
        AppConstants.tableUser,
        user.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
      print('DEBUG INSERT: Insert completed with result: $result');
      return result;
    } catch (e) {
      print('DEBUG INSERT: Exception occurred: ${e.toString()}');
      print('DEBUG INSERT: Stack: $e');
      rethrow;
    }
  }

  /// Get user berdasarkan username
  Future<UserModel?> getUserByUsername(String username) async {
    final db = await database;
    final maps = await db.query(
      AppConstants.tableUser,
      where: '${AppConstants.colUsername} = ?',
      whereArgs: [username],
    );
    print('DEBUG DB: Query username=$username, found ${maps.length} record(s)');
    if (maps.isNotEmpty) {
      print('DEBUG DB: First record: ${maps.first}');
      final user = UserModel.fromMap(maps.first);
      print('DEBUG DB: UserModel created: $user');
      return user;
    }
    return null;
  }

  /// Get user berdasarkan ID
  Future<UserModel?> getUserById(int id) async {
    final db = await database;
    final maps = await db.query(
      AppConstants.tableUser,
      where: '${AppConstants.colUserId} = ?',
      whereArgs: [id],
    );
    if (maps.isNotEmpty) {
      return UserModel.fromMap(maps.first);
    }
    return null;
  }

  /// Get semua user
  Future<List<UserModel>> getAllUsers() async {
    final db = await database;
    final maps = await db.query(AppConstants.tableUser);
    return List.generate(maps.length, (i) => UserModel.fromMap(maps[i]));
  }

  /// Get user berdasarkan role
  Future<List<UserModel>> getUsersByRole(String role) async {
    final db = await database;
    final maps = await db.query(
      AppConstants.tableUser,
      where: '${AppConstants.colRole} = ?',
      whereArgs: [role],
    );
    return List.generate(maps.length, (i) => UserModel.fromMap(maps[i]));
  }

  /// Update user
  Future<int> updateUser(UserModel user) async {
    final db = await database;
    return await db.update(
      AppConstants.tableUser,
      user.toMap(),
      where: '${AppConstants.colUserId} = ?',
      whereArgs: [user.idUser],
    );
  }

  /// Delete user
  Future<int> deleteUser(int id) async {
    final db = await database;
    return await db.delete(
      AppConstants.tableUser,
      where: '${AppConstants.colUserId} = ?',
      whereArgs: [id],
    );
  }

  // ==================== JENIS KENDARAAN OPERATIONS ====================

  /// Insert jenis kendaraan baru
  Future<int> insertJenisKendaraan(JenisKendaraanModel jenis) async {
    final db = await database;
    return await db.insert(
      AppConstants.tableJenisKendaraan,
      jenis.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  /// Get semua jenis kendaraan
  Future<List<JenisKendaraanModel>> getAllJenisKendaraan() async {
    final db = await database;
    final maps = await db.query(AppConstants.tableJenisKendaraan);
    return List.generate(
      maps.length,
      (i) => JenisKendaraanModel.fromMap(maps[i]),
    );
  }

  /// Get jenis kendaraan berdasarkan ID
  Future<JenisKendaraanModel?> getJenisKendaraanById(int id) async {
    final db = await database;
    final maps = await db.query(
      AppConstants.tableJenisKendaraan,
      where: '${AppConstants.colJenisId} = ?',
      whereArgs: [id],
    );
    if (maps.isNotEmpty) {
      return JenisKendaraanModel.fromMap(maps.first);
    }
    return null;
  }

  /// Update jenis kendaraan
  Future<int> updateJenisKendaraan(JenisKendaraanModel jenis) async {
    final db = await database;
    return await db.update(
      AppConstants.tableJenisKendaraan,
      jenis.toMap(),
      where: '${AppConstants.colJenisId} = ?',
      whereArgs: [jenis.idJenis],
    );
  }

  /// Delete jenis kendaraan
  Future<int> deleteJenisKendaraan(int id) async {
    final db = await database;
    return await db.delete(
      AppConstants.tableJenisKendaraan,
      where: '${AppConstants.colJenisId} = ?',
      whereArgs: [id],
    );
  }

  // ==================== AREA PARKIR OPERATIONS ====================

  /// Insert area parkir baru
  Future<int> insertAreaParkir(AreaParkirModel area) async {
    final db = await database;
    return await db.insert(
      AppConstants.tableAreaParkir,
      area.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  /// Get semua area parkir
  Future<List<AreaParkirModel>> getAllAreaParkir() async {
    final db = await database;
    final maps = await db.query(AppConstants.tableAreaParkir);
    return List.generate(maps.length, (i) => AreaParkirModel.fromMap(maps[i]));
  }

  /// Get area parkir berdasarkan ID
  Future<AreaParkirModel?> getAreaParkirById(int id) async {
    final db = await database;
    final maps = await db.query(
      AppConstants.tableAreaParkir,
      where: '${AppConstants.colAreaId} = ?',
      whereArgs: [id],
    );
    if (maps.isNotEmpty) {
      return AreaParkirModel.fromMap(maps.first);
    }
    return null;
  }

  /// Update area parkir
  Future<int> updateAreaParkir(AreaParkirModel area) async {
    final db = await database;
    return await db.update(
      AppConstants.tableAreaParkir,
      area.toMap(),
      where: '${AppConstants.colAreaId} = ?',
      whereArgs: [area.idArea],
    );
  }

  /// Delete area parkir
  Future<int> deleteAreaParkir(int id) async {
    final db = await database;
    return await db.delete(
      AppConstants.tableAreaParkir,
      where: '${AppConstants.colAreaId} = ?',
      whereArgs: [id],
    );
  }

  // ==================== KENDARAAN OPERATIONS ====================

  /// Insert kendaraan baru
  Future<int> insertKendaraan(KendaraanModel kendaraan) async {
    final db = await database;
    return await db.insert(
      AppConstants.tableKendaraan,
      kendaraan.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  /// Get kendaraan berdasarkan plat nomor
  Future<KendaraanModel?> getKendaraanByPlat(String plat) async {
    final db = await database;
    final maps = await db.query(
      AppConstants.tableKendaraan,
      where: '${AppConstants.colPlatNomor} = ?',
      whereArgs: [plat],
    );
    if (maps.isNotEmpty) {
      return KendaraanModel.fromMap(maps.first);
    }
    return null;
  }

  /// Get semua kendaraan
  Future<List<KendaraanModel>> getAllKendaraan() async {
    final db = await database;
    final maps = await db.query(AppConstants.tableKendaraan);
    return List.generate(maps.length, (i) => KendaraanModel.fromMap(maps[i]));
  }

  /// Get kendaraan berdasarkan ID
  Future<KendaraanModel?> getKendaraanById(int id) async {
    final db = await database;
    final maps = await db.query(
      AppConstants.tableKendaraan,
      where: '${AppConstants.colKendaraanId} = ?',
      whereArgs: [id],
    );
    if (maps.isNotEmpty) {
      return KendaraanModel.fromMap(maps.first);
    }
    return null;
  }

  /// Update kendaraan
  Future<int> updateKendaraan(KendaraanModel kendaraan) async {
    final db = await database;
    return await db.update(
      AppConstants.tableKendaraan,
      kendaraan.toMap(),
      where: '${AppConstants.colKendaraanId} = ?',
      whereArgs: [kendaraan.idKendaraan],
    );
  }

  /// Delete kendaraan
  Future<int> deleteKendaraan(int id) async {
    final db = await database;
    return await db.delete(
      AppConstants.tableKendaraan,
      where: '${AppConstants.colKendaraanId} = ?',
      whereArgs: [id],
    );
  }

  // ==================== TRANSAKSI OPERATIONS ====================

  /// Insert transaksi baru
  Future<int> insertTransaksi(TransaksiModel transaksi) async {
    final db = await database;
    return await db.insert(
      AppConstants.tableTransaksi,
      transaksi.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  /// Get semua transaksi
  Future<List<TransaksiModel>> getAllTransaksi() async {
    final db = await database;
    final maps = await db.query(AppConstants.tableTransaksi);
    return List.generate(maps.length, (i) => TransaksiModel.fromMap(maps[i]));
  }

  /// Get transaksi berdasarkan ID
  Future<TransaksiModel?> getTransaksiById(int id) async {
    final db = await database;
    final maps = await db.query(
      AppConstants.tableTransaksi,
      where: '${AppConstants.colTransaksiId} = ?',
      whereArgs: [id],
    );
    if (maps.isNotEmpty) {
      return TransaksiModel.fromMap(maps.first);
    }
    return null;
  }

  /// Get transaksi aktif (status = 'Parkir')
  Future<List<TransaksiModel>> getTransaksiAktif() async {
    final db = await database;
    final maps = await db.query(
      AppConstants.tableTransaksi,
      where: '${AppConstants.colTransaksiStatus} = ?',
      whereArgs: [AppConstants.statusParkir],
    );
    return List.generate(maps.length, (i) => TransaksiModel.fromMap(maps[i]));
  }

  /// Get transaksi berdasarkan ID kendaraan dan status aktif
  Future<TransaksiModel?> getTransaksiAktifByKendaraan(int idKendaraan) async {
    final db = await database;
    final maps = await db.query(
      AppConstants.tableTransaksi,
      where:
          '${AppConstants.colKendaraanId} = ? AND ${AppConstants.colTransaksiStatus} = ?',
      whereArgs: [idKendaraan, AppConstants.statusParkir],
    );
    if (maps.isNotEmpty) {
      return TransaksiModel.fromMap(maps.first);
    }
    return null;
  }

  /// Get transaksi selesai hari ini
  Future<List<TransaksiModel>> getTransaksiHariIni() async {
    final db = await database;
    final now = DateTime.now();
    final startOfDay = DateTime(now.year, now.month, now.day);
    final endOfDay = DateTime(now.year, now.month, now.day, 23, 59, 59);

    final maps = await db.query(
      AppConstants.tableTransaksi,
      where:
          '${AppConstants.colTransaksiStatus} = ? AND ${AppConstants.colWaktuMasuk} >= ? AND ${AppConstants.colWaktuMasuk} <= ?',
      whereArgs: [
        AppConstants.statusSelesai,
        startOfDay.toIso8601String(),
        endOfDay.toIso8601String(),
      ],
    );
    return List.generate(maps.length, (i) => TransaksiModel.fromMap(maps[i]));
  }

  /// Update transaksi
  Future<int> updateTransaksi(TransaksiModel transaksi) async {
    final db = await database;
    return await db.update(
      AppConstants.tableTransaksi,
      transaksi.toMap(),
      where: '${AppConstants.colTransaksiId} = ?',
      whereArgs: [transaksi.idTransaksi],
    );
  }

  /// Delete transaksi
  Future<int> deleteTransaksi(int id) async {
    final db = await database;
    return await db.delete(
      AppConstants.tableTransaksi,
      where: '${AppConstants.colTransaksiId} = ?',
      whereArgs: [id],
    );
  }

  // ==================== LOG AKTIVITAS OPERATIONS ====================

  /// Insert log aktivitas (append-only)
  Future<int> insertLogAktivitas(LogAktivitasModel log) async {
    final db = await database;
    return await db.insert(
      AppConstants.tableLogAktivitas,
      log.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  /// Get semua log
  Future<List<LogAktivitasModel>> getAllLogs() async {
    final db = await database;
    final maps = await db.query(
      AppConstants.tableLogAktivitas,
      orderBy: '${AppConstants.colWaktu} DESC',
    );
    return List.generate(
      maps.length,
      (i) => LogAktivitasModel.fromMap(maps[i]),
    );
  }

  /// Get log berdasarkan kategori
  Future<List<LogAktivitasModel>> getLogsByKategori(String kategori) async {
    final db = await database;
    final maps = await db.query(
      AppConstants.tableLogAktivitas,
      where: '${AppConstants.colKategoriLog} = ?',
      whereArgs: [kategori],
      orderBy: '${AppConstants.colWaktu} DESC',
    );
    return List.generate(
      maps.length,
      (i) => LogAktivitasModel.fromMap(maps[i]),
    );
  }

  /// Get log transaksi
  Future<List<LogAktivitasModel>> getTransaksiLogs() async {
    return await getLogsByKategori(AppConstants.logTransaksi);
  }

  /// Get log otorisasi
  Future<List<LogAktivitasModel>> getOtorisasiLogs() async {
    return await getLogsByKategori(AppConstants.logOtorisasi);
  }

  /// Get log berdasarkan user ID
  Future<List<LogAktivitasModel>> getLogsByUser(int idUser) async {
    final db = await database;
    final maps = await db.query(
      AppConstants.tableLogAktivitas,
      where: '${AppConstants.colUserId} = ?',
      whereArgs: [idUser],
      orderBy: '${AppConstants.colWaktu} DESC',
    );
    return List.generate(
      maps.length,
      (i) => LogAktivitasModel.fromMap(maps[i]),
    );
  }

  /// Update password user
  Future<int> updateUserPassword(int userId, String newPassword) async {
    final db = await database;
    return await db.update(
      AppConstants.tableUser,
      {AppConstants.colPassword: newPassword, 'is_default_password': 0},
      where: '${AppConstants.colUserId} = ?',
      whereArgs: [userId],
    );
  }

  /// Update default password flag
  Future<int> updateDefaultPasswordFlag(int userId, bool value) async {
    final db = await database;
    return await db.update(
      AppConstants.tableUser,
      {'is_default_password': value ? 1 : 0},
      where: '${AppConstants.colUserId} = ?',
      whereArgs: [userId],
    );
  }

  /// Record activity untuk audit trail
  Future<int> recordActivity(
    int userId,
    String kategori,
    String aktivitas, {
    Map<String, dynamic>? metadata,
  }) async {
    final db = await database;
    final now = DateTime.now();

    final logData = {
      AppConstants.colUserId: userId,
      AppConstants.colKategoriLog: kategori,
      AppConstants.colAktivitas: aktivitas,
      AppConstants.colWaktu: now.toIso8601String(),
    };

    return await db.insert(
      AppConstants.tableLogAktivitas,
      logData,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // ==================== UTILITY OPERATIONS ====================

  /// Close database
  Future<void> closeDatabase() async {
    final db = _database;
    if (db != null) {
      await db.close();
      _database = null;
    }
  }

  /// Delete entire database (untuk reset/testing)
  Future<void> deleteDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, AppConstants.databaseName);
    await openDatabase(
      path,
      version: AppConstants.databaseVersion,
    ).then((db) => db.close());
    await databaseFactory.deleteDatabase(path);
    _database = null;
  }
}
