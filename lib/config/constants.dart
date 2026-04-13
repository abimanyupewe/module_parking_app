/// Konstanta aplikasi Manajemen Parkir
class AppConstants {
  // App Info
  static const String appName = 'Manajemen Parkir';
  static const String appVersion = '1.0.0';

  // Database
  static const String databaseName = 'parking_app.db';
  static const int databaseVersion = 1;

  // Table Names
  static const String tableUser = 'tb_user';
  static const String tableJenisKendaraan = 'tb_jenis_kendaraan';
  static const String tableAreaParkir = 'tb_area_parkir';
  static const String tableKendaraan = 'tb_kendaraan';
  static const String tableTransaksi = 'tb_transaksi';
  static const String tableLogAktivitas = 'tb_log_aktivitas';

  // Column Names - tb_user
  static const String colUserId = 'id_user';
  static const String colNamaLengkap = 'nama_lengkap';
  static const String colUsername = 'username';
  static const String colPassword = 'password';
  static const String colRole = 'role';
  static const String colStatus = 'status';

  // Column Names - tb_jenis_kendaraan
  static const String colJenisId = 'id_jenis';
  static const String colNamaJenis = 'nama_jenis';
  static const String colTarifPerJam = 'tarif_per_jam';

  // Column Names - tb_area_parkir
  static const String colAreaId = 'id_area';
  static const String colNamaArea = 'nama_area';
  static const String colKapasitas = 'kapasitas';
  static const String colTerisi = 'terisi';

  // Column Names - tb_kendaraan
  static const String colKendaraanId = 'id_kendaraan';
  static const String colPlatNomor = 'plat_nomor';
  static const String colMerk = 'merk';
  static const String colWarna = 'warna';

  // Column Names - tb_transaksi
  static const String colTransaksiId = 'id_transaksi';
  static const String colWaktuMasuk = 'waktu_masuk';
  static const String colWaktuKeluar = 'waktu_keluar';
  static const String colTransaksiStatus = 'status';
  static const String colTotalBiaya = 'total_biaya';

  // Column Names - tb_log_aktivitas
  static const String colLogId = 'id_log';
  static const String colKategoriLog = 'kategori_log';
  static const String colAktivitas = 'aktivitas';
  static const String colWaktu = 'waktu';

  // Role Types
  static const String roleOwner = 'Owner';
  static const String roleAdmin = 'Admin';
  static const String rolePetugas = 'Petugas';

  // Status Types
  static const String statusAktif = 'aktif';
  static const String statusNonaktif = 'nonaktif';
  static const String statusParkir = 'Parkir';
  static const String statusSelesai = 'Selesai';

  // Log Categories
  static const String logTransaksi = 'Transaksi';
  static const String logOtorisasi = 'Otorisasi';

  // SharedPreferences Keys
  static const String spIsFirstRun = 'is_first_run';
  static const String spIsLoggedIn = 'is_logged_in';
  static const String spUserId = 'user_id';
  static const String spUsername = 'username';
  static const String spUserRole = 'user_role';
  static const String spUserStatus = 'user_status';

  // Regex Patterns
  static const String patternUsername = r'^[a-zA-Z0-9_]{3,}$';
  static const String patternPassword = r'^.{6,}$';
  static const String patternPlatNomor = r'^[A-Z]{1,3}\s?\d{1,4}\s?[A-Z]{1,3}$';

  // Durations
  static const Duration splashDuration = Duration(seconds: 2);
}
