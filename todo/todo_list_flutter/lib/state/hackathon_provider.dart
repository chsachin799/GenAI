import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:uuid/uuid.dart';
import '../models/hackathon_model.dart';
import '../engine/reverse_milestone_engine.dart';
import '../core/local_storage.dart';

class HackathonProvider extends ChangeNotifier {
  final _uuid = const Uuid();
  List<HackathonModel> _hackathons = [];
  bool _isLoading = true;
  Timer? _tickerTimer;

  List<HackathonModel> get hackathons => _hackathons;
  bool get isLoading => _isLoading;

  // Active hackathons (not expired or completed)
  List<HackathonModel> get activeHackathons {
    final now = DateTime.now();
    return _hackathons
        .where((h) => !h.isCompleted && h.submissionDeadline.isAfter(now))
        .toList()
      ..sort((a, b) => a.submissionDeadline.compareTo(b.submissionDeadline));
  }

  // The single most pressing hackathon for the top HUD banner
  HackathonModel? get mostPressingHackathon {
    final active = activeHackathons;
    if (active.isEmpty) return null;
    return active.first;
  }

  HackathonProvider() {
    loadData();
    _startTicker();
  }

  @override
  void dispose() {
    _tickerTimer?.cancel();
    super.dispose();
  }

  void _startTicker() {
    _tickerTimer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (activeHackathons.isNotEmpty) {
        notifyListeners();
      }
    });
  }

  Future<void> loadData() async {
    _isLoading = true;
    notifyListeners();

    _hackathons = await LocalStorageService.loadHackathons();

    if (_hackathons.isEmpty) {
      _seedDefaultHackathon();
    }

    _isLoading = false;
    notifyListeners();
  }

  void _seedDefaultHackathon() {
    final now = DateTime.now();
    // Default demo hackathon ending in 36 hours
    final deadline = now.add(const Duration(hours: 36, minutes: 30));
    final milestones = ReverseMilestoneEngine.generateMilestones(
      startDate: now,
      deadline: deadline,
    );
    final deliverables = ReverseMilestoneEngine.generateDefaultDeliverables();

    final defaultHackathon = HackathonModel(
      id: _uuid.v4(),
      name: 'Global AI & Web3 Hackathon 2026',
      platform: 'Devpost',
      startDate: now,
      submissionDeadline: deadline,
      projectTheme: 'AI Agents & Circadian Productivity Apps',
      registrationUrl: 'https://devpost.com',
      milestones: milestones,
      deliverables: deliverables,
    );

    _hackathons.add(defaultHackathon);
    _persistHackathons();
  }

  Future<void> addHackathon({
    required String name,
    required String platform,
    required DateTime startDate,
    required DateTime deadline,
    String? projectTheme,
    String? registrationUrl,
  }) async {
    final milestones = ReverseMilestoneEngine.generateMilestones(
      startDate: startDate,
      deadline: deadline,
    );
    final deliverables = ReverseMilestoneEngine.generateDefaultDeliverables();

    final newHackathon = HackathonModel(
      id: _uuid.v4(),
      name: name.trim(),
      platform: platform.trim(),
      startDate: startDate,
      submissionDeadline: deadline,
      projectTheme: projectTheme?.trim(),
      registrationUrl: registrationUrl?.trim(),
      milestones: milestones,
      deliverables: deliverables,
    );

    _hackathons.add(newHackathon);
    notifyListeners();
    await _persistHackathons();
  }

  Future<void> toggleMilestone(String hackathonId, String milestoneId) async {
    final hIndex = _hackathons.indexWhere((h) => h.id == hackathonId);
    if (hIndex == -1) return;

    final hackathon = _hackathons[hIndex];
    final updatedMilestones = hackathon.milestones.map((m) {
      if (m.id == milestoneId) {
        return m.copyWith(isCompleted: !m.isCompleted);
      }
      return m;
    }).toList();

    _hackathons[hIndex] = hackathon.copyWith(milestones: updatedMilestones);
    notifyListeners();
    await _persistHackathons();
  }

  Future<void> toggleDeliverable(
      String hackathonId, String deliverableId) async {
    final hIndex = _hackathons.indexWhere((h) => h.id == hackathonId);
    if (hIndex == -1) return;

    final hackathon = _hackathons[hIndex];
    final updatedDeliverables = hackathon.deliverables.map((d) {
      if (d.id == deliverableId) {
        return d.copyWith(isDone: !d.isDone);
      }
      return d;
    }).toList();

    _hackathons[hIndex] =
        hackathon.copyWith(deliverables: updatedDeliverables);
    notifyListeners();
    await _persistHackathons();
  }

  Future<void> updateHackathon(HackathonModel updatedHackathon) async {
    final index = _hackathons.indexWhere((h) => h.id == updatedHackathon.id);
    if (index != -1) {
      _hackathons[index] = updatedHackathon;
      notifyListeners();
      await _persistHackathons();
    }
  }

  Future<void> deleteHackathon(String id) async {
    _hackathons.removeWhere((h) => h.id == id);
    notifyListeners();
    await _persistHackathons();
  }

  Future<void> _persistHackathons() async {
    await LocalStorageService.saveHackathons(_hackathons);
  }
}
