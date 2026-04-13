import '../config/constants.dart';

/// Model untuk Pengguna (User)
class UserModel {
  final int? idUser;
  final String namaLengkap;
  final String username;
  final String password;
  final String role; // 'owner', 'admin', 'petugas'
  final String status; // 'aktif', 'nonaktif'

  UserModel({
    this.idUser,
    required this.namaLengkap,
    required this.username,
    required this.password,
    required this.role,
    this.status = AppConstants.statusAktif,
  });

  /// Konversi dari Map (dari database)
  factory UserModel.fromMap(Map<String, dynamic> json) {
    return UserModel(
      idUser: json[AppConstants.colUserId],
      namaLengkap: json[AppConstants.colNamaLengkap] ?? '',
      username: json[AppConstants.colUsername] ?? '',
      password: json[AppConstants.colPassword] ?? '',
      role: json[AppConstants.colRole] ?? AppConstants.roleAdmin,
      status: json[AppConstants.colStatus] ?? AppConstants.statusAktif,
    );
  }

  /// Konversi ke Map (untuk database)
  Map<String, dynamic> toMap() {
    final map = <String, dynamic>{
      AppConstants.colNamaLengkap: namaLengkap,
      AppConstants.colUsername: username,
      AppConstants.colPassword: password,
      AppConstants.colRole: role,
      AppConstants.colStatus: status,
    };
    if (idUser != null) {
      map[AppConstants.colUserId] = idUser;
    }
    return map;
  }

  /// Copy with
  UserModel copyWith({
    int? idUser,
    String? namaLengkap,
    String? username,
    String? password,
    String? role,
    String? status,
  }) {
    return UserModel(
      idUser: idUser ?? this.idUser,
      namaLengkap: namaLengkap ?? this.namaLengkap,
      username: username ?? this.username,
      password: password ?? this.password,
      role: role ?? this.role,
      status: status ?? this.status,
    );
  }

  @override
  String toString() {
    return 'UserModel(idUser: $idUser, namaLengkap: $namaLengkap, username: $username, role: $role, status: $status)';
  }
}
