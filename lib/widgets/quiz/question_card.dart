import 'package:flutter/material.dart';
import '../../core/models/question.dart';

class QuestionCard extends StatelessWidget {
  final Question question;
  final int index;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const QuestionCard({
    Key? key,
    required this.question,
    required this.index,
    required this.onEdit,
    required this.onDelete,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final cardColor = isDark ? theme.colorScheme.surface : Colors.white;
    final correctColor = theme.colorScheme.secondaryContainer;
    final correctTextColor = theme.colorScheme.onSecondaryContainer;
    return Card(
      elevation: 3,
      color: cardColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  backgroundColor: theme.colorScheme.primary.withOpacity(0.15),
                  child: Text('${index + 1}',
                      style: const TextStyle(fontWeight: FontWeight.bold)),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    question.question,
                    style: theme.textTheme.titleMedium,
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.edit, color: theme.colorScheme.primary),
                  onPressed: onEdit,
                  tooltip: 'Edit',
                ),
                IconButton(
                  icon: Icon(Icons.delete, color: theme.colorScheme.error),
                  onPressed: onDelete,
                  tooltip: 'Delete',
                ),
              ],
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 4,
              children: List.generate(question.options.length, (idx) {
                final isCorrect = idx == question.correct;
                return Chip(
                  label: Text(question.options[idx]),
                  backgroundColor: isCorrect ? correctColor : null,
                  labelStyle: TextStyle(
                    color: isCorrect ? correctTextColor : null,
                    fontWeight: isCorrect ? FontWeight.bold : null,
                  ),
                  avatar: isCorrect
                      ? Icon(Icons.check, size: 16, color: correctTextColor)
                      : null,
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}
