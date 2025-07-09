import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:slido/core/models/question.dart';

class Quiz {
  final String? id;
  final String name;
  final String createdBy;
  final DateTime createdAt;
  final List<Question> questions;

  Quiz({
    this.id,
    required this.name,
    required this.createdBy,
    required this.createdAt,
    this.questions = const [],
  });

  factory Quiz.fromJson(Map<String, dynamic> json) {
    return Quiz(
      id: json['id'],
      name: json['name'] as String,
      createdBy: json['createdBy'] as String,
      createdAt: (json['createdAt'] as Timestamp).toDate(),
      questions: (json['questions'] as List<dynamic>?)
              ?.map((q) => Question.fromJson(q as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'createdBy': createdBy,
      'createdAt': createdAt,
      'questions': questions.map((e) => e.toJson()).toList(),
      'id': id,
    };
  }

  Quiz copyWith({
    String? id,
    String? name,
    String? createdBy,
    DateTime? createdAt,
    List<Question>? questions,
  }) {
    return Quiz(
      id: id ?? this.id,
      name: name ?? this.name,
      createdBy: createdBy ?? this.createdBy,
      createdAt: createdAt ?? this.createdAt,
      questions: questions ?? this.questions,
    );
  }
}
