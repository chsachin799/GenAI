import 'dart:convert';

class SubtaskModel {
  final String id;
  final String title;
  final bool isCompleted;

  SubtaskModel({
    required this.id,
    required this.title,
    this.isCompleted = false,
  });

  SubtaskModel copyWith({
    String? id,
    String? title,
    bool? isCompleted,
  }) {
    return SubtaskModel(
      id: id ?? this.id,
      title: title ?? this.title,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'isCompleted': isCompleted,
    };
  }

  factory SubtaskModel.fromMap(Map<String, dynamic> map) {
    return SubtaskModel(
      id: map['id'] ?? '',
      title: map['title'] ?? '',
      isCompleted: map['isCompleted'] ?? false,
    );
  }

  String toJson() => json.encode(toMap());

  factory SubtaskModel.fromJson(String source) =>
      SubtaskModel.fromMap(json.decode(source));
}
