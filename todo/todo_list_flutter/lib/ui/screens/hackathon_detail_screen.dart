import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../core/app_colors.dart';
import '../../models/hackathon_model.dart';
import '../../state/hackathon_provider.dart';

class HackathonDetailScreen extends StatelessWidget {
  final String hackathonId;

  const HackathonDetailScreen({
    super.key,
    required this.hackathonId,
  });

  @override
  Widget build(BuildContext context) {
    final hackathonProvider = context.watch<HackathonProvider>();
    final hackathons = hackathonProvider.hackathons;
    final index = hackathons.indexWhere((h) => h.id == hackathonId);

    if (index == -1) {
      return Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(),
        body: const Center(
          child: Text('Hackathon not found',
              style: TextStyle(color: AppColors.textSecondary)),
        ),
      );
    }

    final hackathon = hackathons[index];
    final remaining = hackathon.remainingDuration;
    final isCritical = hackathon.isCritical;
    final isUrgent = hackathon.isUrgent;

    final days = remaining.inDays;
    final hours = remaining.inHours % 24;
    final minutes = remaining.inMinutes % 60;
    final seconds = remaining.inSeconds % 60;

    final accentColor = isCritical
        ? AppColors.flameRed
        : (isUrgent ? AppColors.flameOrange : AppColors.flameAmber);

