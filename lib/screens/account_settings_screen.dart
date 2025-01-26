import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../widgets/theme_background.dart';
import '../models/user.dart';
import '../services/database_service.dart';
import '../services/theme_service.dart';
import 'welcome_screen.dart';

class AccountSettingsScreen extends StatefulWidget {
  final User? user;
  
  const AccountSettingsScreen({super.key, this.user});

  @override
  State<AccountSettingsScreen> createState() => _AccountSettingsScreenState();
}

class _AccountSettingsScreenState extends State<AccountSettingsScreen> {
  late TextEditingController _nameController;
  late TextEditingController _emailController;
  bool _isEditing = false;
  bool _isSaving = false;
  ThemeMode _currentThemeMode = ThemeMode.system;
  bool _notificationsEnabled = true;
  bool _biometricLoginEnabled = false;
  TimeOfDay _reminderTime = TimeOfDay(hour: 19, minute: 0); // Default 7 PM

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.user?.name);
    _emailController = TextEditingController(text: widget.user?.email);
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    final themeMode = await ThemeService.loadThemeMode();
    
    setState(() {
      _currentThemeMode = themeMode;
      _notificationsEnabled = prefs.getBool('notifications_enabled') ?? true;
      _biometricLoginEnabled = prefs.getBool('biometric_login_enabled') ?? false;
      
      // Load saved reminder time or use default
      final savedHour = prefs.getInt('reminder_hour') ?? 19;
      final savedMinute = prefs.getInt('reminder_minute') ?? 0;
      _reminderTime = TimeOfDay(hour: savedHour, minute: savedMinute);
    });
  }

  Future<void> _saveChanges() async {
    if (widget.user == null) return;

    setState(() => _isSaving = true);
    try {
      final updatedUser = widget.user!.copyWith(
        name: _nameController.text,
        email: _emailController.text,
      );

      await DatabaseService().updateUser(updatedUser);
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Profile updated successfully')),
        );
        setState(() {
          _isEditing = false;
          _isSaving = false;
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error updating profile: $e')),
        );
        setState(() => _isSaving = false);
      }
    }
  }

  Future<void> _changeThemeMode(ThemeMode themeMode) async {
    await ThemeService.setThemeMode(themeMode);
    setState(() {
      _currentThemeMode = themeMode;
    });
  }

  Future<void> _saveReminderTime() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('reminder_hour', _reminderTime.hour);
    await prefs.setInt('reminder_minute', _reminderTime.minute);
    
    // TODO: Implement actual notification scheduling
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Reminder set for ${_reminderTime.format(context)}'),
      ),
    );
  }

  Future<void> _toggleNotifications(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('notifications_enabled', value);
    setState(() {
      _notificationsEnabled = value;
    });

    // TODO: Enable/Disable notification scheduling
    if (value) {
      // Schedule notifications
      _saveReminderTime();
    } else {
      // Cancel all scheduled notifications
      // You would implement this with a notification service
    }
  }

  Future<void> _selectReminderTime() async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _reminderTime,
    );

    if (picked != null && picked != _reminderTime) {
      setState(() {
        _reminderTime = picked;
      });
      await _saveReminderTime();
    }
  }

  Future<void> _toggleBiometricLogin(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('biometric_login_enabled', value);
    setState(() {
      _biometricLoginEnabled = value;
    });
  }

  Future<void> _logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('isLoggedIn');
    await prefs.remove('userId');

    if (mounted) {
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (_) => const WelcomeScreen()),
        (route) => false,
      );
    }
  }

  Future<void> _deleteAccount() async {
    // Show confirmation dialog
    final confirmDelete = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Account'),
        content: const Text('Are you sure you want to delete your account? This action cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirmDelete == true && widget.user != null) {
      try {
        // Delete user from database
        await DatabaseService().deleteUser(widget.user!.id!);
        
        // Clear preferences
        final prefs = await SharedPreferences.getInstance();
        await prefs.clear();

        if (mounted) {
          // Navigate to welcome screen
          Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (_) => const WelcomeScreen()),
            (route) => false,
          );
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error deleting account: $e')),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Account Settings'),
        actions: [
          if (_isEditing)
            IconButton(
              icon: _isSaving 
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.white,
                    ),
                  )
                : const Icon(Icons.save),
              onPressed: _isSaving ? null : _saveChanges,
            )
          else
            IconButton(
              icon: const Icon(Icons.edit),
              onPressed: () => setState(() => _isEditing = true),
            ),
        ],
      ),
      body: ThemeBackground(
        child: SafeArea(
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              _buildProfileSection(),
              const SizedBox(height: 24),
              _buildSection('Notifications', [
                _buildSwitchTile(
                  'Meditation Reminders',
                  'Receive daily meditation reminders',
                  _notificationsEnabled,
                  _toggleNotifications,
                ),
                if (_notificationsEnabled)
                  ListTile(
                    title: const Text('Reminder Time'),
                    subtitle: Text(_reminderTime.format(context)),
                    trailing: const Icon(Icons.access_time),
                    onTap: _selectReminderTime,
                  ),
              ]),
              const SizedBox(height: 16),
              _buildSection('Security', [
                _buildSwitchTile(
                  'Biometric Login',
                  'Use fingerprint or face ID to log in',
                  _biometricLoginEnabled,
                  _toggleBiometricLogin,
                ),
              ]),
              const SizedBox(height: 16),
              _buildSection('Account', [
                _buildActionTile(
                  'Logout',
                  'Sign out of your account',
                  Icons.logout,
                  onTap: _logout,
                ),
                _buildActionTile(
                  'Delete Account',
                  'Permanently remove your account',
                  Icons.delete_forever,
                  onTap: _deleteAccount,
                  color: Colors.red,
                ),
              ]),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProfileSection() {
    return Column(
      children: [
        Stack(
          children: [
            CircleAvatar(
              radius: 60,
              backgroundImage: widget.user?.profileImage != null
                ? NetworkImage(widget.user!.profileImage!)
                : const AssetImage('assets/images/chant2.png') as ImageProvider,
            ),
            Positioned(
              bottom: 0,
              right: 0,
              child: Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary,
                  shape: BoxShape.circle,
                ),
                child: IconButton(
                  icon: const Icon(Icons.edit, size: 20),
                  color: Theme.of(context).colorScheme.onPrimary,
                  onPressed: () {
                    // TODO: Implement profile image upload
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Profile image upload coming soon')),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        _buildTextField(
          'Name',
          _nameController,
          Icons.person_outline,
          enabled: _isEditing,
        ),
        const SizedBox(height: 16),
        _buildTextField(
          'Email',
          _emailController,
          Icons.email_outlined,
          enabled: _isEditing,
        ),
      ],
    );
  }

  Widget _buildTextField(
    String label,
    TextEditingController controller,
    IconData icon, {
    bool enabled = true,
  }) {
    return TextField(
      controller: controller,
      enabled: enabled,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon),
        border: const OutlineInputBorder(),
      ),
    );
  }

  Widget _buildSection(String title, List<Widget> children) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            children: children,
          ),
        ),
      ],
    );
  }

  Widget _buildThemeModeTile() {
    return ListTile(
      title: const Text('Theme Mode'),
      subtitle: Text(_getThemeModeString(_currentThemeMode)),
      trailing: DropdownButton<ThemeMode>(
        value: _currentThemeMode,
        onChanged: (ThemeMode? newMode) {
          if (newMode != null) {
            _changeThemeMode(newMode);
          }
        },
        items: ThemeService.getThemeModes()
            .map<DropdownMenuItem<ThemeMode>>((ThemeMode themeMode) {
          return DropdownMenuItem<ThemeMode>(
            value: themeMode,
            child: Text(_getThemeModeString(themeMode)),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildSwitchTile(
    String title, 
    String subtitle, 
    bool value, 
    ValueChanged<bool> onChanged
  ) {
    return SwitchListTile(
      title: Text(title),
      subtitle: Text(subtitle),
      value: value,
      onChanged: onChanged,
    );
  }

  Widget _buildActionTile(
    String title,
    String subtitle,
    IconData icon, {
    required VoidCallback onTap,
    Color? color,
  }) {
    return ListTile(
      leading: Icon(icon, color: color),
      title: Text(title, style: color != null ? TextStyle(color: color) : null),
      subtitle: Text(subtitle),
      trailing: const Icon(Icons.chevron_right),
      onTap: onTap,
    );
  }

  String _getThemeModeString(ThemeMode themeMode) {
    switch (themeMode) {
      case ThemeMode.system:
        return 'System Default';
      case ThemeMode.light:
        return 'Light Mode';
      case ThemeMode.dark:
        return 'Dark Mode';
    }
  }
} 