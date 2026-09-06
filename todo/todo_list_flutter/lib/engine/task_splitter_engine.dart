import 'package:uuid/uuid.dart';
import '../models/subtask_model.dart';

/// Novel AI-Inspired Task Decomposition Engine
/// Analyzes task title/category and dynamically splits broad goals into 5-7 frictionless micro-steps
class TaskSplitterEngine {
  static const _uuid = Uuid();

  static List<SubtaskModel> splitTask(String title, {String? category}) {
    final lower = title.toLowerCase();

    if (lower.contains('aiml') || lower.contains('machine learning') || lower.contains('ai') || lower.contains('deep learning')) {
      return [
        SubtaskModel(id: _uuid.v4(), title: 'Define problem scope & select datasets'),
        SubtaskModel(id: _uuid.v4(), title: 'Data cleaning, EDA & feature transformation'),
        SubtaskModel(id: _uuid.v4(), title: 'Train baseline ML / Neural Network model'),
        SubtaskModel(id: _uuid.v4(), title: 'Evaluate accuracy/F1 & hyperparameter tuning'),
        SubtaskModel(id: _uuid.v4(), title: 'Expose FastAPI / Flask inference endpoint'),
        SubtaskModel(id: _uuid.v4(), title: 'Document pipeline & benchmark metrics'),
      ];
    } else if (lower.contains('hackathon') || lower.contains('project') || lower.contains('build')) {
      return [
        SubtaskModel(id: _uuid.v4(), title: 'Initialize GitHub repository & README'),
        SubtaskModel(id: _uuid.v4(), title: 'Design low-fi Figma wireframe / architecture'),
        SubtaskModel(id: _uuid.v4(), title: 'Build backend API routes & database models'),
        SubtaskModel(id: _uuid.v4(), title: 'Implement frontend UI & state management'),
        SubtaskModel(id: _uuid.v4(), title: 'End-to-end integration test on localhost'),
        SubtaskModel(id: _uuid.v4(), title: 'Deploy live build (Vercel / Render / Firebase)'),
      ];
    } else if (lower.contains('video') || lower.contains('demo') || lower.contains('pitch')) {
      return [
        SubtaskModel(id: _uuid.v4(), title: 'Write 2-minute demo script with key bullet points'),
        SubtaskModel(id: _uuid.v4(), title: 'Record screen flow of live working features'),
        SubtaskModel(id: _uuid.v4(), title: 'Add voiceover explanation of value proposition'),
        SubtaskModel(id: _uuid.v4(), title: 'Render video at 1080p & upload to YouTube/Loom'),
        SubtaskModel(id: _uuid.v4(), title: 'Verify public visibility & audio clarity'),
      ];
    } else if (lower.contains('study') || lower.contains('exam') || lower.contains('chapter') || lower.contains('read')) {
      return [
        SubtaskModel(id: _uuid.v4(), title: 'Skim chapter syllabus & key learning outcomes'),
        SubtaskModel(id: _uuid.v4(), title: 'Watch reference YouTube tutorial / lecture'),
        SubtaskModel(id: _uuid.v4(), title: 'Write concise handwritten/digital summary notes'),
        SubtaskModel(id: _uuid.v4(), title: 'Solve 5-10 practice questions / past papers'),
        SubtaskModel(id: _uuid.v4(), title: 'Flashcard / active recall self-quiz'),
      ];
    } else if (lower.contains('leetcode') || lower.contains('dsa') || lower.contains('coding')) {
      return [
        SubtaskModel(id: _uuid.v4(), title: 'Read problem statement & identify constraints'),
        SubtaskModel(id: _uuid.v4(), title: 'Trace brute force approach on paper'),
        SubtaskModel(id: _uuid.v4(), title: 'Optimize time & space complexity (O(N) / O(log N))'),
        SubtaskModel(id: _uuid.v4(), title: 'Code solution with boundary condition checks'),
        SubtaskModel(id: _uuid.v4(), title: 'Submit & review optimal editorial solution'),
      ];
    } else {
      // General decomposition
      return [
        SubtaskModel(id: _uuid.v4(), title: 'Clarify initial goal & gather required resources'),
        SubtaskModel(id: _uuid.v4(), title: 'Complete first 15-minute quick sprint (Phase 1)'),
        SubtaskModel(id: _uuid.v4(), title: 'Execute main core deliverables (Phase 2)'),
        SubtaskModel(id: _uuid.v4(), title: 'Review output, test & fix rough edges'),
        SubtaskModel(id: _uuid.v4(), title: 'Finalize, submit or archive completion'),
      ];
    }
  }
}
