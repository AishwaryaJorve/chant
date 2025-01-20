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
  final prefs = await SharedPreferences.getInstance();
  final isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
  
  runApp(MyApp(initialRoute: isLoggedIn ? '/home' : '/welcome'));
}

class MyApp extends StatelessWidget {
  final String initialRoute;
  
  const MyApp({super.key, required this.initialRoute});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Meditation App',
      themeMode: ThemeMode.system,
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
}

Future<void> _onUpgrade(sqflite.Database db, int oldVersion, int newVersion) async {
  if (oldVersion < 2) {
    await db.execute('ALTER TABLE user_stats ADD COLUMN total_minutes INTEGER DEFAULT 0');
    await db.execute('ALTER TABLE user_stats ADD COLUMN total_sessions INTEGER DEFAULT 0');
  }
}
