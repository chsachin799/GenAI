import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/app_colors.dart';
import '../../models/task_model.dart';
import '../../state/todo_provider.dart';
import '../widgets/resource_link_chip.dart';

class PomodoroScreen extends StatefulWidget {
  final TaskModel? activeTask;

  const PomodoroScreen({super.key, this.activeTask});

  @override
  State<PomodoroScreen> createState() => _PomodoroScreenState();
}

class _PomodoroScreenState extends State<PomodoroScreen> {
  int _selectedDurationMinutes = 25;
  int _remainingSeconds = 25 * 60;
  bool _isRunning = false;
  Timer? _timer;
  int _completedSessions = 0;

  @override
  void initState() {
    super.initState();
    _resetTimer(25);
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _resetTimer(int minutes) {
    _timer?.cancel();
    setState(() {
      _selectedDurationMinutes = minutes;
      _remainingSeconds = minutes * 60;
      _isRunning = false;
    });
  }

  void _toggleTimer() {
    if (_isRunning) {
      _timer?.cancel();
      setState(() => _isRunning = false);
    } else {
      setState(() => _isRunning = true);
      _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
        if (_remainingSeconds > 0) {
          setState(() => _remainingSeconds--);
        } else {
          _timer?.cancel();
          setState(() {
            _isRunning = false;
            _completedSessions++;
          });

          // Award XP and focus minutes
          context.read<TodoProvider>().recordPomodoroSession(
                minutes: _selectedDurationMinutes,
                taskId: widget.activeTask?.id,
              );

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              backgroundColor: AppColors.emeraldGreen,
              content: Text(
                  '🎉 Focus session complete! +${_selectedDurationMinutes * 4} XP earned!'),
            ),
          );
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final minutes = _remainingSeconds ~/ 60;
    final seconds = _remainingSeconds % 60;
    final totalSeconds = _selectedDurationMinutes * 60;
    final progress = totalSeconds > 0
        ? (_remainingSeconds / totalSeconds).clamp(0.0, 1.0)
        : 0.0;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Pomodoro Focus Shield'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Active Task Card if linked
              if (widget.activeTask != null) ...[
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                        color: AppColors.cyanPrimary.withValues(alpha: 0.3)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Row(
                        children: [
                          Icon(Icons.bolt,
                              size: 14, color: AppColors.cyanPrimary),
                          SizedBox(width: 6),
                          Text(
                            'CURRENT FOCUS OBJECTIVE',
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w800,
                              color: AppColors.cyanPrimary,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Text(
                        widget.activeTask!.title,
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      if (widget.activeTask!.resourceLinks.isNotEmpty) ...[
                        const SizedBox(height: 10),
                        const Text(
                          'Study & Reference Links:',
                          style: TextStyle(
                              fontSize: 11, color: AppColors.textMuted),
                        ),
                        const SizedBox(height: 6),
                        Wrap(
                          spacing: 6,
                          runSpacing: 6,
                          children: widget.activeTask!.resourceLinks
                              .map((link) => ResourceLinkChip(link: link))
                              .toList(),
                        ),
                      ],
                    ],
                  ),
                ),
                const SizedBox(height: 24),
              ],

              // Mode Selector Tabs (25m Focus / 5m Short Break / 15m Long Break)
              Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: AppColors.border),
                ),
                child: Row(
                  children: [
                    _buildModeButton('25m Focus', 25, AppColors.flameOrange),
                    _buildModeButton('5m Break', 5, AppColors.emeraldGreen),
                    _buildModeButton('15m Long', 15, AppColors.cyanPrimary),
                  ],
                ),
              ),
              const SizedBox(height: 36),

              // Circular Countdown Visual Ring
              Stack(
                alignment: Alignment.center,
                children: [
                  SizedBox(
                    width: 240,
                    height: 240,
                    child: CircularProgressIndicator(
                      value: progress,
                      strokeWidth: 10,
                      backgroundColor: AppColors.surfaceLight,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        _selectedDurationMinutes == 25
                            ? AppColors.flameOrange
                            : AppColors.emeraldGreen,
                      ),
                    ),
                  ),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}',
                        style: const TextStyle(
                          fontSize: 48,
                          fontWeight: FontWeight.w900,
                          color: AppColors.textPrimary,
                          fontFamily: 'monospace',
                          letterSpacing: -1,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        _isRunning ? 'STAY LOCKED IN 🔥' : 'READY TO GRIND',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w800,
                          color: _isRunning
                              ? AppColors.flameOrange
                              : AppColors.textMuted,
                          letterSpacing: 1,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 40),

              // Play / Pause / Reset Control Buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    onPressed: () => _resetTimer(_selectedDurationMinutes),
                    icon: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: AppColors.surfaceLight,
                        shape: BoxShape.circle,
                        border: Border.all(color: AppColors.border),
                      ),
                      child: const Icon(Icons.refresh_rounded,
                          color: AppColors.textSecondary, size: 22),
                    ),
                  ),
                  const SizedBox(width: 20),
                  ElevatedButton(
                    onPressed: _toggleTimer,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _isRunning
                          ? AppColors.flameRed
                          : AppColors.flameOrange,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 36, vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          _isRunning
                              ? Icons.pause_rounded
                              : Icons.play_arrow_rounded,
                          size: 24,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          _isRunning ? 'Pause' : 'Start Focus',
                          style: const TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w800),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 32),

              // Motivational Footer
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: AppColors.surfaceCard,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.border),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.psychology_rounded,
                        color: AppColors.cyanPrimary, size: 20),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        'Sessions Completed Today: $_completedSessions (Total +${_completedSessions * 100} XP)',
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildModeButton(String title, int minutes, Color activeColor) {
    final isSelected = _selectedDurationMinutes == minutes;
    return Expanded(
      child: GestureDetector(
        onTap: () => _resetTimer(minutes),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: isSelected ? activeColor : Colors.transparent,
            borderRadius: BorderRadius.circular(10),
          ),
          alignment: Alignment.center,
          child: Text(
            title,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: isSelected ? Colors.white : AppColors.textSecondary,
            ),
          ),
        ),
      ),
    );
  }
}
