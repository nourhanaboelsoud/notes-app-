import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'dart:developer';
import 'dart:async';

class SqlDB {
  static Database? _db; // Static variable to hold the database instance

  Future<Database?> get db async {
    if (_db == null) {
      _db = await initDatabase(); // Initialize the database if it's null
      return _db;
    }
    else {
      return _db; // Return the existing database instance
    }
  }
}

initDatabase() async {
  String dpPath = await getDatabasesPath(); // Get the default database path to Store or delete db
  String path = join(dpPath, 'notes.db'); // name of the database
  Database mydb = await openDatabase(
    path,
    onCreate: _onCreate, // Create the database if it doesn't exist
    version: 1,
    //onUpgrade: _onUpgrade, //add new column after version change
  );
  return mydb;
}

// _onUpgrade(Database db, int oldVersion, int newVersion) async {
//   oldVersion = 1;
//   newVersion = 2;
//   _onCreate(db, version) {
//     db.execute('CREATE TABLE notes (id INTEGER PRIMARY KEY, title NewColumn)');
//   }
//   await db.insert('notes',{'title':'NewColumn'}); // Insert new column
//   log('Upgraded from $oldVersion to $newVersion');
// }

_onCreate(Database db, int version) async {
  // Create the notes tables
  await db.execute('''
    CREATE TABLE notes (
      id INTEGER PRIMARY KEY AUTOINCREMENT, // Auto-incrementing primary key
      title TEXT NOT NULL, // Title of the note
      note TEXT // Content of the note
    )
  ''');
  log('OnCreate : Database created with version $version'); // to avoid errors 
}

//using helper functions

read(String table) async {
  Database? mydb = await SqlDB().db;
  List<Map> response = await mydb!.query(table);
  return response;
}

insert(String table, Map<String, Object?> values) async {
  Database? mydb = await SqlDB().db;
  int response = await mydb!.insert(table, values);
  return response;
}

update(String table, Map<String, Object?> values, where , whereArgs) async {
  Database? mydb = await SqlDB().db;
  int response = await mydb!.update(table, values, where: where , whereArgs: whereArgs);
  return response;
}

delete(String table, String where) async {
  Database? mydb = await SqlDB().db;
  int response = await mydb!.delete(table, where: where);
  return response;
}