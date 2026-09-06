import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/app_colors.dart';
import '../../models/task_model.dart';
import '../../state/todo_provider.dart';

class StakeLockDialog extends StatefulWidget {
  final TaskModel task;

  const StakeLockDialog({super.key, required this.task});

  @override
  State<StakeLockDialog> createState() => _StakeLockDialogState();
}

class _StakeLockDialogState extends State<StakeLockDialog> {
  int _selectedMinutes = 30;

  void _lockStake() {
    final endTime = DateTime.now().add(Duration(minutes: _selectedMinutes));
    context.read<TodoProvider>().setTaskStakeLock(
          widget.task.id,
          endTime: endTime,
          bonusXp: 250,
        );

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: AppColors.flameRed,
        content: Row(
          children: [
            const Icon(Icons.local_fire_department_rounded, color: Colors.white),
            const SizedBox(width: 8),
            Text('🔥 Stake Locked for $_selectedMinutes mins! Earn +250 XP if done on time!'),
          ],
        ),
      ),
    );

    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: AppColors.surface,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      child: Padding(
        padding: const EdgeInsets.all(22),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppColors.flameRed.withValues(alpha: 0.15),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.local_fire_department_rounded,
                      color: AppColors.flameRed, size: 24),
                ),
                const SizedBox(width: 10),
                const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Anti-Procrastination Stake',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    Text(
                      'Commitment Contract with XP Stakes',
                      style: TextStyle(fontSize: 11, color: AppColors.textMuted),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.surfaceLight,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.border),
              ),
              child: Text(
                'Task: "${widget.task.title}"',
                style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: AppColors.textPrimary),
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Select Commitment Window:',
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: AppColors.textSecondary),
            ),
            const SizedBox(height: 10),
            Row(
              children: [15, 30, 45, 60].map((mins) {
                final isSelected = _selectedMinutes == mins;
                return Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 3),
                    child: ChoiceChip(
                      label: Center(
                        child: Text(
                          '${mins}m',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            color: isSelected ? Colors.white : AppColors.textPrimary,
                          ),
                        ),
                      ),
                      selected: isSelected,
                      selectedColor: AppColors.flameRed,
                      backgroundColor: AppColors.surfaceLight,
                      onSelected: (selected) {
                        if (selected) setState(() => _selectedMinutes = mins);
                      },
                    ),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.emeraldGreen.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.emeraldGreen.withValues(alpha: 0.3)),
              ),
              child: const Row(
                children: [
                  Icon(Icons.military_tech_rounded, color: AppColors.emeraldGreen, size: 20),
                  SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Reward: +250 Bonus XP if completed before timer expires!',
                      style: TextStyle(fontSize: 11, color: Color(0xFF6EE7B7)),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text('Cancel'),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  flex: 2,
                  child: ElevatedButton.icon(
                    onPressed: _lockStake,
                    icon: const Icon(Icons.lock_clock_rounded, size: 18),
                    label: const Text('Lock Stake 🔥'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.flameRed,
                      foregroundColor: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
