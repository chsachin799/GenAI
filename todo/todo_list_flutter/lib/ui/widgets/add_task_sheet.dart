import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import '../../core/app_colors.dart';
import '../../models/task_model.dart';
import '../../models/resource_link_model.dart';
import '../../models/subtask_model.dart';
import '../../engine/task_splitter_engine.dart';
import '../../state/todo_provider.dart';
import '../../state/hackathon_provider.dart';

class AddTaskSheet extends StatefulWidget {
  const AddTaskSheet({super.key});

  @override
  State<AddTaskSheet> createState() => _AddTaskSheetState();
}

class _AddTaskSheetState extends State<AddTaskSheet> {
  final _uuid = const Uuid();
  final _titleController = TextEditingController();
  final _descController = TextEditingController();
  final _linkTitleController = TextEditingController();
  final _linkUrlController = TextEditingController();

  TaskPriority _priority = TaskPriority.medium;
  TaskCategory _category = TaskCategory.personal;
  bool _isMorningFocus = false;
  bool _autoSplitWithAi = false;
  String? _linkedHackathonId;

  final List<ResourceLinkModel> _tempLinks = [];

  @override
  void dispose() {
    _titleController.dispose();
    _descController.dispose();
    _linkTitleController.dispose();
    _linkUrlController.dispose();
    super.dispose();
  }

  void _addLink() {
    if (_linkUrlController.text.trim().isEmpty) return;

    final url = _linkUrlController.text.trim();
    final title = _linkTitleController.text.trim().isEmpty
        ? url
        : _linkTitleController.text.trim();

    setState(() {
      _tempLinks.add(
        ResourceLinkModel(
          id: _uuid.v4(),
          title: title,
          url: url,
          type: ResourceLinkModel.detectType(url),
        ),
      );
      _linkTitleController.clear();
      _linkUrlController.clear();
    });
  }

