import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'dart:io';

void main() async {
  sqfliteFfiInit();
  var databaseFactory = databaseFactoryFfi;
  var db = await databaseFactory.openDatabase('parking_app.db');
  List<Map> list = await db.rawQuery('SELECT * FROM tb_user');
  for (var u in list) {
    print("User: ${u['username']}, Role: ${u['role']}, Status: ${u['status']}, Password: ${u['password']}");
  }
}
