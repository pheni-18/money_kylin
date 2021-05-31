import 'dart:io';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';

class DatabaseHelper {
  static final _databaseName = "money_kylin.db";
  static final _databaseVersion = 1;

  static final table = 'trades';

  static final columnId = '_id';
  static final columnType = 'type';
  static final columnGroup = '_group';
  static final columnCategory = 'category';
  static final columnAmount = 'amount';
  static final columnDate = 'date';

  // make this a singleton class
  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  static Database _database;
  Future<Database> get database async {
    if (_database != null) return _database;
    _database = await _initDatabase();
    return _database;
  }

  _initDatabase() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, _databaseName);
    return await openDatabase(path,
        version: _databaseVersion, onCreate: _onCreate);
  }

  Future _onCreate(Database db, int version) async {
    await db.execute('''
          CREATE TABLE $table (
            $columnId INTEGER PRIMARY KEY,
            $columnType TEXT NOT NULL,
            $columnGroup TEXT NOT NULL,
            $columnCategory TEXT NOT NULL,
            $columnAmount INTEGER NOT NULL,
            $columnDate TEXT NOT NULL
          )
          ''');
  }

  // Helper methods
  Future<int> insert(Map<String, dynamic> row) async {
    Database db = await instance.database;
    return await db.insert(table, row);
  }

  Future<List<Map<String, dynamic>>> findAll() async {
    Database db = await instance.database;
    return await db.query(table);
  }

  Future<Map<String, dynamic>> find(int id) async {
    Database db = await instance.database;
    List<Map<String, dynamic>> rows =
        await db.query(table, where: '$columnId = ?', whereArgs: [id]);
    return rows[0];
  }

  Future<int> update(Map<String, dynamic> row) async {
    Database db = await instance.database;
    int id = row[columnId];
    return await db.update(table, row, where: '$columnId = ?', whereArgs: [id]);
  }

  Future<int> delete(int id) async {
    Database db = await instance.database;
    return await db.delete(table, where: '$columnId = ?', whereArgs: [id]);
  }
}
