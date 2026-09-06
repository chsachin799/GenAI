import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/app_colors.dart';
import '../../models/task_model.dart';
import '../../state/todo_provider.dart';
import '../screens/pomodoro_screen.dart';
import '../screens/ai_copilot_sheet.dart';
import '../screens/flashcard_study_screen.dart';
import 'stake_lock_dialog.dart';
import 'edit_task_sheet.dart';
import 'resource_link_chip.dart';

class TaskItemTile extends StatelessWidget {
  final TaskModel task;

  const TaskItemTile({
    super.key,
    required this.task,
  });

  void _showEditSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => EditTaskSheet(task: task),
    );
  }

  void _showAddLinkDialog(BuildContext context) {
    final titleController = TextEditingController();
    final urlController = TextEditingController();

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.surfaceCard,
        title: const Row(
          children: [
            Icon(Icons.link_rounded, color: AppColors.cyanPrimary),
            SizedBox(width: 8),
            Text('Attach Study/Web Link', style: TextStyle(fontSize: 16)),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: titleController,
              decoration: const InputDecoration(
                hintText: 'Resource Title (e.g., YouTube Lecture)',
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: urlController,
              decoration: const InputDecoration(
                hintText: 'URL (e.g., https://youtube.com/...)',
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              if (urlController.text.trim().isNotEmpty) {
                context.read<TodoProvider>().addResourceLink(
                      task.id,
                      titleController.text,
                      urlController.text,
                    );
              }
              Navigator.of(ctx).pop();
            },
            child: const Text('Add Link'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final todoProvider = context.read<TodoProvider>();

    Color priorityColor;
    switch (task.priority) {
      case TaskPriority.high:
        priorityColor = AppColors.priorityHigh;
        break;
      case TaskPriority.medium:
        priorityColor = AppColors.priorityMedium;
        break;
      case TaskPriority.low:
        priorityColor = AppColors.priorityLow;
        break;
    }

    Color categoryColor;
    String categoryName;
    switch (task.category) {
      case TaskCategory.hackathon:
        categoryColor = AppColors.tagHackathon;
        categoryName = 'Hackathon';
        break;
      case TaskCategory.dev:
        categoryColor = AppColors.tagDev;
        categoryName = 'Dev';
        break;
      case TaskCategory.study:
        categoryColor = AppColors.tagStudy;
        categoryName = 'Study';
        break;
      case TaskCategory.personal:
        categoryColor = AppColors.tagPersonal;
        categoryName = 'Personal';
        break;
      case TaskCategory.morningFocus:
        categoryColor = AppColors.morningGlow;
        categoryName = 'Wake Focus';
        break;
    }

    final isStakeActive = task.isStakeActive;
    final remainingStake = task.remainingStakeDuration;

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: task.isCompleted
            ? AppColors.surface.withValues(alpha: 0.4)
            : (isStakeActive
                ? const Color(0xFF1F1212)
                : AppColors.surface),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: task.isCompleted
              ? AppColors.border.withValues(alpha: 0.3)
              : (isStakeActive
                  ? AppColors.flameRed.withValues(alpha: 0.7)
                  : AppColors.border),
          width: isStakeActive ? 1.5 : 1.0,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Main Row: Checkbox, Title, Description, Quick Launch, Actions Menu
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GestureDetector(
                onTap: () => todoProvider.toggleTaskCompletion(task.id),
                child: Padding(
                  padding: const EdgeInsets.only(top: 2, right: 12),
                  child: Icon(
                    task.isCompleted
                        ? Icons.check_circle_rounded
                        : Icons.radio_button_unchecked_rounded,
                    color: task.isCompleted
                        ? AppColors.emeraldGreen
                        : (isStakeActive ? AppColors.flameRed : AppColors.cyanPrimary),
                    size: 22,
                  ),
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      task.title,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: task.isCompleted
                            ? AppColors.textMuted
                            : AppColors.textPrimary,
                        decoration: task.isCompleted
                            ? TextDecoration.lineThrough
                            : null,
                      ),
                    ),
                    if (task.description != null &&
                        task.description!.isNotEmpty) ...[
                      const SizedBox(height: 3),
                      Text(
                        task.description!,
                        style: TextStyle(
                          fontSize: 12,
                          color: task.isCompleted
                              ? AppColors.textMuted.withValues(alpha: 0.6)
                              : AppColors.textSecondary,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ],
                ),
              ),
              // Focus Timer Quick Button
              if (!task.isCompleted)
                IconButton(
                  tooltip: 'Start 25m Focus',
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                  icon: const Icon(Icons.play_circle_fill_rounded,
                      size: 22, color: AppColors.flameOrange),
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => PomodoroScreen(activeTask: task),
                      ),
                    );
                  },
                ),
              const SizedBox(width: 6),
              // 3-Dots Action Menu (Clean hub for Copilot, Split, Cards, Stake, Edit, Delete)
              PopupMenuButton<String>(
                icon: const Icon(Icons.more_vert_rounded,
                    color: AppColors.textMuted, size: 18),
                color: AppColors.surfaceCard,
                tooltip: 'More Actions',
                onSelected: (action) {
                  switch (action) {
                    case 'copilot':
                      showModalBottomSheet(
                        context: context,
                        isScrollControlled: true,
                        backgroundColor: Colors.transparent,
                        builder: (_) => AiCopilotSheet(taskTitle: task.title),
                      );
                      break;
                    case 'split':
                      todoProvider.splitTaskWithAi(task.id);
                      break;
                    case 'cards':
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => FlashcardStudyScreen(taskTitle: task.title),
                        ),
                      );
                      break;
                    case 'stake':
                      showDialog(
                        context: context,
                        builder: (_) => StakeLockDialog(task: task),
                      );
                      break;
                    case 'add_link':
                      _showAddLinkDialog(context);
                      break;
                    case 'edit':
                      _showEditSheet(context);
                      break;
                    case 'delete':
                      todoProvider.deleteTask(task.id);
                      break;
                  }
                },
                itemBuilder: (ctx) => [
                  const PopupMenuItem(
                    value: 'copilot',
                    child: Row(
                      children: [
                        Icon(Icons.psychology_rounded, size: 16, color: Color(0xFF818CF8)),
                        SizedBox(width: 8),
                        Text('Ask AI Copilot 🤖'),
                      ],
                    ),
                  ),
                  if (task.subtasks.isEmpty)
                    const PopupMenuItem(
                      value: 'split',
                      child: Row(
                        children: [
                          Icon(Icons.auto_awesome, size: 16, color: AppColors.cyanPrimary),
                          SizedBox(width: 8),
                          Text('AI Smart Split 🧠'),
                        ],
                      ),
                    ),
                  const PopupMenuItem(
                    value: 'cards',
                    child: Row(
                      children: [
                        Icon(Icons.style_rounded, size: 16, color: Color(0xFFA78BFA)),
                        SizedBox(width: 8),
                        Text('Study Flashcards 🃏'),
                      ],
                    ),
                  ),
                  if (!task.isCompleted && !isStakeActive)
                    const PopupMenuItem(
                      value: 'stake',
                      child: Row(
                        children: [
                          Icon(Icons.local_fire_department_rounded, size: 16, color: AppColors.flameRed),
                          SizedBox(width: 8),
                          Text('Anti-Procrastination Stake 🔥'),
                        ],
                      ),
                    ),
                  const PopupMenuItem(
                    value: 'add_link',
                    child: Row(
                      children: [
                        Icon(Icons.link_rounded, size: 16, color: AppColors.cyanPrimary),
                        SizedBox(width: 8),
                        Text('Attach Study Link 🔗'),
                      ],
                    ),
                  ),
                  const PopupMenuDivider(),
                  const PopupMenuItem(
                    value: 'edit',
                    child: Row(
                      children: [
                        Icon(Icons.edit_outlined, size: 16, color: AppColors.textSecondary),
                        SizedBox(width: 8),
                        Text('Edit Task ✏️'),
                      ],
                    ),
                  ),
                  const PopupMenuItem(
                    value: 'delete',
                    child: Row(
                      children: [
                        Icon(Icons.delete_outline_rounded, size: 16, color: AppColors.flameRed),
                        SizedBox(width: 8),
                        Text('Delete Task 🗑️'),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),

          // Active Stake Warning (if locked)
          if (isStakeActive) ...[
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: AppColors.flameRed.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(6),
                border: Border.all(color: AppColors.flameRed.withValues(alpha: 0.4)),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.timer_rounded, size: 12, color: AppColors.flameRed),
                  const SizedBox(width: 6),
                  Text(
                    'Stake Active: ${remainingStake.inMinutes}m ${remainingStake.inSeconds % 60}s remaining',
                    style: const TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w800,
                      color: AppColors.flameRed,
                    ),
                  ),
                ],
              ),
            ),
          ],

          // Attached Resource Links (YouTube, Docs, GitHub)
          if (task.resourceLinks.isNotEmpty) ...[
            const SizedBox(height: 10),
            Wrap(
              spacing: 6,
              runSpacing: 6,
              children: task.resourceLinks
                  .map((link) => ResourceLinkChip(link: link))
                  .toList(),
            ),
          ],

          // Subtasks Decomposition (AI Smart Splitter)
          if (task.subtasks.isNotEmpty) ...[
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: AppColors.surfaceLight.withValues(alpha: 0.6),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: AppColors.border),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.auto_awesome, size: 13, color: AppColors.cyanPrimary),
                      const SizedBox(width: 6),
                      const Text(
                        'Micro-Steps',
                        style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: AppColors.cyanPrimary),
                      ),
                      const Spacer(),
                      Text(
                        '${(task.subtaskProgress * 100).toInt()}% Done',
                        style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: AppColors.textMuted),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(3),
                    child: LinearProgressIndicator(
                      value: task.subtaskProgress,
                      backgroundColor: AppColors.surfaceCard,
                      valueColor: const AlwaysStoppedAnimation<Color>(AppColors.cyanPrimary),
                      minHeight: 4,
                    ),
                  ),
                  const SizedBox(height: 8),
                  ...task.subtasks.map((subtask) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 4),
                      child: InkWell(
                        onTap: () => todoProvider.toggleSubtask(task.id, subtask.id),
                        child: Row(
                          children: [
                            Icon(
                              subtask.isCompleted
                                  ? Icons.check_box_rounded
                                  : Icons.check_box_outline_blank_rounded,
                              size: 16,
                              color: subtask.isCompleted ? AppColors.emeraldGreen : AppColors.textMuted,
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                subtask.title,
                                style: TextStyle(
                                  fontSize: 11,
                                  color: subtask.isCompleted ? AppColors.textMuted : AppColors.textPrimary,
                                  decoration: subtask.isCompleted ? TextDecoration.lineThrough : null,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }),
                ],
              ),
            ),
          ],

          const SizedBox(height: 8),
          // Clean Minimal Badges Row
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: categoryColor.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  categoryName,
                  style: TextStyle(fontSize: 9, fontWeight: FontWeight.w700, color: categoryColor),
                ),
              ),
              const SizedBox(width: 6),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: priorityColor.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  task.priority.name.toUpperCase(),
                  style: TextStyle(fontSize: 9, fontWeight: FontWeight.w700, color: priorityColor),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
