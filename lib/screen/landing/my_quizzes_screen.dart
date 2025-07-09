import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:slido/core/services/quiz_service.dart';
import 'package:slido/util/email_getter.dart';
import '../../core/models/quiz.dart';
import 'create_quiz_screen.dart';
import '../../core/utils/time_utils.dart';

class MyQuizzesScreen extends ConsumerStatefulWidget {
  const MyQuizzesScreen({super.key});

  @override
  ConsumerState<MyQuizzesScreen> createState() => _MyQuizzesScreenState();
}

class _MyQuizzesScreenState extends ConsumerState<MyQuizzesScreen> {
  late List<Quiz> quizzes;

  @override
  Widget build(BuildContext context) {
    final user = EMAIL;
    print(EMAIL);
    if (user == null) {
      return const Scaffold(body: Center(child: Text('Not authenticated')));
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Quizzes'),
      ),
      body: FutureBuilder<List<Quiz>>(
        future: _fetchUserQuizzes(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          quizzes = snapshot.data ?? [];
          return Column(
            children: [
              Expanded(
                child: quizzes.isEmpty
                    ? const Center(child: Text('No quizzes found.'))
                    : ListView.builder(
                        itemCount: quizzes.length,
                        itemBuilder: (context, i) {
                          final Quiz quiz = quizzes[i];
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
                              trailing: IconButton(
                                onPressed: () async {
                                  final q = await QuizService()
                                      .deleteQuiz(i, quizzes);
                                  setState(() {
                                    quizzes = q;
                                  });

                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content:
                                          Text('Quiz deleted successfully'),
                                    ),
                                  );
                                },
                                icon: const Icon(Icons.delete,
                                    color: Colors.blueAccent),
                                tooltip: 'Edit Quiz',
                              ),
                              onTap: () async {
                                final updatedQuiz = await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => CreateQuizScreen(
                                        quiz: quiz,
                                        index: i,
                                        initialQuestions: quiz.questions),
                                  ),
                                );
                                if (updatedQuiz == null) return;
                                setState(() {
                                  quizzes[i] = updatedQuiz;
                                });

                                // updatedQuiz.then((value) {
                                //   if (value != null) {
                                //     setState(() {
                                //       quizzes[i] = value;
                                //     });
                                //   }
                                // });
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
    final quizzes = await QuizService().getQuiz();
    return quizzes;
  }
}
