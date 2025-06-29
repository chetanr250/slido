import 'package:flutter/material.dart';

class PresentQuestionScreen extends StatelessWidget {
  final String questionText;
  final List<String> options;
  final int? selectedOption;
  final int timeLeft;
  final bool isAdmin;
  final VoidCallback? onNext;
  final ValueChanged<int?>? onSelectOption;

  const PresentQuestionScreen({
    Key? key,
    required this.questionText,
    required this.options,
    this.selectedOption,
    required this.timeLeft,
    required this.isAdmin,
    this.onNext,
    this.onSelectOption,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Question')),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Time left: $timeLeft s',
                style: const TextStyle(fontSize: 18)),
            const SizedBox(height: 16),
            Text(questionText, style: const TextStyle(fontSize: 22)),
            const SizedBox(height: 24),
            ...List.generate(
                options.length,
                (i) => ListTile(
                      title: Text(options[i]),
                      leading: Radio<int>(
                        value: i,
                        groupValue: selectedOption,
                        onChanged: isAdmin ? null : onSelectOption,
                      ),
                    )),
            const Spacer(),
            if (isAdmin)
              ElevatedButton(
                onPressed: onNext,
                child: const Text('Next'),
              ),
          ],
        ),
      ),
    );
  }
}
