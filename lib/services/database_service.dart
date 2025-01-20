import 'package:flutter/foundation.dart';
import 'package:sqflite/sqflite.dart' as sqflite;
import 'package:path/path.dart' as path;
import '../models/meditation_session.dart';
import '../models/user.dart';

class DatabaseService {
  static sqflite.Database? _database;

  Future<sqflite.Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB();
    return _database!;
  }

  Future<sqflite.Database> _initDB() async {
    String dbPath = path.join(await sqflite.getDatabasesPath(), 'meditation_app.db');
    
    // Delete existing database to force recreation
    await sqflite.deleteDatabase(dbPath);
    
    return await sqflite.openDatabase(
      dbPath,
      version: 4, // Increment this version if you added new tables
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );
  }

  Future<User> createUser(User user) async {
    final db = await database;

    // Check if user object is null or has required fields
    if (user == null || user.name.isEmpty || user.email.isEmpty) {
      throw Exception('User object or required fields are null');
    }

    // Insert the user and get the ID
    final id = await db.insert('users', user.toMap(), conflictAlgorithm: sqflite.ConflictAlgorithm.replace);
    
    // Return the user with the new ID
    return user.copyWith(id: id);
  }

  Future<User?> getUser(int id) async {
    try {
      final db = await database;
      final maps = await db.query(
        'users',
        where: 'id = ?',
        whereArgs: [id],
      );

      debugPrint('Found user records: ${maps.length}');
      if (maps.isEmpty) {
        debugPrint('No user found with ID: $id');
        return null;
      }
      
      final user = User.fromMap(maps.first);
      debugPrint('Retrieved user: ${user.toMap()}');
      return user;
    } catch (e) {
      debugPrint('Error getting user: $e');
      return null;
    }
  }

  // Get all favorite sessions
  Future<List<MeditationSession>> getFavoriteSessions() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'meditation_sessions',
      where: 'is_favorite = ?',
      whereArgs: [1],
    );
    return List.generate(maps.length, (i) {
      return MeditationSession(
        id: maps[i]['id'],
        title: maps[i]['title'],
        duration: maps[i]['duration'],
        completedAt: DateTime.parse(maps[i]['completed_at']),
        isFavorite: maps[i]['is_favorite'] == 1,
      );
    });
  }

  Future<Map<String, dynamic>> getUserStats(int userId) async {
    final db = await database;
    try {
      // First try to get existing stats
      final stats = await db.query(
        'user_stats',
        where: 'user_id = ?',
        whereArgs: [userId],
      );

      if (stats.isEmpty) {
        debugPrint('Creating new stats for user: $userId');
        // Try to insert new stats
        try {
          await db.insert('user_stats', {
            'user_id': userId,
            'total_minutes': 0,
            'total_sessions': 0,
          });
        } catch (e) {
          debugPrint('Error inserting stats: $e');
          // If insert fails, try to get stats again
          final retryStats = await db.query(
            'user_stats',
            where: 'user_id = ?',
            whereArgs: [userId],
          );
          if (retryStats.isNotEmpty) {
            return retryStats.first;
          }
        }
        
        return {
          'total_minutes': 0,
          'total_sessions': 0,
        };
      }

      debugPrint('Found existing stats for user: $userId');
      return stats.first;
    } catch (e) {
      debugPrint('Error in getUserStats: $e');
      // Return default stats if everything fails
      return {
        'total_minutes': 0,
        'total_sessions': 0,
      };
    }
  }

  Future<void> updateUserStats(int userId, {int addMinutes = 0, bool incrementSession = false, int malasCount = 0}) async {
    final db = await database;

    // Check if user stats exist
    final List<Map<String, dynamic>> existingStats = await db.query(
      'user_stats',
      where: 'user_id = ?',
      whereArgs: [userId],
    );

    if (existingStats.isNotEmpty) {
      // Update existing stats
      await db.update(
        'user_stats',
        {
          'total_minutes': existingStats.first['total_minutes'] + addMinutes,
          'total_sessions': existingStats.first['total_sessions'] + (incrementSession ? 1 : 0),
          'total_malas': existingStats.first['total_malas'] + malasCount,
          'total_duration': existingStats.first['total_duration'] + addMinutes,
        },
        where: 'user_id = ?',
        whereArgs: [userId],
      );
    } else {
      // Insert new stats
      await db.insert('user_stats', {
        'user_id': userId,
        'total_minutes': addMinutes,
        'total_sessions': incrementSession ? 1 : 0,
        'total_malas': malasCount,
        'total_duration': addMinutes,
      });
    }
  }

  Future<User?> getUserByEmail(String email) async {
    final db = await database;
    final maps = await db.query(
      'users',
      where: 'email = ?',
      whereArgs: [email],
    );

    if (maps.isEmpty) return null;
    return User.fromMap(maps.first);
  }

  Future<void> updateUser(User user) async {
    if (user.id == null) {
      throw Exception('Cannot update user without id');
    }

    final db = await database;
    await db.update(
      'users',
      user.toMap(),
      where: 'id = ?',
      whereArgs: [user.id],
      conflictAlgorithm: sqflite.ConflictAlgorithm.replace,
    );
  }

  Future<User?> getUserByEmailAndPassword(String email, String password) async {
    final db = await database;
    final maps = await db.query(
      'users',
      where: 'email = ?',
      whereArgs: [email],
    );

    debugPrint('Found ${maps.length} users with email: $email');
    if (maps.isEmpty) return null;
    
    final user = User.fromMap(maps.first);
    debugPrint('Logging in user: ${user.name} with ID: ${user.id}');
    return user;
  }

  Future<void> _onUpgrade(sqflite.Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      // Add the total_minutes and total_sessions columns if they don't exist
      await db.execute('ALTER TABLE user_stats ADD COLUMN total_minutes INTEGER DEFAULT 0');
      await db.execute('ALTER TABLE user_stats ADD COLUMN total_sessions INTEGER DEFAULT 0');
    }
  }

  Future<void> _onCreate(sqflite.Database db, int version) async {
    await db.execute('''
      CREATE TABLE IF NOT EXISTS users(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        email TEXT UNIQUE NOT NULL,
        profile_image TEXT,
        created_at TEXT NOT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE IF NOT EXISTS user_stats(
        user_id INTEGER PRIMARY KEY,
        total_minutes INTEGER DEFAULT 0,
        total_sessions INTEGER DEFAULT 0,
        total_malas INTEGER DEFAULT 0,
        total_duration INTEGER DEFAULT 0,
        FOREIGN KEY (user_id) REFERENCES users (id)
      )
    ''');
    
    debugPrint('All tables created successfully');
  }

  Future<int> getTotalMalas(int userId) async {
    final db = await database;
    final List<Map<String, dynamic>> sessions = await db.query(
      'user_stats',
      where: 'user_id = ?',
      whereArgs: [userId],
    );

    // Count the number of completed malas (assuming each session is a mala)
    return sessions.length; // Adjust this logic if needed
  }
} 