class UserStats {
  final int totalMinutes;
  final int totalSessions;
  final int currentStreak;
  final DateTime lastSessionDate;

  UserStats({
    required this.totalMinutes,
    required this.totalSessions,
    required this.currentStreak,
    required this.lastSessionDate,
  });
} 