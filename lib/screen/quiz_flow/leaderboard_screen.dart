import 'package:flutter/material.dart';

class LeaderboardScreen extends StatelessWidget {
  final List<LeaderboardEntry> leaderboard;

  const LeaderboardScreen({Key? key, required this.leaderboard})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Leaderboard')),
      body: ListView.separated(
        padding: const EdgeInsets.all(24.0),
        itemCount: leaderboard.length,
        separatorBuilder: (_, __) => const Divider(),
        itemBuilder: (context, i) {
          final entry = leaderboard[i];
          return ListTile(
            leading: Text('#${i + 1}', style: const TextStyle(fontSize: 20)),
            title: Text(entry.userEmail),
            subtitle: Text('Score: ${entry.score} | Time: ${entry.totalTime}s'),
            trailing: i == 0
                ? const Icon(Icons.emoji_events, color: Colors.amber)
                : null,
          );
        },
      ),
    );
  }
}

class LeaderboardEntry {
  final String userEmail;
  final int score;
  final int totalTime;

  LeaderboardEntry(
      {required this.userEmail, required this.score, required this.totalTime});
}