  void _saveTask() {
    if (_titleController.text.trim().isEmpty) return;

    final subtasks = _autoSplitWithAi
        ? TaskSplitterEngine.splitTask(_titleController.text)
        : <SubtaskModel>[];

    context.read<TodoProvider>().addTask(
          title: _titleController.text,
          description: _descController.text,
          priority: _priority,
          category: _category,
          isMorningFocus: _isMorningFocus,
          linkedHackathonId: _linkedHackathonId,
          resourceLinks: _tempLinks,
          subtasks: subtasks,
        );

    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final hackathonProvider = context.watch<HackathonProvider>();
    final activeHackathons = hackathonProvider.activeHackathons;

    return Container(
      padding: EdgeInsets.only(
        left: 20,
        right: 20,
        top: 20,
        bottom: MediaQuery.of(context).viewInsets.bottom + 20,
      ),
      decoration: const BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Text(
                  'Add New Task',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                ),
                const Spacer(),
                IconButton(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: const Icon(Icons.close, color: AppColors.textMuted),
                ),
              ],
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _titleController,
              autofocus: true,
              style: const TextStyle(color: AppColors.textPrimary),
              decoration: const InputDecoration(
                hintText: 'What needs to be done? (e.g., Study AIML 8-10pm)',
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _descController,
              style: const TextStyle(color: AppColors.textPrimary),
              maxLines: 2,
              decoration: const InputDecoration(
                hintText: 'Additional details or notes (optional)',
              ),
            ),
            const SizedBox(height: 16),

            // AI Smart Task Splitter Checkbox
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: AppColors.cyanPrimary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                    color: AppColors.cyanPrimary.withValues(alpha: 0.3)),
              ),
              child: Row(
                children: [
                  const Icon(Icons.auto_awesome,
                      color: AppColors.cyanPrimary, size: 20),
                  const SizedBox(width: 10),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'AI Smart Task Splitter',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                            color: AppColors.cyanPrimary,
                          ),
                        ),
                        Text(
                          'Auto-decompose into 5-7 micro-steps',
                          style: TextStyle(
                              fontSize: 11, color: AppColors.textSecondary),
                        ),
                      ],
                    ),
                  ),
                  Switch(
                    value: _autoSplitWithAi,
                    activeThumbColor: AppColors.cyanPrimary,
                    onChanged: (val) => setState(() => _autoSplitWithAi = val),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Attached Resource Links (YouTube, Docs, GitHub, Web)
            const Text(
              'Attach Web/YouTube Links',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  flex: 2,
                  child: TextField(
                    controller: _linkTitleController,
                    style: const TextStyle(fontSize: 12, color: AppColors.textPrimary),
                    decoration: const InputDecoration(
                      hintText: 'Title (e.g. YouTube Part 1)',
                      contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  flex: 3,
                  child: TextField(
                    controller: _linkUrlController,
                    style: const TextStyle(fontSize: 12, color: AppColors.textPrimary),
                    decoration: const InputDecoration(
                      hintText: 'https://youtube.com/...',
                      contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(
                  onPressed: _addLink,
                  icon: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: AppColors.cyanPrimary,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(Icons.add_link_rounded,
                        color: Colors.black, size: 18),
                  ),
                ),
              ],
            ),
            if (_tempLinks.isNotEmpty) ...[
              const SizedBox(height: 10),
              Wrap(
                spacing: 6,
                runSpacing: 6,
                children: _tempLinks.map((link) {
                  return Chip(
                    label: Text(link.title, style: const TextStyle(fontSize: 11)),
                    backgroundColor: AppColors.surfaceLight,
                    deleteIcon: const Icon(Icons.close, size: 14),
                    onDeleted: () {
                      setState(() => _tempLinks.remove(link));
                    },
                  );
                }).toList(),
              ),
            ],
            const SizedBox(height: 16),

            // Priority Selector
            const Text(
              'Priority',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: TaskPriority.values.map((priority) {
                final isSelected = _priority == priority;
                Color color;
                switch (priority) {
                  case TaskPriority.high:
                    color = AppColors.priorityHigh;
                    break;
                  case TaskPriority.medium:
                    color = AppColors.priorityMedium;
                    break;
                  case TaskPriority.low:
                    color = AppColors.priorityLow;
                    break;
                }

                return Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: ChoiceChip(
                      label: Center(
                        child: Text(
                          priority.name.toUpperCase(),
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                            color: isSelected ? Colors.white : color,
                          ),
                        ),
                      ),
                      selected: isSelected,
                      selectedColor: color,
                      backgroundColor: AppColors.surfaceLight,
                      onSelected: (selected) {
                        if (selected) setState(() => _priority = priority);
                      },
                    ),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 16),

            // Category Selector
            const Text(
              'Category',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              children: TaskCategory.values.map((category) {
                final isSelected = _category == category;
                return ChoiceChip(
                  label: Text(
                    category.name.toUpperCase(),
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: isSelected ? Colors.black : AppColors.textSecondary,
                    ),
                  ),
                  selected: isSelected,
                  selectedColor: AppColors.cyanPrimary,
                  backgroundColor: AppColors.surfaceLight,
                  onSelected: (selected) {
                    if (selected) setState(() => _category = category);
                  },
                );
              }).toList(),
            ),
            const SizedBox(height: 16),

            // Morning Focus Toggle
            SwitchListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text(
                'Pin as Morning Focus Goal',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
              subtitle: const Text(
                'Show on the top wake-up widget',
                style: TextStyle(fontSize: 12, color: AppColors.textMuted),
              ),
              value: _isMorningFocus,
              activeThumbColor: AppColors.cyanPrimary,
              onChanged: (val) => setState(() => _isMorningFocus = val),
            ),

            if (activeHackathons.isNotEmpty) ...[
              const SizedBox(height: 8),
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(
                  labelText: 'Link to Hackathon (Optional)',
                ),
                dropdownColor: AppColors.surfaceCard,
                initialValue: _linkedHackathonId,
                items: [
                  const DropdownMenuItem(
                    value: null,
                    child: Text('None',
                        style: TextStyle(color: AppColors.textSecondary)),
                  ),
                  ...activeHackathons.map((h) => DropdownMenuItem(
                        value: h.id,
                        child: Text(h.name,
                            style: const TextStyle(
                                color: AppColors.textPrimary, fontSize: 13)),
                      )),
                ],
                onChanged: (val) => setState(() => _linkedHackathonId = val),
              ),
            ],
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                onPressed: _saveTask,
                child: const Text('Add Task'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
