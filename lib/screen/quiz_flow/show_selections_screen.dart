import 'package:flutter/material.dart';

class ShowSelectionsScreen extends StatelessWidget {
  final String questionText;
  final List<String> options;
  final List<int> optionCounts;
  final int correctIndex;
  final int totalParticipants;
  final Map<String, dynamic>? extraStats;

  const ShowSelectionsScreen({
    Key? key,
    required this.questionText,
    required this.options,
    required this.optionCounts,
    required this.correctIndex,
    required this.totalParticipants,
    this.extraStats,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Selections & Stats')),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(questionText, style: const TextStyle(fontSize: 22)),
            const SizedBox(height: 24),
            ...List.generate(
                options.length,
                (i) => ListTile(
                      title: Text(options[i]),
                      trailing: Text('${optionCounts[i]}',
                          style: const TextStyle(fontSize: 18)),
                      leading: i == correctIndex
                          ? const Icon(Icons.check_circle, color: Colors.green)
                          : null,
                    )),
            const SizedBox(height: 32),
            Text('Total Participants: $totalParticipants',
                style: const TextStyle(fontSize: 16)),
            if (extraStats != null) ...[
              const SizedBox(height: 16),
              Text('Other Stats:', style: const TextStyle(fontSize: 16)),
              ...extraStats!.entries.map((e) => Text('${e.key}: ${e.value}')),
            ],
          ],
        ),
      ),
    );
  }
}
