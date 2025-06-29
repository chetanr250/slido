import 'package:flutter/material.dart';

class JoinQuizScreen extends StatelessWidget {
  const JoinQuizScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Join Quiz'),
      ),
      body: const Center(
        child: Text('Join quiz flow goes here.'),
      ),
    );
  }
}
