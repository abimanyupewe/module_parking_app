import '../config/constants.dart';

/// Model untuk Kendaraan
class KendaraanModel {
  final int? idKendaraan;
  final String platNomor;
  final int idJenis;
  final String merk;
  final String warna;

  KendaraanModel({
    this.idKendaraan,
    required this.platNomor,
    required this.idJenis,
    required this.merk,
    required this.warna,
  });

  /// Konversi dari Map (dari database)
  factory KendaraanModel.fromMap(Map<String, dynamic> json) {
    return KendaraanModel(
      idKendaraan: json[AppConstants.colKendaraanId],
      platNomor: json[AppConstants.colPlatNomor] ?? '',
      idJenis: json[AppConstants.colJenisId] ?? 0,
      merk: json[AppConstants.colMerk] ?? '',
      warna: json[AppConstants.colWarna] ?? '',
    );
  }

  /// Konversi ke Map (untuk database)
  Map<String, dynamic> toMap() {
    final map = <String, dynamic>{
      AppConstants.colPlatNomor: platNomor,
      AppConstants.colJenisId: idJenis,
      AppConstants.colMerk: merk,
      AppConstants.colWarna: warna,
    };
    if (idKendaraan != null) {
      map[AppConstants.colKendaraanId] = idKendaraan;
    }
    return map;
  }

  /// Copy with
  KendaraanModel copyWith({
    int? idKendaraan,
    String? platNomor,
    int? idJenis,
    String? merk,
    String? warna,
  }) {
    return KendaraanModel(
      idKendaraan: idKendaraan ?? this.idKendaraan,
      platNomor: platNomor ?? this.platNomor,
      idJenis: idJenis ?? this.idJenis,
      merk: merk ?? this.merk,
      warna: warna ?? this.warna,
    );
  }

  @override
  String toString() {
    return 'KendaraanModel(idKendaraan: $idKendaraan, platNomor: $platNomor, merk: $merk, warna: $warna)';
  }
}
