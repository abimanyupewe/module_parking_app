import '../config/constants.dart';

/// Model untuk Transaksi Parkir
class TransaksiModel {
  final int? idTransaksi;
  final int idKendaraan;
  final int idArea;
  final DateTime waktuMasuk;
  final DateTime? waktuKeluar;
  final String status; // 'Parkir', 'Selesai'
  final int? totalBiaya;
  final int idUser;
  final String? imagePath; // Path ke gambar kendaraan saat check-in

  TransaksiModel({
    this.idTransaksi,
    required this.idKendaraan,
    required this.idArea,
    required this.waktuMasuk,
    this.waktuKeluar,
    this.status = AppConstants.statusParkir,
    this.totalBiaya,
    required this.idUser,
    this.imagePath,
  });

  /// Durasi parkir dalam jam (dibulatkan ke atas)
  int? getDurationInHours() {
    if (waktuKeluar == null) return null;
    final durationSeconds = waktuKeluar!.difference(waktuMasuk).inSeconds;
    return (durationSeconds / 3600).ceil();
  }

  /// Apakah transaksi masih aktif (belum checkout)
  bool get isActive => status == AppConstants.statusParkir;

  /// Apakah transaksi sudah selesai
  bool get isCompleted => status == AppConstants.statusSelesai;

  /// Konversi dari Map (dari database)
  factory TransaksiModel.fromMap(Map<String, dynamic> json) {
    return TransaksiModel(
      idTransaksi: json[AppConstants.colTransaksiId],
      idKendaraan: json[AppConstants.colKendaraanId] ?? 0,
      idArea: json[AppConstants.colAreaId] ?? 0,
      waktuMasuk: DateTime.parse(json[AppConstants.colWaktuMasuk] ?? ''),
      waktuKeluar: json[AppConstants.colWaktuKeluar] != null
          ? DateTime.parse(json[AppConstants.colWaktuKeluar])
          : null,
      status:
          json[AppConstants.colTransaksiStatus] ?? AppConstants.statusParkir,
      totalBiaya: json[AppConstants.colTotalBiaya],
      idUser: json[AppConstants.colUserId] ?? 0,
      imagePath: json['image_path'],
    );
  }

  /// Konversi ke Map (untuk database)
  Map<String, dynamic> toMap() {
    final map = <String, dynamic>{
      AppConstants.colKendaraanId: idKendaraan,
      AppConstants.colAreaId: idArea,
      AppConstants.colWaktuMasuk: waktuMasuk.toIso8601String(),
      AppConstants.colWaktuKeluar: waktuKeluar?.toIso8601String(),
      AppConstants.colTransaksiStatus: status,
      AppConstants.colTotalBiaya: totalBiaya,
      AppConstants.colUserId: idUser,
      'image_path': imagePath,
    };
    if (idTransaksi != null) {
      map[AppConstants.colTransaksiId] = idTransaksi;
    }
    return map;
  }

  /// Copy with
  TransaksiModel copyWith({
    int? idTransaksi,
    int? idKendaraan,
    int? idArea,
    DateTime? waktuMasuk,
    DateTime? waktuKeluar,
    String? status,
    int? totalBiaya,
    int? idUser,
    String? imagePath,
  }) {
    return TransaksiModel(
      idTransaksi: idTransaksi ?? this.idTransaksi,
      idKendaraan: idKendaraan ?? this.idKendaraan,
      idArea: idArea ?? this.idArea,
      waktuMasuk: waktuMasuk ?? this.waktuMasuk,
      waktuKeluar: waktuKeluar ?? this.waktuKeluar,
      status: status ?? this.status,
      totalBiaya: totalBiaya ?? this.totalBiaya,
      idUser: idUser ?? this.idUser,
      imagePath: imagePath ?? this.imagePath,
    );
  }

  @override
  String toString() {
    return 'TransaksiModel(idTransaksi: $idTransaksi, platNomor: $idKendaraan, status: $status, totalBiaya: $totalBiaya)';
  }
}
