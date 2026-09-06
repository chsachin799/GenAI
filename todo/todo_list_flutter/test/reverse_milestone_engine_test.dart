import 'package:flutter_test/flutter_test.dart';
import 'package:todo_list_flutter/engine/reverse_milestone_engine.dart';

void main() {
  group('ReverseMilestoneEngine Tests', () {
    test('Calculates 4 weighted milestone phases accurately', () {
      final start = DateTime(2026, 1, 1, 10, 0);
      final deadline = DateTime(2026, 1, 3, 10, 0); // 48 hours

      final milestones = ReverseMilestoneEngine.generateMilestones(
        startDate: start,
        deadline: deadline,
      );

      expect(milestones.length, 4);

      // Verify phase titles & quarantine
      expect(milestones[0].title.contains('Phase 1'), isTrue);
      expect(milestones[0].percentageWeight, 0.10);

      expect(milestones[1].title.contains('Phase 2'), isTrue);
      expect(milestones[1].percentageWeight, 0.60);

      expect(milestones[2].title.contains('Phase 3'), isTrue);
      expect(milestones[2].percentageWeight, 0.20);

      expect(milestones[3].title.contains('Phase 4'), isTrue);
      expect(milestones[3].percentageWeight, 0.10);
      expect(milestones[3].isQuarantinePhase, isTrue);

      // Verify final target time matches deadline
      expect(milestones[3].targetTime, deadline);
    });

    test('Generates default critical deliverables list', () {
      final deliverables = ReverseMilestoneEngine.generateDefaultDeliverables();
      expect(deliverables.isNotEmpty, isTrue);
      expect(deliverables.any((d) => d.title.contains('Video Demo')), isTrue);
      expect(deliverables.any((d) => d.title.contains('GitHub')), isTrue);
    });
  });
}
