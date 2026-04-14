import '../config/constants.dart';

/// Model untuk Area Parkir
class AreaParkirModel {
  final int? idArea;
  final String namaArea;
  final int idJenis;
  final int kapasitas;
  final int terisi;

  AreaParkirModel({
    this.idArea,
    required this.namaArea,
    required this.idJenis,
    required this.kapasitas,
    this.terisi = 0,
  });

  /// Sisa kapasitas
  int get sisaKapasitas => kapasitas - terisi;

  /// Persentase penggunaan (0-100)
  double get percentageUsed => (terisi / kapasitas) * 100;

  /// Status area (penuh atau tidak)
  bool get isFull => terisi >= kapasitas;

  /// Konversi dari Map (dari database)
  factory AreaParkirModel.fromMap(Map<String, dynamic> json) {
    return AreaParkirModel(
      idArea: json[AppConstants.colAreaId],
      namaArea: json[AppConstants.colNamaArea] ?? '',
      idJenis: json[AppConstants.colJenisId] ?? 0,
      kapasitas: json[AppConstants.colKapasitas] ?? 0,
      terisi: json[AppConstants.colTerisi] ?? 0,
    );
  }

  /// Konversi ke Map (untuk database)
  Map<String, dynamic> toMap() {
    final map = <String, dynamic>{
      AppConstants.colNamaArea: namaArea,
      AppConstants.colJenisId: idJenis,
      AppConstants.colKapasitas: kapasitas,
      AppConstants.colTerisi: terisi,
    };
    if (idArea != null) {
      map[AppConstants.colAreaId] = idArea;
    }
    return map;
  }

  /// Copy with
  AreaParkirModel copyWith({
    int? idArea,
    String? namaArea,
    int? idJenis,
    int? kapasitas,
    int? terisi,
  }) {
    return AreaParkirModel(
      idArea: idArea ?? this.idArea,
      namaArea: namaArea ?? this.namaArea,
      idJenis: idJenis ?? this.idJenis,
      kapasitas: kapasitas ?? this.kapasitas,
      terisi: terisi ?? this.terisi,
    );
  }

  @override
  String toString() {
    return 'AreaParkirModel(idArea: $idArea, namaArea: $namaArea, kapasitas: $kapasitas, terisi: $terisi)';
  }
}
