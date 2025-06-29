class Question {
  final String id;
  final String quizId;
  final String question;
  final List<String> options;
  final int correct;

  Question({
    required this.id,
    required this.quizId,
    required this.question,
    required this.options,
    required this.correct,
  });

  factory Question.fromJson(Map<String, dynamic> json, String id) {
    return Question(
      id: id,
      quizId: json['quizId'] as String,
      question: json['question'] as String,
      options: (json['options'] as List<dynamic>).cast<String>(),
      correct: json['correct'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'quizId': quizId,
      'question': question,
      'options': options,
      'correct': correct,
    };
  }

  Question copyWith({
    String? id,
    String? quizId,
    String? question,
    List<String>? options,
    int? correct,
  }) {
    return Question(
      id: id ?? this.id,
      quizId: quizId ?? this.quizId,
      question: question ?? this.question,
      options: options ?? this.options,
      correct: correct ?? this.correct,
    );
  }
}
