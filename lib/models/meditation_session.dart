class MeditationSession {
  final int? id;
  final String title;
  final int duration;
  final DateTime completedAt;
  final bool isFavorite;

  MeditationSession({
    this.id,
    required this.title,
    required this.duration,
    required this.completedAt,
    this.isFavorite = false,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'duration': duration,
      'completedAt': completedAt.toIso8601String(),
      'isFavorite': isFavorite ? 1 : 0,
    };
  }
} 