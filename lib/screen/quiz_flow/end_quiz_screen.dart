import 'package:flutter/material.dart';

class EndQuizScreen extends StatelessWidget {
  final bool isAdmin;
  final VoidCallback? onSaveResults;
  final VoidCallback? onReturnHome;

  const EndQuizScreen({
    Key? key,
    required this.isAdmin,
    this.onSaveResults,
    this.onReturnHome,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Quiz Ended')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Quiz has ended!', style: TextStyle(fontSize: 24)),
            const SizedBox(height: 32),
            if (isAdmin && onSaveResults != null)
              ElevatedButton(
                onPressed: onSaveResults,
                child: const Text('Save Results'),
              ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: onReturnHome,
              child: const Text('Return to Home'),
            ),
          ],
        ),
      ),
    );
  }
}
