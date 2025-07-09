// import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/quiz.dart';
import '../models/question.dart';
import '../services/quiz_service.dart';

// final quizServiceProvider = Provider<QuizService>((ref) => QuizService());

// final quizProvider = FutureProvider.family<Quiz?, String>((ref, quizId) async {
//   final service = ref.watch(quizServiceProvider);
//   return service.getQuiz(quizId);
// });

// final questionsProvider =
//     FutureProvider.family<List<Question>, String>((ref, quizId) async {
//   final service = ref.watch(quizServiceProvider);
//   return service.getQuestionsForQuiz(quizId);
// });

// final quizActionsProvider = Provider<QuizActions>((ref) {
//   final service = ref.watch(quizServiceProvider);
//   return QuizActions(service);
// });

// class QuizActions {
//   final QuizService _service;
//   QuizActions(this._service);

//   Future<String> createNewQuiz(Quiz quiz) => _service.createNewQuiz(quiz);
//   Future<String> addOrUpdateQuestion(Question question) =>
//       _service.addOrUpdateQuestion(question: question);
//   Future<void> deleteQuestion(String quizId, String questionId) =>
//       _service.deleteQuestion(quizId, questionId);
//   // Future<void> deleteQuiz(String quizId) => _service.deleteQuiz(quizId);
// }
