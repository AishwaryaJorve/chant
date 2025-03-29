class TimeFormatter {
  static String formatTotalTime(int totalMinutes) {
    if (totalMinutes < 60) {
      return '$totalMinutes mins';
    }
    
    final hours = totalMinutes ~/ 60;
    final minutes = totalMinutes % 60;
    
    if (hours < 24) {
      return '${hours}h ${minutes}m';
    }
    
    final days = hours ~/ 24;
    final remainingHours = hours % 24;
    
    return '${days}d ${remainingHours}h ${minutes}m';
  }
  
  static String getTimeAchievementLabel(int totalMinutes) {
    if (totalMinutes < 60) return 'Beginner';
    if (totalMinutes < 300) return 'Regular';
    if (totalMinutes < 1000) return 'Dedicated';
    if (totalMinutes < 5000) return 'Advanced';
    return 'Master';
  }
}