import 'package:flutter/foundation.dart';
import 'package:uuid/uuid.dart';
import '../models/task_model.dart';
import '../models/resource_link_model.dart';
import '../models/subtask_model.dart';
import '../models/gamification_model.dart';
import '../engine/gamification_engine.dart';
import '../engine/task_splitter_engine.dart';
import '../core/local_storage.dart';

class TodoProvider extends ChangeNotifier {
  final _uuid = const Uuid();
  List<TaskModel> _tasks = [];
  bool _isLoading = true;
  int _streakCount = 0;
  bool _hasDoneMorningRoutineToday = false;
  GamificationProfile _profile = GamificationProfile();

  TaskCategory? _selectedCategory;
  String _searchQuery = '';

  List<TaskModel> get tasks => _tasks;
  bool get isLoading => _isLoading;
  int get streakCount => _streakCount;
  bool get hasDoneMorningRoutineToday => _hasDoneMorningRoutineToday;
  GamificationProfile get profile => _profile;
  TaskCategory? get selectedCategory => _selectedCategory;
  String get searchQuery => _searchQuery;

  // Filtered lists
  List<TaskModel> get morningFocusTasks =>
      _tasks.where((t) => t.isMorningFocus && !t.isCompleted).toList();

  List<TaskModel> get completedTasks =>
      _tasks.where((t) => t.isCompleted).toList();

  // Kanban lists
  List<TaskModel> get todoTasks =>
      _tasks.where((t) => t.status == TaskStatus.todo && !t.isCompleted).toList();

  List<TaskModel> get inProgressTasks =>
      _tasks.where((t) => t.status == TaskStatus.inProgress && !t.isCompleted).toList();

  List<TaskModel> get doneTasks =>
      _tasks.where((t) => t.status == TaskStatus.done || t.isCompleted).toList();

  List<TaskModel> get filteredTasks {
    return _tasks.where((task) {
      if (_selectedCategory != null && task.category != _selectedCategory) {
        return false;
      }
      if (_searchQuery.isNotEmpty) {
        final query = _searchQuery.toLowerCase();
        final matchTitle = task.title.toLowerCase().contains(query);
        final matchDesc =
            task.description?.toLowerCase().contains(query) ?? false;
        return matchTitle || matchDesc;
      }
      return true;
    }).toList();
  }

  int get totalCompletedCount => _tasks.where((t) => t.isCompleted).length;
  int get totalPendingCount => _tasks.where((t) => !t.isCompleted).length;

  TodoProvider() {
    loadData();
  }

  Future<void> loadData() async {
    _isLoading = true;
    notifyListeners();

    _tasks = await LocalStorageService.loadTasks();
    _streakCount = await LocalStorageService.loadStreak();
    _hasDoneMorningRoutineToday =
        await LocalStorageService.hasCompletedMorningRoutineToday();
    _profile = await LocalStorageService.loadGamificationProfile();

    if (_tasks.isEmpty) {
      _seedDefaultTasks();
    }

    _isLoading = false;
    notifyListeners();
  }

  void _seedDefaultTasks() {
    final now = DateTime.now();
    _tasks = [
      TaskModel(
        id: _uuid.v4(),
        title: 'Study AIML Concepts (Deep Learning & CNNs)',
        description: 'Watch reference YouTube tutorials and implement first PyTorch baseline',
        priority: TaskPriority.high,
        category: TaskCategory.study,
        status: TaskStatus.inProgress,
        createdAt: now,
        isMorningFocus: true,
        energyRequirement: 3,
        hasSpacedRepetition: true,
        resourceLinks: [
          ResourceLinkModel(
            id: _uuid.v4(),
            title: 'Neural Networks & Deep Learning - 3Blue1Brown',
            url: 'https://www.youtube.com/watch?v=aircAruvnKk',
            type: ResourceType.youtube,
          ),
          ResourceLinkModel(
            id: _uuid.v4(),
            title: 'PyTorch Official Documentation & Tutorials',
            url: 'https://pytorch.org/tutorials/',
            type: ResourceType.doc,
          ),
        ],
        subtasks: TaskSplitterEngine.splitTask('Study AIML Concepts'),
      ),
      TaskModel(
        id: _uuid.v4(),
        title: 'Complete 30-sec Morning Wake-Up Kickstart',
        description: 'Set your top 3 daily rocks and fuel your focus',
        priority: TaskPriority.medium,
        category: TaskCategory.morningFocus,
        createdAt: now,
        isMorningFocus: true,
        energyRequirement: 2,
      ),
      TaskModel(
        id: _uuid.v4(),
        title: 'Build Hackathon AI Agent Prototype',
        description: 'Design MVP architecture and connect backend APIs',
        priority: TaskPriority.high,
        category: TaskCategory.hackathon,
        status: TaskStatus.todo,
        createdAt: now,
        isMorningFocus: true,
        energyRequirement: 3,
        isStakeLocked: true,
        stakeEndTime: now.add(const Duration(minutes: 45)),
        stakeXpBonus: 250,
        resourceLinks: [
          ResourceLinkModel(
            id: _uuid.v4(),
            title: 'Devpost Hackathon Submission Portal',
            url: 'https://devpost.com',
            type: ResourceType.devpost,
          ),
        ],
        subtasks: TaskSplitterEngine.splitTask('Build Hackathon AI Agent'),
      ),
    ];
    _persistTasks();
  }

