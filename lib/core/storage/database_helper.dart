import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('app_database.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDB,
    );
  }

  Future<void> _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE favorite_places (
        id TEXT PRIMARY KEY,
        userId TEXT NOT NULL,
        name TEXT NOT NULL,
        type TEXT NOT NULL,
        address TEXT NOT NULL,
        phone TEXT,
        rating REAL NOT NULL DEFAULT 0.0,
        notes TEXT,
        lastVisit TEXT
      )
    ''');

    await db.execute('''
      CREATE TABLE vehicles (
        id TEXT PRIMARY KEY,
        userId TEXT NOT NULL,
        brand TEXT NOT NULL,
        model TEXT NOT NULL,
        year INTEGER NOT NULL,
        vin TEXT,
        licensePlate TEXT,
        color TEXT,
        mileage INTEGER,
        purchaseDate TEXT,
        isActive INTEGER NOT NULL DEFAULT 1,
        vehicleType TEXT
      )
    ''');

    await db.execute('''
      CREATE TABLE tips (
        id TEXT PRIMARY KEY,
        title TEXT NOT NULL,
        content TEXT NOT NULL,
        category TEXT NOT NULL,
        publishDate TEXT NOT NULL,
        imageUrl TEXT,
        likes INTEGER NOT NULL DEFAULT 0,
        isLiked INTEGER NOT NULL DEFAULT 0
      )
    ''');

    await db.execute('''
      CREATE TABLE expenses (
        id TEXT PRIMARY KEY,
        userId TEXT NOT NULL,
        vehicleId TEXT NOT NULL,
        title TEXT NOT NULL,
        amount REAL NOT NULL,
        date TEXT NOT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE service_records (
        id TEXT PRIMARY KEY,
        userId TEXT NOT NULL,
        vehicleId TEXT NOT NULL,
        title TEXT NOT NULL,
        type TEXT NOT NULL,
        date TEXT NOT NULL,
        mileage INTEGER,
        worksDone TEXT NOT NULL,
        serviceCenter TEXT,
        notes TEXT,
        nextServiceDate TEXT
      )
    ''');
  }

  Future<void> close() async {
    final db = await instance.database;
    await db.close();
  }
}

