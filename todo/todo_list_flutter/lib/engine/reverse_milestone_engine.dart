import 'package:uuid/uuid.dart';
import '../models/milestone_model.dart';
import '../models/hackathon_model.dart';

/// Novel Reverse Milestone Decomposition Engine
/// Dynamically breaks down total sprint duration T into weighted milestones
/// and guarantees a safety buffer (Quarantine Phase) before the hard cutoff.
class ReverseMilestoneEngine {
  static const _uuid = Uuid();

  /// Generates the standard 4-stage reverse milestone timeline
  static List<MilestoneModel> generateMilestones({
    required DateTime startDate,
    required DateTime deadline,
  }) {
    final totalDuration = deadline.difference(startDate);
    if (totalDuration.inMinutes <= 0) return [];

    final totalSeconds = totalDuration.inSeconds;

    // Phase 1: Team & Ideation Setup (10% of duration)
    final phase1End = startDate.add(Duration(seconds: (totalSeconds * 0.10).round()));

    // Phase 2: Core MVP & Tech Build (60% of duration)
    final phase2End = phase1End.add(Duration(seconds: (totalSeconds * 0.60).round()));

    // Phase 3: Demo Video & Pitch Deck Creation (20% of duration)
    final phase3End = phase2End.add(Duration(seconds: (totalSeconds * 0.20).round()));

    // Phase 4: Final 2-Hour / 10% Submission Safety Buffer (Hard Stop Quarantine)
    final phase4End = deadline;

    return [
      MilestoneModel(
        id: _uuid.v4(),
        title: 'Phase 1: Architecture & Scope Lock',
        description: 'Define problem, design UX mockup & setup repository / API keys',
        percentageWeight: 0.10,
        targetTime: phase1End,
        isCompleted: false,
      ),
      MilestoneModel(
        id: _uuid.v4(),
        title: 'Phase 2: Core MVP Build & Features',
        description: 'Implement core functionality, backend logic, and working frontend',
        percentageWeight: 0.60,
        targetTime: phase2End,
        isCompleted: false,
      ),
      MilestoneModel(
        id: _uuid.v4(),
        title: 'Phase 3: Demo Video & Pitch Deck',
        description: 'Record 2-minute video, test deployment, and assemble presentation slides',
        percentageWeight: 0.20,
        targetTime: phase3End,
        isCompleted: false,
      ),
      MilestoneModel(
        id: _uuid.v4(),
        title: 'Phase 4: Devpost Submission Quarantine',
        description: 'Hard-stop code freeze. Make repo public, verify video link & submit early',
        percentageWeight: 0.10,
        targetTime: phase4End,
        isCompleted: false,
        isQuarantinePhase: true,
      ),
    ];
  }

  /// Default critical deliverables for any hackathon submission
  static List<HackathonDeliverable> generateDefaultDeliverables() {
    return [
      HackathonDeliverable(
        id: _uuid.v4(),
        title: '2-Minute Video Demo (YouTube / Loom / Vimeo)',
        isDone: false,
      ),
      HackathonDeliverable(
        id: _uuid.v4(),
        title: 'Public GitHub Repository with README & License',
        isDone: false,
      ),
      HackathonDeliverable(
        id: _uuid.v4(),
        title: 'Live Demo URL / Working APK / Deployment Test',
        isDone: false,
      ),
      HackathonDeliverable(
        id: _uuid.v4(),
        title: 'Devpost / Platform Project Story & Tech Stack Form',
        isDone: false,
      ),
      HackathonDeliverable(
        id: _uuid.v4(),
        title: 'Pitch Deck / Slides PDF uploaded',
        isDone: false,
      ),
    ];
  }
}
