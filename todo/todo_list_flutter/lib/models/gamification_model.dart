import 'dart:convert';

/// Lightweight stats profile — no ranks, badges, or gimmicks.
/// Just tracks raw productivity numbers for Analytics screen.
class GamificationProfile {
  final int totalXp;
  final int totalTasksCompleted;
  final int totalPomodoroMinutes;
  final int hackathonsFinished;

  GamificationProfile({
    this.totalXp = 0,
    this.totalTasksCompleted = 0,
    this.totalPomodoroMinutes = 0,
    this.hackathonsFinished = 0,
  });

  GamificationProfile copyWith({
    int? totalXp,
    int? totalTasksCompleted,
    int? totalPomodoroMinutes,
    int? hackathonsFinished,
  }) {
    return GamificationProfile(
      totalXp: totalXp ?? this.totalXp,
      totalTasksCompleted: totalTasksCompleted ?? this.totalTasksCompleted,
      totalPomodoroMinutes: totalPomodoroMinutes ?? this.totalPomodoroMinutes,
      hackathonsFinished: hackathonsFinished ?? this.hackathonsFinished,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'totalXp': totalXp,
      'totalTasksCompleted': totalTasksCompleted,
      'totalPomodoroMinutes': totalPomodoroMinutes,
      'hackathonsFinished': hackathonsFinished,
    };
  }

  factory GamificationProfile.fromMap(Map<String, dynamic> map) {
    return GamificationProfile(
      totalXp: map['totalXp'] ?? 0,
      totalTasksCompleted: map['totalTasksCompleted'] ?? 0,
      totalPomodoroMinutes: map['totalPomodoroMinutes'] ?? 0,
      hackathonsFinished: map['hackathonsFinished'] ?? 0,
    );
  }

  String toJson() => json.encode(toMap());

  factory GamificationProfile.fromJson(String source) =>
      GamificationProfile.fromMap(json.decode(source));
}
