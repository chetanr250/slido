import 'package:cloud_firestore/cloud_firestore.dart';
import 'quiz_status.dart';

class Room {
  final String roomCode;
  final String adminEmail;
  final String quizId;
  final QuizStatus status;
  final int currentQuestion;
  final Map<String, dynamic> participants; // Map<userEmail, Participant>
  final DateTime startedAt;
  final DateTime? endedAt;
  final Map<String, dynamic> stats;
  final List<dynamic> leaderboard;

  Room({
    required this.roomCode,
    required this.adminEmail,
    required this.quizId,
    required this.status,
    required this.currentQuestion,
    required this.participants,
    required this.startedAt,
    this.endedAt,
    this.stats = const {},
    this.leaderboard = const [],
  });

  factory Room.fromJson(Map<String, dynamic> json, String roomCode) {
    return Room(
      roomCode: roomCode,
      adminEmail: json['adminEmail'] as String,
      quizId: json['quizId'] as String,
      status: quizStatusFromString(json['status'] as String),
      currentQuestion: json['currentQuestion'] as int,
      participants: json['participants'] as Map<String, dynamic>? ?? {},
      startedAt: (json['startedAt'] as Timestamp).toDate(),
      endedAt: json['endedAt'] != null
          ? (json['endedAt'] as Timestamp).toDate()
          : null,
      stats: json['stats'] as Map<String, dynamic>? ?? {},
      leaderboard: json['leaderboard'] as List<dynamic>? ?? [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'adminEmail': adminEmail,
      'quizId': quizId,
      'status': quizStatusToString(status),
      'currentQuestion': currentQuestion,
      'participants': participants,
      'startedAt': startedAt,
      'endedAt': endedAt,
      'stats': stats,
      'leaderboard': leaderboard,
    };
  }
}
