import 'dart:async';

class TimerService {
  final Stopwatch stopwatch = Stopwatch();
  Timer? _timer;
  final Duration _interval = const Duration(seconds: 1);
  void Function(Duration)? onTick;

  void startTimer({required void Function(Duration) onTick}) {
    stopwatch.start();
    this.onTick = onTick;
    _timer = Timer.periodic(_interval, (_) {
      if (stopwatch.isRunning) {
        onTick(stopwatch.elapsed);
      }
    });
  }

  void stopTimer() {
    stopwatch.stop();
    _timer?.cancel();
  }

  void resetTimer() {
    stopwatch.reset();
    stopTimer();
  }

  static String formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    return "${twoDigits(duration.inMinutes)}:${twoDigits(duration.inSeconds % 60)}";
  }
}
