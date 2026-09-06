import 'dart:convert';

class MilestoneModel {
  final String id;
  final String title;
  final String description;
  final double percentageWeight; // 0.10, 0.60, etc.
  final DateTime targetTime;
  final bool isCompleted;
  final bool isQuarantinePhase; // Video / Devpost final submission buffer

  MilestoneModel({
    required this.id,
    required this.title,
    required this.description,
    required this.percentageWeight,
    required this.targetTime,
    this.isCompleted = false,
    this.isQuarantinePhase = false,
  });

  MilestoneModel copyWith({
    String? id,
    String? title,
    String? description,
    double? percentageWeight,
    DateTime? targetTime,
    bool? isCompleted,
    bool? isQuarantinePhase,
  }) {
    return MilestoneModel(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      percentageWeight: percentageWeight ?? this.percentageWeight,
      targetTime: targetTime ?? this.targetTime,
      isCompleted: isCompleted ?? this.isCompleted,
      isQuarantinePhase: isQuarantinePhase ?? this.isQuarantinePhase,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'percentageWeight': percentageWeight,
      'targetTime': targetTime.toIso8601String(),
      'isCompleted': isCompleted,
      'isQuarantinePhase': isQuarantinePhase,
    };
  }

  factory MilestoneModel.fromMap(Map<String, dynamic> map) {
    return MilestoneModel(
      id: map['id'] ?? '',
      title: map['title'] ?? '',
      description: map['description'] ?? '',
      percentageWeight: (map['percentageWeight'] as num?)?.toDouble() ?? 0.0,
      targetTime: DateTime.parse(map['targetTime']),
      isCompleted: map['isCompleted'] ?? false,
      isQuarantinePhase: map['isQuarantinePhase'] ?? false,
    );
  }

  String toJson() => json.encode(toMap());

  factory MilestoneModel.fromJson(String source) => MilestoneModel.fromMap(json.decode(source));
}
