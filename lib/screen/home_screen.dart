import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:slido/Providers/shared_preferences_provider.dart';
import 'package:slido/screen/interaction/interactive_mode.dart';
import 'package:slido/widgets/create_slido/add_questions.dart';
import 'package:slido/widgets/home_screen/questions_list.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      bottomNavigationBar: BottomAppBar(
        child: Padding(
          padding: const EdgeInsets.all(0),
          child: ElevatedButton(
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const InteractiveMode(),
                  ));
            },
            child: const Text('Start interaction'),
          ),
        ),
      ),
      appBar: AppBar(
        title: const Text('Create Slido'),
        actions: [
          IconButton(
            onPressed: () {
              // logout(ref, context);
            },
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const AddQuestions(),
            const SizedBox(height: 10),
            QuestionsList()
          ],
        ),
      ),
    );
  }
}
