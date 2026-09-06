import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/app_colors.dart';
import '../../models/flashcard_model.dart';
import '../../engine/flashcard_generator_engine.dart';
import '../../state/todo_provider.dart';

class FlashcardStudyScreen extends StatefulWidget {
  final String taskTitle;

  const FlashcardStudyScreen({
    super.key,
    required this.taskTitle,
  });

  @override
  State<FlashcardStudyScreen> createState() => _FlashcardStudyScreenState();
}

class _FlashcardStudyScreenState extends State<FlashcardStudyScreen> {
  late List<FlashcardItem> _deck;
  int _currentIndex = 0;
  bool _showAnswer = false;
  int _masteredCount = 0;

  @override
  void initState() {
    super.initState();
    _deck = FlashcardGeneratorEngine.generateDeckForTask(widget.taskTitle);
  }

  void _flipCard() {
    setState(() => _showAnswer = !_showAnswer);
  }

  void _nextCard({required bool mastered}) {
    if (mastered) {
      _masteredCount++;
      context.read<TodoProvider>().recordPomodoroSession(minutes: 2); // XP bonus
    }

    if (_currentIndex < _deck.length - 1) {
      setState(() {
        _currentIndex++;
        _showAnswer = false;
      });
    } else {
      _showCompletionDialog();
    }
  }

  void _showCompletionDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.surfaceCard,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Row(
          children: [
            Icon(Icons.military_tech_rounded, color: AppColors.emeraldGreen, size: 28),
            SizedBox(width: 8),
            Text('Deck Mastered! 🎉'),
          ],
        ),
        content: Text(
          'You reviewed ${_deck.length} flashcards and mastered $_masteredCount concepts (+${_masteredCount * 30} XP)!',
          style: const TextStyle(color: AppColors.textSecondary, fontSize: 13),
        ),
        actions: [
          ElevatedButton(
            onPressed: () {
              Navigator.of(ctx).pop();
              Navigator.of(context).pop();
            },
            child: const Text('Back to Tasks'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_deck.isEmpty) {
      return Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(),
        body: const Center(child: Text('No flashcards available')),
      );
    }

    final card = _deck[_currentIndex];
    final progress = (_currentIndex + 1) / _deck.length;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Active Recall Flashcards'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              // Progress Bar
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Card ${_currentIndex + 1} of ${_deck.length}',
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: AppColors.cyanPrimary.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      card.category,
                      style: const TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w800,
                        color: AppColors.cyanPrimary,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: LinearProgressIndicator(
                  value: progress,
                  backgroundColor: AppColors.surfaceLight,
                  valueColor: const AlwaysStoppedAnimation<Color>(AppColors.cyanPrimary),
                  minHeight: 6,
                ),
              ),
              const SizedBox(height: 28),

              // Interactive Flip Card
              Expanded(
                child: GestureDetector(
                  onTap: _flipCard,
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    width: double.infinity,
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: _showAnswer ? const Color(0xFF1E293B) : AppColors.surface,
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(
                        color: _showAnswer
                            ? AppColors.emeraldGreen.withValues(alpha: 0.5)
                            : AppColors.cyanPrimary.withValues(alpha: 0.4),
                        width: 1.5,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: (_showAnswer ? AppColors.emeraldGreen : AppColors.cyanPrimary)
                              .withValues(alpha: 0.1),
                          blurRadius: 20,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(
                              _showAnswer ? Icons.visibility_rounded : Icons.help_outline_rounded,
                              size: 18,
                              color: _showAnswer ? AppColors.emeraldGreen : AppColors.cyanPrimary,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              _showAnswer ? 'ANSWER & RECALL EXPLANATION' : 'QUESTION & CONCEPT',
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w800,
                                color: _showAnswer ? AppColors.emeraldGreen : AppColors.cyanPrimary,
                                letterSpacing: 0.5,
                              ),
                            ),
                            const Spacer(),
                            const Text(
                              'Tap to Flip',
                              style: TextStyle(fontSize: 10, color: AppColors.textMuted),
                            ),
                          ],
                        ),
                        const SizedBox(height: 24),
                        Expanded(
                          child: SingleChildScrollView(
                            child: Text(
                              _showAnswer ? card.answer : card.question,
                              style: TextStyle(
                                fontSize: _showAnswer ? 15 : 18,
                                fontWeight: _showAnswer ? FontWeight.w500 : FontWeight.w700,
                                color: AppColors.textPrimary,
                                height: 1.5,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 28),

              // Action Buttons: Need Review vs I Knew It
              Row(
                children: [
                  Expanded(
                    child: SizedBox(
                      height: 50,
                      child: OutlinedButton.icon(
                        onPressed: () => _nextCard(mastered: false),
                        icon: const Icon(Icons.refresh_rounded, size: 18),
                        label: const Text('Need Review'),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: AppColors.flameOrange,
                          side: const BorderSide(color: AppColors.flameOrange),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: SizedBox(
                      height: 50,
                      child: ElevatedButton.icon(
                        onPressed: () => _nextCard(mastered: true),
                        icon: const Icon(Icons.check_circle_rounded, size: 18),
                        label: const Text('I Knew It! (+30 XP)'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.emeraldGreen,
                          foregroundColor: Colors.black,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
