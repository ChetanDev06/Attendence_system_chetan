import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DBHelper {
  static Database? _db;

  static Future<void> initDb() async {
    final path = join(await getDatabasesPath(), 'attendance_app.db');
    _db = await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE users (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            name TEXT,
            roll TEXT,
            irisData TEXT
          )
        ''');
        await db.execute('''
          CREATE TABLE attendance (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            userId INTEGER,
            date TEXT,
            status TEXT
          )
        ''');
      },
    );
  }

  static Future<int> insertUser(Map<String, dynamic> user) async {
    return await _db!.insert('users', user);
  }

  static Future<List<Map<String, dynamic>>> getUsers() async {
    return await _db!.query('users');
  }

  static Future<int> insertAttendance(Map<String, dynamic> attendance) async {
    return await _db!.insert('attendance', attendance);
  }

  static Future<List<Map<String, dynamic>>> getAttendance() async {
    return await _db!.query('attendance');
  }
}
