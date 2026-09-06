import 'package:uuid/uuid.dart';
import '../models/flashcard_model.dart';

class FlashcardGeneratorEngine {
  static const _uuid = Uuid();

  static List<FlashcardItem> generateDeckForTask(String taskTitle, {List<String>? resourceUrls}) {
    final lower = taskTitle.toLowerCase();

    if (lower.contains('aiml') || lower.contains('deep learning') || lower.contains('neural')) {
      return [
        FlashcardItem(
          id: _uuid.v4(),
          category: 'AIML',
          question: 'What is the vanishing gradient problem and how does ReLU mitigate it?',
          answer: 'Sigmoid/Tanh gradients saturate near 0 for large inputs. ReLU maintains a constant derivative of 1 for x > 0, preventing gradient vanishing in deep layers.',
        ),
        FlashcardItem(
          id: _uuid.v4(),
          category: 'AIML',
          question: 'Why do we use AdamW instead of standard Adam with L2 regularization?',
          answer: 'Adam with standard L2 penalizes weights coupled with gradient momentum incorrectly. AdamW properly decouples weight decay from gradient updates.',
        ),
        FlashcardItem(
          id: _uuid.v4(),
          category: 'AIML',
          question: 'What is the difference between Batch Normalization and Layer Normalization?',
          answer: 'BatchNorm normalizes across the batch dimension (effective in CNNs). LayerNorm normalizes across the channel/feature dimension per sample (essential in Transformers).',
        ),
        FlashcardItem(
          id: _uuid.v4(),
          category: 'AIML',
          question: 'How does Cross-Entropy Loss penalize confident wrong predictions?',
          answer: 'CrossEntropy = -log(P(y_true)). As the predicted probability for the true class approaches 0, the loss exponentially approaches infinity.',
        ),
      ];
    } else if (lower.contains('dsa') || lower.contains('leetcode') || lower.contains('algorithm')) {
      return [
        FlashcardItem(
          id: _uuid.v4(),
          category: 'DSA',
          question: 'When should you use Sliding Window instead of Two Pointers?',
          answer: 'Sliding Window is optimal for contiguous subarray/substring problems looking for min/max size or fixed length K with constraint tracking.',
        ),
        FlashcardItem(
          id: _uuid.v4(),
          category: 'DSA',
          question: 'What is the time complexity of building a heap from an array of N elements?',
          answer: 'O(N) time using Floyd\'s bottom-up heapify algorithm, not O(N log N) like sequential insertions.',
        ),
        FlashcardItem(
          id: _uuid.v4(),
          category: 'DSA',
          question: 'How do you detect a cycle in a directed vs undirected graph?',
          answer: 'Undirected: Simple DFS checking visited ancestor. Directed: DFS with 3-color states (White = unvisited, Gray = in current recursion stack, Black = processed).',
        ),
      ];
    } else if (lower.contains('hackathon') || lower.contains('project') || lower.contains('architecture')) {
      return [
        FlashcardItem(
          id: _uuid.v4(),
          category: 'Hackathon MVP',
          question: 'What is the 80/20 rule for Hackathon demo features?',
          answer: 'Build only the critical "Happy Path" user journey that demonstrates the core value proposition in under 60 seconds of video footage.',
        ),
        FlashcardItem(
          id: _uuid.v4(),
          category: 'Hackathon MVP',
          question: 'Why must code freeze occur 2 hours before the hard submission deadline?',
          answer: 'To ensure time to render video, verify public GitHub repository permissions, test deployment in Incognito mode, and avoid server crashes.',
        ),
        FlashcardItem(
          id: _uuid.v4(),
          category: 'Hackathon MVP',
          question: 'What makes a Devpost submission description stand out to judges?',
          answer: 'Clear problem statement, real-world impact, architecture diagram, challenges overcome, and sponsor track integration details.',
        ),
      ];
    } else {
      return [
        FlashcardItem(
          id: _uuid.v4(),
          category: 'Core Concepts',
          question: 'What is the primary objective of this task?',
          answer: 'Define clear completion criteria and eliminate non-essential friction to produce high-quality output.',
        ),
        FlashcardItem(
          id: _uuid.v4(),
          category: 'Core Concepts',
          question: 'How can you verify that this task is successfully done?',
          answer: 'Review output against initial requirements, run tests, and check deliverables.',
        ),
      ];
    }
  }
}
