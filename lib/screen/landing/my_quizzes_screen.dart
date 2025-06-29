import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:slido/core/models/question.dart';
import 'package:slido/core/services/quiz_service.dart';
// import 'package:slido/core/services/user_service.dart';
import 'package:slido/util/email_getter.dart';
// import '../../core/providers/user_provider.dart';
// import '../../core/providers/quiz_provider.dart';
import '../../core/models/quiz.dart';
// import '../../core/models/question.dart';
// import '../../core/models/user.dart';
import 'create_quiz_screen.dart';
import '../../core/utils/time_utils.dart';

class MyQuizzesScreen extends ConsumerWidget {
  const MyQuizzesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = EMAIL;
    print(EMAIL);
    if (user == null) {
      return const Scaffold(body: Center(child: Text('Not authenticated')));
    }
    return Scaffold(
      appBar: AppBar(title: const Text('My Quizzes')),
      body: FutureBuilder<List<Quiz>>(
        future: _fetchUserQuizzes(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          final quizzes = snapshot.data ?? [];
          return Column(
            children: [
              Expanded(
                child: quizzes.isEmpty
                    ? const Center(child: Text('No quizzes found.'))
                    : ListView.builder(
                        itemCount: quizzes.length,
                        itemBuilder: (context, i) {
                          final quiz = quizzes[i];
                          return Card(
                            elevation: 4,
                            margin: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 8),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: ListTile(
                              contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 12),
                              leading: CircleAvatar(
                                backgroundColor: Colors.blue.shade100,
                                child: Text('${i + 1}'),
                              ),
                              title: Text(
                                quiz.name,
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 18),
                              ),
                              subtitle: Text(
                                'Questions: ${quiz.questions.length}\nCreated: ${timeAgo(quiz.createdAt)}',
                                style: const TextStyle(fontSize: 14),
                              ),
                              trailing: const Icon(Icons.edit,
                                  color: Colors.blueAccent),
                              onTap: () async {
                                // Fetch questions for this quiz
                                // final questions = await ref
                                //     .read(quizServiceProvider)
                                //     .getQuestionsForQuiz(quiz.id);

                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => CreateQuizScreen(
                                      quiz: quiz,
                                      index: i,
                                      initialQuestions: quiz.questions
                                          .map((q) => Question.fromJson(
                                              q as Map<String, dynamic>,
                                              (q as Map<String, dynamic>)['id']
                                                  as String))
                                          .toList(),
                                    ),
                                  ),
                                );
                              },
                            ),
                          );
                        },
                      ),
              ),
              SafeArea(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: ElevatedButton.icon(
                    icon: const Icon(Icons.add),
                    label: const Text('Create New Quiz'),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => CreateQuizScreen(
                                  index: quizzes.length,
                                )),
                      );
                    },
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Future<List<Quiz>> _fetchUserQuizzes() async {
    final userEmail = EMAIL;
    if (userEmail == null) {
      return [];
    }
    // print('fetchUserQuizzes');
    // print(userEmail);
    final quizzes = await QuizService().getQuiz();
    print(quizzes);
    // final userQuizzes = await FirebaseFirestore.instance
    //     .collection('users')
    //     .doc(userEmail)
    //     .get();
    // final quizIds = user.quizzes;
    // // final quizService = ref.read(quizServiceProvider);
    // final quizzes = <Quiz>[];
    // for (final id in quizIds) {
    //   final quiz = await quizService.getQuiz(id);
    //   if (quiz != null) quizzes.add(quiz);
    // }
    return quizzes;
  }
}
