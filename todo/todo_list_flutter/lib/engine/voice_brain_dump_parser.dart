import '../models/task_model.dart';

class ParsedVoiceIntent {
  final String title;
  final String? description;
  final TaskPriority priority;
  final TaskCategory category;
  final DateTime? dueDate;
  final int energyLevel; // 1: Low, 2: Medium, 3: High

  ParsedVoiceIntent({
    required this.title,
    this.description,
    this.priority = TaskPriority.medium,
    this.category = TaskCategory.personal,
    this.dueDate,
    this.energyLevel = 2,
  });
}

/// Natural Language Speech/Voice Intent Parser
/// Parses natural Hinglish & English voice brain dumps into structured tasks
class VoiceBrainDumpParser {
  static ParsedVoiceIntent parse(String text) {
    final lower = text.toLowerCase();

    // Priority detection
    TaskPriority priority = TaskPriority.medium;
    if (lower.contains('urgent') ||
        lower.contains('high priority') ||
        lower.contains('critical') ||
        lower.contains('jaldi') ||
        lower.contains('important') ||
        lower.contains('turant')) {
      priority = TaskPriority.high;
    } else if (lower.contains('low priority') ||
        lower.contains('whenever') ||
        lower.contains('aaram se') ||
        lower.contains('baad me')) {
      priority = TaskPriority.low;
    }

    // Category detection
    TaskCategory category = TaskCategory.personal;
    if (lower.contains('hackathon') ||
        lower.contains('devpost') ||
        lower.contains('pitch') ||
        lower.contains('demo video') ||
        lower.contains('sprint')) {
      category = TaskCategory.hackathon;
    } else if (lower.contains('aiml') ||
        lower.contains('study') ||
        lower.contains('padhna') ||
        lower.contains('assignment') ||
        lower.contains('exam') ||
        lower.contains('syllabus') ||
        lower.contains('chapter') ||
        lower.contains('lecture')) {
      category = TaskCategory.study;
    } else if (lower.contains('code') ||
        lower.contains('backend') ||
        lower.contains('frontend') ||
        lower.contains('api') ||
        lower.contains('bug') ||
        lower.contains('github') ||
        lower.contains('deploy')) {
      category = TaskCategory.dev;
    } else if (lower.contains('morning') || lower.contains('subah')) {
      category = TaskCategory.morningFocus;
    }

    // Energy level detection
    int energy = 2;
    if (category == TaskCategory.dev || priority == TaskPriority.high) {
      energy = 3; // High focus
    } else if (lower.contains('light') || lower.contains('easy') || lower.contains('water') || lower.contains('stretch')) {
      energy = 1; // Low energy
    }

    // Time detection (e.g., today, tomorrow / kal, tonight)
    DateTime? dueDate;
    final now = DateTime.now();
    if (lower.contains('kal') || lower.contains('tomorrow')) {
      dueDate = now.add(const Duration(days: 1));
    } else if (lower.contains('today') || lower.contains('aaj') || lower.contains('tonight') || lower.contains('shaam')) {
      dueDate = DateTime(now.year, now.month, now.day, 20, 0);
    }

    // Cleaned title
    String title = text.trim();
    if (title.isNotEmpty) {
      title = title[0].toUpperCase() + title.substring(1);
    }

    return ParsedVoiceIntent(
      title: title,
      priority: priority,
      category: category,
      dueDate: dueDate,
      energyLevel: energy,
    );
  }
}
