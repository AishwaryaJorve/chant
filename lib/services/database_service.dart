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
    
    return await sqflite.openDatabase(
      dbPath,
      version: 4, // Keep track of database version
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
      onConfigure: (db) async {
        await db.execute('PRAGMA foreign_keys = ON');
      },
    );
  }

  Future<User> createUser(User user) async {
    final db = await database;

    try {
      if (user.name.isEmpty || user.email.isEmpty) {
        throw Exception('User object or required fields are null');
      }

      final existingUser = await getUserByEmail(user.email);
      if (existingUser != null) {
        throw Exception('User with this email already exists');
      }

      final id = await db.insert(
        'users', 
        user.toMap(), 
        conflictAlgorithm: sqflite.ConflictAlgorithm.fail,
      );
      
      await db.insert(
        'user_stats', 
        {
          'user_id': id,
          'total_minutes': 0,
          'total_sessions': 0,
          'total_malas': 0,
          'total_duration': 0,
        },
        conflictAlgorithm: sqflite.ConflictAlgorithm.replace,
      );
      
      return user.copyWith(id: id);
    } catch (e) {
      debugPrint('Error creating user: $e');
      rethrow;
    }
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
      final stats = await db.query(
        'user_stats',
        where: 'user_id = ?',
        whereArgs: [userId],
      );

      if (stats.isEmpty) {
        debugPrint('Creating new stats for user: $userId');
        try {
          await db.insert(
            'user_stats', 
            {
              'user_id': userId,
              'total_minutes': 0,
              'total_sessions': 0,
              'total_malas': 0,
              'total_duration': 0,
            },
            conflictAlgorithm: sqflite.ConflictAlgorithm.replace,
          );

          final newStats = await db.query(
            'user_stats',
            where: 'user_id = ?',
            whereArgs: [userId],
          );

          return newStats.first;
        } catch (e) {
          debugPrint('Error inserting stats: $e');
          return {
            'user_id': userId,
            'total_minutes': 0,
            'total_sessions': 0,
            'total_malas': 0,
            'total_duration': 0,
          };
        }
      }

      return stats.first;
    } catch (e) {
      debugPrint('Error fetching user stats: $e');
      return {
        'user_id': userId,
        'total_minutes': 0,
        'total_sessions': 0,
        'total_malas': 0,
        'total_duration': 0,
      };
    }
  }

  Future<void> updateUserStats(int userId, {int addMinutes = 0, bool incrementSession = false, int malasCount = 0}) async {
    final db = await database;

    final List<Map<String, dynamic>> existingStats = await db.query(
      'user_stats',
      where: 'user_id = ?',
      whereArgs: [userId],
    );

    if (existingStats.isNotEmpty) {
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
    try {
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
    } catch (e) {
      debugPrint('Error during login: $e');
      return null;
    }
  }

  Future<void> _onUpgrade(sqflite.Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
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

    return sessions.isNotEmpty ? (sessions.first['total_malas'] ?? 0) : 0;
  }

  Future<void> checkDatabaseIntegrity() async {
    final db = await database;
    try {
      final result = await db.rawQuery('PRAGMA integrity_check');
      
      if (result.isNotEmpty) {
        final integrityResult = result.first['integrity_check'] as String;
        if (integrityResult != 'ok') {
          debugPrint('Database integrity check failed: $integrityResult');
        } else {
          debugPrint('Database integrity check passed');
        }
      }
    } catch (e) {
      debugPrint('Unexpected error during database integrity check: $e');
    }
  }

  Future<void> deleteUser(int userId) async {
    final db = await database;
    
    try {
      // Delete user stats
      await db.delete(
        'user_stats',
        where: 'user_id = ?',
        whereArgs: [userId],
      );

      // Delete meditation sessions
      await db.delete(
        'meditation_sessions',
        where: 'user_id = ?',
        whereArgs: [userId],
      );

      // Delete user
      await db.delete(
        'users',
        where: 'id = ?',
        whereArgs: [userId],
      );
    } catch (e) {
      debugPrint('Error deleting user: $e');
      rethrow;
    }
  }
} 