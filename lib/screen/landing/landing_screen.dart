import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:slido/core/providers/user_provider.dart';
import 'package:slido/screen/auth/auth.dart';
import 'my_quizzes_screen.dart';

class LandingScreen extends ConsumerWidget {
  const LandingScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Quiz App'),
          actions: [
            IconButton(
              onPressed: () {
                // ref.read(currentUserProvider.notifier).state = null;
                FirebaseAuth.instance.signOut();
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const Auth()),
                );
              },
              icon: const Icon(Icons.logout),
            ),
          ],
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton.icon(
                icon: const Icon(Icons.list_alt),
                label: const Text('My Quizzes'),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const MyQuizzesScreen(),
                    ),
                  );
                },
              ),
              const SizedBox(height: 24),
              ElevatedButton.icon(
                icon: const Icon(Icons.group),
                label: const Text('Join Quiz'),
                onPressed: () {
                  Navigator.pushNamed(context, '/joinQuiz');
                },
              ),
              const SizedBox(height: 24),
              ElevatedButton.icon(
                icon: const Icon(Icons.history),
                label: const Text('View Past Results'),
                onPressed: () {
                  Navigator.pushNamed(context, '/pastResults');
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