    final timeFormatter = DateFormat('MMM d, yyyy • hh:mm a');

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(hackathon.name),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_outline_rounded,
                color: AppColors.flameRed),
            onPressed: () {
              _showDeleteConfirm(context, hackathon);
            },
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Hero Live Ticker Box
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: isCritical
                        ? AppColors.flameRed
                        : AppColors.flameOrange.withValues(alpha: 0.5),
                    width: 1.5,
                  ),
                  gradient: LinearGradient(
                    colors: [
                      AppColors.surfaceCard,
                      accentColor.withValues(alpha: 0.1),
                    ],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: accentColor.withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            hackathon.platform.toUpperCase(),
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w800,
                              color: accentColor,
                            ),
                          ),
                        ),
                        if (isCritical)
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: AppColors.flameRed,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Text(
                              'HARD STOP BUFFER ACTIVE',
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.w900,
                                color: Colors.white,
                              ),
                            ),
                          )
                        else
                          Text(
                            'Due: ${timeFormatter.format(hackathon.submissionDeadline)}',
                            style: const TextStyle(
                              fontSize: 12,
                              color: AppColors.textSecondary,
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    // Large Numbers Countdown
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _buildBigTimerBlock(days.toString().padLeft(2, '0'),
                            'DAYS', accentColor),
                        _buildTimerColon(accentColor),
                        _buildBigTimerBlock(hours.toString().padLeft(2, '0'),
                            'HOURS', accentColor),
                        _buildTimerColon(accentColor),
                        _buildBigTimerBlock(minutes.toString().padLeft(2, '0'),
                            'MINUTES', accentColor),
                        _buildTimerColon(accentColor),
                        _buildBigTimerBlock(seconds.toString().padLeft(2, '0'),
                            'SECONDS', accentColor),
                      ],
                    ),
                    const SizedBox(height: 20),
                    // Progress & Stats
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Reverse Milestone Progress',
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textSecondary,
                          ),
                        ),
                        Text(
                          '${(hackathon.progressPercentage * 100).toInt()}% Done',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w800,
                            color: accentColor,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(6),
                      child: LinearProgressIndicator(
                        value: hackathon.progressPercentage,
                        backgroundColor: AppColors.surfaceLight,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          hackathon.progressPercentage >= 1.0
                              ? AppColors.emeraldGreen
                              : accentColor,
                        ),
                        minHeight: 8,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              // Submission Safety Warning Banner
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: AppColors.flameOrange.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: AppColors.flameOrange.withValues(alpha: 0.3),
                  ),
                ),
                child: const Row(
                  children: [
                    Icon(
                      Icons.shield_outlined,
                      color: AppColors.flameOrange,
                      size: 22,
                    ),
                    SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        '2-Hour Submission Safety Rule: Code freeze must occur 2 hours before the deadline to record video, write Devpost story & avoid server crashes.',
                        style: TextStyle(
                          fontSize: 12,
                          color: Color(0xFFFDBA74),
                          height: 1.3,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              // Reverse Milestones Section
              const Text(
                'Reverse Sprint Milestones',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 12),
              ...hackathon.milestones.map((milestone) {
                final isPassed =
                    DateTime.now().isAfter(milestone.targetTime);
                final isQuarantine = milestone.isQuarantinePhase;

                return Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: InkWell(
                    onTap: () {
                      hackathonProvider.toggleMilestone(
                          hackathon.id, milestone.id);
                    },
                    borderRadius: BorderRadius.circular(14),
                    child: Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: milestone.isCompleted
                            ? AppColors.surface.withValues(alpha: 0.5)
                            : AppColors.surface,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(
                          color: milestone.isCompleted
                              ? AppColors.emeraldGreen.withValues(alpha: 0.5)
                              : (isQuarantine
                                  ? AppColors.flameRed.withValues(alpha: 0.5)
                                  : AppColors.border),
                          width: isQuarantine ? 1.5 : 1.0,
                        ),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(
                            milestone.isCompleted
                                ? Icons.check_circle_rounded
                                : Icons.radio_button_unchecked_rounded,
                            color: milestone.isCompleted
                                ? AppColors.emeraldGreen
                                : (isQuarantine
                                    ? AppColors.flameRed
                                    : AppColors.textSecondary),
                            size: 22,
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        milestone.title,
                                        style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w700,
                                          color: milestone.isCompleted
                                              ? AppColors.textMuted
                                              : (isQuarantine
                                                  ? AppColors.flameRed
                                                  : AppColors.textPrimary),
                                          decoration: milestone.isCompleted
                                              ? TextDecoration.lineThrough
                                              : null,
                                        ),
                                      ),
                                    ),
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 6, vertical: 2),
                                      decoration: BoxDecoration(
                                        color: AppColors.surfaceLight,
                                        borderRadius: BorderRadius.circular(4),
                                      ),
                                      child: Text(
                                        '${(milestone.percentageWeight * 100).toInt()}%',
                                        style: const TextStyle(
                                          fontSize: 10,
                                          fontWeight: FontWeight.w700,
                                          color: AppColors.textSecondary,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  milestone.description,
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: milestone.isCompleted
                                        ? AppColors.textMuted
                                        : AppColors.textSecondary,
                                  ),
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  'Target: ${timeFormatter.format(milestone.targetTime)} ${isPassed && !milestone.isCompleted ? "(Late)" : ""}',
                                  style: TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w600,
                                    color: isPassed && !milestone.isCompleted
                                        ? AppColors.flameRed
                                        : AppColors.textMuted,
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
              }),
              const SizedBox(height: 24),
              // Deliverable Checklist Section
              const Text(
                'Submission Deliverables Checklist',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 12),
              ...hackathon.deliverables.map((deliv) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: InkWell(
                    onTap: () {
                      hackathonProvider.toggleDeliverable(
                          hackathon.id, deliv.id);
                    },
                    borderRadius: BorderRadius.circular(10),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 12),
                      decoration: BoxDecoration(
                        color: AppColors.surfaceLight,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: AppColors.border),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            deliv.isDone
                                ? Icons.task_alt_rounded
                                : Icons.circle_outlined,
                            color: deliv.isDone
                                ? AppColors.emeraldGreen
                                : AppColors.textMuted,
                            size: 20,
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              deliv.title,
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                color: deliv.isDone
                                    ? AppColors.textMuted
                                    : AppColors.textPrimary,
                                decoration: deliv.isDone
                                    ? TextDecoration.lineThrough
                                    : null,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBigTimerBlock(String value, String label, Color color) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          decoration: BoxDecoration(
            color: AppColors.surfaceLight,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.border),
          ),
          child: Text(
            value,
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w900,
              color: color,
              fontFamily: 'monospace',
            ),
          ),
        ),
        const SizedBox(height: 6),
        Text(
          label,
          style: const TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.w700,
            color: AppColors.textMuted,
            letterSpacing: 0.5,
          ),
        ),
      ],
    );
  }

  Widget _buildTimerColon(Color color) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Text(
        ':',
        style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w900,
          color: color.withValues(alpha: 0.6),
        ),
      ),
    );
  }

  void _showDeleteConfirm(BuildContext context, HackathonModel hackathon) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.surfaceCard,
        title: const Text('Delete Hackathon?'),
        content: Text('Are you sure you want to remove "${hackathon.name}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              context.read<HackathonProvider>().deleteHackathon(hackathon.id);
              Navigator.of(ctx).pop();
              Navigator.of(context).pop();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.flameRed,
              foregroundColor: Colors.white,
            ),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}
