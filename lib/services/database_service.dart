import 'package:sqflite/sqflite.dart' as sqflite;
import 'package:path/path.dart' as path;
import '../models/meditation_session.dart';

class DatabaseService {
  static sqflite.Database? _database;

  Future<sqflite.Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB();
    return _database!;
  }

  Future<sqflite.Database> _initDB() async {
    String dbPath = path.join(await sqflite.getDatabasesPath(), 'meditation_app.db');
    return await sqflite.openDatabase(
      dbPath,
      version: 1,
      onCreate: (db, version) async {
        // Create tables
        await db.execute('''
          CREATE TABLE meditation_sessions(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            title TEXT,
            duration INTEGER,
            completedAt TEXT,
            isFavorite INTEGER
          )
        ''');

        await db.execute('''
          CREATE TABLE user_stats(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            totalMinutes INTEGER,
            totalSessions INTEGER,
            currentStreak INTEGER,
            lastSessionDate TEXT
          )
        ''');
      },
    );
  }

  // Save completed meditation session
  Future<void> saveMeditationSession(MeditationSession session) async {
    final db = await database;
    await db.insert(
      'meditation_sessions',
      session.toMap(),
      conflictAlgorithm: sqflite.ConflictAlgorithm.replace,
    );
  }

  // Get all favorite sessions
  Future<List<MeditationSession>> getFavoriteSessions() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'meditation_sessions',
      where: 'isFavorite = ?',
      whereArgs: [1],
    );
    return List.generate(maps.length, (i) {
      return MeditationSession(
        id: maps[i]['id'],
        title: maps[i]['title'],
        duration: maps[i]['duration'],
        completedAt: DateTime.parse(maps[i]['completedAt']),
        isFavorite: maps[i]['isFavorite'] == 1,
      );
    });
  }

  // Update user stats
  Future<void> updateUserStats(int minutes) async {
    final db = await database;
    final List<Map<String, dynamic>> stats = await db.query('user_stats');
    
    if (stats.isEmpty) {
      await db.insert('user_stats', {
        'totalMinutes': minutes,
        'totalSessions': 1,
        'currentStreak': 1,
        'lastSessionDate': DateTime.now().toIso8601String(),
      });
    } else {
      final currentStats = stats.first;
      await db.update(
        'user_stats',
        {
          'totalMinutes': currentStats['totalMinutes'] + minutes,
          'totalSessions': currentStats['totalSessions'] + 1,
          'lastSessionDate': DateTime.now().toIso8601String(),
        },
        where: 'id = ?',
        whereArgs: [currentStats['id']],
      );
    }
  }
} 