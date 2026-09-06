import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/app_colors.dart';
import '../../engine/voice_brain_dump_parser.dart';
import '../../state/todo_provider.dart';

class VoiceBrainDumpSheet extends StatefulWidget {
  const VoiceBrainDumpSheet({super.key});

  @override
  State<VoiceBrainDumpSheet> createState() => _VoiceBrainDumpSheetState();
}

class _VoiceBrainDumpSheetState extends State<VoiceBrainDumpSheet> {
  final _inputController = TextEditingController();
  bool _isListening = false;
  ParsedVoiceIntent? _preview;

  final List<String> _sampleVoiceDumps = [
    'Shaam 6 baje Hackathon demo video record karna hai urgent high priority',
    'Study AIML Chapter 3 Convolutional Networks with 2 YouTube lectures',
    'Submit Devpost final form before 4pm tomorrow',
    'Solve 2 LeetCode sliding window problems light study',
  ];

  @override
  void dispose() {
    _inputController.dispose();
    super.dispose();
  }

  void _onTextChanged(String text) {
    if (text.trim().isNotEmpty) {
      setState(() {
        _preview = VoiceBrainDumpParser.parse(text);
      });
    } else {
      setState(() => _preview = null);
    }
  }

  void _simulateVoiceRecording(String sample) {
    setState(() {
      _isListening = true;
    });

    Future.delayed(const Duration(milliseconds: 600), () {
      if (mounted) {
        setState(() {
          _isListening = false;
          _inputController.text = sample;
          _preview = VoiceBrainDumpParser.parse(sample);
        });
      }
    });
  }

  void _saveParsedTask() {
    if (_preview == null || _preview!.title.trim().isEmpty) return;

    context.read<TodoProvider>().addTask(
          title: _preview!.title,
          priority: _preview!.priority,
          category: _preview!.category,
          dueDate: _preview!.dueDate,
        );

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Row(
          children: [
            Icon(Icons.mic_rounded, color: Colors.white),
            SizedBox(width: 8),
            Text('Voice Thought Parsed & Created! +30 XP'),
          ],
        ),
        backgroundColor: AppColors.emeraldGreen,
      ),
    );

    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
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
                  child: const Icon(Icons.mic_rounded,
                      color: AppColors.cyanPrimary, size: 20),
                ),
                const SizedBox(width: 10),
                const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Voice & Thought Dump AI',
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w800,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    Text(
                      'Speak naturally in Hinglish or English',
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

            // Large Animated Mic Center Button
            Center(
              child: GestureDetector(
                onTap: () => _simulateVoiceRecording(_sampleVoiceDumps[0]),
                child: Container(
                  width: 72,
                  height: 72,
                  decoration: BoxDecoration(
                    color: _isListening
                        ? AppColors.flameRed
                        : AppColors.cyanPrimary.withValues(alpha: 0.15),
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: _isListening
                          ? AppColors.flameRed
                          : AppColors.cyanPrimary,
                      width: 2,
                    ),
                  ),
                  child: Icon(
                    _isListening ? Icons.graphic_eq_rounded : Icons.mic_rounded,
                    color: _isListening ? Colors.white : AppColors.cyanPrimary,
                    size: 32,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10),
            Center(
              child: Text(
                _isListening ? 'Listening & Extracting Intent...' : 'Tap mic to dictate or type below',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: _isListening ? AppColors.flameRed : AppColors.textSecondary,
                ),
              ),
            ),
            const SizedBox(height: 16),

            TextField(
              controller: _inputController,
              onChanged: _onTextChanged,
              maxLines: 2,
              style: const TextStyle(color: AppColors.textPrimary, fontSize: 13),
              decoration: const InputDecoration(
                hintText: 'e.g. Kal subah AIML ka model train karna hai high priority...',
              ),
            ),
            const SizedBox(height: 14),

            // Sample Quick Voice Taps
            const Text(
              'Sample Voice Dumps:',
              style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: AppColors.textMuted),
            ),
            const SizedBox(height: 6),
            Wrap(
              spacing: 6,
              runSpacing: 6,
              children: _sampleVoiceDumps.map((sample) {
                return ActionChip(
                  label: Text(sample, style: const TextStyle(fontSize: 10)),
                  backgroundColor: AppColors.surfaceLight,
                  onPressed: () => _simulateVoiceRecording(sample),
                );
              }).toList(),
            ),

            // Real-Time NLP Preview Card
            if (_preview != null) ...[
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: AppColors.surfaceLight,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: AppColors.cyanPrimary.withValues(alpha: 0.4)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Row(
                      children: [
                        Icon(Icons.auto_awesome, size: 14, color: AppColors.cyanPrimary),
                        SizedBox(width: 6),
                        Text(
                          'AI AUTO-DETECTED INTENT',
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w800,
                            color: AppColors.cyanPrimary,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      _preview!.title,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: AppColors.flameOrange.withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            'Category: ${_preview!.category.name.toUpperCase()}',
                            style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: AppColors.flameOrange),
                          ),
                        ),
                        const SizedBox(width: 6),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: AppColors.emeraldGreen.withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            'Priority: ${_preview!.priority.name.toUpperCase()}',
                            style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: AppColors.emeraldGreen),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],

            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton.icon(
                onPressed: _saveParsedTask,
                icon: const Icon(Icons.check, size: 18),
                label: const Text('Add Task from Voice Dump'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.cyanPrimary,
                  foregroundColor: Colors.black,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
