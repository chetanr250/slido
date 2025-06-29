import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
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
  late int correct;

  @override
  void initState() {
    super.initState();
    questionController =
        TextEditingController(text: widget.editQuestion?.question ?? '');
    options = List<String>.from(widget.editQuestion?.options ?? ['', '']);
    correct = widget.editQuestion?.correct ?? 0;
  }

  @override
  void dispose() {
    questionController.dispose();
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
              (i) => Row(
                children: [
                  Radio<int>(
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
                      controller: TextEditingController(text: options[i]),
                      onChanged: (val) => options[i] = val,
                      decoration: InputDecoration(
                        labelText: 'Option ${i + 1}',
                      ),
                    ),
                  ),
                  if (options.length > 2)
                    IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () {
                        setState(() {
                          options.removeAt(i);
                          if (correct >= options.length) correct = 0;
                        });
                      },
                    ),
                ],
              ),
            ),
            TextButton.icon(
              icon: const Icon(Icons.add),
              label: const Text('Add Option'),
              onPressed: () {
                setState(() {
                  options.add('');
                });
              },
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () {
            if (questionController.text.trim().isEmpty ||
                options.any((o) => o.isEmpty)) {
              return;
            }
            final question = Question(
              id: widget.editQuestion?.id ?? const Uuid().v4(),
              quizId: widget.quizId,
              question: questionController.text.trim(),
              options: List<String>.from(options),
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
