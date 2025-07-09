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
  Quiz? quiz;
  final List<Question>? initialQuestions;
  final int? index;
  CreateQuizScreen({super.key, this.quiz, this.initialQuestions, this.index});

  @override
  ConsumerState<CreateQuizScreen> createState() => _CreateQuizScreenState();
}

class _CreateQuizScreenState extends ConsumerState<CreateQuizScreen> {
  final TextEditingController _quizNameController = TextEditingController();
  String? quizId;
  late List<Question> questions;
  bool quizCreated = false;
  bool isEdit = false;
  bool isChanged = false;
  bool quizTitleEdit = false;
  FocusNode editTitleFocusNode = FocusNode();

  @override
  void initState() {
    // print(widget.quiz!.toJson());
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

  void _createNewQuiz() async {
    final name = _quizNameController.text.trim();
    if (name.isEmpty) return;
    final id = quizId ?? const Uuid().v4();
    print(id);
    widget.quiz = Quiz(
      id: id,
      name: name,
      createdBy: EMAIL!,
      createdAt: DateTime.now(),
      questions: [],
    );
    print(widget.quiz!.toJson());
    await QuizService().createNewQuiz(widget.quiz!);
    setState(() {
      quizId = id;
      quizCreated = true;
    });
  }

  void _editTitle() {
    if (_quizNameController.text.isNotEmpty) {
      widget.quiz = widget.quiz!.copyWith(name: _quizNameController.text);
      isChanged = true;
    }
  }

  void _addOrEditQuestion({Question? editQuestion, int? index}) async {
    await showDialog(
      context: context,
      builder: (context) => QuestionDialog(
        editQuestion: editQuestion,
        quizId: widget.quiz!.id!,
        onSave: (Question q) {
          setState(() {
            if (editQuestion != null) {
              questions = List.from(questions)..[index!] = q;
            } else {
              questions.add(q);
            }
          });
          isChanged = true;
          // print(q.toJson());
          widget.quiz = widget.quiz!.copyWith(
            questions: questions,
          );
        },
      ),
    );
  }

  Future<bool> _deleteQuestion(int index) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Question'),
        content: const Text('Are you sure you want to delete this question?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(true);
              setState(() {
                questions.removeAt(index);
              });
            },
            child: const Text('Delete'),
          ),
        ],
      ),
    );
    widget.quiz = widget.quiz!.copyWith(
      questions: questions,
    );
    isChanged = true;
    return confirm ?? false;
  }

  Future<void> _saveQuiz() async {
    if (quizId == null || questions.isEmpty) return;
    isChanged = false;
    await QuizService().submitQuizToFirebase(widget.quiz!, widget.index ?? 0);

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Quiz saved!'), backgroundColor: Colors.green),
      );
      Navigator.of(context).pop(widget.quiz);
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Scaffold(
        appBar: CustomAppBar(
          title: isEdit ? 'Edit Quiz' : 'Create Quiz',
          leadingButtonFunction: () {
            if (isChanged) {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('Unsaved Changes'),
                  content: const Text(
                      'You have unsaved changes. Do you want to save them?'),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                        Navigator.of(context).pop(null);
                      },
                      child: const Text(
                        'Discard Changes',
                        style: TextStyle(color: Colors.red),
                      ),
                    ),
                    OutlinedButton(
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(
                          Colors.green,
                        ),
                        foregroundColor: MaterialStateProperty.all<Color>(
                          Colors.white,
                        ),
                      ),
                      onPressed: () {
                        _saveQuiz();
                        Navigator.of(context).pop();
                        Navigator.of(context).pop();
                      },
                      child: const Text('Save'),
                    ),
                  ],
                ),
              );
            } else {
              Navigator.of(context).pop();
            }
          },
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
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          quizTitleEdit
                              ? Expanded(
                                  child: TextField(
                                    focusNode: editTitleFocusNode,
                                    textCapitalization:
                                        TextCapitalization.sentences,
                                    controller: _quizNameController,
                                    decoration:
                                        context.inputDecoration.copyWith(
                                      // labelText: 'Quiz Name',
                                      prefixIcon: Icon(
                                        Icons.edit,
                                        color: context.primaryColor,
                                      ),
                                    ),
                                    style: context.bodyStyle
                                        .copyWith(fontSize: 18),
                                    onChanged: (value) {
                                      _editTitle();
                                    },
                                  ),
                                )
                              : Text(
                                  _quizNameController.text,
                                  style: context.titleStyle,
                                ),
                          // const Spacer(),
                          IconButton(
                            icon: Icon(
                              quizTitleEdit ? Icons.check : Icons.edit,
                              color: context.primaryColor,
                            ),
                            onPressed: () {
                              setState(() {
                                quizTitleEdit = !quizTitleEdit;
                                if (!quizTitleEdit) {
                                  _editTitle();
                                } else {
                                  editTitleFocusNode.requestFocus();
                                }
                              });
                            },
                            tooltip: quizTitleEdit ? 'Save' : 'Edit Title',
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      // Text(
                      //   _quizNameController.text,
                      //   style: context.titleStyle,
                      // ),
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
                                    onEdit: () => _addOrEditQuestion(
                                        editQuestion: q, index: i),
                                    onDelete: () => _deleteQuestion(i),
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
                        onPressed: _createNewQuiz,
                      ),
                    ],
                  ),
          ),
        ),
      ),
    );
  }
}
