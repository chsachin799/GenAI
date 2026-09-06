import 'dart:convert';

class ScratchpadNote {
  final String id;
  final String content;
  final DateTime createdAt;

  ScratchpadNote({
    required this.id,
    required this.content,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'content': content,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory ScratchpadNote.fromMap(Map<String, dynamic> map) {
    return ScratchpadNote(
      id: map['id'] ?? '',
      content: map['content'] ?? '',
      createdAt: DateTime.parse(map['createdAt']),
    );
  }

  String toJson() => json.encode(toMap());

  factory ScratchpadNote.fromJson(String source) =>
      ScratchpadNote.fromMap(json.decode(source));
}
