class CopilotAdvice {
  final String summary;
  final String? codeSnippet;
  final List<String> steps;
  final String estimatedTime;
  final String proTip;

  CopilotAdvice({
    required this.summary,
    this.codeSnippet,
    required this.steps,
    required this.estimatedTime,
    required this.proTip,
  });
}

class AiCopilotService {
  static CopilotAdvice getAdviceForTask(String taskTitle) {
    final lower = taskTitle.toLowerCase();

    if (lower.contains('aiml') || lower.contains('deep learning') || lower.contains('neural')) {
      return CopilotAdvice(
        summary: 'AIML Deep Learning Pipeline Setup Guide with PyTorch / TensorFlow.',
        codeSnippet: '''import torch
import torch.nn as nn

class SimpleClassifier(nn.Module):
    def __init__(self, input_dim, num_classes):
        super().__init__()
        self.net = nn.Sequential(
            nn.Linear(input_dim, 128),
            nn.ReLU(),
            nn.Dropout(0.2),
            nn.Linear(128, num_classes)
        )
    def forward(self, x):
        return self.net(x)''',
        steps: [
          'Verify dataset normalization and train/test split (80/20).',
          'Use AdamW optimizer with learning rate 1e-3 and CrossEntropyLoss.',
          'Log loss per epoch and save best weights checkpoint.',
          'Test inference on sample batch and compute F1-score.',
        ],
        estimatedTime: '45 - 60 minutes',
        proTip: 'Always freeze base weights first if fine-tuning a pre-trained HuggingFace or ResNet model!',
      );
    } else if (lower.contains('hackathon') || lower.contains('video') || lower.contains('pitch')) {
      return CopilotAdvice(
        summary: '120-Second Winning Hackathon Pitch Structure.',
        steps: [
          '00:00 - 00:25: Hook the judges with the real-world pain point & current flaws.',
          '00:25 - 01:20: Live screen recording showing actual product working (no fake mockups).',
          '01:20 - 01:45: Tech stack architecture highlight (FastAPI, Flutter, AI Models, Supabase).',
          '01:45 - 02:00: Business impact, sponsor bounty alignment, and future vision.',
        ],
        estimatedTime: '30 minutes',
        proTip: 'Record screen in 1080p, speak at 1.1x brisk tempo, and test microphone audio before recording the full run!',
      );
    } else if (lower.contains('dsa') || lower.contains('leetcode') || lower.contains('algorithm')) {
      return CopilotAdvice(
        summary: 'Optimal Problem Solving & Complexity Strategy.',
        codeSnippet: '''// Two-Pointer / Sliding Window Template
int maxWindow(List<int> nums, int k) {
  int left = 0, currentSum = 0, maxSum = 0;
  for (int right = 0; right < nums.length; right++) {
    currentSum += nums[right];
    if (right - left + 1 > k) {
      currentSum -= nums[left++];
    }
    maxSum = max(maxSum, currentSum);
  }
  return maxSum;
}''',
        steps: [
          'Identify pattern: Sliding Window, Two-Pointers, BFS/DFS, or DP.',
          'Check edge cases: Empty input, negative values, single element, extreme N.',
          'Aim for O(N) or O(N log N) complexity before writing code.',
        ],
        estimatedTime: '25 minutes',
        proTip: 'Explain your thought process out loud as if in an interview setting!',
      );
    } else {
      return CopilotAdvice(
        summary: 'Structured Sprint Execution Plan.',
        steps: [
          'Block 25 minutes of zero-distraction focus with Pomodoro timer.',
          'Eliminate non-essential micro-decisions and produce raw draft first.',
          'Review against initial requirements and polish final output.',
        ],
        estimatedTime: '25 minutes',
        proTip: 'Done is better than perfect. Iterate after the initial functional pass!',
      );
    }
  }
}
