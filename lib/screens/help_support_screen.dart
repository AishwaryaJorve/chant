import 'package:flutter/material.dart';
import '../widgets/theme_background.dart';

class HelpSupportScreen extends StatelessWidget {
  const HelpSupportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Help & Support'),
      ),
      body: ThemeBackground(
        child: SafeArea(
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              _buildSection(
                context,
                'FAQs',
                [
                  _buildExpandableTile(
                    'How do I start meditating?',
                    'Start with our guided meditations in the "Focus" category. '
                    'Find a quiet place, sit comfortably, and follow the instructions.',
                  ),
                  _buildExpandableTile(
                    'Can I download meditations?',
                    'Yes, premium users can download meditations for offline use. '
                    'Look for the download icon next to each meditation.',
                  ),
                  _buildExpandableTile(
                    'How do I track my progress?',
                    'Your meditation stats are available on your profile page, '
                    'showing your total minutes meditated and current streak.',
                  ),
                ],
              ),
              const SizedBox(height: 24),
              _buildSection(
                context,
                'Contact Us',
                [
                  _buildContactTile(
                    context,
                    'Email Support',
                    'Get help via email',
                    Icons.email_outlined,
                    () {
                      // TODO: Implement email support
                    },
                  ),
                  // _buildContactTile(
                  //   context,
                  //   'Live Chat',
                  //   'Chat with our support team',
                  //   Icons.chat_outlined,
                  //   () {
                  //     // TODO: Implement live chat
                  //   },
                  // ),
                ],
              ),
              // const SizedBox(height: 24),
              // _buildSection(
              //   context,
              //   'Resources',
              //   [
              //     _buildResourceTile(
              //       context,
              //       'Meditation Guide',
              //       'Learn meditation basics',
              //       Icons.book_outlined,
              //     ),
              //     _buildResourceTile(
              //       context,
              //       'Video Tutorials',
              //       'Watch helpful tutorials',
              //       Icons.play_circle_outline,
              //     ),
              //   ],
              // ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSection(BuildContext context, String title, List<Widget> children) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(height: 16),
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

  Widget _buildExpandableTile(String title, String content) {
    return ExpansionTile(
      title: Text(title),
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: Text(content),
        ),
      ],
    );
  }

  Widget _buildContactTile(
    BuildContext context,
    String title,
    String subtitle,
    IconData icon,
    VoidCallback onTap,
  ) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      subtitle: Text(subtitle),
      trailing: const Icon(Icons.chevron_right),
      onTap: onTap,
    );
  }

  Widget _buildResourceTile(
    BuildContext context,
    String title,
    String subtitle,
    IconData icon,
  ) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      subtitle: Text(subtitle),
      trailing: const Icon(Icons.chevron_right),
      onTap: () {
        // TODO: Implement resource navigation
      },
    );
  }
} 