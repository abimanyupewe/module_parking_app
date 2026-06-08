import '../config/constants.dart';

/// Model untuk Jenis Kendaraan
class JenisKendaraanModel {
  final int? idJenis;
  final String namaJenis;
  final int tarifPerJam;

  JenisKendaraanModel({
    this.idJenis,
    required this.namaJenis,
    required this.tarifPerJam,
  });

  /// Konversi dari Map (dari database)
  factory JenisKendaraanModel.fromMap(Map<String, dynamic> json) {
    return JenisKendaraanModel(
      idJenis: json[AppConstants.colJenisId],
      namaJenis: json[AppConstants.colNamaJenis] ?? '',
      tarifPerJam: json[AppConstants.colTarifPerJam] ?? 0,
    );
  }

  /// Konversi ke Map (untuk database)
  Map<String, dynamic> toMap() {
    final map = <String, dynamic>{
      AppConstants.colNamaJenis: namaJenis,
      AppConstants.colTarifPerJam: tarifPerJam,
    };
    if (idJenis != null) {
      map[AppConstants.colJenisId] = idJenis;
    }
    return map;
  }

  /// Copy with
  JenisKendaraanModel copyWith({
    int? idJenis,
    String? namaJenis,
    int? tarifPerJam,
  }) {
    return JenisKendaraanModel(
      idJenis: idJenis ?? this.idJenis,
      namaJenis: namaJenis ?? this.namaJenis,
      tarifPerJam: tarifPerJam ?? this.tarifPerJam,
    );
  }

  @override
  String toString() {
    return 'JenisKendaraanModel(idJenis: $idJenis, namaJenis: $namaJenis, tarifPerJam: $tarifPerJam)';
  }
}
