import 'package:flutter/material.dart';
import '../widgets/bottom_nav.dart';
import 'dart:async';
import '../mixins/auth_required_mixin.dart';
import '../widgets/theme_background.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/database_service.dart';

class ChantScreen extends StatefulWidget {
  const ChantScreen({super.key});

  @override
  State<ChantScreen> createState() => _ChantScreenState();
}

class _ChantScreenState extends State<ChantScreen>
    with SingleTickerProviderStateMixin, AuthRequiredMixin {
  int _count = 0;
  int _malas = 0;
  bool _isTimerRunning = false;
  Duration _elapsed = Duration.zero;
  Timer? _timer;
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _fetchTotalMalas();
  }

  @override
  void dispose() {
    _timer?.cancel();
    _animationController.dispose();
    super.dispose();
  }

  void _startTimer() {
    setState(() => _isTimerRunning = true);
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        _elapsed += const Duration(seconds: 1);
      });
    });
  }

  void _stopTimer() {
    _timer?.cancel();
    setState(() => _isTimerRunning = false);
  }

  void _resetCounter() {
    setState(() {
      _count = 0;
      _elapsed = Duration.zero;
      _isTimerRunning = false;
    });
    _timer?.cancel();
  }

  void _incrementCount() async {
    if (!_isTimerRunning) {
      _startTimer();
    }

    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getInt('userId');

    setState(() {
      _count++;
      if (_count % 108 == 0) {
        _malas++;
        _count = 0;

        // Save session time before resetting
        if (userId != null) {
          DatabaseService().updateUserStats(
            userId,
            malasCount: 1, // Increment the malas count by 1
          );
        }

        // Reset timer
        _elapsed = Duration.zero;
        _timer?.cancel();
        _isTimerRunning = false;

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Completed $_malas malas! 🎉'),
              duration: const Duration(seconds: 2),
            ),
          );
        }
      }
    });
    _animationController
      ..reset()
      ..forward();
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final hours = twoDigits(duration.inHours);
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return "$hours:$minutes:$seconds";
  }

  Future<void> _fetchTotalMalas() async {
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getInt('userId');

    if (userId != null) {
      final totalMalas = await DatabaseService().getTotalMalas(userId);
      setState(() {
        _malas = totalMalas; // Update the state with the fetched malas
      });
      debugPrint('Fetched total malas: $_malas'); // Debug statement
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ThemeColors.backgroundColor(context),
      body: ThemeBackground(
        child: SafeArea(
          child: Column(
            children: [
              // Header with Timer
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.05),
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(30),
                    bottomRight: Radius.circular(30),
                  ),
                ),
                child: Column(
                  children: [
                    Text(
                      'Chanting Session',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        color: ThemeColors.textColor(context),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      _formatDuration(_elapsed),
                      style: const TextStyle(
                        fontSize: 36,
                        fontWeight: FontWeight.w300,
                        color: Colors.orange,
                      ),
                    ),
                  ],
                ),
              ),

              // Main Counter Area
              Expanded(
                child: GestureDetector(
                  onTap: _incrementCount,
                  child: Container(
                    margin: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.indigo.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            _count.toString(),
                            style: const TextStyle(
                              fontSize: 72,
                              fontWeight: FontWeight.bold,
                              color: Colors.indigo,
                            ),
                          ),
                          Text(
                            'Tap to Count',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.indigo.withOpacity(0.7),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),

              // Stats Cards
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  children: [
                    _buildStatBox('Malas', _malas),
                    const SizedBox(width: 16),
                    _buildStatBox('Chants', _count),
                  ],
                ),
              ),

              // Control Panel
              Container(
                margin: const EdgeInsets.all(20),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.05),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildControlIcon(
                      Icons.refresh,
                      'Reset',
                      Colors.red.shade300,
                      _resetCounter,
                    ),
                    _buildControlIcon(
                      _isTimerRunning ? Icons.pause : Icons.play_arrow,
                      _isTimerRunning ? 'Pause' : 'Start',
                      Colors.teal,
                      _isTimerRunning ? _stopTimer : _startTimer,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNav(
        currentIndex: 2,
        totalMalas: _malas,
      ),
    );
  }

  Widget _buildStatBox(String label, int value) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.05),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          children: [
            Text(
              value.toString(),
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: ThemeColors.textColor(context),
              ),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 14,
                color: ThemeColors.secondaryTextColor(context),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildControlIcon(
      IconData icon, String label, Color color, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: color, size: 32),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                color: color,
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Background Pattern Painter
class CirclePatternPainter extends CustomPainter {
  final Color color;

  CirclePatternPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final radius = size.width / 12;
    for (var i = 0; i < size.height / (radius * 3); i++) {
      for (var j = 0; j < size.width / (radius * 3); j++) {
        canvas.drawCircle(
          Offset(j * radius * 3 + radius, i * radius * 3 + radius),
          radius / 2,
          paint,
        );
      }
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
