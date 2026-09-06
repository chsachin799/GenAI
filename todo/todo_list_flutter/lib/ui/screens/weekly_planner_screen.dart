import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../core/app_colors.dart';
import '../../state/todo_provider.dart';
import '../../state/hackathon_provider.dart';
import '../widgets/task_item_tile.dart';
import '../widgets/add_task_sheet.dart';

class WeeklyPlannerScreen extends StatefulWidget {
  const WeeklyPlannerScreen({super.key});

  @override
  State<WeeklyPlannerScreen> createState() => _WeeklyPlannerScreenState();
}

class _WeeklyPlannerScreenState extends State<WeeklyPlannerScreen> {
  DateTime _selectedDate = DateTime.now();

  @override
  Widget build(BuildContext context) {
    final todoProvider = context.watch<TodoProvider>();
    final hackathonProvider = context.watch<HackathonProvider>();

    final now = DateTime.now();
    final startOfWeek = now.subtract(Duration(days: now.weekday - 1));
    final weekDays = List.generate(7, (i) => startOfWeek.add(Duration(days: i)));

    final dayTasks = todoProvider.tasks;
    final dayHackathons = hackathonProvider.hackathons.where((h) {
      return h.submissionDeadline.year == _selectedDate.year &&
          h.submissionDeadline.month == _selectedDate.month &&
          h.submissionDeadline.day == _selectedDate.day;
    }).toList();

    final dayFormatter = DateFormat('EEE');
    final numFormatter = DateFormat('d');
    final fullDateFormatter = DateFormat('EEEE, MMMM d, yyyy');

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Weekly Planner & Schedule'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 7-Day Horizontal Strip
            Container(
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
              color: AppColors.surface,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: weekDays.map((day) {
                  final isSelected = day.year == _selectedDate.year &&
                      day.month == _selectedDate.month &&
                      day.day == _selectedDate.day;
                  final isToday = day.year == now.year &&
                      day.month == now.month &&
                      day.day == now.day;

                  return GestureDetector(
                    onTap: () => setState(() => _selectedDate = day),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 10),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? AppColors.cyanPrimary
                            : (isToday
                                ? AppColors.surfaceLight
                                : Colors.transparent),
                        borderRadius: BorderRadius.circular(14),
                        border: isToday && !isSelected
                            ? Border.all(color: AppColors.cyanPrimary)
                            : null,
                      ),
                      child: Column(
                        children: [
                          Text(
                            dayFormatter.format(day).toUpperCase(),
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w700,
                              color: isSelected
                                  ? Colors.black
                                  : AppColors.textSecondary,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            numFormatter.format(day),
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w900,
                              color: isSelected
                                  ? Colors.black
                                  : AppColors.textPrimary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
            const SizedBox(height: 16),

            // Date Header
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  Text(
                    fullDateFormatter.format(_selectedDate),
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const Spacer(),
                  IconButton(
                    onPressed: () {
                      showModalBottomSheet(
                        context: context,
                        isScrollControlled: true,
                        backgroundColor: Colors.transparent,
                        builder: (_) => const AddTaskSheet(),
                      );
                    },
                    icon: const Icon(Icons.add_circle_outline_rounded,
                        color: AppColors.cyanPrimary),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),

            // Day Deadlines & Tasks
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                children: [
                  // Hackathons ending on this day
                  if (dayHackathons.isNotEmpty) ...[
                    ...dayHackathons.map((h) {
                      return Container(
                        margin: const EdgeInsets.only(bottom: 12),
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: AppColors.flameOrange.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: AppColors.flameOrange),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.flag_rounded,
                                color: AppColors.flameOrange, size: 20),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'SUBMISSION DEADLINE TODAY: ${h.name}',
                                    style: const TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w800,
                                      color: AppColors.flameOrange,
                                    ),
                                  ),
                                  Text(
                                    'Platform: ${h.platform} • Reverse Milestones Active',
                                    style: const TextStyle(
                                      fontSize: 11,
                                      color: AppColors.textSecondary,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    }),
                  ],

                  ...dayTasks.map((t) => TaskItemTile(task: t)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
