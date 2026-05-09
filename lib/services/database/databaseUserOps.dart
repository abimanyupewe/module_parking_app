// ignore_for_file: file_names

part of '../database_helper.dart';

extension DatabaseUserOps on DatabaseHelper {
  Future<int> insertUser(UserModel user) async {
    final db = await database;
    return await db.insert(AppConstants.tableUser, user.toMap());
  }

  Future<UserModel?> getUserByUsername(String username) async {
    final db = await database;
    final maps = await db.query(
      AppConstants.tableUser,
      where: '${AppConstants.colUsername} = ?',
      whereArgs: [username],
    );
    if (maps.isNotEmpty) return UserModel.fromMap(maps.first);
    return null;
  }

  Future<UserModel?> getUserById(int id) async {
    final db = await database;
    final maps = await db.query(
      AppConstants.tableUser,
      where: '${AppConstants.colUserId} = ?',
      whereArgs: [id],
    );
    if (maps.isNotEmpty) return UserModel.fromMap(maps.first);
    return null;
  }

  Future<List<UserModel>> getAllUsers() async {
    final db = await database;
    final maps = await db.query(AppConstants.tableUser);
    return List.generate(maps.length, (i) => UserModel.fromMap(maps[i]));
  }

  Future<int> updateUser(UserModel user) async {
    final db = await database;
    return await db.update(
      AppConstants.tableUser,
      user.toMap(),
      where: '${AppConstants.colUserId} = ?',
      whereArgs: [user.idUser],
    );
  }

  Future<int> deleteUser(int id) async {
    final db = await database;
    return await db.delete(
      AppConstants.tableUser,
      where: '${AppConstants.colUserId} = ?',
      whereArgs: [id],
    );
  }

  Future<bool> isDuplicateUsername(String username) async {
    final db = await database;
    final result = await db.query(
      AppConstants.tableUser,
      where: '${AppConstants.colUsername} = ?',
      whereArgs: [username],
    );
    return result.isNotEmpty;
  }
}
