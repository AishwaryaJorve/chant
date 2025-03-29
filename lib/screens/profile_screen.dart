import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../main.dart';  // Import to access getTotalMalas function
import '../widgets/bottom_nav.dart';
import '../widgets/theme_background.dart';
import '../services/database_service.dart';
import '../models/user.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'account_settings_screen.dart';
import 'help_support_screen.dart';
import '../mixins/auth_required_mixin.dart';
import 'welcome_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> with AuthRequiredMixin {
  User? _user;
  Map<String, dynamic>? _stats;
  bool _isLoading = true;
  int? _malas;
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadUserData();
    _fetchTotalMalas();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    if (!mounted) return;
    
    try {
      final prefs = await SharedPreferences.getInstance();
      final userId = prefs.getInt('userId');
      final isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
      
      debugPrint('Loading user data - UserID: $userId, IsLoggedIn: $isLoggedIn');

      if (userId == null || !isLoggedIn) {
        debugPrint('No valid user session found');
        _redirectToWelcomeScreen();
        return;
      }

      final user = await DatabaseService().getUser(userId);
      
      if (user == null) {
        debugPrint('User not found in database');
        _redirectToWelcomeScreen();
        return;
      }

      final stats = await DatabaseService().getUserStats(userId);
      
      debugPrint('Loaded Stats: $stats');

      if (mounted) {
        setState(() {
          _user = user;
          _stats = stats;
          _isLoading = false;
        });
      }
    } catch (e) {
      debugPrint('Error in _loadUserData: $e');
      _redirectToWelcomeScreen();
    }
  }

  void _redirectToWelcomeScreen() {
    if (mounted) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const WelcomeScreen())
      );
    }
  }

  Future<void> _logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    if (mounted) {
      Navigator.pushReplacementNamed(context, '/welcome');
    }
  }

  Future<void> _fetchTotalMalas() async {
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getInt('userId');

    if (userId != null) {
      final totalMalas = await DatabaseService().getTotalMalas(userId);
      setState(() {
        _malas = totalMalas;
      });
      debugPrint('Fetched total malas: $_malas');
    }
  }

  Future<void> _signUp() async {
    // Assuming you have a method to get user details
    User newUser = await getUserDetails();

    // Debugging
    debugPrint('Signing up user: ${newUser.toMap()}');

    try {
      await DatabaseService().createUser(newUser);
      // Proceed with the sign-up process
    } catch (e) {
      debugPrint('Error during sign-up: $e');
      // Handle the error appropriately
    }
  }

  Future<User> getUserDetails() async {
    // Assuming you have some way to get user input, e.g., from text fields
    String name = _nameController.text; // Replace with your actual input method
    String email = _emailController.text; // Replace with your actual input method

    // Create and return a User object
    return User(
      name: name,
      email: email,
      profileImage: null, // or provide a default image if applicable
      createdAt: DateTime.now().toIso8601String(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ThemeColors.backgroundColor(context),
      body: ThemeBackground(
        child: SafeArea(
          child: _isLoading
              ? const Center(child: CircularProgressIndicator())
              : ListView(
                  padding: const EdgeInsets.all(16.0),
                  children: [
                    _buildProfileHeader(),
                    const SizedBox(height: 24),
                    _buildStatsSection(context),
                    const SizedBox(height: 24),
                    _buildSettingsSection(context),
                  ],
                ),
        ),
      ),
      bottomNavigationBar: BottomNav(
        currentIndex: 3,
        totalMalas: _malas ?? 0,
      ),
    );
  }

  Widget _buildProfileHeader() {
    debugPrint('Building profile header with user: ${_user?.name}');
    return Column(
      children: [
        Container(
          width: 100,
          height: 100,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
          ),
          child: Icon(
            Icons.person_outline,
            color: Theme.of(context).colorScheme.primary,
            size: 50,
          ),
        ),
        const SizedBox(height: 16),
        Text(
          _user?.name ?? 'Guest User',
          style: Theme.of(context).textTheme.headlineSmall,
        ),
        Text(
          _user?.email ?? 'guest@example.com',
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
              ),
        ),
        const SizedBox(height: 24),
        TextButton.icon(
          onPressed: _logout,
          icon: Icon(
            Icons.logout_rounded,
            color: Theme.of(context).colorScheme.primary.withOpacity(0.8),
          ),
          label: Text(
            'Logout',
            style: TextStyle(
              color: Theme.of(context).colorScheme.primary.withOpacity(0.8),
              fontSize: 16,
            ),
          ),
          style: TextButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildStatsSection(BuildContext context) {
    final stats = [
      {
        'title': 'Total Time',
        'value': _formatDuration(_stats?['total_minutes'] ?? 0),
        'icon': Icons.timer,
        'color': Colors.indigo,
      },
      {
        'title': 'Total Malas',
        'value': '${_malas ?? 0}',  // Changed this line to use _malas
        'icon': Icons.repeat,
        'color': Colors.teal,
      },
      {
        'title': 'Sessions Completed',
        'value': '${_stats?['total_sessions'] ?? 0}',
        'icon': Icons.check_circle_outline,
        'color': Colors.indigo,
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Your Stats',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(height: 16),
        SizedBox(
          height: 140,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: stats.length,
            separatorBuilder: (context, index) => const SizedBox(width: 12),
            itemBuilder: (context, index) {
              final stat = stats[index];
              return Container(
                width: 140,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: (stat['color'] as Color).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(
                      stat['icon'] as IconData,
                      color: stat['color'] as Color,
                      size: 32,
                    ),
                    const Spacer(),
                    Text(
                      stat['value'] as String,
                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                            color: stat['color'] as Color,
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    Text(
                      stat['title'] as String,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Theme.of(context)
                                .colorScheme
                                .onSurface
                                .withOpacity(0.7),
                          ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildSettingsSection(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          _buildSettingsTile(
            context,
            'Account Settings',
            Icons.person_outline,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => AccountSettingsScreen(user: _user),
                ),
              );
            },
          ),
          _buildDivider(context),
          _buildSettingsTile(
            context,
            'Help & Support',
            Icons.help_outline,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const HelpSupportScreen(),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsTile(BuildContext context, String title, IconData icon, {required VoidCallback onTap}) {
    final colorScheme = Theme.of(context).colorScheme;
    
    return ListTile(
      leading: Icon(icon, color: colorScheme.onSurface),
      title: Text(
        title,
        style: TextStyle(
          color: colorScheme.onSurface,
          fontSize: 16,
        ),
      ),
      trailing: Icon(
        Icons.chevron_right,
        color: colorScheme.onSurface.withOpacity(0.5),
      ),
      onTap: onTap,
    );
  }

  Widget _buildDivider(BuildContext context) {
    return Divider(
      color: Theme.of(context).colorScheme.onSurface.withOpacity(0.1),
      height: 1,
    );
  }

  String _formatDuration(int minutes) {
    final hours = minutes ~/ 60;
    final remainingMinutes = minutes % 60;
    
    if (hours > 0) {
      return '${hours}h ${remainingMinutes}m';
    }
    return '${minutes}m';
  }
}