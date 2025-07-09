import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:slido/util/email_getter.dart';
import '../models/quiz.dart';
import '../models/question.dart';

class QuizService {
  final DocumentReference<Map<String, dynamic>> userDocRef =
      FirebaseFirestore.instance.collection('users').doc(EMAIL);

  // // Create a new quiz under user document
  Future<String> createNewQuiz(Quiz quiz) async {
    final quizData = quiz.toJson();

    await userDocRef.update({
      'quizzes': FieldValue.arrayUnion([quizData])
    });
    return quiz.id!;
  }

  ////
  Future<void> submitQuizToFirebase(Quiz quiz, int index) async {
    final userDoc = await userDocRef.get();
    if (!userDoc.exists) throw Exception('User document not found');

    final quizzes =
        (userDoc.data() as Map<String, dynamic>)['quizzes'] as List<dynamic>;

    quizzes[index] = quiz.toJson();
    await userDocRef.update({'quizzes': quizzes});
  }

  Future<List<Quiz>> getQuiz() async {
    final userDoc = await userDocRef.get();
    if (!userDoc.exists) return [];

    final quizzes = (userDoc.data() as Map<String, dynamic>)['quizzes'];

    List<Quiz> quizzesList = [];
    for (var i = 0; i < quizzes.length; i++) {
      try {
        quizzesList.add(Quiz.fromJson(quizzes[i]));
      } catch (e) {
        print('Error: $e');
      }
    }
    return quizzesList;
  }

  // Add or update a question in a quiz
  Future<String> addOrUpdateQuestion(
      {required Question question, int? index}) async {
    final userDoc = await userDocRef.get();
    if (!userDoc.exists) throw Exception('User document not found');

    final quizzes =
        (userDoc.data() as Map<String, dynamic>)['quizzes'] as List<dynamic>;
    final quizIndex = quizzes.indexWhere(
        (q) => (q as Map<String, dynamic>)['id'] == question.quizId);

    if (quizIndex == -1) throw Exception('Quiz not found');

    final quiz = quizzes[quizIndex] as Map<String, dynamic>;
    final questions = (quiz['questions'] as List<dynamic>?) ?? [];
    questions;
    //TODO: Implement add and update questions (prefer to differenciate)
    return Future.delayed(Duration.zero, () {
      return "";
    });
  }

  // Delete a question from a quiz
  Future<void> deleteQuestion(String quizId, String questionId) async {
    final userDoc = await userDocRef.get();
    if (!userDoc.exists) throw Exception('User document not found');

    final quizzes =
        (userDoc.data() as Map<String, dynamic>)['quizzes'] as List<dynamic>;
    final quizIndex =
        quizzes.indexWhere((q) => (q as Map<String, dynamic>)['id'] == quizId);

    if (quizIndex == -1) throw Exception('Quiz not found');

    final quiz = quizzes[quizIndex] as Map<String, dynamic>;
    final questions = (quiz['questions'] as List<dynamic>?) ?? [];

    questions
        .removeWhere((q) => (q as Map<String, dynamic>)['id'] == questionId);

    quiz['questions'] = questions;
    quizzes[quizIndex] = quiz;

    await userDocRef.update({'quizzes': quizzes});
  }

  // // Get all questions for a quiz
  // Future<List<Question>> getQuestionsForQuiz(String quizId) async {
  //   final userDoc = await userDocRef.get();
  //   if (!userDoc.exists) throw Exception('User document not found');

  //   final quizzes =
  //       (userDoc.data() as Map<String, dynamic>)['quizzes'] as List<dynamic>;
  //   final quiz = quizzes.firstWhere(
  //     (q) => (q as Map<String, dynamic>)['id'] == quizId,
  //     orElse: () => null,
  //   );
  //   if (quiz == null) throw Exception('Quiz not found');
  //   final questions = (quiz['questions'] as List<dynamic>?) ?? [];
  //   // TODO: implement getQuestionsForQuiz
  //   return questions as Future<List<Question>>;
  // }

  // Delete a quiz
  Future<List<Quiz>> deleteQuiz(int index, List<Quiz> quizzes) async {
    quizzes.removeAt(index);
    final jsonQuizzes = quizzes.map((q) => q.toJson()).toList();
    await userDocRef.update({'quizzes': jsonQuizzes});
    return quizzes;
  }
}
