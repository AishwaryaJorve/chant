import 'package:flutter/foundation.dart';
import 'package:sqflite/sqflite.dart' as sqflite;
import 'package:path/path.dart' as path;
import '../models/meditation_session.dart';
import '../models/user.dart';
import 'dart:math';

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
      version: 5, // Increment version to force table creation
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
      debugPrint('Fetching stats for userId: $userId');

      // First ensure tables exist
      await _ensureTablesExist(db);

      // 1. Get meditation sessions data
      Map<String, dynamic> meditationData = {'total_meditation_minutes': 0, 'total_sessions': 0};
      try {
        final meditationQuery = await db.rawQuery('''
          SELECT 
            COALESCE(SUM(duration), 0) as total_meditation_minutes,
            COUNT(*) as total_sessions
          FROM meditation_sessions 
          WHERE user_id = ?
        ''', [userId]);
        meditationData = meditationQuery.first;
      } catch (e) {
        debugPrint('Error querying meditation_sessions: $e');
      }

      // 2. Get chant sessions data
      Map<String, dynamic> chantData = {'total_malas': 0, 'total_chant_sessions': 0};
      try {
        final chantQuery = await db.rawQuery('''
          SELECT 
            COALESCE(SUM(malas), 0) as total_malas,
            COUNT(*) as total_chant_sessions
          FROM chant_sessions 
          WHERE user_id = ?
        ''', [userId]);
        chantData = chantQuery.first;
      } catch (e) {
        debugPrint('Error querying chant_sessions: $e');
      }

      // Combine all data
      final result = {
        'total_minutes': meditationData['total_meditation_minutes'] ?? 0,
        'total_sessions': ((meditationData['total_sessions'] as int?) ?? 0) +
                        ((chantData['total_chant_sessions'] as int?) ?? 0),
        'total_malas': chantData['total_malas'] ?? 0,
        'current_streak': 0, // Default value if stats table doesn't exist
      };

      debugPrint('Computed final stats: $result');
      return result;
    } catch (e) {
      debugPrint('Error in getUserStats: $e');
      return {
        'total_minutes': 0,
        'total_sessions': 0,
        'total_malas': 0,
        'current_streak': 0,
      };
    }
}

