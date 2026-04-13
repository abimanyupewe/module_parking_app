import '../config/constants.dart';

/// Model untuk Pengguna (User)
class UserModel {
  final int? idUser;
  final String namaLengkap;
  final String username;
  final String password;
  final String role; // 'owner', 'admin', 'petugas'
  final String status; // 'aktif', 'nonaktif'
  final String? securityQuestion;
  final String? securityAnswer;
  final bool isDefaultPassword;

  UserModel({
    this.idUser,
    required this.namaLengkap,
    required this.username,
    required this.password,
    required this.role,
    this.status = AppConstants.statusAktif,
    this.securityQuestion,
    this.securityAnswer,
    this.isDefaultPassword = true,
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
      securityQuestion: json['security_question'],
      securityAnswer: json['security_answer'],
      isDefaultPassword: (json['is_default_password'] ?? 1) == 1,
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
      'security_question': securityQuestion,
      'security_answer': securityAnswer,
      'is_default_password': isDefaultPassword ? 1 : 0,
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
    String? securityQuestion,
    String? securityAnswer,
    bool? isDefaultPassword,
  }) {
    return UserModel(
      idUser: idUser ?? this.idUser,
      namaLengkap: namaLengkap ?? this.namaLengkap,
      username: username ?? this.username,
      password: password ?? this.password,
      role: role ?? this.role,
      status: status ?? this.status,
      securityQuestion: securityQuestion ?? this.securityQuestion,
      securityAnswer: securityAnswer ?? this.securityAnswer,
      isDefaultPassword: isDefaultPassword ?? this.isDefaultPassword,
    );
  }

  @override
  String toString() {
    return 'UserModel(idUser: $idUser, namaLengkap: $namaLengkap, username: $username, role: $role, status: $status)';
  }
}
