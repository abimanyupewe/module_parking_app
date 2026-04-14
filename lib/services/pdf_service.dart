import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:intl/intl.dart';

/// Service untuk generate dan print PDF reports
class PdfService {
  /// Format currency ke Rupiah
  static String formatCurrency(int amount) {
    return NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp ',
      decimalDigits: 0,
    ).format(amount);
  }

  /// Format datetime menjadi string yang readable
  static String formatDateTime(DateTime? dateTime) {
    if (dateTime == null) return '-';
    return DateFormat('dd/MM/yyyy HH:mm:ss', 'id_ID').format(dateTime);
  }

  /// Generate Struk Parkir (Receipt)
  static Future<void> generateParkingReceipt({
    required String platNomor,
    required String jenis,
    required String merk,
    required String warna,
    required String area,
    required DateTime waktuMasuk,
    required DateTime waktuKeluar,
    required int totalBiaya,
    required String petugas,
  }) async {
    final pdf = pw.Document();

    // Hitung durasi parkir
    final duration = waktuKeluar.difference(waktuMasuk);
    final jam = duration.inHours;
    final menit = duration.inMinutes % 60;

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) {
          return pw.Column(
            mainAxisAlignment: pw.MainAxisAlignment.start,
            crossAxisAlignment: pw.CrossAxisAlignment.center,
            children: [
              // Header
              pw.Text(
                'STRUK PARKIR',
                style: pw.TextStyle(
                  fontSize: 20,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
              pw.SizedBox(height: 10),
              pw.Divider(),
              pw.SizedBox(height: 10),

              // Informasi Kendaraan
              pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  _buildRow('Plat Nomor', platNomor),
                  _buildRow('Jenis', jenis),
                  _buildRow('Merk', merk),
                  _buildRow('Warna', warna),
                  _buildRow('Area Parkir', area),
                ],
              ),
              pw.SizedBox(height: 15),
              pw.Divider(),
              pw.SizedBox(height: 15),

              // Informasi Waktu
              pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  _buildRow('Waktu Masuk', formatDateTime(waktuMasuk)),
                  _buildRow('Waktu Keluar', formatDateTime(waktuKeluar)),
                  _buildRow('Durasi', '$jam jam $menit menit'),
                ],
              ),
              pw.SizedBox(height: 15),
              pw.Divider(),
              pw.SizedBox(height: 15),

              // Biaya
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Text(
                    'TOTAL BIAYA:',
                    style: pw.TextStyle(
                      fontSize: 14,
                      fontWeight: pw.FontWeight.bold,
                    ),
                  ),
                  pw.Text(
                    formatCurrency(totalBiaya),
                    style: pw.TextStyle(
                      fontSize: 14,
                      fontWeight: pw.FontWeight.bold,
                    ),
                  ),
                ],
              ),
              pw.SizedBox(height: 15),
              pw.Divider(),
              pw.SizedBox(height: 15),

              // Petugas
              pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  _buildRow('Petugas', petugas),
                  _buildRow('Tanggal Cetak', formatDateTime(DateTime.now())),
                ],
              ),
              pw.SizedBox(height: 20),
              pw.Text(
                'Terima kasih telah mempercayakan kendaraan Anda kepada kami',
                style: pw.TextStyle(fontSize: 10),
                textAlign: pw.TextAlign.center,
              ),
            ],
          );
        },
      ),
    );

    await Printing.layoutPdf(
      onLayout: (PdfPageFormat format) async => pdf.save(),
    );
  }

  /// Generate Laporan Transaksi
  static Future<void> generateTransactionReport({
    required List<Map<String, dynamic>> transactions,
    required String reportTitle,
  }) async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4.landscape,
        build: (pw.Context context) {
          return pw.Column(
            mainAxisAlignment: pw.MainAxisAlignment.start,
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              // Header
              pw.Text(
                reportTitle,
                style: pw.TextStyle(
                  fontSize: 18,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
              pw.SizedBox(height: 5),
              pw.Text(
                'Tanggal Cetak: ${formatDateTime(DateTime.now())}',
                style: pw.TextStyle(fontSize: 10),
              ),
              pw.SizedBox(height: 15),

              // Table
              pw.TableHelper.fromTextArray(
                context: context,
                data: _buildTransactionTableData(transactions),
                headerStyle: pw.TextStyle(
                  fontWeight: pw.FontWeight.bold,
                  fontSize: 10,
                ),
                cellStyle: pw.TextStyle(fontSize: 9),
                headerDecoration: pw.BoxDecoration(
                  border: pw.Border.all(),
                  color: PdfColors.grey300,
                ),
                cellAlignment: pw.Alignment.centerLeft,
                border: pw.TableBorder.all(),
                rowDecoration: pw.BoxDecoration(border: pw.Border.all()),
              ),
            ],
          );
        },
      ),
    );

    await Printing.layoutPdf(
      onLayout: (PdfPageFormat format) async => pdf.save(),
    );
  }

  /// Generate Laporan Log Aktivitas
  static Future<void> generateActivityLogReport({
    required List<Map<String, dynamic>> logs,
  }) async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4.landscape,
        build: (pw.Context context) {
          return pw.Column(
            mainAxisAlignment: pw.MainAxisAlignment.start,
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              // Header
              pw.Text(
                'LAPORAN LOG AKTIVITAS',
                style: pw.TextStyle(
                  fontSize: 18,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
              pw.SizedBox(height: 5),
              pw.Text(
                'Tanggal Cetak: ${formatDateTime(DateTime.now())}',
                style: pw.TextStyle(fontSize: 10),
              ),
              pw.SizedBox(height: 15),

              // Table
              pw.TableHelper.fromTextArray(
                context: context,
                data: _buildActivityLogTableData(logs),
                headerStyle: pw.TextStyle(
                  fontWeight: pw.FontWeight.bold,
                  fontSize: 10,
                ),
                cellStyle: pw.TextStyle(fontSize: 9),
                headerDecoration: pw.BoxDecoration(
                  border: pw.Border.all(),
                  color: PdfColors.grey300,
                ),
                cellAlignment: pw.Alignment.centerLeft,
                border: pw.TableBorder.all(),
                rowDecoration: pw.BoxDecoration(border: pw.Border.all()),
              ),
            ],
          );
        },
      ),
    );

    await Printing.layoutPdf(
      onLayout: (PdfPageFormat format) async => pdf.save(),
    );
  }

  /// Generate Laporan Kendaraan Parkir
  static Future<void> generateParkedVehiclesReport({
    required List<Map<String, dynamic>> vehicles,
  }) async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4.landscape,
        build: (pw.Context context) {
          return pw.Column(
            mainAxisAlignment: pw.MainAxisAlignment.start,
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              // Header
              pw.Text(
                'LAPORAN KENDARAAN SEDANG PARKIR',
                style: pw.TextStyle(
                  fontSize: 18,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
              pw.SizedBox(height: 5),
              pw.Text(
                'Tanggal Cetak: ${formatDateTime(DateTime.now())}',
                style: pw.TextStyle(fontSize: 10),
              ),
              pw.SizedBox(height: 15),

              // Table
              pw.TableHelper.fromTextArray(
                context: context,
                data: _buildParkedVehiclesTableData(vehicles),
                headerStyle: pw.TextStyle(
                  fontWeight: pw.FontWeight.bold,
                  fontSize: 10,
                ),
                cellStyle: pw.TextStyle(fontSize: 9),
                headerDecoration: pw.BoxDecoration(
                  border: pw.Border.all(),
                  color: PdfColors.grey300,
                ),
                cellAlignment: pw.Alignment.centerLeft,
                border: pw.TableBorder.all(),
                rowDecoration: pw.BoxDecoration(border: pw.Border.all()),
              ),
            ],
          );
        },
      ),
    );

    await Printing.layoutPdf(
      onLayout: (PdfPageFormat format) async => pdf.save(),
    );
  }

  /// Helper: Build row untuk receipt
  static pw.Row _buildRow(String label, String value) {
    return pw.Row(
      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
      children: [
        pw.Text(label, style: pw.TextStyle(fontSize: 11)),
        pw.Text(
          value,
          style: pw.TextStyle(fontSize: 11, fontWeight: pw.FontWeight.bold),
        ),
      ],
    );
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
        t['platNomor'] ?? '-',
        t['area'] ?? '-',
        _formatShortDateTime(t['waktuMasuk']),
        _formatShortDateTime(t['waktuKeluar']),
        formatCurrency(t['totalBiaya'] ?? 0),
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
      ['No', 'User', 'Kategori', 'Aktivitas', 'Waktu'],
    ];

    for (int i = 0; i < logs.length; i++) {
      final log = logs[i];
      data.add([
        (i + 1).toString(),
        log['user'] ?? '-',
        log['kategori'] ?? '-',
        log['aktivitas'] ?? '-',
        _formatShortDateTime(log['waktu']),
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
      final waktuMasuk = v['waktuMasuk'] as DateTime?;
      String durasi = '-';

      if (waktuMasuk != null) {
        final duration = DateTime.now().difference(waktuMasuk);
        final jam = duration.inHours;
        final menit = duration.inMinutes % 60;
        durasi = '$jam jam $menit menit';
      }

      data.add([
        (i + 1).toString(),
        v['platNomor'] ?? '-',
        v['jenis'] ?? '-',
        v['merk'] ?? '-',
        v['warna'] ?? '-',
        v['area'] ?? '-',
        _formatShortDateTime(waktuMasuk),
        durasi,
      ]);
    }

    return data;
  }

  /// Helper: Format short datetime (HH:mm)
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
}
