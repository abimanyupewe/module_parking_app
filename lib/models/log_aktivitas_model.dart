import '../config/constants.dart';

/// Model untuk Log Aktivitas
class LogAktivitasModel {
  final int? idLog;
  final int idUser;
  final String kategoriLog; // 'Transaksi', 'Otorisasi'
  final String aktivitas;
  final DateTime waktu;

  LogAktivitasModel({
    this.idLog,
    required this.idUser,
    required this.kategoriLog,
    required this.aktivitas,
    required this.waktu,
  });

  /// Apakah log adalah transaksi
  bool get isTransaksi => kategoriLog == AppConstants.logTransaksi;

  /// Apakah log adalah otorisasi
  bool get isOtorisasi => kategoriLog == AppConstants.logOtorisasi;

  /// Konversi dari Map (dari database)
  factory LogAktivitasModel.fromMap(Map<String, dynamic> json) {
    return LogAktivitasModel(
      idLog: json[AppConstants.colLogId],
      idUser: json[AppConstants.colUserId] ?? 0,
      kategoriLog: json[AppConstants.colKategoriLog] ?? '',
      aktivitas: json[AppConstants.colAktivitas] ?? '',
      waktu: DateTime.parse(json[AppConstants.colWaktu] ?? ''),
    );
  }

  /// Konversi ke Map (untuk database)
  Map<String, dynamic> toMap() {
    final map = <String, dynamic>{
      AppConstants.colUserId: idUser,
      AppConstants.colKategoriLog: kategoriLog,
      AppConstants.colAktivitas: aktivitas,
      AppConstants.colWaktu: waktu.toIso8601String(),
    };
    if (idLog != null) {
      map[AppConstants.colLogId] = idLog;
    }
    return map;
  }

  @override
  String toString() {
    return 'LogAktivitasModel(idLog: $idLog, kategoriLog: $kategoriLog, aktivitas: $aktivitas, waktu: $waktu)';
  }
}