  Future<void> addTask({
    required String title,
    String? description,
    TaskPriority priority = TaskPriority.medium,
    TaskCategory category = TaskCategory.personal,
    TaskStatus status = TaskStatus.todo,
    DateTime? dueDate,
    DateTime? scheduledDate,
    bool isMorningFocus = false,
    String? linkedHackathonId,
    int energyRequirement = 2,
    bool hasSpacedRepetition = false,
    List<ResourceLinkModel> resourceLinks = const [],
    List<SubtaskModel> subtasks = const [],
  }) async {
    final newTask = TaskModel(
      id: _uuid.v4(),
      title: title.trim(),
      description: description?.trim(),
      priority: priority,
      category: category,
      status: status,
      createdAt: DateTime.now(),
      dueDate: dueDate,
      scheduledDate: scheduledDate,
      isMorningFocus: isMorningFocus,
      linkedHackathonId: linkedHackathonId,
      energyRequirement: energyRequirement,
      hasSpacedRepetition: hasSpacedRepetition,
      resourceLinks: resourceLinks,
      subtasks: subtasks,
    );

    _tasks.insert(0, newTask);

    if (resourceLinks.isNotEmpty) {
      _addXp(30);
    }

    notifyListeners();
    await _persistTasks();
  }

  Future<void> toggleTaskCompletion(String id) async {
    final index = _tasks.indexWhere((t) => t.id == id);
    if (index != -1) {
      final task = _tasks[index];
      final newCompleted = !task.isCompleted;
      _tasks[index] = task.copyWith(
        isCompleted: newCompleted,
        status: newCompleted ? TaskStatus.done : TaskStatus.todo,
      );

      if (newCompleted) {
        int earnedXp = task.xpValue;
        // Check if stake completed on time
        if (task.isStakeLocked && task.stakeEndTime != null) {
          if (DateTime.now().isBefore(task.stakeEndTime!)) {
            earnedXp += task.stakeXpBonus;
          }
        }
        _addXp(earnedXp);
      }

      notifyListeners();
      await _persistTasks();
    }
  }

  Future<void> setTaskStakeLock(String id, {required DateTime endTime, required int bonusXp}) async {
    final index = _tasks.indexWhere((t) => t.id == id);
    if (index != -1) {
      _tasks[index] = _tasks[index].copyWith(
        isStakeLocked: true,
        stakeEndTime: endTime,
        stakeXpBonus: bonusXp,
      );
      notifyListeners();
      await _persistTasks();
    }
  }

  Future<void> updateTaskStatus(String id, TaskStatus newStatus) async {
    final index = _tasks.indexWhere((t) => t.id == id);
    if (index != -1) {
      final task = _tasks[index];
      _tasks[index] = task.copyWith(
        status: newStatus,
        isCompleted: newStatus == TaskStatus.done,
      );

      if (newStatus == TaskStatus.done && !task.isCompleted) {
        _addXp(task.xpValue);
      }

      notifyListeners();
      await _persistTasks();
    }
  }

  Future<void> updateTask(TaskModel updatedTask) async {
    final index = _tasks.indexWhere((t) => t.id == updatedTask.id);
    if (index != -1) {
      _tasks[index] = updatedTask;
      notifyListeners();
      await _persistTasks();
    }
  }