// Add this new method to ensure tables exist
Future<void> _ensureTablesExist(sqflite.Database db) async {
  await db.execute('''
    CREATE TABLE IF NOT EXISTS meditation_sessions(
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      title TEXT NOT NULL,
      duration INTEGER NOT NULL,
      completed_at TEXT NOT NULL,
      is_favorite INTEGER DEFAULT 0,
      user_id INTEGER,
      FOREIGN KEY (user_id) REFERENCES users (id)
    )
  ''');

  await db.execute('''
    CREATE TABLE IF NOT EXISTS chant_sessions(
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      user_id INTEGER,
      malas INTEGER NOT NULL,
      completed_at TEXT NOT NULL,
      FOREIGN KEY (user_id) REFERENCES users (id)
    )
  ''');

  await db.execute('''
    CREATE TABLE IF NOT EXISTS user_stats(
      user_id INTEGER PRIMARY KEY,
      total_minutes INTEGER DEFAULT 0,
      total_sessions INTEGER DEFAULT 0,
      total_malas INTEGER DEFAULT 0,
      total_duration INTEGER DEFAULT 0,
      last_session_date TEXT,
      current_streak INTEGER DEFAULT 0,
      FOREIGN KEY (user_id) REFERENCES users (id)
    )
  ''');
}

  Future<void> updateUserStats({
    required int userId, 
    int addMinutes = 0, 
    bool incrementSession = false, required int meditationMinutes,
  }) async {
    final db = await database;
    final now = DateTime.now();

    try {
      // Check existing stats
      final existingStats = await db.query(
        'user_stats', 
        where: 'user_id = ?', 
        whereArgs: [userId]
      );

      if (existingStats.isEmpty) {
        // Insert new stats record
        await db.insert('user_stats', {
          'user_id': userId,
          'total_minutes': addMinutes,
          'total_sessions': incrementSession ? 1 : 0,
          'last_session_date': now.toIso8601String(),
          'current_streak': incrementSession ? 1 : 0
        });
      } else {
        // Update existing stats
        final currentStats = existingStats.first;
        final lastSessionDate = DateTime.parse(currentStats['last_session_date']?.toString() ?? now.toIso8601String());
        
        int newStreak = (currentStats['current_streak'] ?? 0) as int;
        
        // Check if session is on consecutive days
        if (incrementSession && 
            now.difference(lastSessionDate).inDays == 1) {
          newStreak++;
        } else if (!incrementSession) {
          newStreak = 0;
        }

        await db.update(
          'user_stats', 
          {
            'total_minutes': (currentStats['total_minutes'] as int? ?? 0) + addMinutes,
            'total_sessions': (currentStats['total_sessions'] as int? ?? 0) + (incrementSession ? 1 : 0),
            'last_session_date': now.toIso8601String(),
            'current_streak': newStreak
          },
          where: 'user_id = ?',
          whereArgs: [userId]
        );
      }
    } catch (e) {
      debugPrint('Error updating user stats: $e');
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
    if (oldVersion < 5) {
      // Create chant_sessions table if it doesn't exist
      await db.execute('''
        CREATE TABLE IF NOT EXISTS chant_sessions(
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          user_id INTEGER,
          malas INTEGER NOT NULL,
          completed_at TEXT NOT NULL,
          FOREIGN KEY (user_id) REFERENCES users (id)
        )
      ''');
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

    await db.execute('''
      CREATE TABLE IF NOT EXISTS meditation_sessions(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT NOT NULL,
        duration INTEGER NOT NULL,
        completed_at TEXT NOT NULL,
        is_favorite INTEGER DEFAULT 0,
        user_id INTEGER,
        FOREIGN KEY (user_id) REFERENCES users (id)
      )
    ''');

    // Add chant_sessions table
    await db.execute('''
      CREATE TABLE IF NOT EXISTS chant_sessions(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        user_id INTEGER,
        malas INTEGER NOT NULL,
        completed_at TEXT NOT NULL,
        FOREIGN KEY (user_id) REFERENCES users (id)
      )
    ''');
    
    debugPrint('All tables created successfully, including chant_sessions');
  }

  Future<void> _ensureChantSessionsTableExists() async {
    final db = await database;
    try {
      // Try to query the table to check if it exists
      await db.query('chant_sessions', limit: 1);
    } catch (e) {
      debugPrint('Chant sessions table does not exist. Creating now.');
      await db.execute('''
        CREATE TABLE IF NOT EXISTS chant_sessions(
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          user_id INTEGER,
          malas INTEGER NOT NULL,
          completed_at TEXT NOT NULL,
          FOREIGN KEY (user_id) REFERENCES users (id)
        )
      ''');
    }
  }

  Future<int> getTotalMalas(int userId) async {
    final db = await database;
    final result = await db.rawQuery('''
      SELECT SUM(malas) as total_malas 
      FROM chant_sessions 
      WHERE user_id = ?
    ''', [userId]);
    
    debugPrint('Mala count query result: $result');
    return result.first['total_malas'] as int? ?? 0;
}

Future<void> recordMalaSession(int userId, int malaCount) async {
    final db = await database;
    await db.insert('chant_sessions', {
      'user_id': userId,
      'malas': malaCount,
      'completed_at': DateTime.now().toIso8601String(),
    });
    debugPrint('Recorded mala session for user $userId: $malaCount malas');
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

  Future<void> createMeditationSession(MeditationSession session, int userId) async {
    final db = await database;
    
    try {
      await db.insert('meditation_sessions', {
        ...session.toMap(),
        'user_id': userId,
      }, 
      conflictAlgorithm: sqflite.ConflictAlgorithm.replace);
    } catch (e) {
      debugPrint('Error creating meditation session: $e');
    }
  }

  Future<List<MeditationSession>> getUserMeditationSessions(int userId) async {
    final db = await database;
    final sessions = await db.query(
      'meditation_sessions',
      where: 'user_id = ?',
      whereArgs: [userId],
      orderBy: 'completed_at DESC'
    );

    return sessions.map((session) => MeditationSession.fromMap(session)).toList();
  }

  Future<void> saveMalaSession(int userId, int malas) async {
    final db = await database;
    try {
      // Insert chant session
      await db.insert('chant_sessions', {
        'user_id': userId,
        'malas': malas,
        'completed_at': DateTime.now().toIso8601String(),
      });

      // Update user_stats
      final existingStats = await db.query(
        'user_stats', 
        where: 'user_id = ?', 
        whereArgs: [userId]
      );

      if (existingStats.isEmpty) {
        // Insert new stats record
        await db.insert('user_stats', {
          'user_id': userId,
          'total_malas': malas,
        });
      } else {
        // Update existing stats
        final currentStats = existingStats.first;
        final currentMalas = (currentStats['total_malas'] as int? ?? 0);
        
        await db.update(
          'user_stats', 
          {
            'total_malas': currentMalas + malas,
          },
          where: 'user_id = ?',
          whereArgs: [userId]
        );
      }

      debugPrint('Recorded mala session: $malas for user $userId');
    } catch (e) {
      debugPrint('Error recording mala session: $e');
    }
  }

  Future<void> updateMeditationTime(int userId, int minutes) async {
    final db = await database;
    
    // Get current stats
    final stats = await getUserStats(userId);
    final currentMinutes = stats?['total_minutes'] ?? 0;
    
    // Update total minutes
    await db.update(
      'user_stats',
      {'total_minutes': currentMinutes + minutes},
      where: 'user_id = ?',
      whereArgs: [userId],
    );
  }

  Future<int> getTotalMeditationTime(int userId) async {
    final db = await database;
    final result = await db.query(
      'user_stats',
      columns: ['total_minutes'],
      where: 'user_id = ?',
      whereArgs: [userId],
    );
    
    return result.isNotEmpty ? (result.first['total_minutes'] as int?) ?? 0 : 0;
  }
}