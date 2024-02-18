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
        onCreate: _onCreate, version: 17, onUpgrade: _onUpgrade);
    return mydb;
  }

  FutureOr<void> _onCreate(Database db, int version) async {
    await db.execute('''CREATE TABLE 'users' (
                "id" INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
                "name" TEXT NOT NULL,
                "national_number" TEXT NOT NULL UNIQUE,
                "date_of_birth" DATE,
                "title" TEXT, 
                "photo" TEXT
               )
                
    ''');
    await db.execute('''
     CREATE TABLE 'currencies' (
        "id" INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
        "name" TEXT NOT NULL,
        "symbol" TEXT,
        "rate" REAL
     )
''');
    await db.execute('''
     CREATE TABLE 'orders' (
        "id" INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
        "currencyId" INTEGER NOT NULL,
        "userId" INTEGER NOT NULL,
        "orderDate" DATE NOT NULL,
        "orderAmmount" INTEGER,
        "equalOrderAmmount" REAL,
        "status" INTEGER,
        "type" TEXT,
        FOREIGN KEY(currencyId) REFERENCES currencies(id),
        FOREIGN KEY(userId) REFERENCES users(id)
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

  getOne(String table, String where) async {
    Database? mydb = await db;
    List<Map> response = await mydb!.query(table, where: where);
    return response;
  }

  insert(String table, Map<String, dynamic> user) async {
    Database? mydb = await db;
    int response = await mydb!.insert(table, user);
    return response;
  }

  readJoin(String sql) async {
    Database? mydb = await db;
    List response = await mydb!.rawQuery(sql);
    return response;
  }

  update(String table, Map<String, dynamic> user, String where) async {
    Database? mydb = await db;
    int response = await mydb!.update(table, user, where: where);
    return response;
  }

  updateOrderState(String sql) async {
    Database? mydb = await db;
    int response = await mydb!.rawUpdate(sql);
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

  sort(String sql) async {
    Database? mydb = await db;
    List<Map> response = await mydb!.rawQuery(sql);
    return response;
  }

  FutureOr<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    await db.execute('''
     CREATE TABLE 'currencies' (
        "id" INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
        "name" TEXT NOT NULL,
        "symbol" TEXT,
        "rate" REAL
     )
''');
    await db.execute('''
     CREATE TABLE 'orders' (
        "id" INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
        "currencyId" INTEGER NOT NULL,
        "userId" INTEGER NOT NULL,
        "orderDate" DATE NOT NULL,
        "orderAmmount" INTEGER,
        "equalOrderAmmount" REAL,
        "status" INTEGER,
        "type" TEXT,
        FOREIGN KEY(currencyId) REFERENCES currencies(id),
        FOREIGN KEY(userId) REFERENCES users(id)
     )
''');

    print("created the new table order");
  }
}
