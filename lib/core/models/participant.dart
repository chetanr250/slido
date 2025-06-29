import 'package:cloud_firestore/cloud_firestore.dart';

class Participant {
  final String email;
  final DateTime joinedAt;
  final List<ParticipantAnswer> answers;
  final int score;
  final int totalTime; // ms

  Participant({
    required this.email,
    required this.joinedAt,
    this.answers = const [],
    this.score = 0,
    this.totalTime = 0,
  });

  factory Participant.fromJson(Map<String, dynamic> json) {
    return Participant(
      email: json['email'] as String,
      joinedAt: (json['joinedAt'] as Timestamp).toDate(),
      answers: (json['answers'] as List<dynamic>?)
              ?.map((a) => ParticipantAnswer.fromJson(a))
              .toList() ??
          [],
      score: json['score'] as int? ?? 0,
      totalTime: json['totalTime'] as int? ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'joinedAt': joinedAt,
      'answers': answers.map((a) => a.toJson()).toList(),
      'score': score,
      'totalTime': totalTime,
    };
  }
}

class ParticipantAnswer {
  final String questionId;
  final int selectedOption;
  final DateTime answeredAt;
  final bool isCorrect;

  ParticipantAnswer({
    required this.questionId,
    required this.selectedOption,
    required this.answeredAt,
    required this.isCorrect,
  });

  factory ParticipantAnswer.fromJson(Map<String, dynamic> json) {
    return ParticipantAnswer(
      questionId: json['questionId'] as String,
      selectedOption: json['selectedOption'] as int,
      answeredAt: (json['answeredAt'] as Timestamp).toDate(),
      isCorrect: json['isCorrect'] as bool,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'questionId': questionId,
      'selectedOption': selectedOption,
      'answeredAt': answeredAt,
      'isCorrect': isCorrect,
    };
  }
}
