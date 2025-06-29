import 'package:flutter/material.dart';

class RevealAnswerScreen extends StatelessWidget {
  final String questionText;
  final List<String> options;
  final int correctIndex;
  final int? userAnswerIndex;
  final bool isAdmin;
  final Map<String, int>? allUserAnswers; // email -> answer index

  const RevealAnswerScreen({
    Key? key,
    required this.questionText,
    required this.options,
    required this.correctIndex,
    this.userAnswerIndex,
    required this.isAdmin,
    this.allUserAnswers,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Reveal Answer')),
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
                      leading: Icon(
                        i == correctIndex
                            ? Icons.check_circle
                            : (userAnswerIndex == i
                                ? Icons.radio_button_checked
                                : Icons.radio_button_unchecked),
                        color: i == correctIndex
                            ? Colors.green
                            : (userAnswerIndex == i ? Colors.blue : null),
                      ),
                    )),
            const SizedBox(height: 32),
            if (isAdmin && allUserAnswers != null)
              Expanded(
                child: ListView(
                  children: allUserAnswers!.entries.map((entry) {
                    return ListTile(
                      title: Text(entry.key),
                      subtitle: Text('Answered: ${options[entry.value]}'),
                      trailing: entry.value == correctIndex
                          ? const Icon(Icons.check, color: Colors.green)
                          : const Icon(Icons.close, color: Colors.red),
                    );
                  }).toList(),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
