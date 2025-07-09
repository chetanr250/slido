import 'package:flutter/material.dart';
import '../../core/models/question.dart';

class QuestionDialog extends StatefulWidget {
  final Question? editQuestion;
  final String quizId;
  final Function(Question) onSave;

  const QuestionDialog({
    super.key,
    this.editQuestion,
    required this.quizId,
    required this.onSave,
  });

  @override
  State<QuestionDialog> createState() => _QuestionDialogState();
}

class _QuestionDialogState extends State<QuestionDialog> {
  late TextEditingController questionController;
  late List<String> options;
  late List<TextEditingController> optionControllers;
  late int correct;

  @override
  void initState() {
    super.initState();
    questionController =
        TextEditingController(text: widget.editQuestion?.question ?? '');
    options = List<String>.from(widget.editQuestion?.options ?? ['', '']);
    correct = widget.editQuestion?.correct ?? 0;

    // Create controllers for each option
    optionControllers =
        options.map((option) => TextEditingController(text: option)).toList();
  }

  @override
  void dispose() {
    questionController.dispose();
    // Dispose all option controllers
    for (var controller in optionControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: TextField(
        textCapitalization: TextCapitalization.sentences,
        controller: questionController,
        autofocus: true,
        decoration: InputDecoration(
          labelText:
              'Question ${widget.editQuestion == null ? '' : widget.editQuestion!.question}',
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          labelStyle: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ...List.generate(
              options.length,
              (i) => Container(
                margin: const EdgeInsets.symmetric(vertical: 4),
                decoration: BoxDecoration(
                  border: correct == i && optionControllers[i].text.isNotEmpty
                      ? Border.all(color: Colors.green, width: 2)
                      : Border.all(color: Colors.grey.shade700),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Radio<int>(
                      activeColor: Colors.green,
                      value: i,
                      groupValue: correct,
                      onChanged: (val) {
                        setState(() {
                          correct = val!;
                        });
                      },
                    ),
                    Expanded(
                      child: TextField(
                        controller: optionControllers[i],
                        onChanged: (val) {
                          setState(() {
                            options[i] = val;
                          });
                        },
                        decoration: InputDecoration(
                          focusedBorder: InputBorder.none,
                          border: InputBorder.none,
                          hintText: 'Option ${i + 1}',
                        ),
                      ),
                    ),
                    if (options.length > 2)
                      IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () {
                          setState(() {
                            optionControllers[i].dispose();
                            optionControllers.removeAt(i);
                            options.removeAt(i);
                            if (correct >= options.length) correct = 0;
                          });
                        },
                      ),
                  ],
                ),
              ),
            ),
            TextButton.icon(
              icon: const Icon(Icons.add),
              label: const Text('Add Option'),
              onPressed: () {
                setState(() {
                  options.add('');
                  optionControllers.add(TextEditingController());
                });
              },
            ),
          ],
        ),
        // ],
      ),
      // ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () {
            if (questionController.text.trim().isEmpty ||
                optionControllers
                    .any((controller) => controller.text.isEmpty)) {
              return;
            }
            final question = Question(
              quizId: widget.quizId,
              question: questionController.text.trim(),
              options: optionControllers
                  .map((controller) => controller.text)
                  .toList(),
              correct: correct,
            );
            widget.onSave(question);
            Navigator.pop(context);
          },
          child: Text(widget.editQuestion == null ? 'Add' : 'Save'),
        ),
      ],
    );
  }
}
