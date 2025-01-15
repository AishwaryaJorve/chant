import 'package:flutter/material.dart';
import 'meditation_session_screen.dart';
import '../widgets/theme_background.dart';

class MeditationDetailScreen extends StatelessWidget {
  final String title;
  final String duration;
  final IconData icon;
  final Color color;

  const MeditationDetailScreen({
    super.key,
    required this.title,
    required this.duration,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    
    return Scaffold(
      body: ThemeBackground(
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Back button and title
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    IconButton(
                      icon: Icon(Icons.arrow_back, color: colorScheme.onBackground),
                      onPressed: () => Navigator.pop(context),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      title,
                      style: TextStyle(
                        color: colorScheme.onBackground,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),

              // Meditation image
              Center(
                child: Icon(
                  icon,
                  size: 120,
                  color: color.withOpacity(0.9),
                ),
              ),
              const SizedBox(height: 32),

              // Details section
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'About this meditation',
                      style: TextStyle(
                        color: colorScheme.onBackground,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    _buildDetailItem(
                      context,
                      Icons.timer_outlined,
                      duration,
                    ),
                    const SizedBox(height: 12),
                    _buildDetailItem(
                      context,
                      Icons.volume_up_outlined,
                      'Calming background sounds',
                    ),
                  ],
                ),
              ),

              const Spacer(),

              // Start button
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: SizedBox(
                  width: double.infinity,
                  child: FilledButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => MeditationSessionScreen(
                            title: title,
                            duration: duration,
                            color: color,
                          ),
                        ),
                      );
                    },
                    style: FilledButton.styleFrom(
                      backgroundColor: color,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(
                      'Start Meditation',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: colorScheme.onPrimary,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetailItem(BuildContext context, IconData icon, String text) {
    final colorScheme = Theme.of(context).colorScheme;
    
    return Row(
      children: [
        Icon(icon, color: colorScheme.onBackground.withOpacity(0.7), size: 24),
        const SizedBox(width: 12),
        Text(
          text,
          style: TextStyle(
            color: colorScheme.onBackground,
            fontSize: 16,
          ),
        ),
      ],
    );
  }
} 