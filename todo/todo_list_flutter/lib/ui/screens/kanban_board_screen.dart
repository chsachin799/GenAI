import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/app_colors.dart';
import '../../models/task_model.dart';
import '../../state/todo_provider.dart';
import '../widgets/resource_link_chip.dart';

class KanbanBoardScreen extends StatelessWidget {
  const KanbanBoardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final todoProvider = context.watch<TodoProvider>();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Kanban Sprint Board'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SafeArea(
        child: DefaultTabController(
          length: 3,
          child: Column(
            children: [
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.border),
                ),
                child: TabBar(
                  indicatorSize: TabBarIndicatorSize.tab,
                  indicator: BoxDecoration(
                    color: AppColors.surfaceLight,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: AppColors.cyanPrimary.withValues(alpha: 0.5)),
                  ),
                  labelColor: AppColors.cyanPrimary,
                  unselectedLabelColor: AppColors.textSecondary,
                  labelStyle: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13),
                  tabs: [
                    Tab(text: 'To Do (${todoProvider.todoTasks.length})'),
                    Tab(text: 'In Progress (${todoProvider.inProgressTasks.length})'),
                    Tab(text: 'Done (${todoProvider.doneTasks.length})'),
                  ],
                ),
              ),
              Expanded(
                child: TabBarView(
                  children: [
                    _buildColumnList(context, todoProvider.todoTasks, TaskStatus.todo),
                    _buildColumnList(context, todoProvider.inProgressTasks, TaskStatus.inProgress),
                    _buildColumnList(context, todoProvider.doneTasks, TaskStatus.done),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildColumnList(BuildContext context, List<TaskModel> tasks, TaskStatus currentStatus) {
    if (tasks.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.inbox_rounded, size: 40, color: AppColors.textMuted.withValues(alpha: 0.5)),
            const SizedBox(height: 10),
            const Text(
              'No tasks in this lane',
              style: TextStyle(color: AppColors.textMuted, fontSize: 13),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: tasks.length,
      itemBuilder: (context, index) {
        final task = tasks[index];
        return _buildKanbanCard(context, task, currentStatus);
      },
    );
  }

  Widget _buildKanbanCard(BuildContext context, TaskModel task, TaskStatus currentStatus) {
    final todoProvider = context.read<TodoProvider>();

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: AppColors.cyanPrimary.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  task.category.name.toUpperCase(),
                  style: const TextStyle(
                    fontSize: 9,
                    fontWeight: FontWeight.w700,
                    color: AppColors.cyanPrimary,
                  ),
                ),
              ),
              const Spacer(),
              PopupMenuButton<TaskStatus>(
                icon: const Icon(Icons.more_horiz_rounded, color: AppColors.textMuted, size: 18),
                color: AppColors.surfaceCard,
                onSelected: (newStatus) {
                  todoProvider.updateTaskStatus(task.id, newStatus);
                },
                itemBuilder: (ctx) => [
                  const PopupMenuItem(
                    value: TaskStatus.todo,
                    child: Text('Move to "To Do" 📋'),
                  ),
                  const PopupMenuItem(
                    value: TaskStatus.inProgress,
                    child: Text('Move to "In Progress" ⚡'),
                  ),
                  const PopupMenuItem(
                    value: TaskStatus.done,
                    child: Text('Move to "Done" ✅'),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            task.title,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
          ),
          if (task.description != null && task.description!.isNotEmpty) ...[
            const SizedBox(height: 4),
            Text(
              task.description!,
              style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
          if (task.resourceLinks.isNotEmpty) ...[
            const SizedBox(height: 8),
            Wrap(
              spacing: 6,
              runSpacing: 6,
              children: task.resourceLinks.map((l) => ResourceLinkChip(link: l)).toList(),
            ),
          ],
        ],
      ),
    );
  }
}
