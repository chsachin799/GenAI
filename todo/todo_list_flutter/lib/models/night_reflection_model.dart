import 'dart:convert';

class NightReflection {
  final String id;
  final DateTime date;
  final String winOfToday;
  final String oneThingLearned;
  final int energyRating; // 1 to 5
  final int tasksCompletedCount;
  final int xpGained;

  NightReflection({
    required this.id,
    required this.date,
    required this.winOfToday,
    required this.oneThingLearned,
    required this.energyRating,
    required this.tasksCompletedCount,
    required this.xpGained,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'date': date.toIso8601String(),
      'winOfToday': winOfToday,
      'oneThingLearned': oneThingLearned,
      'energyRating': energyRating,
      'tasksCompletedCount': tasksCompletedCount,
      'xpGained': xpGained,
    };
  }

  factory NightReflection.fromMap(Map<String, dynamic> map) {
    return NightReflection(
      id: map['id'] ?? '',
      date: DateTime.parse(map['date']),
      winOfToday: map['winOfToday'] ?? '',
      oneThingLearned: map['oneThingLearned'] ?? '',
      energyRating: map['energyRating'] ?? 5,
      tasksCompletedCount: map['tasksCompletedCount'] ?? 0,
      xpGained: map['xpGained'] ?? 0,
    );
  }

  String toJson() => json.encode(toMap());

  factory NightReflection.fromJson(String source) =>
      NightReflection.fromMap(json.decode(source));
}
