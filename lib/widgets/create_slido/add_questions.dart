import 'package:flutter/material.dart';
import 'package:slido/screen/create/create_question.dart';

class AddQuestions extends StatelessWidget {
  const AddQuestions({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height - 100,
        maxWidth: MediaQuery.of(context).size.width - 30,
      ),
      child: Card(
        shape: RoundedRectangleBorder(
          side: BorderSide(
            color: theme.colorScheme.primary.withValues(alpha: 0.5),
            width: 1,
          ),
          borderRadius: const BorderRadius.all(
            Radius.circular(10),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const CreateQuestion(),
                ),
              );
            },
            child: ListTile(
              leading: Icon(
                Icons.add_circle,
                color: theme.colorScheme.primary,
              ),
              title: Text(
                'Add Question',
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: theme.colorScheme.primary),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
