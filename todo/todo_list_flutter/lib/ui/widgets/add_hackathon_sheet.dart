import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../core/app_colors.dart';
import '../../state/hackathon_provider.dart';

class AddHackathonSheet extends StatefulWidget {
  const AddHackathonSheet({super.key});

  @override
  State<AddHackathonSheet> createState() => _AddHackathonSheetState();
}

class _AddHackathonSheetState extends State<AddHackathonSheet> {
  final _nameController = TextEditingController();
  final _themeController = TextEditingController();
  final _urlController = TextEditingController();

  String _platform = 'Devpost';
  DateTime _deadline = DateTime.now().add(const Duration(hours: 48));

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
      firstDate: DateTime.now(),
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

    context.read<HackathonProvider>().addHackathon(
          name: _nameController.text,
          platform: _platform,
          startDate: DateTime.now(),
          deadline: _deadline,
          projectTheme: _themeController.text,
          registrationUrl: _urlController.text,
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
                Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: AppColors.flameOrange.withValues(alpha: 0.15),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.flag_rounded,
                    color: AppColors.flameOrange,
                    size: 18,
                  ),
                ),
                const SizedBox(width: 10),
                const Text(
                  'Add New Hackathon',
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
              controller: _nameController,
              autofocus: true,
              style: const TextStyle(color: AppColors.textPrimary),
              decoration: const InputDecoration(
                labelText: 'Hackathon Name',
                hintText: 'e.g., HackMIT, ETHGlobal, Google AI Hack',
              ),
            ),
            const SizedBox(height: 12),
            // Platform Selector
            DropdownButtonFormField<String>(
              initialValue: _platform,
              decoration: const InputDecoration(labelText: 'Platform'),
              dropdownColor: AppColors.surfaceCard,
              items: _platforms.map((plat) {
                return DropdownMenuItem(
                  value: plat,
                  child: Text(
                    plat,
                    style: const TextStyle(color: AppColors.textPrimary),
                  ),
                );
              }).toList(),
              onChanged: (val) {
                if (val != null) setState(() => _platform = val);
              },
            ),
            const SizedBox(height: 16),
            // Deadline Picker Button
            const Text(
              'Submission Hard Deadline',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 8),
            InkWell(
              onTap: _pickDeadline,
              borderRadius: BorderRadius.circular(12),
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                decoration: BoxDecoration(
                  color: AppColors.surfaceLight,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                      color: AppColors.flameOrange.withValues(alpha: 0.5)),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.alarm_on_rounded,
                      color: AppColors.flameOrange,
                      size: 20,
                    ),
                    const SizedBox(width: 12),
                    Text(
                      dateFormat.format(_deadline),
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const Spacer(),
                    const Text(
                      'Change',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: AppColors.flameOrange,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 14),
            TextField(
              controller: _themeController,
              style: const TextStyle(color: AppColors.textPrimary),
              decoration: const InputDecoration(
                labelText: 'Project Theme / Track (Optional)',
                hintText: 'e.g., AI Agents, Web3, FinTech',
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _urlController,
              style: const TextStyle(color: AppColors.textPrimary),
              decoration: const InputDecoration(
                labelText: 'Devpost / Registration URL (Optional)',
                hintText: 'https://...',
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                onPressed: _saveHackathon,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.flameOrange,
                  foregroundColor: Colors.white,
                ),
                child: const Text('Generate Reverse Timeline & Add'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
