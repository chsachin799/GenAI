import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/app_colors.dart';
import '../../models/hackathon_model.dart';
import '../../state/hackathon_provider.dart';
import '../screens/hackathon_detail_screen.dart';
import 'edit_hackathon_sheet.dart';

class HackathonTimerCard extends StatelessWidget {
  final HackathonModel hackathon;

  const HackathonTimerCard({
    super.key,
    required this.hackathon,
  });

  void _showEditSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => EditHackathonSheet(hackathon: hackathon),
    );
  }

  void _showDeleteConfirm(BuildContext context) {
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

  @override
  Widget build(BuildContext context) {
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

    return InkWell(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => HackathonDetailScreen(hackathonId: hackathon.id),
          ),
        );
      },
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isCritical
                ? AppColors.flameRed.withValues(alpha: 0.6)
                : AppColors.border,
            width: isCritical ? 1.5 : 1.0,
          ),
          gradient: LinearGradient(
            colors: [
              AppColors.surface,
              accentColor.withValues(alpha: 0.08),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: accentColor.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.bolt,
                        size: 14,
                        color: accentColor,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        hackathon.platform.toUpperCase(),
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w800,
                          color: accentColor,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  '${(hackathon.progressPercentage * 100).toInt()}% Done',
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textSecondary,
                  ),
                ),
                const Spacer(),
                // Edit / Delete Actions
                IconButton(
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                  icon: const Icon(Icons.edit_outlined, size: 16, color: AppColors.textMuted),
                  tooltip: 'Modify Hackathon',
                  onPressed: () => _showEditSheet(context),
                ),
                const SizedBox(width: 8),
                IconButton(
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                  icon: const Icon(Icons.delete_outline_rounded, size: 16, color: AppColors.flameRed),
                  tooltip: 'Delete Hackathon',
                  onPressed: () => _showDeleteConfirm(context),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Text(
              hackathon.name,
              style: const TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
                letterSpacing: -0.3,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 14),
            // Live Countdown Ticker
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildTimeUnit(days.toString().padLeft(2, '0'), 'DAYS', accentColor),
                _buildTimeSeparator(accentColor),
                _buildTimeUnit(hours.toString().padLeft(2, '0'), 'HOURS', accentColor),
                _buildTimeSeparator(accentColor),
                _buildTimeUnit(minutes.toString().padLeft(2, '0'), 'MINS', accentColor),
                _buildTimeSeparator(accentColor),
                _buildTimeUnit(seconds.toString().padLeft(2, '0'), 'SECS', accentColor),
              ],
            ),
            const SizedBox(height: 12),
            // Milestone Mini Progress Bar
            ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: hackathon.progressPercentage,
                backgroundColor: AppColors.surfaceLight,
                valueColor: AlwaysStoppedAnimation<Color>(
                  hackathon.progressPercentage >= 1.0
                      ? AppColors.emeraldGreen
                      : accentColor,
                ),
                minHeight: 5,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTimeUnit(String value, String label, Color color) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          decoration: BoxDecoration(
            color: AppColors.surfaceLight,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: AppColors.border),
          ),
          child: Text(
            value,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w800,
              color: color,
              fontFamily: 'monospace',
            ),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(
            fontSize: 9,
            fontWeight: FontWeight.w600,
            color: AppColors.textMuted,
            letterSpacing: 0.5,
          ),
        ),
      ],
    );
  }

  Widget _buildTimeSeparator(Color color) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Text(
        ':',
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w900,
          color: color.withValues(alpha: 0.6),
        ),
      ),
    );
  }
}
