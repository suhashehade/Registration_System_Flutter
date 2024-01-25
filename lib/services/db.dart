import 'dart:async';

import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DB {
  static Database? _db;

  Future<Database?> get db async {
    if (_db != null) {
      return _db;
    } else {
      _db = await initialDB();
      return _db;
    }
  }

  initialDB() async {
    String databasePath = await getDatabasesPath();
    String path = join(databasePath, 'registration_db');
    Database mydb = await openDatabase(path,
        onCreate: _onCreate, version: 1, onUpgrade: _onUpgrade);
    return mydb;
  }

  FutureOr<void> _onCreate(Database db, int version) async {
    await db.execute('''CREATE TABLE 'users' (
                "id" INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
                "name" TEXT NOT NULL,
                "national_number" TEXT NOT NULL UNIQUE,
                "date_of_birth" DATE,
                "title" TEXT
               )
                
    ''');

    print('OnCreate ========================================');
  }

  deleteMyDatabase() async {
    String databasePath = await getDatabasesPath();
    String path = join(databasePath, 'registration_db');
    await deleteDatabase(path);
    print('Database Deleted');
  }

  read(String table) async {
    Database? mydb = await db;
    List<Map> response = await mydb!.query(table);
    return response;
  }

  insert(String table, Map<String, String> user) async {
    Database? mydb = await db;
    int response = await mydb!.insert(table, user);
    return response;
  }

  update(String table, Map<String, String> user, String where) async {
    Database? mydb = await db;
    int response = await mydb!.update(table, user, where: where);
    return response;
  }

  delete(String table, String where) async {
    Database? mydb = await db;
    int response = await mydb!.delete(table, where: where);
    return response;
  }

  login(String sql) async {
    Database? mydb = await db;
    List<Map> response = await mydb!.rawQuery(sql);
    return response;
  }

  search(String sql) async {
    Database? mydb = await db;
    List<Map> response = await mydb!.rawQuery(sql);
    return response;
  }

  FutureOr<void> _onUpgrade(Database db, int oldVersion, int newVersion) {}
}
