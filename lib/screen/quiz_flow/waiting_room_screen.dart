import 'package:flutter/material.dart';

class WaitingRoomScreen extends StatelessWidget {
  final String roomCode;
  final bool isAdmin;
  final List<String> participants;
  final VoidCallback? onStartQuiz;

  const WaitingRoomScreen({
    Key? key,
    required this.roomCode,
    required this.isAdmin,
    required this.participants,
    this.onStartQuiz,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Waiting Room')),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Room Code: $roomCode', style: const TextStyle(fontSize: 24)),
            const SizedBox(height: 16),
            // TODO: Add QR code widget here
            const SizedBox(height: 16),
            Text('Participants:', style: const TextStyle(fontSize: 18)),
            ...participants.map((p) => ListTile(title: Text(p))).toList(),
            const SizedBox(height: 32),
            if (isAdmin)
              ElevatedButton(
                onPressed: onStartQuiz,
                child: const Text('Start Quiz'),
              ),
            if (!isAdmin)
              const Text('Waiting for admin to start...',
                  style: TextStyle(fontSize: 16)),
          ],
        ),
      ),
    );
  }
}
