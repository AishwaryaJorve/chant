import 'package:flutter/material.dart';
import '../widgets/theme_background.dart';
import '../models/user.dart';
import '../services/database_service.dart';

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

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.user?.name);
    _emailController = TextEditingController(text: widget.user?.email);
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

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    super.dispose();
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
              _buildProfileImage(),
              const SizedBox(height: 24),
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
              const SizedBox(height: 24),
              _buildSection('Privacy Settings', [
                _buildSwitchTile(
                  'Email Notifications',
                  'Receive meditation reminders',
                  true,
                ),
                _buildSwitchTile(
                  'Dark Mode',
                  'Enable dark theme',
                  Theme.of(context).brightness == Brightness.dark,
                ),
              ]),
              const SizedBox(height: 16),
              _buildSection('Data & Storage', [
                _buildActionTile(
                  'Clear Cache',
                  'Free up storage space',
                  Icons.cleaning_services_outlined,
                  onTap: () {
                    // TODO: Implement cache clearing
                  },
                ),
                _buildActionTile(
                  'Download Data',
                  'Get a copy of your meditation data',
                  Icons.download_outlined,
                  onTap: () {
                    // TODO: Implement data download
                  },
                ),
              ]),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProfileImage() {
    return Center(
      child: Stack(
        children: [
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
            ),
            child: Icon(
              Icons.person_outline,
              size: 60,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
          if (_isEditing)
            Positioned(
              right: 0,
              bottom: 0,
              child: Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.edit,
                  size: 20,
                  color: Theme.of(context).colorScheme.onPrimary,
                ),
              ),
            ),
        ],
      ),
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

  Widget _buildSwitchTile(String title, String subtitle, bool value) {
    return SwitchListTile(
      title: Text(title),
      subtitle: Text(subtitle),
      value: value,
      onChanged: (newValue) {
        // TODO: Implement switch functionality
        setState(() {});
      },
    );
  }

  Widget _buildActionTile(
    String title,
    String subtitle,
    IconData icon, {
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      subtitle: Text(subtitle),
      trailing: const Icon(Icons.chevron_right),
      onTap: onTap,
    );
  }
} 