  Future<void> splitTaskWithAi(String id) async {
    final index = _tasks.indexWhere((t) => t.id == id);
    if (index != -1) {
      final task = _tasks[index];
      final generatedSubtasks = TaskSplitterEngine.splitTask(task.title);
      _tasks[index] = task.copyWith(subtasks: generatedSubtasks);
      _addXp(25);
      notifyListeners();
      await _persistTasks();
    }
  }

  Future<void> toggleSubtask(String taskId, String subtaskId) async {
    final taskIndex = _tasks.indexWhere((t) => t.id == taskId);
    if (taskIndex != -1) {
      final task = _tasks[taskIndex];
      final updatedSubtasks = task.subtasks.map((s) {
        if (s.id == subtaskId) {
          final updated = s.copyWith(isCompleted: !s.isCompleted);
          if (updated.isCompleted) {
            _addXp(15);
          }
          return updated;
        }
        return s;
      }).toList();

      final allDone = updatedSubtasks.isNotEmpty && updatedSubtasks.every((s) => s.isCompleted);
      _tasks[taskIndex] = task.copyWith(
        subtasks: updatedSubtasks,
        isCompleted: allDone ? true : task.isCompleted,
        status: allDone ? TaskStatus.done : task.status,
      );

      notifyListeners();
      await _persistTasks();
    }
  }

  Future<void> addResourceLink(String taskId, String title, String url) async {
    final taskIndex = _tasks.indexWhere((t) => t.id == taskId);
    if (taskIndex != -1) {
      final task = _tasks[taskIndex];
      final newLink = ResourceLinkModel(
        id: _uuid.v4(),
        title: title.trim().isEmpty ? url : title.trim(),
        url: url.trim(),
        type: ResourceLinkModel.detectType(url),
      );
      final updatedLinks = [...task.resourceLinks, newLink];
      _tasks[taskIndex] = task.copyWith(resourceLinks: updatedLinks);

      _addXp(20);

      notifyListeners();
      await _persistTasks();
    }
  }

  Future<void> recordPomodoroSession({required int minutes, String? taskId}) async {
    if (taskId != null) {
      final taskIndex = _tasks.indexWhere((t) => t.id == taskId);
      if (taskIndex != -1) {
        final task = _tasks[taskIndex];
        _tasks[taskIndex] = task.copyWith(
          focusMinutesSpent: task.focusMinutesSpent + minutes,
        );
      }
    }

    _addXp(minutes * 4);

    _profile = _profile.copyWith(
      totalPomodoroMinutes: _profile.totalPomodoroMinutes + minutes,
    );

    notifyListeners();
    await _persistTasks();
    await LocalStorageService.saveGamificationProfile(_profile);
  }

  Future<void> deleteTask(String id) async {
    _tasks.removeWhere((t) => t.id == id);
    notifyListeners();
    await _persistTasks();
  }

  Future<void> setMorningFocusTasks(List<String> taskTitles) async {
    for (int i = 0; i < _tasks.length; i++) {
      if (_tasks[i].isMorningFocus) {
        _tasks[i] = _tasks[i].copyWith(isMorningFocus: false);
      }
    }

    final now = DateTime.now();
    for (final title in taskTitles) {
      if (title.trim().isNotEmpty) {
        final newTask = TaskModel(
          id: _uuid.v4(),
          title: title.trim(),
          priority: TaskPriority.high,
          category: TaskCategory.morningFocus,
          createdAt: now,
          isMorningFocus: true,
          subtasks: TaskSplitterEngine.splitTask(title),
        );
        _tasks.insert(0, newTask);
      }
    }

    await LocalStorageService.incrementStreak();
    _streakCount = await LocalStorageService.loadStreak();
    _hasDoneMorningRoutineToday = true;

    _addXp(100);

    notifyListeners();
    await _persistTasks();
  }

  /// Simple XP counter — no ranks, no badges, no level grind.
  void _addXp(int xpEarned) {
    _profile = GamificationEngine.addXp(_profile, xpEarned);
    LocalStorageService.saveGamificationProfile(_profile);
  }

  void setCategoryFilter(TaskCategory? category) {
    _selectedCategory = category;
    notifyListeners();
  }

  void setSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  Future<void> _persistTasks() async {
    await LocalStorageService.saveTasks(_tasks);
  }
}
