import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/task_model.dart';
import '../models/hackathon_model.dart';
import '../models/gamification_model.dart';

class LocalStorageService {
  static const String _tasksKey = 'chronodo_tasks_v2';
  static const String _hackathonsKey = 'chronodo_hackathons_v2';
  static const String _lastWakeDateKey = 'chronodo_last_wake_date';
  static const String _streakCountKey = 'chronodo_streak_count';
  static const String _gamificationKey = 'chronodo_gamification_profile';

  // Tasks
  static Future<List<TaskModel>> loadTasks() async {
    final prefs = await SharedPreferences.getInstance();
    final String? tasksJson = prefs.getString(_tasksKey);
    if (tasksJson == null || tasksJson.isEmpty) return [];

    try {
      final List<dynamic> decoded = json.decode(tasksJson);
      return decoded.map((item) => TaskModel.fromMap(item)).toList();
    } catch (e) {
      return [];
    }
  }

  static Future<void> saveTasks(List<TaskModel> tasks) async {
    final prefs = await SharedPreferences.getInstance();
    final String encoded = json.encode(tasks.map((t) => t.toMap()).toList());
    await prefs.setString(_tasksKey, encoded);
  }

  // Hackathons
  static Future<List<HackathonModel>> loadHackathons() async {
    final prefs = await SharedPreferences.getInstance();
    final String? hackathonsJson = prefs.getString(_hackathonsKey);
    if (hackathonsJson == null || hackathonsJson.isEmpty) return [];

    try {
      final List<dynamic> decoded = json.decode(hackathonsJson);
      return decoded.map((item) => HackathonModel.fromMap(item)).toList();
    } catch (e) {
      return [];
    }
  }

  static Future<void> saveHackathons(List<HackathonModel> hackathons) async {
    final prefs = await SharedPreferences.getInstance();
    final String encoded =
        json.encode(hackathons.map((h) => h.toMap()).toList());
    await prefs.setString(_hackathonsKey, encoded);
  }

  // Stats Profile (lightweight — no badges or ranks)
  static Future<GamificationProfile> loadGamificationProfile() async {
    final prefs = await SharedPreferences.getInstance();
    final String? profileJson = prefs.getString(_gamificationKey);
    if (profileJson == null || profileJson.isEmpty) {
      return GamificationProfile();
    }

    try {
      return GamificationProfile.fromJson(profileJson);
    } catch (e) {
      return GamificationProfile();
    }
  }

  static Future<void> saveGamificationProfile(GamificationProfile profile) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_gamificationKey, profile.toJson());
  }

  // Morning Routine & Streaks
  static Future<int> loadStreak() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_streakCountKey) ?? 0;
  }

  static Future<void> incrementStreak() async {
    final prefs = await SharedPreferences.getInstance();
    final now = DateTime.now();
    final todayStr = '${now.year}-${now.month}-${now.day}';
    final lastWakeStr = prefs.getString(_lastWakeDateKey);

    if (lastWakeStr != todayStr) {
      final currentStreak = prefs.getInt(_streakCountKey) ?? 0;
      await prefs.setInt(_streakCountKey, currentStreak + 1);
      await prefs.setString(_lastWakeDateKey, todayStr);
    }
  }

  static Future<bool> hasCompletedMorningRoutineToday() async {
    final prefs = await SharedPreferences.getInstance();
    final now = DateTime.now();
    final todayStr = '${now.year}-${now.month}-${now.day}';
    final lastWakeStr = prefs.getString(_lastWakeDateKey);
    return lastWakeStr == todayStr;
  }
}
