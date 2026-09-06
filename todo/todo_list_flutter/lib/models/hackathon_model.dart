import 'dart:convert';
import 'milestone_model.dart';

class HackathonDeliverable {
  final String id;
  final String title;
  final bool isDone;
  final String? url;

  HackathonDeliverable({
    required this.id,
    required this.title,
    this.isDone = false,
    this.url,
  });

  HackathonDeliverable copyWith({
    String? id,
    String? title,
    bool? isDone,
    String? url,
  }) {
    return HackathonDeliverable(
      id: id ?? this.id,
      title: title ?? this.title,
      isDone: isDone ?? this.isDone,
      url: url ?? this.url,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'isDone': isDone,
      'url': url,
    };
  }

  factory HackathonDeliverable.fromMap(Map<String, dynamic> map) {
    return HackathonDeliverable(
      id: map['id'] ?? '',
      title: map['title'] ?? '',
      isDone: map['isDone'] ?? false,
      url: map['url'],
    );
  }
}

class HackathonModel {
  final String id;
  final String name;
  final String platform; // Devpost, Devfolio, MLH, Taikai, Unstop, etc.
  final DateTime startDate;
  final DateTime submissionDeadline;
  final String? projectTheme;
  final String? registrationUrl;
  final List<MilestoneModel> milestones;
  final List<HackathonDeliverable> deliverables;
  final bool isCompleted;

  HackathonModel({
    required this.id,
    required this.name,
    required this.platform,
    required this.startDate,
    required this.submissionDeadline,
    this.projectTheme,
    this.registrationUrl,
    required this.milestones,
    required this.deliverables,
    this.isCompleted = false,
  });

  Duration get remainingDuration {
    final now = DateTime.now();
    return submissionDeadline.isAfter(now)
        ? submissionDeadline.difference(now)
        : Duration.zero;
  }

  bool get isUrgent {
    final rem = remainingDuration;
    return rem.inHours <= 12 && rem.inSeconds > 0;
  }

  bool get isCritical {
    final rem = remainingDuration;
    return rem.inHours <= 2 && rem.inSeconds > 0;
  }

  double get progressPercentage {
    if (milestones.isEmpty) return 0.0;
    final completed = milestones.where((m) => m.isCompleted).length;
    return completed / milestones.length;
  }

  HackathonModel copyWith({
    String? id,
    String? name,
    String? platform,
    DateTime? startDate,
    DateTime? submissionDeadline,
    String? projectTheme,
    String? registrationUrl,
    List<MilestoneModel>? milestones,
    List<HackathonDeliverable>? deliverables,
    bool? isCompleted,
  }) {
    return HackathonModel(
      id: id ?? this.id,
      name: name ?? this.name,
      platform: platform ?? this.platform,
      startDate: startDate ?? this.startDate,
      submissionDeadline: submissionDeadline ?? this.submissionDeadline,
      projectTheme: projectTheme ?? this.projectTheme,
      registrationUrl: registrationUrl ?? this.registrationUrl,
      milestones: milestones ?? this.milestones,
      deliverables: deliverables ?? this.deliverables,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'platform': platform,
      'startDate': startDate.toIso8601String(),
      'submissionDeadline': submissionDeadline.toIso8601String(),
      'projectTheme': projectTheme,
      'registrationUrl': registrationUrl,
      'milestones': milestones.map((x) => x.toMap()).toList(),
      'deliverables': deliverables.map((x) => x.toMap()).toList(),
      'isCompleted': isCompleted,
    };
  }

  factory HackathonModel.fromMap(Map<String, dynamic> map) {
    return HackathonModel(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      platform: map['platform'] ?? 'Devpost',
      startDate: DateTime.parse(map['startDate']),
      submissionDeadline: DateTime.parse(map['submissionDeadline']),
      projectTheme: map['projectTheme'],
      registrationUrl: map['registrationUrl'],
      milestones: (map['milestones'] as List<dynamic>?)
              ?.map((x) => MilestoneModel.fromMap(x))
              .toList() ??
          [],
      deliverables: (map['deliverables'] as List<dynamic>?)
              ?.map((x) => HackathonDeliverable.fromMap(x))
              .toList() ??
          [],
      isCompleted: map['isCompleted'] ?? false,
    );
  }

  String toJson() => json.encode(toMap());

  factory HackathonModel.fromJson(String source) =>
      HackathonModel.fromMap(json.decode(source));
}
