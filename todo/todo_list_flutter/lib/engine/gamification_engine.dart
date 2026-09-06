import '../models/gamification_model.dart';

/// Lightweight XP counter — no ranks, no levels, no badge grind.
/// Just adds earned XP to the profile for stats tracking.
class GamificationEngine {
  static GamificationProfile addXp(GamificationProfile current, int xpEarned) {
    return current.copyWith(
      totalXp: current.totalXp + xpEarned,
    );
  }
}
