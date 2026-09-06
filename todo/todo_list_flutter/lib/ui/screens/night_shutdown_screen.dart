import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/app_colors.dart';
import '../../state/todo_provider.dart';

class NightShutdownScreen extends StatefulWidget {
  const NightShutdownScreen({super.key});

  @override
  State<NightShutdownScreen> createState() => _NightShutdownScreenState();
}

class _NightShutdownScreenState extends State<NightShutdownScreen> {
  final _winController = TextEditingController();
  final _learnedController = TextEditingController();
  int _energyRating = 4;

  @override
  void dispose() {
    _winController.dispose();
    _learnedController.dispose();
    super.dispose();
  }

  void _finishShutdown() {
    context.read<TodoProvider>().recordPomodoroSession(minutes: 5); // XP boost
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Row(
          children: [
            Icon(Icons.bedtime_rounded, color: Colors.white),
            SizedBox(width: 8),
            Text('🌙 Night shutdown complete! +150 XP bonus earned.'),
          ],
        ),
        backgroundColor: Color(0xFF6366F1),
      ),
    );
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final todoProvider = context.watch<TodoProvider>();
    final completedCount = todoProvider.totalCompletedCount;
    final totalCount = todoProvider.tasks.length;
    final profile = todoProvider.profile;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Night Shutdown & Recap'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Hero Night Banner
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(22),
                  border: Border.all(color: const Color(0xFF6366F1).withValues(alpha: 0.4)),
                  gradient: const LinearGradient(
                    colors: [
                      Color(0xFF0F172A),
                      Color(0xFF1E1B4B),
                      Color(0xFF312E81),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Row(
                      children: [
                        Icon(Icons.nightlight_round, color: Color(0xFFA5B4FC), size: 26),
                        SizedBox(width: 10),
                        Text(
                          'Daily Win Recap',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w800,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'You crushed $completedCount out of $totalCount objectives today and collected ${profile.totalXp} XP total!',
                      style: const TextStyle(fontSize: 13, color: Color(0xFFE0E7FF), height: 1.4),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Win of the day
              const Text(
                '1. What was your biggest win today?',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: AppColors.textPrimary),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: _winController,
                style: const TextStyle(color: AppColors.textPrimary, fontSize: 13),
                decoration: const InputDecoration(
                  hintText: 'e.g., Finished PyTorch CNN architecture & pushed to repo!',
                ),
              ),
              const SizedBox(height: 20),

              // One concept learned
              const Text(
                '2. One concept or technique you learned today?',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: AppColors.textPrimary),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: _learnedController,
                style: const TextStyle(color: AppColors.textPrimary, fontSize: 13),
                decoration: const InputDecoration(
                  hintText: 'e.g., Learned how sliding window avoids O(N^2) complexity',
                ),
              ),
              const SizedBox(height: 20),

              // Energy Rating
              const Text(
                '3. How satisfied are you with today’s execution?',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: AppColors.textPrimary),
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(5, (index) {
                  final rating = index + 1;
                  return IconButton(
                    icon: Icon(
                      rating <= _energyRating ? Icons.star_rounded : Icons.star_outline_rounded,
                      color: const Color(0xFFFBBF24),
                      size: 36,
                    ),
                    onPressed: () => setState(() => _energyRating = rating),
                  );
                }),
              ),
              const SizedBox(height: 32),

              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton.icon(
                  onPressed: _finishShutdown,
                  icon: const Icon(Icons.bedtime_rounded, size: 20),
                  label: const Text('Lock In Daily Win & Sleep 🌙'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF6366F1),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
