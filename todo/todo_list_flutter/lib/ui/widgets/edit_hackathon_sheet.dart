import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../core/app_colors.dart';
import '../../models/hackathon_model.dart';
import '../../state/hackathon_provider.dart';
import '../../engine/reverse_milestone_engine.dart';

class EditHackathonSheet extends StatefulWidget {
  final HackathonModel hackathon;

  const EditHackathonSheet({super.key, required this.hackathon});

  @override
  State<EditHackathonSheet> createState() => _EditHackathonSheetState();
}

class _EditHackathonSheetState extends State<EditHackathonSheet> {
  late TextEditingController _nameController;
  late TextEditingController _themeController;
  late TextEditingController _urlController;
  late String _platform;
  late DateTime _deadline;

  final List<String> _platforms = [
    'Devpost',
    'Devfolio',
    'MLH',
    'Taikai',
    'Unstop',
    'Kaggle',
    'Other'
  ];

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.hackathon.name);
    _themeController = TextEditingController(text: widget.hackathon.projectTheme ?? '');
    _urlController = TextEditingController(text: widget.hackathon.registrationUrl ?? '');
    _platform = widget.hackathon.platform;
    _deadline = widget.hackathon.submissionDeadline;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _themeController.dispose();
    _urlController.dispose();
    super.dispose();
  }

  Future<void> _pickDeadline() async {
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: _deadline,
      firstDate: DateTime.now().subtract(const Duration(days: 30)),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      builder: (context, child) {
        return Theme(
          data: ThemeData.dark().copyWith(
            colorScheme: const ColorScheme.dark(
              primary: AppColors.flameOrange,
              surface: AppColors.surfaceCard,
            ),
          ),
          child: child!,
        );
      },
    );

    if (pickedDate != null && mounted) {
      final pickedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.fromDateTime(_deadline),
        builder: (context, child) {
          return Theme(
            data: ThemeData.dark().copyWith(
              colorScheme: const ColorScheme.dark(
                primary: AppColors.flameOrange,
                surface: AppColors.surfaceCard,
              ),
            ),
            child: child!,
          );
        },
      );

      if (pickedTime != null) {
        setState(() {
          _deadline = DateTime(
            pickedDate.year,
            pickedDate.month,
            pickedDate.day,
            pickedTime.hour,
            pickedTime.minute,
          );
        });
      }
    }
  }

  void _saveHackathon() {
    if (_nameController.text.trim().isEmpty) return;

    final deadlineChanged = _deadline != widget.hackathon.submissionDeadline;
    final updatedMilestones = deadlineChanged
        ? ReverseMilestoneEngine.generateMilestones(
            startDate: widget.hackathon.startDate,
            deadline: _deadline,
          )
        : widget.hackathon.milestones;

    final updated = widget.hackathon.copyWith(
      name: _nameController.text.trim(),
      platform: _platform,
      submissionDeadline: _deadline,
      projectTheme: _themeController.text.trim(),
      registrationUrl: _urlController.text.trim(),
      milestones: updatedMilestones,
    );

    context.read<HackathonProvider>().updateHackathon(updated);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Hackathon updated! ✅'),
        backgroundColor: AppColors.emeraldGreen,
      ),
    );

    Navigator.of(context).pop();
  }

  void _deleteHackathon() {
    context.read<HackathonProvider>().deleteHackathon(widget.hackathon.id);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Hackathon deleted.'),
        backgroundColor: AppColors.flameRed,
      ),
    );
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('EEE, MMM d, yyyy • hh:mm a');

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
                const Icon(Icons.edit_note_rounded, color: AppColors.flameOrange, size: 24),
                const SizedBox(width: 8),
                const Text(
                  'Edit / Modify Hackathon',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                ),
                const Spacer(),
                IconButton(
                  tooltip: 'Delete Hackathon',
                  icon: const Icon(Icons.delete_outline_rounded, color: AppColors.flameRed),
                  onPressed: _deleteHackathon,
                ),
                IconButton(
                  icon: const Icon(Icons.close, color: AppColors.textMuted),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ],
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _nameController,
              style: const TextStyle(color: AppColors.textPrimary),
              decoration: const InputDecoration(labelText: 'Hackathon Name'),
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField<String>(
              initialValue: _platform,
              decoration: const InputDecoration(labelText: 'Platform'),
              dropdownColor: AppColors.surfaceCard,
              items: _platforms.map((plat) {
                return DropdownMenuItem(
                  value: plat,
                  child: Text(plat, style: const TextStyle(color: AppColors.textPrimary)),
                );
              }).toList(),
              onChanged: (val) {
                if (val != null) setState(() => _platform = val);
              },
            ),
            const SizedBox(height: 16),
            const Text(
              'Submission Hard Deadline',
              style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.textSecondary),
            ),
            const SizedBox(height: 8),
            InkWell(
              onTap: _pickDeadline,
              borderRadius: BorderRadius.circular(12),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                decoration: BoxDecoration(
                  color: AppColors.surfaceLight,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.flameOrange.withValues(alpha: 0.5)),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.alarm_on_rounded, color: AppColors.flameOrange, size: 20),
                    const SizedBox(width: 12),
                    Text(
                      dateFormat.format(_deadline),
                      style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: AppColors.textPrimary),
                    ),
                    const Spacer(),
                    const Text(
                      'Change',
                      style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.flameOrange),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 14),
            TextField(
              controller: _themeController,
              style: const TextStyle(color: AppColors.textPrimary),
              decoration: const InputDecoration(labelText: 'Project Theme / Track'),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _urlController,
              style: const TextStyle(color: AppColors.textPrimary),
              decoration: const InputDecoration(labelText: 'Devpost / Registration URL'),
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: _deleteHackathon,
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.flameRed,
                      side: const BorderSide(color: AppColors.flameRed),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    child: const Text('Delete'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  flex: 2,
                  child: ElevatedButton(
                    onPressed: _saveHackathon,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.flameOrange,
                      foregroundColor: Colors.white,
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
}
