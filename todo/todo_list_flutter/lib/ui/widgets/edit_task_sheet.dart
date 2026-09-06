import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import '../../core/app_colors.dart';
import '../../models/task_model.dart';
import '../../models/resource_link_model.dart';
import '../../state/todo_provider.dart';
import '../../state/hackathon_provider.dart';

class EditTaskSheet extends StatefulWidget {
  final TaskModel task;

  const EditTaskSheet({super.key, required this.task});

  @override
  State<EditTaskSheet> createState() => _EditTaskSheetState();
}

class _EditTaskSheetState extends State<EditTaskSheet> {
  final _uuid = const Uuid();
  late TextEditingController _titleController;
  late TextEditingController _descController;
  final _linkTitleController = TextEditingController();
  final _linkUrlController = TextEditingController();

  late TaskPriority _priority;
  late TaskCategory _category;
  late int _energyRequirement;
  late bool _isMorningFocus;
  String? _linkedHackathonId;
  late List<ResourceLinkModel> _links;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.task.title);
    _descController = TextEditingController(text: widget.task.description ?? '');
    _priority = widget.task.priority;
    _category = widget.task.category;
    _energyRequirement = widget.task.energyRequirement;
    _isMorningFocus = widget.task.isMorningFocus;
    _linkedHackathonId = widget.task.linkedHackathonId;
    _links = List.from(widget.task.resourceLinks);
  }

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
      _links.add(
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

  void _saveChanges() {
    if (_titleController.text.trim().isEmpty) return;

    final updated = widget.task.copyWith(
      title: _titleController.text.trim(),
      description: _descController.text.trim(),
      priority: _priority,
      category: _category,
      energyRequirement: _energyRequirement,
      isMorningFocus: _isMorningFocus,
      linkedHackathonId: _linkedHackathonId,
      resourceLinks: _links,
    );

    context.read<TodoProvider>().updateTask(updated);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Task updated successfully! ✅'),
        backgroundColor: AppColors.emeraldGreen,
        duration: Duration(seconds: 2),
      ),
    );

    Navigator.of(context).pop();
  }

  void _deleteTask() {
    context.read<TodoProvider>().deleteTask(widget.task.id);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Task deleted.'),
        backgroundColor: AppColors.flameRed,
        duration: Duration(seconds: 2),
      ),
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
                const Icon(Icons.edit_note_rounded, color: AppColors.cyanPrimary, size: 24),
                const SizedBox(width: 8),
                const Text(
                  'Edit / Modify Task',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                ),
                const Spacer(),
                IconButton(
                  tooltip: 'Delete Task',
                  icon: const Icon(Icons.delete_outline_rounded, color: AppColors.flameRed),
                  onPressed: _deleteTask,
                ),
                IconButton(
                  icon: const Icon(Icons.close, color: AppColors.textMuted),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ],
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _titleController,
              style: const TextStyle(color: AppColors.textPrimary),
              decoration: const InputDecoration(labelText: 'Task Title'),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _descController,
              style: const TextStyle(color: AppColors.textPrimary),
              maxLines: 2,
              decoration: const InputDecoration(labelText: 'Description / Notes'),
            ),
            const SizedBox(height: 16),

            // Priority Selector
            const Text(
              'Priority',
              style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.textSecondary),
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
              style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.textSecondary),
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

            // Brain Energy Requirement Selector
            const Text(
              'Brain Energy Requirement',
              style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.textSecondary),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                _buildEnergyChoice('⚡ Deep Focus', 3),
                const SizedBox(width: 8),
                _buildEnergyChoice('☕ Medium', 2),
                const SizedBox(width: 8),
                _buildEnergyChoice('😴 Light Chores', 1),
              ],
            ),
            const SizedBox(height: 16),

            // Attached Resource Links
            const Text(
              'Attached Web/YouTube Links',
              style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.textSecondary),
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
                      hintText: 'Title',
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
                      hintText: 'https://...',
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
                    child: const Icon(Icons.add_link_rounded, color: Colors.black, size: 18),
                  ),
                ),
              ],
            ),
            if (_links.isNotEmpty) ...[
              const SizedBox(height: 10),
              Wrap(
                spacing: 6,
                runSpacing: 6,
                children: _links.map((link) {
                  return Chip(
                    label: Text(link.title, style: const TextStyle(fontSize: 11)),
                    backgroundColor: AppColors.surfaceLight,
                    deleteIcon: const Icon(Icons.close, size: 14),
                    onDeleted: () => setState(() => _links.remove(link)),
                  );
                }).toList(),
              ),
            ],
            const SizedBox(height: 16),

            // Morning Focus Toggle
            SwitchListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text(
                'Pin as Morning Focus Goal',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.textPrimary),
              ),
              value: _isMorningFocus,
              activeThumbColor: AppColors.cyanPrimary,
              onChanged: (val) => setState(() => _isMorningFocus = val),
            ),

            if (activeHackathons.isNotEmpty) ...[
              const SizedBox(height: 8),
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(labelText: 'Link to Hackathon'),
                dropdownColor: AppColors.surfaceCard,
                initialValue: _linkedHackathonId,
                items: [
                  const DropdownMenuItem(
                    value: null,
                    child: Text('None', style: TextStyle(color: AppColors.textSecondary)),
                  ),
                  ...activeHackathons.map((h) => DropdownMenuItem(
                        value: h.id,
                        child: Text(h.name, style: const TextStyle(color: AppColors.textPrimary, fontSize: 13)),
                      )),
                ],
                onChanged: (val) => setState(() => _linkedHackathonId = val),
              ),
            ],
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: _deleteTask,
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.flameRed,
                      side: const BorderSide(color: AppColors.flameRed),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    child: const Text('Delete Task'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  flex: 2,
                  child: ElevatedButton(
                    onPressed: _saveChanges,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.cyanPrimary,
                      foregroundColor: Colors.black,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                    child: const Text('Save Changes'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEnergyChoice(String label, int value) {
    final isSelected = _energyRequirement == value;
    return Expanded(
      child: ChoiceChip(
        label: Center(
          child: Text(
            label,
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w700,
              color: isSelected ? Colors.black : AppColors.textSecondary,
            ),
          ),
        ),
        selected: isSelected,
        selectedColor: AppColors.cyanPrimary,
        backgroundColor: AppColors.surfaceLight,
        onSelected: (selected) {
          if (selected) setState(() => _energyRequirement = value);
        },
      ),
    );
  }
}
