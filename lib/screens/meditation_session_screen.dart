import 'package:flutter/material.dart';
import 'dart:async';
import 'package:just_audio/just_audio.dart';
import '../models/meditation_session.dart';
import '../services/database_service.dart';
import '../widgets/theme_background.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MeditationSessionScreen extends StatefulWidget {
  final String title;
  final String duration;
  final Color color;

  const MeditationSessionScreen({
    super.key,
    required this.title,
    required this.duration,
    required this.color,
  });

  @override
  State<MeditationSessionScreen> createState() =>
      _MeditationSessionScreenState();
}

class _MeditationSessionScreenState extends State<MeditationSessionScreen> {
  bool isPlaying = true;
  bool isSoundOn = true;
  late Timer _timer;
  int _timeLeft = 0;
  final AudioPlayer _audioPlayer = AudioPlayer();
  Timer? _sessionTimer;
  int _elapsedSeconds = 0;

  @override
  void initState() {
    super.initState();
    _timeLeft = int.parse(widget.duration.split(' ')[0]) * 60;
    _initAudio();
    _startTimer();
    _sessionTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        _elapsedSeconds++;
      });
    });
  }

  // Fix _showCompletionDialog method
  void _showCompletionDialog() async {
    _timer.cancel();
    await _endSession();

    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getInt('userId');

    if (userId != null) {
      final dbService = DatabaseService();
      // Create meditation session record
      await dbService.createMeditationSession(
          MeditationSession(
            title: widget.title,
            duration: int.parse(widget.duration.split(' ')[0]),
            completedAt: DateTime.now(),
            isFavorite: false,
          ),
          userId);
    }

    if (!mounted) return;
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        backgroundColor: Theme.of(context).colorScheme.surface,
        title: Text(
          'Session Complete',
          style: TextStyle(
            color: Theme.of(context).colorScheme.onSurface,
          ),
        ),
        content: Text(
          'Congratulations on completing your meditation session!',
          style: TextStyle(
            color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); // Close dialog
              Navigator.of(context).pop(); // Return to detail screen
            },
            child: Text(
              'Done',
              style: TextStyle(color: widget.color),
            ),
          ),
        ],
      ),
    );
  }

  // Fix _endSession method
  Future<void> _endSession() async {
    _sessionTimer?.cancel();

    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getInt('userId');

    if (userId != null) {
      final sessionDuration =
          int.parse(widget.duration.split(' ')[0]); // Use actual duration

      // Update user stats
      await DatabaseService().updateUserStats(
          meditationMinutes: sessionDuration,
          userId: userId,
          addMinutes: sessionDuration,
          incrementSession: true);
    }
  }

  // Fix audio initialization
  Future<void> _initAudio() async {
    try {
      await _audioPlayer.setAsset('assets/audio/meditation_bell.mp3');
      await _audioPlayer.setLoopMode(LoopMode.one);
      if (isSoundOn) {
        await _audioPlayer.play();
      }
    } catch (e) {
      debugPrint('Error initializing audio: $e');
    }
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_timeLeft > 0 && isPlaying) {
        setState(() {
          _timeLeft--;
        });
      } else if (_timeLeft == 0) {
        timer.cancel();
        _showCompletionDialog();
      }
    });
  }

  void _togglePlayPause() {
    setState(() {
      isPlaying = !isPlaying;
      if (isSoundOn) {
        if (isPlaying) {
          _audioPlayer.play();
        } else {
          _audioPlayer.pause();
        }
      }
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    _sessionTimer?.cancel();
    _audioPlayer.dispose();
    super.dispose();
  }

  // Add _toggleSound method
  void _toggleSound() {
    setState(() {
      isSoundOn = !isSoundOn;
      if (isSoundOn) {
        _audioPlayer.play();
      } else {
        _audioPlayer.pause();
      }
    });
  }

  // Remove the standalone Text widget and fix the build method's Timer Display
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: ThemeBackground(
        child: SafeArea(
          child: Column(
            children: [
              // Header
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    IconButton(
                      icon: Icon(
                        Icons.close,
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                      onPressed: () => Navigator.pop(context),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      widget.title,
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.onSurface,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),

              const Spacer(),

              // Timer Display
              Text(
                '${(_timeLeft ~/ 60).toString().padLeft(2, '0')}:${(_timeLeft % 60).toString().padLeft(2, '0')}',
                style: TextStyle(
                  color: widget.color,
                  fontSize: 72,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const Spacer(),

              // Controls
              Padding(
                padding: const EdgeInsets.all(32.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      icon: Icon(
                        isSoundOn ? Icons.volume_up : Icons.volume_off,
                        color: widget.color,
                        size: 32,
                      ),
                      onPressed: _toggleSound,
                    ),
                    const SizedBox(width: 32),
                    IconButton(
                      icon: Icon(
                        isPlaying ? Icons.pause_circle : Icons.play_circle,
                        color: widget.color,
                        size: 64,
                      ),
                      onPressed: _togglePlayPause,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
