class UserSelectionModel {
  final String displayName;
  final String username;
  final String password;

  UserSelectionModel({
    required this.displayName,
    required this.username,
    required this.password,
  });

  @override
  String toString() => displayName;
}
