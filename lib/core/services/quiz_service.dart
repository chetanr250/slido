import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:slido/util/email_getter.dart';
import '../models/quiz.dart';
import '../models/question.dart';

class QuizService {
  final CollectionReference usersCollection =
      FirebaseFirestore.instance.collection('users');
  // final userDoc = usersCollection.doc(EMAIL);

  // // Create a new quiz under user document
  Future<String> createQuiz(Quiz quiz) async {
    final userEmail = EMAIL;
    if (userEmail == null) throw Exception('User not authenticated');

    final quizId = quiz.id ?? DateTime.now().millisecondsSinceEpoch.toString();
    final quizData = quiz.copyWith(id: quizId).toJson();

    await usersCollection.doc(userEmail).update({
      'quizzes': FieldValue.arrayUnion([quizData])
    });
    return quizId ?? '';
  }

  ////
  Future<void> submitQuizToFirebase(Quiz quiz, int index) async {
    // print('submitQuizToFirebase');
    // print(quiz.toJson());
    // print(index);
    final userEmail = EMAIL;
    if (userEmail == null) throw Exception('User not authenticated');

    final userDoc = await usersCollection.doc(userEmail).get();
    if (!userDoc.exists) throw Exception('User document not found');

    final quizzes =
        (userDoc.data() as Map<String, dynamic>)['quizzes'] as List<dynamic>;

    // Update the quiz at the specified index
    quizzes[index] = quiz.toJson();

    // Update the user document with the modified quizzes array
    await usersCollection.doc(userEmail).update({'quizzes': quizzes});
  }

  // Get a quiz by ID
  Future<List<Quiz>> getQuiz() async {
    final userEmail = EMAIL;
    // print('getQuiz: $userEmail');
    // print('getQuiz');
    if (userEmail == null) throw Exception('User not authenticated');

    final userDoc = await usersCollection.doc(userEmail).get();
    // print('userDoc: ${(userDoc.data() as Map<String, dynamic>)['quizzes']}');
    if (!userDoc.exists) return [];

    final quizzes = (userDoc.data() as Map<String, dynamic>)['quizzes']
       ;
    // print(quizzes.length);
    // print('quizzes: $quizzes');

    List<Quiz> quizzesList = [];
    for (var i = 0; i < quizzes.length; i++) {
      try {
        // print(quizzes[i]);
        quizzesList.add(Quiz.fromJson(quizzes[i]));
      } catch (e) {
        print('Error: $e');
      }
    }
    // print(quizzesList);
    // print('quizzesList: ${quizzesList.length}');
    // print(quizzesList);
    return quizzesList;
  }

  // Add or update a question in a quiz
  Future<String> addOrUpdateQuestion(Question question) async {
    final userEmail = EMAIL;
    if (userEmail == null) throw Exception('User not authenticated');

    final userDoc = await usersCollection.doc(userEmail).get();
    if (!userDoc.exists) throw Exception('User document not found');

    final quizzes =
        (userDoc.data() as Map<String, dynamic>)['quizzes'] as List<dynamic>;
    final quizIndex = quizzes.indexWhere(
        (q) => (q as Map<String, dynamic>)['id'] == question.quizId);

    if (quizIndex == -1) throw Exception('Quiz not found');

    final quiz = quizzes[quizIndex] as Map<String, dynamic>;
    final questions = (quiz['questions'] as List<dynamic>?) ?? [];

    final questionId = question.id.isEmpty
        ? DateTime.now().millisecondsSinceEpoch.toString()
        : question.id;

    final questionData = question.copyWith(id: questionId).toJson();

    // Update or add the question
    final questionIndex = questions
        .indexWhere((q) => (q as Map<String, dynamic>)['id'] == questionId);

    if (questionIndex != -1) {
      questions[questionIndex] = questionData;
    } else {
      questions.add(questionData);
    }

    quiz['questions'] = questions;
    quizzes[quizIndex] = quiz;

    await usersCollection.doc(userEmail).update({'quizzes': quizzes});

    return questionId;
  }

  // Delete a question from a quiz
  Future<void> deleteQuestion(String quizId, String questionId) async {
    final userEmail = EMAIL;
    if (userEmail == null) throw Exception('User not authenticated');

    final userDoc = await usersCollection.doc(userEmail).get();
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

    await usersCollection.doc(userEmail).update({'quizzes': quizzes});
  }

  // Get all questions for a quiz
  Future<List<Question>> getQuestionsForQuiz(String quizId) async {
    final userEmail = EMAIL;
    if (userEmail == null) throw Exception('User not authenticated');

    final userDoc = await usersCollection.doc(userEmail).get();
    if (!userDoc.exists) throw Exception('User document not found');

    final quizzes =
        (userDoc.data() as Map<String, dynamic>)['quizzes'] as List<dynamic>;
    final quiz = quizzes.firstWhere(
      (q) => (q as Map<String, dynamic>)['id'] == quizId,
      orElse: () => null,
    );
    if (quiz == null) throw Exception('Quiz not found');
    final questions = (quiz['questions'] as List<dynamic>?) ?? [];
    return questions
        .map((q) => Question.fromJson(q as Map<String, dynamic>, (q)['id']))
        .toList();
  }

  // Delete a quiz
  Future<void> deleteQuiz(String quizId) async {
    final userEmail = EMAIL;
    if (userEmail == null) throw Exception('User not authenticated');

    final userDoc = await usersCollection.doc(userEmail).get();
    if (!userDoc.exists) throw Exception('User document not found');

    final quizzes =
        (userDoc.data() as Map<String, dynamic>)['quizzes'] as List<dynamic>;
    quizzes.removeWhere((q) => (q as Map<String, dynamic>)['id'] == quizId);

    await usersCollection.doc(userEmail).update({'quizzes': quizzes});
  }
}
