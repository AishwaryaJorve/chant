import 'package:flutter/material.dart';
import '../widgets/bottom_nav.dart';
import '../widgets/theme_background.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ThemeColors.backgroundColor(context),
      body: ThemeBackground(
        child: SafeArea(
          child: ListView(
            padding: const EdgeInsets.all(16.0),
            children: [
              const _ProfileHeader(),
              const SizedBox(height: 24),
              _buildStatsSection(context),
              const SizedBox(height: 24),
              _buildSettingsSection(context),
            ],
          ),
        ),
      ),
      bottomNavigationBar: const BottomNav(currentIndex: 3),
    );
  }

  Widget _buildStatsSection(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colorScheme.surface.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Your Stats',
            style: TextStyle(
              color: colorScheme.onBackground,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildStatItem(context, 'Minutes\nMeditated', '345'),
              _buildStatItem(context, 'Sessions\nCompleted', '28'),
              _buildStatItem(context, 'Current\nStreak', '7'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(BuildContext context, String label, String value) {
    final colorScheme = Theme.of(context).colorScheme;
    
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            color: colorScheme.onBackground,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: colorScheme.onBackground.withOpacity(0.7),
            fontSize: 12,
          ),
        ),
      ],
    );
  }

  Widget _buildSettingsSection(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    
    return Container(
      decoration: BoxDecoration(
        color: colorScheme.surface.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          _buildSettingsTile(
            context,
            'Account Settings',
            Icons.person_outline,
            onTap: () {},
          ),
          _buildDivider(context),
          _buildSettingsTile(
            context,
            'Notifications',
            Icons.notifications_none,
            onTap: () {},
          ),
          _buildDivider(context),
          _buildSettingsTile(
            context,
            'Download Settings',
            Icons.download_outlined,
            onTap: () {},
          ),
          _buildDivider(context),
          _buildSettingsTile(
            context,
            'Help & Support',
            Icons.help_outline,
            onTap: () {},
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsTile(BuildContext context, String title, IconData icon, {required VoidCallback onTap}) {
    final colorScheme = Theme.of(context).colorScheme;
    
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            Icon(icon, color: colorScheme.onBackground, size: 24),
            const SizedBox(width: 12),
            Text(
              title,
              style: TextStyle(
                color: colorScheme.onBackground,
                fontSize: 16,
              ),
            ),
            const Spacer(),
            Icon(
              Icons.chevron_right,
              color: colorScheme.onBackground.withOpacity(0.5),
              size: 24,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDivider(BuildContext context) {
    return Divider(
      color: Theme.of(context).colorScheme.onBackground.withOpacity(0.1),
      height: 1,
    );
  }
}

class _ProfileHeader extends StatelessWidget {
  const _ProfileHeader();

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    
    return Column(
      children: [
        Container(
          width: 100,
          height: 100,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: colorScheme.surface.withOpacity(0.1),
            border: Border.all(
              color: colorScheme.onBackground.withOpacity(0.2),
              width: 2,
            ),
          ),
          child: Icon(
            Icons.person_outline,
            color: colorScheme.onBackground,
            size: 50,
          ),
        ),
        const SizedBox(height: 16),
        Text(
          'John Doe',
          style: TextStyle(
            color: colorScheme.onBackground,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          'john.doe@example.com',
          style: TextStyle(
            color: colorScheme.onBackground.withOpacity(0.7),
            fontSize: 16,
          ),
        ),
        const SizedBox(height: 16),
        OutlinedButton(
          onPressed: () {},
          style: OutlinedButton.styleFrom(
            side: BorderSide(color: colorScheme.onBackground.withOpacity(0.3)),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
          ),
          child: Text(
            'Edit Profile',
            style: TextStyle(color: colorScheme.onBackground),
          ),
        ),
      ],
    );
  }
} 