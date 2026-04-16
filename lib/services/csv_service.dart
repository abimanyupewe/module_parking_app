import 'dart:io';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:csv/csv.dart';

/// Service untuk generate dan download CSV reports
class CsvService {
  static const _androidPublicDownloadPath = '/storage/emulated/0/Download';

  /// Format currency ke Rupiah
  static String formatCurrency(int amount) {
    return NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp ',
      decimalDigits: 0,
    ).format(amount);
  }

  /// Format datetime menjadi string yang readable
  static String formatDateTime(dynamic dateTime) {
    if (dateTime == null) return '-';
    if (dateTime is String) {
      try {
        dateTime = DateTime.parse(dateTime);
      } catch (_) {
        return dateTime;
      }
    }
    if (dateTime is DateTime) {
      return DateFormat('dd/MM/yyyy HH:mm:ss', 'id_ID').format(dateTime);
    }
    return '-';
  }

  /// Generate Transaction CSV dan download
  static Future<void> generateTransactionCSV({
    required List<Map<String, dynamic>> transactions,
  }) async {
    try {
      // Prepare data untuk CSV
      final data = _buildTransactionTableData(transactions);

      // Convert to CSV
      final csv = const ListToCsvConverter().convert(data);

      // Get writable export directory
      final directory = await _getWritableExportDirectory();

      // Create filename dengan timestamp
      final timestamp = DateFormat(
        'yyyy-MM-dd-HHmmss',
        'id_ID',
      ).format(DateTime.now());
      final filename = 'laporan-transaksi-$timestamp.csv';
      final filePath = '${directory.path}/$filename';

      // Write file
      final file = File(filePath);
      await file.writeAsString(csv);

      // Optionally, share or open file
      // You can use share_plus package for this
      print('CSV saved to: $filePath');
    } catch (e) {
      throw Exception('Error generating transaction CSV: $e');
    }
  }

  /// Generate Activity Log CSV dan download
  static Future<void> generateActivityLogCSV({
    required List<Map<String, dynamic>> logs,
  }) async {
    try {
      // Prepare data untuk CSV
      final data = _buildActivityLogTableData(logs);

      // Convert to CSV
      final csv = const ListToCsvConverter().convert(data);

      // Get writable export directory
      final directory = await _getWritableExportDirectory();

      // Create filename dengan timestamp
      final timestamp = DateFormat(
        'yyyy-MM-dd-HHmmss',
        'id_ID',
      ).format(DateTime.now());
      final filename = 'laporan-aktivitas-$timestamp.csv';
      final filePath = '${directory.path}/$filename';

      // Write file
      final file = File(filePath);
      await file.writeAsString(csv);

      print('CSV saved to: $filePath');
    } catch (e) {
      throw Exception('Error generating activity log CSV: $e');
    }
  }

  /// Generate Parked Vehicles CSV dan download
  static Future<void> generateParkedVehiclesCSV({
    required List<Map<String, dynamic>> vehicles,
  }) async {
    try {
      // Prepare data untuk CSV
      final data = _buildParkedVehiclesTableData(vehicles);

      // Convert to CSV
      final csv = const ListToCsvConverter().convert(data);

      // Get writable export directory
      final directory = await _getWritableExportDirectory();

      // Create filename dengan timestamp
      final timestamp = DateFormat(
        'yyyy-MM-dd-HHmmss',
        'id_ID',
      ).format(DateTime.now());
      final filename = 'laporan-kendaraan-$timestamp.csv';
      final filePath = '${directory.path}/$filename';

      // Write file
      final file = File(filePath);
      await file.writeAsString(csv);

      print('CSV saved to: $filePath');
    } catch (e) {
      throw Exception('Error generating parked vehicles CSV: $e');
    }
  }

  /// Helper: Build transaction table data
  static List<List<String>> _buildTransactionTableData(
    List<Map<String, dynamic>> transactions,
  ) {
    final data = [
      [
        'No',
        'Plat Nomor',
        'Area',
        'Waktu Masuk',
        'Waktu Keluar',
        'Biaya',
        'Status',
      ],
    ];

    for (int i = 0; i < transactions.length; i++) {
      final t = transactions[i];
      data.add([
        (i + 1).toString(),
        t['plat_nomor'] ?? t['platNomor'] ?? '-',
        t['area'] ?? t['namaArea'] ?? '-',
        _formatShortDateTime(t['waktu_masuk'] ?? t['waktuMasuk']),
        _formatShortDateTime(t['waktu_keluar'] ?? t['waktuKeluar']),
        formatCurrency(t['total_biaya'] ?? t['totalBiaya'] ?? 0),
        t['status'] ?? '-',
      ]);
    }

    return data;
  }

  /// Helper: Build activity log table data
  static List<List<String>> _buildActivityLogTableData(
    List<Map<String, dynamic>> logs,
  ) {
    final data = [
      ['No', 'User', 'Role', 'Kategori', 'Aktivitas', 'Waktu'],
    ];

    for (int i = 0; i < logs.length; i++) {
      final log = logs[i];
      final username = log['username'] ?? log['user'] ?? 'Sistem';
      final role = log['role'] ?? '-';

      data.add([
        (i + 1).toString(),
        username.toString(),
        role.toString(),
        log['kategori']?.toString() ?? log['category']?.toString() ?? '-',
        log['aktivitas']?.toString() ?? log['activity']?.toString() ?? '-',
        _formatShortDateTime(log['waktu'] ?? log['timestamp']),
      ]);
    }

    return data;
  }

  /// Helper: Build parked vehicles table data
  static List<List<String>> _buildParkedVehiclesTableData(
    List<Map<String, dynamic>> vehicles,
  ) {
    final data = [
      [
        'No',
        'Plat Nomor',
        'Jenis',
        'Merk',
        'Warna',
        'Area',
        'Waktu Masuk',
        'Durasi',
      ],
    ];

    for (int i = 0; i < vehicles.length; i++) {
      final v = vehicles[i];
      final waktuMasuk = v['waktu_masuk'] ?? v['waktuMasuk'];
      String durasi = '-';

      if (waktuMasuk != null) {
        late DateTime parsedTime;
        if (waktuMasuk is String) {
          try {
            parsedTime = DateTime.parse(waktuMasuk);
          } catch (_) {
            parsedTime = DateTime.now();
          }
        } else if (waktuMasuk is DateTime) {
          parsedTime = waktuMasuk;
        }

        final duration = DateTime.now().difference(parsedTime);
        final jam = duration.inHours;
        final menit = duration.inMinutes % 60;
        durasi = '$jam jam $menit menit';
      }

      data.add([
        (i + 1).toString(),
        v['plat_nomor'] ?? v['platNomor'] ?? '-',
        v['jenis'] ?? v['namaJenis'] ?? '-',
        v['merk'] ?? '-',
        v['warna'] ?? '-',
        v['area'] ?? v['namaArea'] ?? '-',
        _formatShortDateTime(waktuMasuk),
        durasi,
      ]);
    }

    return data;
  }

  /// Helper: Format short datetime
  static String _formatShortDateTime(dynamic dateTime) {
    if (dateTime == null) return '-';
    if (dateTime is String) {
      try {
        dateTime = DateTime.parse(dateTime);
      } catch (_) {
        return dateTime;
      }
    }
    if (dateTime is DateTime) {
      return DateFormat('dd/MM/yyyy HH:mm', 'id_ID').format(dateTime);
    }
    return '-';
  }

  static Future<Directory> _getWritableExportDirectory() async {
    // Android: prefer app-specific Downloads folder
    if (Platform.isAndroid) {
      final downloadDirs = await getExternalStorageDirectories(
        type: StorageDirectory.downloads,
      );
      if (downloadDirs != null && downloadDirs.isNotEmpty) {
        final dir = downloadDirs.first;
        if (!await dir.exists()) {
          await dir.create(recursive: true);
        }
        return dir;
      }

      // Fallback public Downloads (may depend on device policy)
      final publicDownloadDir = Directory(_androidPublicDownloadPath);
      if (await publicDownloadDir.exists()) {
        return publicDownloadDir;
      }

      // Last fallback: app-specific external files dir
      final externalDir = await getExternalStorageDirectory();
      if (externalDir != null) {
        if (!await externalDir.exists()) {
          await externalDir.create(recursive: true);
        }
        return externalDir;
      }
    }

    // Desktop/iOS fallback
    final downloads = await getDownloadsDirectory();
    if (downloads != null) {
      if (!await downloads.exists()) {
        await downloads.create(recursive: true);
      }
      return downloads;
    }

    final docs = await getApplicationDocumentsDirectory();
    if (!await docs.exists()) {
      await docs.create(recursive: true);
    }
    return docs;
  }
}
