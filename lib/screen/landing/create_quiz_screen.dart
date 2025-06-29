import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:slido/core/services/quiz_service.dart';
import 'package:slido/util/email_getter.dart';
import 'package:slido/widgets/common/custom_body.dart';
import '../../core/models/quiz.dart';
import '../../core/models/question.dart';
// import '../../core/providers/quiz_provider.dart';
// import '../../core/providers/user_provider.dart';
import 'package:uuid/uuid.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
import '../../widgets/quiz/question_card.dart';
import '../../widgets/quiz/fancy_button.dart';
import '../../widgets/common/app_bar.dart';
import '../../core/theme/theme_extension.dart';
import '../../widgets/quiz/question_dialog.dart';

class CreateQuizScreen extends ConsumerStatefulWidget {
  final Quiz? quiz;
  final List<Question>? initialQuestions;
  final int? index;
  const CreateQuizScreen(
      {super.key, this.quiz, this.initialQuestions, this.index});

  @override
  ConsumerState<CreateQuizScreen> createState() => _CreateQuizScreenState();
}

class _CreateQuizScreenState extends ConsumerState<CreateQuizScreen> {
  final TextEditingController _quizNameController = TextEditingController();
  String? quizId;
  late List<Question> questions;
  bool quizCreated = false;
  bool isEdit = false;

  @override
  void initState() {
    super.initState();
    if (widget.quiz != null) {
      isEdit = true;
      quizId = widget.quiz!.id;
      _quizNameController.text = widget.quiz!.name;
      quizCreated = true;
    }
    setState(() {
      questions = widget.initialQuestions ?? [];
    });
  }

  @override
  void dispose() {
    _quizNameController.dispose();
    super.dispose();
  }

  void _createQuiz() async {
    final name = _quizNameController.text.trim();
    if (name.isEmpty) return;
    final id = quizId ?? const Uuid().v4();
    final quiz = Quiz(
      id: id,
      name: name,
      createdBy: EMAIL!,
      createdAt: DateTime.now(),
      questions: [],
    );
    await QuizService().createQuiz(quiz);
    setState(() {
      quizId = id;
      quizCreated = true;
    });
  }

  void _addOrEditQuestion({Question? editQuestion}) async {
    await showDialog(
      context: context,
      builder: (context) => QuestionDialog(
        editQuestion: editQuestion,
        quizId: quizId!,
        onSave: (Question q) {
          setState(() {
            if (editQuestion != null) {
              questions =
                  questions.map((qq) => qq.id == q.id ? q : qq).toList();
            } else {
              questions.add(q);
            }
          });
        },
      ),
    );
  }

  void _deleteQuestion(Question q) async {
    // await ref.read(quizActionsProvider).deleteQuestion(quizId!, q.id);
    setState(() {
      questions.removeWhere((qq) => qq.id == q.id);
    });
  }

  Future<void> _saveQuiz() async {
    if (quizId == null || questions.isEmpty) return;

    // Update the quiz with all questions
    final quiz = Quiz(
      id: quizId!,
      name: _quizNameController.text,
      createdBy: EMAIL!,
      createdAt: DateTime.now(),
      questions: questions,
    );

    await QuizService().submitQuizToFirebase(quiz, widget.index ?? 0);

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Quiz saved!'), backgroundColor: Colors.green),
      );
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: isEdit ? 'Edit Quiz' : 'Create Quiz',
      ),
      body: CustomBody(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: quizCreated
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Quiz Name',
                      style: context.subtitleStyle,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      _quizNameController.text,
                      style: context.titleStyle,
                    ),
                    const SizedBox(height: 24),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Questions',
                          style: context.subtitleStyle,
                        ),
                        FancyButton(
                          label: 'Add Question',
                          icon: Icons.add_circle_outline,
                          onPressed: () => _addOrEditQuestion(),
                          filled: false,
                          color: context.primaryColor,
                          fontSize: 16,
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Expanded(
                      child: questions.isEmpty
                          ? Center(
                              child: Text(
                                'No questions added yet.',
                                style: context.bodyStyle.copyWith(
                                  color: context.textSecondary,
                                ),
                              ),
                            )
                          : ListView.separated(
                              itemCount: questions.length,
                              separatorBuilder: (_, __) =>
                                  const SizedBox(height: 12),
                              itemBuilder: (context, i) {
                                final q = questions[i];
                                return QuestionCard(
                                  question: q,
                                  index: i,
                                  onEdit: () =>
                                      _addOrEditQuestion(editQuestion: q),
                                  onDelete: () => _deleteQuestion(q),
                                );
                              },
                            ),
                    ),
                    if (questions.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.only(top: 18.0, bottom: 8),
                        child: Center(
                          child: FancyButton(
                            label: 'Save Quiz',
                            icon: Icons.save,
                            onPressed: _saveQuiz,
                            filled: true,
                            color: context.primaryColor,
                            fontSize: 18,
                          ),
                        ),
                      ),
                  ],
                )
              : Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      isEdit ? 'Edit Quiz Name' : 'Enter Quiz Name',
                      style: context.titleStyle,
                    ),
                    const SizedBox(height: 24),
                    TextField(
                      textCapitalization: TextCapitalization.sentences,
                      controller: _quizNameController,
                      decoration: context.inputDecoration.copyWith(
                        labelText: 'Quiz Name',
                        prefixIcon: Icon(
                          Icons.edit,
                          color: context.primaryColor,
                        ),
                      ),
                      style: context.bodyStyle.copyWith(fontSize: 18),
                    ),
                    const SizedBox(height: 32),
                    ElevatedButton.icon(
                      icon: Icon(
                        Icons.arrow_forward,
                        size: 22,
                        color: context.colors.onPrimary,
                      ),
                      label: Text(
                        isEdit ? 'Continue' : 'Create Quiz',
                        style: context.subtitleStyle.copyWith(
                          color: context.colors.onPrimary,
                        ),
                      ),
                      style: context.primaryButtonStyle,
                      onPressed: _createQuiz,
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}
