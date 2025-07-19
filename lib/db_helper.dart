import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'user_model.dart';

class DBHelper {
  //i used static coz we cna acces same throught no need to creare sperate dat base objects
  static Database? _db;

  // Get the database or create it if not exists
  //future here means the value is not available and will be  avaivleable later
  Future<Database> get database async {
    if (_db != null) return _db!;

    _db = await _initDB(); // create database
    return _db!;
  }

  // Initialize the database
  // we use async  for function coz  it will tkae time for the taks inside to get complete so it will return a value that will be available later
  Future<Database> _initDB() async {
    String path = join(await getDatabasesPath(), 'users.db');
    // we use await it means we need results before moving forward
    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDB,
    );
  }

  // Create the table
  Future _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE users(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        email TEXT NOT NULL,
        password TEXT NOT NULL
      )
    ''');
  }

  // Insert a new user
  Future<int> insertUser(User user) async {
    final db = await database;
    return await db.insert('users', user.toMap());
  }

  // Get user by email and password (for login)
  Future<User?> getUser(String email, String password) async {
    final db = await database;
    final res = await db.query(
      'users',
      where: 'email = ? AND password = ?',
      whereArgs: [email, password],
    );

    if (res.isNotEmpty) {
      return User.fromMap(res.first);
    }
    return null;
  }
}
