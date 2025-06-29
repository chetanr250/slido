enum QuizStatus {
  waiting,
  presentQuestion,
  revealAnswer,
  showSelections,
  leaderboard,
  ended,
}

QuizStatus quizStatusFromString(String status) {
  switch (status) {
    case 'waiting':
      return QuizStatus.waiting;
    case 'present_question':
      return QuizStatus.presentQuestion;
    case 'reveal_answer':
      return QuizStatus.revealAnswer;
    case 'show_selections':
      return QuizStatus.showSelections;
    case 'leaderboard':
      return QuizStatus.leaderboard;
    case 'ended':
      return QuizStatus.ended;
    default:
      throw Exception('Unknown status: $status');
  }
}

String quizStatusToString(QuizStatus status) {
  switch (status) {
    case QuizStatus.waiting:
      return 'waiting';
    case QuizStatus.presentQuestion:
      return 'present_question';
    case QuizStatus.revealAnswer:
      return 'reveal_answer';
    case QuizStatus.showSelections:
      return 'show_selections';
    case QuizStatus.leaderboard:
      return 'leaderboard';
    case QuizStatus.ended:
      return 'ended';
  }
}
