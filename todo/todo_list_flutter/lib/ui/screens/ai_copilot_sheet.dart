import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../core/app_colors.dart';
import '../../engine/ai_copilot_service.dart';

class AiCopilotSheet extends StatelessWidget {
  final String taskTitle;

  const AiCopilotSheet({
    super.key,
    required this.taskTitle,
  });

  @override
  Widget build(BuildContext context) {
    final advice = AiCopilotService.getAdviceForTask(taskTitle);

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
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppColors.cyanPrimary.withValues(alpha: 0.15),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.psychology_rounded,
                      color: AppColors.cyanPrimary, size: 20),
                ),
                const SizedBox(width: 10),
                const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'AI Task Copilot',
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w800,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    Text(
                      'Instant Strategy, Code & Execution Blueprint',
                      style: TextStyle(fontSize: 11, color: AppColors.textMuted),
                    ),
                  ],
                ),
                const Spacer(),
                IconButton(
                  icon: const Icon(Icons.close, color: AppColors.textMuted),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Task Name Header
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.surfaceLight,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.border),
              ),
              child: Text(
                'Target: "$taskTitle"',
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: AppColors.cyanPrimary,
                ),
              ),
            ),
            const SizedBox(height: 14),

            // Summary Box
            Text(
              advice.summary,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 12),

            // Code Snippet if applicable
            if (advice.codeSnippet != null) ...[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Starter Code / Implementation:',
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: AppColors.textSecondary),
                  ),
                  TextButton.icon(
                    onPressed: () {
                      Clipboard.setData(ClipboardData(text: advice.codeSnippet!));
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Code snippet copied to clipboard!')),
                      );
                    },
                    icon: const Icon(Icons.copy_rounded, size: 14, color: AppColors.cyanPrimary),
                    label: const Text('Copy', style: TextStyle(fontSize: 12, color: AppColors.cyanPrimary)),
                  ),
                ],
              ),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFF0F172A),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: AppColors.border),
                ),
                child: Text(
                  advice.codeSnippet!,
                  style: const TextStyle(
                    fontFamily: 'monospace',
                    fontSize: 11,
                    color: Color(0xFF38BDF8),
                  ),
                ),
              ),
              const SizedBox(height: 14),
            ],

            // Step-by-Step Blueprint
            const Text(
              'Step-by-Step Execution:',
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: AppColors.textSecondary),
            ),
            const SizedBox(height: 8),
            ...advice.steps.asMap().entries.map((entry) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 6),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 18,
                      height: 18,
                      decoration: BoxDecoration(
                        color: AppColors.cyanPrimary.withValues(alpha: 0.2),
                        shape: BoxShape.circle,
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        '${entry.key + 1}',
                        style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w800, color: AppColors.cyanPrimary),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        entry.value,
                        style: const TextStyle(fontSize: 12, color: AppColors.textPrimary),
                      ),
                    ),
                  ],
                ),
              );
            }),
            const SizedBox(height: 12),

            // Pro Tip Box
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.flameOrange.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: AppColors.flameOrange.withValues(alpha: 0.3)),
              ),
              child: Row(
                children: [
                  const Icon(Icons.tips_and_updates_rounded, color: AppColors.flameOrange, size: 18),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Pro-Tip: ${advice.proTip}',
                      style: const TextStyle(fontSize: 11, color: Color(0xFFFDBA74)),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              height: 46,
              child: ElevatedButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Got It! Start Task'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
