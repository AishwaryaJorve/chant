import 'package:chants/services/database_service.dart';
import 'package:flutter/material.dart';
import 'meditation_session_screen.dart';
import '../widgets/theme_background.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MeditationDetailScreen extends StatefulWidget {
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
  State<MeditationDetailScreen> createState() => _MeditationDetailScreenState();
}

class _MeditationDetailScreenState extends State<MeditationDetailScreen> {
  Future<void> _onSessionComplete() async {
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getInt('userId');
    
    if (userId != null) {
      try {
        // Create a session object
        final sessionDuration = int.parse(widget.duration.replaceAll(' min', ''));
        
        // Update user stats
        await DatabaseService().updateUserStats(
          userId: userId,
          addMinutes: sessionDuration, // Add the duration of the session
          incrementSession: true, // Increment the session count
        );
        
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Session completed successfully!')),
          );
          Navigator.pop(context);
        }
      } catch (e) {
        debugPrint('Error saving session: $e');
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Error saving session')),
          );
        }
      }
    }
  }

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
                      icon: Icon(Icons.arrow_back, color: colorScheme.onSurface),
                      onPressed: () => Navigator.pop(context),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      widget.title,
                      style: TextStyle(
                        color: colorScheme.onSurface,
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
                  widget.icon,
                  size: 120,
                  color: widget.color.withOpacity(0.9),
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
                        color: colorScheme.onSurface,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    _buildDetailItem(
                      context,
                      Icons.timer_outlined,
                      widget.duration,
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
                            title: widget.title,
                            duration: widget.duration,
                            color: widget.color,
                          ),
                        ),
                      );
                    },
                    style: FilledButton.styleFrom(
                      backgroundColor: widget.color,
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
        Icon(icon, color: colorScheme.onSurface.withOpacity(0.7), size: 24),
        const SizedBox(width: 12),
        Text(
          text,
          style: TextStyle(
            color: colorScheme.onSurface,
            fontSize: 16,
          ),
        ),
      ],
    );
  }
} 