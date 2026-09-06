import 'dart:convert';

class FlashcardItem {
  final String id;
  final String question;
  final String answer;
  final String category;
  final bool isMastered;

  FlashcardItem({
    required this.id,
    required this.question,
    required this.answer,
    required this.category,
    this.isMastered = false,
  });

  FlashcardItem copyWith({
    String? id,
    String? question,
    String? answer,
    String? category,
    bool? isMastered,
  }) {
    return FlashcardItem(
      id: id ?? this.id,
      question: question ?? this.question,
      answer: answer ?? this.answer,
      category: category ?? this.category,
      isMastered: isMastered ?? this.isMastered,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'question': question,
      'answer': answer,
      'category': category,
      'isMastered': isMastered,
    };
  }

  factory FlashcardItem.fromMap(Map<String, dynamic> map) {
    return FlashcardItem(
      id: map['id'] ?? '',
      question: map['question'] ?? '',
      answer: map['answer'] ?? '',
      category: map['category'] ?? 'General',
      isMastered: map['isMastered'] ?? false,
    );
  }

  String toJson() => json.encode(toMap());

  factory FlashcardItem.fromJson(String source) =>
      FlashcardItem.fromMap(json.decode(source));
}
