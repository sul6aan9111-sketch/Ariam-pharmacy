import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseService {
  static Database? _db;

  Future<Database> get db async {
    if (_db != null) return _db!;
    _db = await initDb();
    return _db!;
  }

  Future<Database> initDb() async {
    String path = join(await getDatabasesPath(), 'pharmacy.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {

        // إنشاء جدول الأدوية
        await db.execute('''
          CREATE TABLE medicines (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            name TEXT,
            quantity INTEGER,
            expiry_date TEXT
          )
        ''');

        // إنشاء جدول المستخدمين (ضروري جداً لعمل تسجيل الدخول)
        await db.execute('''
          CREATE TABLE users (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            username TEXT NOT NULL,
            password TEXT NOT NULL
          )
        ''');



      },
    );
  }

  // --- دوال المستخدمين ---

  // دالة للتحقق من وجود المستخدم عند تسجيل الدخول
  Future<bool> checkUser(String username, String password) async {
    final dbClient = await db;
    final res = await dbClient.query(
      "users",
      where: "username = ? AND password = ?",
      whereArgs: [username, password],
    );
    return res.isNotEmpty; // ترجع true إذا كان الحساب موجوداً في الجدول
  }

  // --- دوال الأدوية ---

  Future<int> insertMedicine(Map<String, dynamic> data) async {
    final dbClient = await db;
    return await dbClient.insert('medicines', data);
  }

  Future<List<Map<String, dynamic>>> getMedicines() async {
    final dbClient = await db;
    return await dbClient.query('medicines');
  }
}