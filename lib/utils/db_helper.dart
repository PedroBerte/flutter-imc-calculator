import 'dart:async';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static const String _databaseName = "imc_calculator_db.db";
  static const int _databaseVersion = 1;

  static const String tableUsers = 'users';

  static const String columnUserId = 'id';
  static const String columnName = 'name';
  static const String columnEmail = 'email';
  static const String columnPassword = 'password';
  static const String columnIsLoggedIn = 'is_logged_in';

  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  static Database? _database;
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, _databaseName);
    return await openDatabase(
      path,
      version: _databaseVersion,
      onCreate: _onCreate,
    );
  }

  FutureOr<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE $tableUsers (
        $columnUserId INTEGER PRIMARY KEY AUTOINCREMENT,
        $columnName TEXT NOT NULL UNIQUE,
        $columnEmail TEXT NOT NULL UNIQUE,
        $columnPassword TEXT NOT NULL,
        $columnIsLoggedIn INTEGER NOT NULL DEFAULT 0
      )
    ''');
  }

  Future<void> insertUser({
    required String email,
    required String name,
    required String password,
  }) async {
    final db = await database;
    await db.insert(tableUsers, {
      columnEmail: email,
      columnName: name,
      columnPassword: password,
      columnIsLoggedIn: 0,
    });
  }

  Future<Map<String, dynamic>?> getUserByEmail(String email) async {
    final db = await database;
    final results = await db.query(
      tableUsers,
      where: '$columnEmail = ?',
      whereArgs: [email],
      limit: 1,
    );
    return results.isNotEmpty ? results.first : null;
  }

  Future<void> logoutAllUsers() async {
    final db = await database;
    await db.update(tableUsers, {columnIsLoggedIn: 0});
  }

  Future<void> setUserLoggedIn(int userId) async {
    final db = await database;
    await db.update(
      tableUsers,
      {columnIsLoggedIn: 1},
      where: '$columnUserId = ?',
      whereArgs: [userId],
    );
  }

  Future<Map<String, dynamic>?> getLoggedInUser() async {
    final db = await database;
    final maps = await db.query(
      tableUsers,
      columns: [columnUserId, columnEmail, columnName],
      where: '$columnIsLoggedIn = ?',
      whereArgs: [1],
      limit: 1,
    );
    if (maps.isNotEmpty) {
      print('Usuário logado: ${maps.first}');
      return maps.first;
    }
    return null;
  }
}
