import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/app_colors.dart';
import '../../state/hackathon_provider.dart';
import '../widgets/hackathon_timer_card.dart';
import '../widgets/add_hackathon_sheet.dart';

class HackathonScreen extends StatelessWidget {
  const HackathonScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final hackathonProvider = context.watch<HackathonProvider>();
    final hackathons = hackathonProvider.hackathons;
    final active = hackathonProvider.activeHackathons;

    return SafeArea(
      child: hackathons.isEmpty
          ? Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.flag_rounded,
                    size: 48,
                    color: AppColors.flameOrange.withValues(alpha: 0.5),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'No Active Hackathons',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 6),
                  const Text(
                    'Track competition deadlines & reverse milestones',
                    style: TextStyle(
                      fontSize: 13,
                      color: AppColors.textMuted,
                    ),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton.icon(
                    onPressed: () {
                      showModalBottomSheet(
                        context: context,
                        isScrollControlled: true,
                        backgroundColor: Colors.transparent,
                        builder: (_) => const AddHackathonSheet(),
                      );
                    },
                    icon: const Icon(Icons.add),
                    label: const Text('Add Hackathon'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.flameOrange,
                      foregroundColor: Colors.white,
                    ),
                  ),
                ],
              ),
            )
          : ListView(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 80),
              children: [
                // Header Row
                Row(
                  children: [
                    const Icon(Icons.bolt, color: AppColors.flameOrange, size: 20),
                    const SizedBox(width: 8),
                    Text(
                      'ACTIVE SPRINT PIPELINE (${active.length})',
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w800,
                        color: AppColors.flameOrange,
                        letterSpacing: 0.5,
                      ),
                    ),
                    const Spacer(),
                    IconButton(
                      tooltip: 'Add Hackathon',
                      icon: const Icon(Icons.add_circle_outline_rounded,
                          color: AppColors.flameOrange, size: 24),
                      onPressed: () {
                        showModalBottomSheet(
                          context: context,
                          isScrollControlled: true,
                          backgroundColor: Colors.transparent,
                          builder: (_) => const AddHackathonSheet(),
                        );
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                ...hackathons.map((h) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 14),
                    child: HackathonTimerCard(hackathon: h),
                  );
                }),
              ],
            ),
    );
  }
}
