import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/app_colors.dart';
import '../../models/task_model.dart';
import '../../state/todo_provider.dart';
import '../../state/hackathon_provider.dart';
import '../widgets/hackathon_timer_card.dart';
import '../widgets/morning_focus_card.dart';
import '../widgets/task_item_tile.dart';
import '../widgets/add_task_sheet.dart';
import '../widgets/add_hackathon_sheet.dart';
import '../widgets/quick_scratchpad_dialog.dart';
import 'hackathon_screen.dart';
import 'morning_routine_screen.dart';
import 'night_shutdown_screen.dart';
import 'voice_brain_dump_sheet.dart';
import 'pomodoro_screen.dart';
import 'kanban_board_screen.dart';
import 'analytics_screen.dart';
import 'weekly_planner_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentNavIndex = 0;
  int? _selectedEnergyFilter;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: IndexedStack(
        index: _currentNavIndex,
        children: [
          _HomeDashboardView(
            selectedEnergyFilter: _selectedEnergyFilter,
            onEnergyFilterChanged: (val) {
              setState(() => _selectedEnergyFilter = val);
            },
          ),
          const HackathonScreen(),
        ],
      ),
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          color: AppColors.surface,
          border: Border(top: BorderSide(color: AppColors.border, width: 1)),
        ),
        child: NavigationBar(
          selectedIndex: _currentNavIndex,
          onDestinationSelected: (idx) => setState(() => _currentNavIndex = idx),
          backgroundColor: AppColors.surface,
          indicatorColor: _currentNavIndex == 0
              ? AppColors.cyanPrimary.withValues(alpha: 0.2)
              : AppColors.flameOrange.withValues(alpha: 0.2),
          destinations: const [
            NavigationDestination(
              icon: Icon(Icons.check_circle_outline_rounded),
              selectedIcon: Icon(Icons.check_circle_rounded, color: AppColors.cyanPrimary),
              label: 'Daily Tasks',
            ),
            NavigationDestination(
              icon: Icon(Icons.timer_outlined),
              selectedIcon: Icon(Icons.timer_rounded, color: AppColors.flameOrange),
              label: 'Hackathons',
            ),
          ],
        ),
      ),
      floatingActionButton: _currentNavIndex == 0
          ? FloatingActionButton(
              heroTag: 'add_task_fab',
              onPressed: () {
                showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  backgroundColor: Colors.transparent,
                  builder: (_) => const AddTaskSheet(),
                );
              },
              backgroundColor: AppColors.cyanPrimary,
              foregroundColor: Colors.black,
              elevation: 4,
              child: const Icon(Icons.add, size: 28),
            )
          : FloatingActionButton.extended(
              heroTag: 'add_hackathon_fab',
              onPressed: () {
                showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  backgroundColor: Colors.transparent,
                  builder: (_) => const AddHackathonSheet(),
                );
              },
              backgroundColor: AppColors.flameOrange,
              foregroundColor: Colors.white,
              icon: const Icon(Icons.add),
              label: const Text(
                'New Hackathon',
                style: TextStyle(fontWeight: FontWeight.w700),
              ),
            ),
    );
  }
}

class _HomeDashboardView extends StatelessWidget {
  final int? selectedEnergyFilter;
  final ValueChanged<int?> onEnergyFilterChanged;

  const _HomeDashboardView({
    required this.selectedEnergyFilter,
    required this.onEnergyFilterChanged,
  });

