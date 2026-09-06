class SpacedRepetitionItem {
  final int stage; // 1 (1d), 2 (3d), 3 (7d)
  final DateTime nextReviewDate;
  final bool isDue;

  SpacedRepetitionItem({
    required this.stage,
    required this.nextReviewDate,
    required this.isDue,
  });

  static SpacedRepetitionItem calculateNext(DateTime completedAt, int currentStage) {
    final now = DateTime.now();
    int daysToAdd = 1;
    if (currentStage == 1) daysToAdd = 3;
    if (currentStage == 2) daysToAdd = 7;

    final next = completedAt.add(Duration(days: daysToAdd));
    return SpacedRepetitionItem(
      stage: currentStage + 1,
      nextReviewDate: next,
      isDue: now.isAfter(next),
    );
  }
}
