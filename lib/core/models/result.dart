import 'package:cloud_firestore/cloud_firestore.dart';

class QuizResult {
  final String id;
  final String roomCode;
  final String quizId;
  final String adminEmail;
  final DateTime endedAt;
  final List<dynamic> leaderboard;
  final Map<String, dynamic> stats;

  QuizResult({
    required this.id,
    required this.roomCode,
    required this.quizId,
    required this.adminEmail,
    required this.endedAt,
    this.leaderboard = const [],
    this.stats = const {},
  });

  factory QuizResult.fromJson(Map<String, dynamic> json, String id) {
    return QuizResult(
      id: id,
      roomCode: json['roomCode'] as String,
      quizId: json['quizId'] as String,
      adminEmail: json['adminEmail'] as String,
      endedAt: (json['endedAt'] as Timestamp).toDate(),
      leaderboard: json['leaderboard'] as List<dynamic>? ?? [],
      stats: json['stats'] as Map<String, dynamic>? ?? {},
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'roomCode': roomCode,
      'quizId': quizId,
      'adminEmail': adminEmail,
      'endedAt': endedAt,
      'leaderboard': leaderboard,
      'stats': stats,
    };
  }
}
