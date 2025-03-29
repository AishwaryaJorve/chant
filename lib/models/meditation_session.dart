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

  factory MeditationSession.fromMap(Map<String, dynamic> map) {
    return MeditationSession(
      id: map['id'],
      title: map['title'].toString(),
      duration: _convertToInt(map['duration']),
      completedAt: DateTime.parse(map['completed_at']),
      isFavorite: (map['is_favorite'] == 1),
    );
  }

  static int _convertToInt(dynamic duration) {
    if (duration is int) return duration;
    if (duration is String) return int.tryParse(duration) ?? 0;
    return 0;
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'duration': duration,
      'completed_at': completedAt.toIso8601String(),
      'is_favorite': isFavorite ? 1 : 0,
    };
  }
} 