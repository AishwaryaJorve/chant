// main.dart
import 'package:chants/screens/profile_screen.dart';
import 'package:chants/screens/welcome_screen.dart';
import 'package:flutter/material.dart';
import 'services/theme_service.dart';
import 'screens/start.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:chants/screens/search_screen.dart';
import 'package:chants/screens/chant_screen.dart';
import 'services/database_service.dart';
import 'package:sqflite/sqflite.dart' as sqflite;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Remove or comment out the integrity check
  // await DatabaseService().checkDatabaseIntegrity();
  
  // Load the theme mode before running the app
  final themeMode = await ThemeService.loadThemeMode();
  
  final prefs = await SharedPreferences.getInstance();
  final isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
  
  runApp(MyApp(
    initialRoute: isLoggedIn ? '/home' : '/welcome',
    initialThemeMode: themeMode,
  ));
}

class MyApp extends StatelessWidget {
  final String initialRoute;
  final ThemeMode initialThemeMode;
  
  const MyApp({
    super.key, 
    required this.initialRoute,
    required this.initialThemeMode,
  });

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Meditation App',
      themeMode: initialThemeMode, // Use the initial theme mode
      theme: ThemeService.lightTheme,
      darkTheme: ThemeService.darkTheme,
      initialRoute: initialRoute,
      routes: {
        '/welcome': (context) => const WelcomeScreen(),
        '/home': (context) => const StartPage(),
        '/search': (context) => const SearchScreen(),
        '/chants': (context) => const ChantScreen(),
        '/profile': (context) => const ProfileScreen(),
      },
    );
  }
}

class AuthenticationWrapper extends StatefulWidget {
  const AuthenticationWrapper({super.key});

  @override
  State<AuthenticationWrapper> createState() => _AuthenticationWrapperState();
}

class _AuthenticationWrapperState extends State<AuthenticationWrapper> {
  bool _isLoading = true;
  bool _isLoggedIn = false;

  @override
  void initState() {
    super.initState();
    _checkLoginStatus();
  }

  Future<void> _checkLoginStatus() async {
    final prefs = await SharedPreferences.getInstance();
    final isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
    final userId = prefs.getInt('userId');

    if (isLoggedIn && userId != null) {
      // Verify user exists in database
      final user = await DatabaseService().getUser(userId);
      if (user != null) {
        setState(() {
          _isLoggedIn = true;
          _isLoading = false;
        });
        return;
      }
      // Clear preferences if user not found in database
      await prefs.clear();
    }

    setState(() {
      _isLoggedIn = false;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    if (!_isLoggedIn) {
      return const WelcomeScreen();
    }

    return const StartPage();
  }
}

Future<sqflite.Database> _initDB() async {
  return await sqflite.openDatabase(
    'meditation_app.db',
    version: 2, // Increment this version
    onCreate: _onCreate,
    onUpgrade: _onUpgrade,
  );
}

Future<void> _onCreate(sqflite.Database db, int version) async {
  await db.execute('''
    CREATE TABLE IF NOT EXISTS user_stats(
      user_id INTEGER PRIMARY KEY,
      total_minutes INTEGER DEFAULT 0,
      total_sessions INTEGER DEFAULT 0
    )
  ''');

  await db.execute('''
    CREATE TABLE IF NOT EXISTS malas(
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      user_id INTEGER NOT NULL,
      count INTEGER NOT NULL DEFAULT 0,
      FOREIGN KEY (user_id) REFERENCES users (id)
    )
  ''');
}

Future<void> _onUpgrade(sqflite.Database db, int oldVersion, int newVersion) async {
  if (oldVersion < 2) {
    await db.execute('ALTER TABLE user_stats ADD COLUMN total_minutes INTEGER DEFAULT 0');
    await db.execute('ALTER TABLE user_stats ADD COLUMN total_sessions INTEGER DEFAULT 0');
  }
}

Future<void> updateMalas(int userId, {int increment = 1}) async {
  final db = await DatabaseService().database;
  final List<Map<String, dynamic>> existingMalas = await db.query(
    'malas',
    where: 'user_id = ?',
    whereArgs: [userId],
  );

  if (existingMalas.isNotEmpty) {
    // Update existing malas count
    await db.update(
      'malas',
      {
        'count': existingMalas.first['count'] + increment,
      },
      where: 'user_id = ?',
      whereArgs: [userId],
    );
  } else {
    // Insert new malas record
    await db.insert('malas', {
      'user_id': userId,
      'count': increment,
    });
  }
}

Future<int> getTotalMalas(int userId) async {
  final db = await DatabaseService().database;
  final List<Map<String, dynamic>> result = await db.query(
    'malas',
    where: 'user_id = ?',
    whereArgs: [userId],
  );

  if (result.isNotEmpty) {
    return result.first['count'] as int;
  }
  return 0; // Return 0 if no malas found
}
