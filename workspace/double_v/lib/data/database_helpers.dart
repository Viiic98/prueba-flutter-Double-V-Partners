import 'dart:io';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'package:double_v/models/user.dart';

// Singleton class to manage the database
class DatabaseHelper {
  // This is the actual database filename that is saved in the docs directory.
  static final _databaseName = "flutter.db";
  // Increment this version when you need to change the schema.
  static final _databaseVersion = 1;

  // Make this a singleton class.
  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  // Only allow a single open connection to the database.
  static Database _database;
  Future<Database> get database async {
    if (_database != null) return _database;
    _database = await _initDatabase();
    return _database;
  }

  // open the database
  _initDatabase() async {
    // The path_provider plugin gets the right directory for Android or iOS.
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, _databaseName);
    // Open the database. Can also add an onUpdate callback parameter.
    return await openDatabase(path,
        version: _databaseVersion, onCreate: _onCreate);
  }

  // SQL string to create the database
  Future _onCreate(Database db, int version) async {
    await db.execute('''
              CREATE TABLE $tableUsers (
                $columnId INTEGER PRIMARY KEY,
                $columnName TEXT NOT NULL,
                $columnLastName TEXT NOT NULL,
                $columnBirthDate TEXT NOT NULL,
                $columnEmail TEXT NOT NULL,
                $columnAddress TEXT NOT NULL,
                UNIQUE($columnEmail)
              )
              ''');
  }

  // Database helper methods:
  // Insert a new User in the database
  Future<int> insert(User user) async {
    Database db = await database;
    int id = 0;
    try {
      id = await db.insert(tableUsers, user.toMap());
    } on DatabaseException catch (e) {
      if (e.isUniqueConstraintError()) print("El email ya ha sido registrado");
      print(e);
    }
    return id;
  }

  // Get a specific user associated to an Email
  // from database
  Future<User> queryUser(String email) async {
    Database db = await database;
    List<Map> maps = await db.query(tableUsers,
        columns: [
          columnId,
          columnName,
          columnLastName,
          columnBirthDate,
          columnEmail,
          columnAddress
        ],
        where: '$columnEmail = ?',
        whereArgs: [email]);
    if (maps.length > 0) {
      return User.fromMap(maps.first);
    }
    return null;
  }

  // Update information of a user in the database
  // associated to an Email
  Future<int> update(User user) async {
    Database db = await database;
    return await db.update(tableUsers, user.toMap(),
        where: '$columnEmail = ?', whereArgs: [user.email]);
  }

  // Delete user from the database
  // with a specific id
  Future<int> delete(int id) async {
    Database db = await database;
    return await db.delete(tableUsers, where: '$columnId = ?', whereArgs: [id]);
  }

  // Get all the users is the database
  Future<List<User>> getAllUsers() async {
    final db = await database;
    var res = await db.query("users");
    List<User> list =
        res.isNotEmpty ? res.map((c) => User.fromMap(c)).toList() : [];
    return list;
  }

  // Delete database
  _deleteDatabase() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, _databaseName);
    await deleteDatabase(path);
  }

  // Delete database
  void deleteDb() async {
    _deleteDatabase();
  }
}
