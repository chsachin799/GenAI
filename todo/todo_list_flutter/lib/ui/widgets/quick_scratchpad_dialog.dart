import 'package:flutter/material.dart';
import '../../core/app_colors.dart';

class QuickScratchpadDialog extends StatefulWidget {
  const QuickScratchpadDialog({super.key});

  @override
  State<QuickScratchpadDialog> createState() => _QuickScratchpadDialogState();
}

class _QuickScratchpadDialogState extends State<QuickScratchpadDialog> {
  final _noteController = TextEditingController();
  static final List<String> _scratchpadNotes = [
    'Remember to push git commits before demo recording',
    'Review cross-entropy loss formula for viva',
  ];

  @override
  void dispose() {
    _noteController.dispose();
    super.dispose();
  }

  void _addNote() {
    if (_noteController.text.trim().isEmpty) return;
    setState(() {
      _scratchpadNotes.insert(0, _noteController.text.trim());
      _noteController.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: AppColors.surface,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.edit_note_rounded, color: AppColors.cyanPrimary, size: 24),
                const SizedBox(width: 8),
                const Text(
                  'Quick Floating Scratchpad',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                ),
                const Spacer(),
                IconButton(
                  icon: const Icon(Icons.close, color: AppColors.textMuted, size: 20),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ],
            ),
            const SizedBox(height: 6),
            const Text(
              'Capture distracting thoughts instantly without breaking flow.',
              style: TextStyle(fontSize: 11, color: AppColors.textSecondary),
            ),
            const SizedBox(height: 14),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _noteController,
                    style: const TextStyle(fontSize: 12, color: AppColors.textPrimary),
                    decoration: const InputDecoration(
                      hintText: 'Type quick thought / note...',
                      contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(
                  onPressed: _addNote,
                  icon: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: AppColors.cyanPrimary,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(Icons.add, color: Colors.black, size: 18),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),
            ConstrainedBox(
              constraints: const BoxConstraints(maxHeight: 180),
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: _scratchpadNotes.length,
                itemBuilder: (context, index) {
                  return Container(
                    margin: const EdgeInsets.only(bottom: 6),
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                    decoration: BoxDecoration(
                      color: AppColors.surfaceLight,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: AppColors.border),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.circle, size: 6, color: AppColors.cyanPrimary),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            _scratchpadNotes[index],
                            style: const TextStyle(fontSize: 12, color: AppColors.textPrimary),
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete_outline_rounded, size: 14, color: AppColors.textMuted),
                          onPressed: () => setState(() => _scratchpadNotes.removeAt(index)),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