  @override
  Widget build(BuildContext context) {
    final todoProvider = context.watch<TodoProvider>();
    final hackathonProvider = context.watch<HackathonProvider>();

    final pressingHackathon = hackathonProvider.mostPressingHackathon;
    List<TaskModel> filteredTasks = todoProvider.filteredTasks;

    if (selectedEnergyFilter != null) {
      filteredTasks = filteredTasks
          .where((t) => t.energyRequirement == selectedEnergyFilter)
          .toList();
    }

    final selectedCategory = todoProvider.selectedCategory;

    return SafeArea(
      child: CustomScrollView(
        slivers: [
          // Header Bar
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
              child: Row(
                children: [
                  // App Logo & Brand Name
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 36,
                        height: 36,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          image: const DecorationImage(
                            image: AssetImage('assets/images/sankalp_logo.jpg'),
                            fit: BoxFit.cover,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.cyanPrimary.withValues(alpha: 0.3),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 10),
                      const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Sankalp',
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.w900,
                              color: AppColors.textPrimary,
                              letterSpacing: -0.5,
                            ),
                          ),
                          Text(
                            'Focus & Deadlines',
                            style: TextStyle(fontSize: 10, color: AppColors.textMuted),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const Spacer(),
                  // Compact Header Action Buttons (Guaranteed 100% visible & tappable on all screen sizes)
                  _buildHeaderAction(
                    icon: Icons.mic_rounded,
                    tooltip: 'Voice Brain Dump',
                    color: const Color(0xFFA5B4FC),
                    bgColor: const Color(0xFF6366F1).withValues(alpha: 0.2),
                    borderColor: const Color(0xFF6366F1).withValues(alpha: 0.5),
                    onTap: () {
                      showModalBottomSheet(
                        context: context,
                        isScrollControlled: true,
                        backgroundColor: Colors.transparent,
                        builder: (_) => const VoiceBrainDumpSheet(),
                      );
                    },
                  ),
                  const SizedBox(width: 6),
                  _buildHeaderAction(
                    icon: Icons.edit_note_rounded,
                    tooltip: 'Quick Scratchpad',
                    color: AppColors.cyanPrimary,
                    bgColor: AppColors.surfaceLight,
                    borderColor: AppColors.border,
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (_) => const QuickScratchpadDialog(),
                      );
                    },
                  ),
                  const SizedBox(width: 6),
                  _buildHeaderAction(
                    icon: Icons.nightlight_round,
                    tooltip: 'Night Shutdown',
                    color: const Color(0xFFA5B4FC),
                    bgColor: AppColors.surfaceLight,
                    borderColor: AppColors.border,
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(builder: (_) => const NightShutdownScreen()),
                      );
                    },
                  ),
                  const SizedBox(width: 6),
                  _buildHeaderAction(
                    icon: Icons.wb_sunny_rounded,
                    tooltip: 'Morning Kickstart',
                    color: AppColors.flameOrange,
                    bgColor: AppColors.flameOrange.withValues(alpha: 0.15),
                    borderColor: AppColors.flameOrange.withValues(alpha: 0.4),
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(builder: (_) => const MorningRoutineScreen()),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),

          // Essential Superpower Action Strip
          SliverToBoxAdapter(
            child: Container(
              height: 44,
              margin: const EdgeInsets.symmetric(vertical: 4),
              child: ListView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 20),
                children: [
                  _buildQuickActionBtn(
                    context: context,
                    icon: Icons.timer_rounded,
                    label: 'Pomodoro Focus',
                    color: AppColors.flameOrange,
                    onTap: () => Navigator.of(context).push(
                      MaterialPageRoute(builder: (_) => const PomodoroScreen()),
                    ),
                  ),
                  const SizedBox(width: 8),
                  _buildQuickActionBtn(
                    context: context,
                    icon: Icons.view_kanban_rounded,
                    label: 'Kanban Board',
                    color: AppColors.cyanPrimary,
                    onTap: () => Navigator.of(context).push(
                      MaterialPageRoute(builder: (_) => const KanbanBoardScreen()),
                    ),
                  ),
                  const SizedBox(width: 8),
                  _buildQuickActionBtn(
                    context: context,
                    icon: Icons.calendar_month_rounded,
                    label: 'Weekly Planner',
                    color: const Color(0xFF8B5CF6),
                    onTap: () => Navigator.of(context).push(
                      MaterialPageRoute(builder: (_) => const WeeklyPlannerScreen()),
                    ),
                  ),
                  const SizedBox(width: 8),
                  _buildQuickActionBtn(
                    context: context,
                    icon: Icons.analytics_rounded,
                    label: 'Analytics',
                    color: AppColors.emeraldGreen,
                    onTap: () => Navigator.of(context).push(
                      MaterialPageRoute(builder: (_) => const AnalyticsScreen()),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Brain Energy Filter Bar
          SliverToBoxAdapter(
            child: Container(
              margin: const EdgeInsets.fromLTRB(20, 6, 20, 4),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.border),
              ),
              child: Row(
                children: [
                  const Text(
                    'Energy Filter:',
                    style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: AppColors.textMuted),
                  ),
                  const SizedBox(width: 8),
                  _buildEnergyChip('All', null),
                  const SizedBox(width: 6),
                  _buildEnergyChip('⚡ Deep Focus', 3),
                  const SizedBox(width: 6),
                  _buildEnergyChip('☕ Medium', 2),
                  const SizedBox(width: 6),
                  _buildEnergyChip('😴 Light', 1),
                ],
              ),
            ),
          ),

          // Morning Kickstart Card
          const SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 6),
              child: MorningFocusCard(),
            ),
          ),

          // Active Pressing Hackathon Countdown (if any)
          if (pressingHackathon != null)
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
                child: HackathonTimerCard(hackathon: pressingHackathon),
              ),
            ),

          // Task Category Filter Chips
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.only(top: 8, bottom: 6),
              child: SizedBox(
                height: 34,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  children: [
                    _buildFilterChip(
                      context: context,
                      label: 'All Tasks (${todoProvider.tasks.length})',
                      isSelected: selectedCategory == null,
                      onSelected: () => todoProvider.setCategoryFilter(null),
                    ),
                    const SizedBox(width: 8),
                    ...TaskCategory.values.map((cat) {
                      final isSelected = selectedCategory == cat;
                      return Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: _buildFilterChip(
                          context: context,
                          label: cat.name.toUpperCase(),
                          isSelected: isSelected,
                          onSelected: () => todoProvider.setCategoryFilter(isSelected ? null : cat),
                        ),
                      );
                    }),
                  ],
                ),
              ),
            ),
          ),

          // Task List Header
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 8),
              child: Row(
                children: [
                  const Text(
                    'Daily Action Items',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: AppColors.textPrimary),
                  ),
                  const Spacer(),
                  Text(
                    '${todoProvider.totalCompletedCount}/${todoProvider.tasks.length} Done',
                    style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.textMuted),
                  ),
                ],
              ),
            ),
          ),

          // Task List Items
          if (filteredTasks.isEmpty)
            SliverToBoxAdapter(
              child: Container(
                margin: const EdgeInsets.all(20),
                padding: const EdgeInsets.all(32),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.border),
                ),
                alignment: Alignment.center,
                child: const Column(
                  children: [
                    Icon(Icons.task_alt_rounded, size: 40, color: AppColors.emeraldGreen),
                    SizedBox(height: 12),
                    Text(
                      'All caught up!',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: AppColors.textPrimary),
                    ),
                    SizedBox(height: 4),
                    Text(
                      'Tap + below to add new goals or study tasks',
                      style: TextStyle(fontSize: 12, color: AppColors.textMuted),
                    ),
                  ],
                ),
              ),
            )
          else
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(20, 4, 20, 80),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    final task = filteredTasks[index];
                    return TaskItemTile(task: task);
                  },
                  childCount: filteredTasks.length,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildHeaderAction({
    required IconData icon,
    required String tooltip,
    required Color color,
    required Color bgColor,
    required Color borderColor,
    required VoidCallback onTap,
  }) {
    return Tooltip(
      message: tooltip,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(10),
        child: Container(
          width: 36,
          height: 36,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: borderColor),
          ),
          child: Icon(icon, color: color, size: 18),
        ),
      ),
    );
  }

  Widget _buildEnergyChip(String label, int? value) {
    final isSelected = selectedEnergyFilter == value;
    return GestureDetector(
      onTap: () => onEnergyFilterChanged(isSelected ? null : value),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.cyanPrimary : AppColors.surfaceLight,
          borderRadius: BorderRadius.circular(6),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.w700,
            color: isSelected ? Colors.black : AppColors.textSecondary,
          ),
        ),
      ),
    );
  }

  Widget _buildQuickActionBtn({
    required BuildContext context,
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: color.withValues(alpha: 0.35)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 16, color: color),
            const SizedBox(width: 6),
            Text(
              label,
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: color),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterChip({
    required BuildContext context,
    required String label,
    required bool isSelected,
    required VoidCallback onSelected,
  }) {
    return ChoiceChip(
      label: Text(
        label,
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w700,
          color: isSelected ? Colors.black : AppColors.textSecondary,
        ),
      ),
      selected: isSelected,
      selectedColor: AppColors.cyanPrimary,
      backgroundColor: AppColors.surfaceLight,
      side: BorderSide(
        color: isSelected ? AppColors.cyanPrimary : AppColors.border,
      ),
      onSelected: (_) => onSelected(),
    );
  }
}
