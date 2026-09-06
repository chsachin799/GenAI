import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/app_colors.dart';
import '../../state/todo_provider.dart';

class MorningRoutineScreen extends StatefulWidget {
  const MorningRoutineScreen({super.key});

  @override
  State<MorningRoutineScreen> createState() => _MorningRoutineScreenState();
}

class _MorningRoutineScreenState extends State<MorningRoutineScreen> {
  final _goal1Controller = TextEditingController();
  final _goal2Controller = TextEditingController();
  final _goal3Controller = TextEditingController();

  final List<String> _quickPicks = [
    'Fix Hackathon MVP Bug',
    'Record 2-Min Demo Video',
    'Write Devpost Story',
    'Study 2 Focus Hours',
    'Solve 2 LeetCode Problems',
    'Drink 500ml Water & Stretch',
  ];

  @override
  void initState() {
    super.initState();
    // Pre-populate with existing focus tasks if any
    final focus = context.read<TodoProvider>().morningFocusTasks;
    if (focus.isNotEmpty) _goal1Controller.text = focus[0].title;
    if (focus.length > 1) _goal2Controller.text = focus[1].title;
    if (focus.length > 2) _goal3Controller.text = focus[2].title;
  }

  @override
  void dispose() {
    _goal1Controller.dispose();
    _goal2Controller.dispose();
    _goal3Controller.dispose();
    super.dispose();
  }

  void _lockInFocus() {
    final titles = [
      _goal1Controller.text,
      _goal2Controller.text,
      _goal3Controller.text,
    ].where((t) => t.trim().isNotEmpty).toList();

    if (titles.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter at least 1 core goal for today!'),
          backgroundColor: AppColors.flameOrange,
        ),
      );
      return;
    }

    context.read<TodoProvider>().setMorningFocusTasks(titles);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Row(
          children: [
            Icon(Icons.local_fire_department_rounded, color: Colors.white),
            SizedBox(width: 8),
            Text('Daily streak boosted! Top 3 goals locked in.'),
          ],
        ),
        backgroundColor: AppColors.emeraldGreen,
        duration: Duration(seconds: 2),
      ),
    );

    Navigator.of(context).pop();
  }

  void _addQuickPick(String text) {
    if (_goal1Controller.text.isEmpty) {
      setState(() => _goal1Controller.text = text);
    } else if (_goal2Controller.text.isEmpty) {
      setState(() => _goal2Controller.text = text);
    } else if (_goal3Controller.text.isEmpty) {
      setState(() => _goal3Controller.text = text);
    }
  }

  @override
  Widget build(BuildContext context) {
    final streak = context.watch<TodoProvider>().streakCount;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Morning Kickstart'),
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
              // Hero Morning Banner
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  gradient: const LinearGradient(
                    colors: [
                      Color(0xFF0F2027),
                      Color(0xFF203A43),
                      Color(0xFF2C5364),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  border: Border.all(
                    color: AppColors.cyanPrimary.withValues(alpha: 0.3),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(
                          Icons.wb_sunny_rounded,
                          color: AppColors.cyanPrimary,
                          size: 28,
                        ),
                        const SizedBox(width: 10),
                        const Text(
                          'Zero-Decision Morning',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w800,
                            color: Colors.white,
                          ),
                        ),
                        const Spacer(),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.black.withValues(alpha: 0.3),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            '$streak Day Streak 🔥',
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                              color: AppColors.flameOrange,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      'Before notifications and messages overwhelm you, define the 3 highest-leverage tasks that make today a win.',
                      style: TextStyle(
                        fontSize: 13,
                        color: Color(0xFFD1D5DB),
                        height: 1.4,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              // Goal Inputs
              _buildGoalInput(
                controller: _goal1Controller,
                number: 1,
                label: 'Goal #1 (Highest Leverage / Critical Rock)',
                hint: 'e.g., Complete core hackathon MVP feature',
                color: AppColors.flameOrange,
              ),
              const SizedBox(height: 16),
              _buildGoalInput(
                controller: _goal2Controller,
                number: 2,
                label: 'Goal #2 (Secondary High Priority)',
                hint: 'e.g., Prepare demo script & slides',
                color: AppColors.cyanPrimary,
              ),
              const SizedBox(height: 16),
              _buildGoalInput(
                controller: _goal3Controller,
                number: 3,
                label: 'Goal #3 (Personal / Daily Health)',
                hint: 'e.g., Drink water & workout',
                color: AppColors.emeraldGreen,
              ),
              const SizedBox(height: 24),
              // Quick Picks
              const Text(
                'Quick Tap Suggestions:',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: 10),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: _quickPicks.map((pick) {
                  return ActionChip(
                    label: Text(
                      '+ $pick',
                      style: const TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    backgroundColor: AppColors.surfaceLight,
                    side: const BorderSide(color: AppColors.border),
                    onPressed: () => _addQuickPick(pick),
                  );
                }).toList(),
              ),
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton.icon(
                  onPressed: _lockInFocus,
                  icon: const Icon(Icons.lock_clock_rounded, size: 20),
                  label: const Text('Lock In Today’s Focus'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.cyanPrimary,
                    foregroundColor: Colors.black,
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

  Widget _buildGoalInput({
    required TextEditingController controller,
    required int number,
    required String label,
    required String hint,
    required Color color,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              width: 22,
              height: 22,
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.2),
                shape: BoxShape.circle,
                border: Border.all(color: color, width: 1.5),
              ),
              alignment: Alignment.center,
              child: Text(
                '$number',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w800,
                  color: color,
                ),
              ),
            ),
            const SizedBox(width: 8),
            Text(
              label,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          style: const TextStyle(color: AppColors.textPrimary, fontSize: 14),
          decoration: InputDecoration(
            hintText: hint,
            suffixIcon: IconButton(
              icon: const Icon(Icons.clear, size: 16, color: AppColors.textMuted),
              onPressed: () => controller.clear(),
            ),
          ),
        ),
      ],
    );
  }
}
