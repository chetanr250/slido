import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/models/room.dart';
import '../../core/models/quiz_status.dart';
import '../../core/providers/room_provider.dart';
import 'waiting_room_screen.dart';
import 'present_question_screen.dart';
import 'reveal_answer_screen.dart';
import 'show_selections_screen.dart';
import 'leaderboard_screen.dart';
import 'end_quiz_screen.dart';

class QuizFlowController extends ConsumerWidget {
  final String roomCode;
  final String userEmail;

  const QuizFlowController(
      {super.key, required this.roomCode, required this.userEmail});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final roomAsync = ref.watch(roomStreamProvider(roomCode));

    return roomAsync.when(
      data: (room) {
        if (room == null) {
          return const Scaffold(body: Center(child: Text('Room not found.')));
        }
        final isAdmin = room.adminEmail == userEmail;
        switch (room.status) {
          case QuizStatus.waiting:
            return WaitingRoomScreen(
              roomCode: room.roomCode,
              isAdmin: isAdmin,
              participants: room.participants.keys.toList(),
              onStartQuiz: isAdmin
                  ? () => ref
                      .read(roomActionsProvider)
                      .updateStatus(room.roomCode, QuizStatus.presentQuestion)
                  : null,
            );
          case QuizStatus.presentQuestion:
            final q = room.currentQuestion;
            final question = room.stats['questions']
                ?[q]; // Replace with actual question fetch
            return PresentQuestionScreen(
              questionText: question?['question'] ?? 'Question',
              options: List<String>.from(question?['options'] ?? []),
              selectedOption: null, // TODO: fetch user's answer if exists
              timeLeft: 20, // TODO: implement timer logic
              isAdmin: isAdmin,
              onNext: isAdmin
                  ? () => ref
                      .read(roomActionsProvider)
                      .updateStatus(room.roomCode, QuizStatus.revealAnswer)
                  : null,
              onSelectOption:
                  isAdmin ? null : (idx) {/* TODO: submit answer */},
            );
          case QuizStatus.revealAnswer:
            final q = room.currentQuestion;
            final question = room.stats['questions']?[q];
            return RevealAnswerScreen(
              questionText: question?['question'] ?? 'Question',
              options: List<String>.from(question?['options'] ?? []),
              correctIndex: question?['correct'] ?? 0,
              userAnswerIndex: null, // TODO: fetch user's answer
              isAdmin: isAdmin,
              allUserAnswers:
                  isAdmin ? {} : null, // TODO: fetch all answers for admin
            );
          case QuizStatus.showSelections:
            final q = room.currentQuestion;
            final question = room.stats['questions']?[q];
            return ShowSelectionsScreen(
              questionText: question?['question'] ?? 'Question',
              options: List<String>.from(question?['options'] ?? []),
              optionCounts:
                  List<int>.from(question?['optionCounts'] ?? [0, 0, 0, 0]),
              correctIndex: question?['correct'] ?? 0,
              totalParticipants: room.participants.length,
              extraStats: room.stats['extraStats'],
            );
          case QuizStatus.leaderboard:
            final leaderboard = (room.leaderboard ?? [])
                .map((e) => LeaderboardEntry(
                      userEmail: e['userEmail'],
                      score: e['score'],
                      totalTime: e['totalTime'],
                    ))
                .toList();
            return LeaderboardScreen(leaderboard: leaderboard);
          case QuizStatus.ended:
            return EndQuizScreen(
              isAdmin: isAdmin,
              onSaveResults: isAdmin ? () {/* TODO: save results */} : null,
              onReturnHome: () =>
                  Navigator.of(context).popUntil((route) => route.isFirst),
            );
        }
      },
      loading: () =>
          const Scaffold(body: Center(child: CircularProgressIndicator())),
      error: (e, st) => Scaffold(body: Center(child: Text('Error: $e'))),
    );
  }
}
