import 'dart:convert';
import 'resource_link_model.dart';
import 'subtask_model.dart';

enum TaskPriority { high, medium, low }

enum TaskCategory { hackathon, dev, study, personal, morningFocus }

enum TaskStatus { todo, inProgress, done }

class TaskModel {
  final String id;
  final String title;
  final String? description;
  final bool isCompleted;
  final TaskPriority priority;
  final TaskCategory category;
  final TaskStatus status;
  final DateTime createdAt;
  final DateTime? dueDate;
  final DateTime? scheduledDate;
  final bool isMorningFocus;
  final String? linkedHackathonId;
  final List<ResourceLinkModel> resourceLinks;
  final List<SubtaskModel> subtasks;
  final int xpValue;
  final int focusMinutesSpent;
  final int energyRequirement; // 1: Low 😴, 2: Medium ☕, 3: High Focus ⚡
  final bool hasSpacedRepetition;
  final int spacedRepetitionStage;
  final DateTime? nextReviewDate;
  final bool isStakeLocked;
  final DateTime? stakeEndTime;
  final int stakeXpBonus;

  TaskModel({
    required this.id,
    required this.title,
    this.description,
    this.isCompleted = false,
    this.priority = TaskPriority.medium,
    this.category = TaskCategory.personal,
    this.status = TaskStatus.todo,
    required this.createdAt,
    this.dueDate,
    this.scheduledDate,
    this.isMorningFocus = false,
    this.linkedHackathonId,
    this.resourceLinks = const [],
    this.subtasks = const [],
    this.xpValue = 50,
    this.focusMinutesSpent = 0,
    this.energyRequirement = 2,
    this.hasSpacedRepetition = false,
    this.spacedRepetitionStage = 0,
    this.nextReviewDate,
    this.isStakeLocked = false,
    this.stakeEndTime,
    this.stakeXpBonus = 200,
  });

  double get subtaskProgress {
    if (subtasks.isEmpty) return isCompleted ? 1.0 : 0.0;
    final completed = subtasks.where((s) => s.isCompleted).length;
    return completed / subtasks.length;
  }

  bool get isStakeActive {
    if (!isStakeLocked || stakeEndTime == null || isCompleted) return false;
    return DateTime.now().isBefore(stakeEndTime!);
  }

  Duration get remainingStakeDuration {
    if (stakeEndTime == null) return Duration.zero;
    final now = DateTime.now();
    return stakeEndTime!.isAfter(now) ? stakeEndTime!.difference(now) : Duration.zero;
  }

  TaskModel copyWith({
    String? id,
    String? title,
    String? description,
    bool? isCompleted,
    TaskPriority? priority,
    TaskCategory? category,
    TaskStatus? status,
    DateTime? createdAt,
    DateTime? dueDate,
    DateTime? scheduledDate,
    bool? isMorningFocus,
    String? linkedHackathonId,
    List<ResourceLinkModel>? resourceLinks,
    List<SubtaskModel>? subtasks,
    int? xpValue,
    int? focusMinutesSpent,
    int? energyRequirement,
    bool? hasSpacedRepetition,
    int? spacedRepetitionStage,
    DateTime? nextReviewDate,
    bool? isStakeLocked,
    DateTime? stakeEndTime,
    int? stakeXpBonus,
  }) {
    return TaskModel(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      isCompleted: isCompleted ?? this.isCompleted,
      priority: priority ?? this.priority,
      category: category ?? this.category,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      dueDate: dueDate ?? this.dueDate,
      scheduledDate: scheduledDate ?? this.scheduledDate,
      isMorningFocus: isMorningFocus ?? this.isMorningFocus,
      linkedHackathonId: linkedHackathonId ?? this.linkedHackathonId,
      resourceLinks: resourceLinks ?? this.resourceLinks,
      subtasks: subtasks ?? this.subtasks,
      xpValue: xpValue ?? this.xpValue,
      focusMinutesSpent: focusMinutesSpent ?? this.focusMinutesSpent,
      energyRequirement: energyRequirement ?? this.energyRequirement,
      hasSpacedRepetition: hasSpacedRepetition ?? this.hasSpacedRepetition,
      spacedRepetitionStage: spacedRepetitionStage ?? this.spacedRepetitionStage,
      nextReviewDate: nextReviewDate ?? this.nextReviewDate,
      isStakeLocked: isStakeLocked ?? this.isStakeLocked,
      stakeEndTime: stakeEndTime ?? this.stakeEndTime,
      stakeXpBonus: stakeXpBonus ?? this.stakeXpBonus,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'isCompleted': isCompleted,
      'priority': priority.index,
      'category': category.index,
      'status': status.index,
      'createdAt': createdAt.toIso8601String(),
      'dueDate': dueDate?.toIso8601String(),
      'scheduledDate': scheduledDate?.toIso8601String(),
      'isMorningFocus': isMorningFocus,
      'linkedHackathonId': linkedHackathonId,
      'resourceLinks': resourceLinks.map((x) => x.toMap()).toList(),
      'subtasks': subtasks.map((x) => x.toMap()).toList(),
      'xpValue': xpValue,
      'focusMinutesSpent': focusMinutesSpent,
      'energyRequirement': energyRequirement,
      'hasSpacedRepetition': hasSpacedRepetition,
      'spacedRepetitionStage': spacedRepetitionStage,
      'nextReviewDate': nextReviewDate?.toIso8601String(),
      'isStakeLocked': isStakeLocked,
      'stakeEndTime': stakeEndTime?.toIso8601String(),
      'stakeXpBonus': stakeXpBonus,
    };
  }

  factory TaskModel.fromMap(Map<String, dynamic> map) {
    return TaskModel(
      id: map['id'] ?? '',
      title: map['title'] ?? '',
      description: map['description'],
      isCompleted: map['isCompleted'] ?? false,
      priority: TaskPriority.values[map['priority'] ?? 1],
      category: TaskCategory.values[map['category'] ?? 3],
      status: TaskStatus.values[map['status'] ?? (map['isCompleted'] == true ? 2 : 0)],
      createdAt: DateTime.parse(map['createdAt']),
      dueDate: map['dueDate'] != null ? DateTime.parse(map['dueDate']) : null,
      scheduledDate: map['scheduledDate'] != null ? DateTime.parse(map['scheduledDate']) : null,
      isMorningFocus: map['isMorningFocus'] ?? false,
      linkedHackathonId: map['linkedHackathonId'],
      resourceLinks: (map['resourceLinks'] as List<dynamic>?)
              ?.map((x) => ResourceLinkModel.fromMap(x))
              .toList() ??
          [],
      subtasks: (map['subtasks'] as List<dynamic>?)
              ?.map((x) => SubtaskModel.fromMap(x))
              .toList() ??
          [],
      xpValue: map['xpValue'] ?? 50,
      focusMinutesSpent: map['focusMinutesSpent'] ?? 0,
      energyRequirement: map['energyRequirement'] ?? 2,
      hasSpacedRepetition: map['hasSpacedRepetition'] ?? false,
      spacedRepetitionStage: map['spacedRepetitionStage'] ?? 0,
      nextReviewDate: map['nextReviewDate'] != null ? DateTime.parse(map['nextReviewDate']) : null,
      isStakeLocked: map['isStakeLocked'] ?? false,
      stakeEndTime: map['stakeEndTime'] != null ? DateTime.parse(map['stakeEndTime']) : null,
      stakeXpBonus: map['stakeXpBonus'] ?? 200,
    );
  }

  String toJson() => json.encode(toMap());

  factory TaskModel.fromJson(String source) =>
      TaskModel.fromMap(json.decode(source));
}
