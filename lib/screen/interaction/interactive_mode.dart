// ignore_for_file: use_build_context_synchronously

import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:gap/gap.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:slido/Providers/bottom_navigation_provider.dart';
import 'package:slido/Providers/firebase_provider.dart';
import 'package:slido/Providers/shared_preferences_provider.dart';
import 'package:slido/consts.dart';
import 'package:slido/screen/interaction/reveal_answer_mode.dart';
import 'package:slido/screen/interaction/waiting.dart';
import 'package:slido/screen/interaction/present_question.dart';
import 'package:slido/screen/interaction/show_selections.dart';
import 'package:slido/util/snack_bar.dart';

class InteractiveMode extends ConsumerStatefulWidget {
  const InteractiveMode({super.key});

  @override
  ConsumerState<InteractiveMode> createState() => _InteractiveModeState();
}

class _InteractiveModeState extends ConsumerState<InteractiveMode> {
  SharedPreferences? prefs;
  String? email;
  String? code;
  bool isWaiting = true;
  int currentQuestion = 0;
  String mode = 'waiting';
  int noOfQuestions = 0;
  int modeIndex = 0;

  Future<void> initInteractiveModeonFirebase() async {
    var firebaseMainStore = FirebaseFirestore.instance.collection('main');
    var interactiveModeActiveStore = firebaseMainStore.doc('active');
    var dataFromFireActive = await interactiveModeActiveStore.get();

    String randomNumberString = '';
    // Creating a new room
    if (!dataFromFireActive.data()!.containsKey(email) ||
        dataFromFireActive.data()![email] == '') {
      snack('Activating slido', context: context, color: Colors.green);
      Random random = Random();
      int randomNumber = random.nextInt(99999);
      randomNumberString = randomNumber.toString().padLeft(5, '0');

      await interactiveModeActiveStore.set({
        email!: randomNumberString,
      });
      var fireDataForActivating = await ref.read(firebaseUsersProvider).get();
      noOfQuestions = fireDataForActivating.data()!['noOfQuestions'];

      if (!fireDataForActivating.data()!.containsKey('active')) {
        fireDataForActivating.data()!['active'] = randomNumberString;
        await firebaseMainStore.doc(randomNumberString).set({
          'email': email,
          'noOfQuestions': fireDataForActivating.data()!['noOfQuestions'],
          'currentQuestion': 0,
          'questions': fireDataForActivating.data()!['questions'],
          'mode': 'waiting',
          'users': [],
          'responses': [
            for (int i = 0; i < noOfQuestions; i++)
              {
                'index': i,
                'optionSelected': {
                  for (int j = 0;
                      j <
                          fireDataForActivating
                              .data()!['questions'][i]['options']
                              .length;
                      j++)
                    '$j': []
                },
                'time': {},
                'correctNo': 0,
                'correctAnswer': [],
                'wrongAnswer': [],
                'wrongNo': 0,
              }
          ]
        });
      }
      ref.watch(codeNotifierProvider.notifier).setCode(randomNumberString);
    } else {
      code = dataFromFireActive.data()![email];

      final firebaseInteracionRef =
          FirebaseFirestore.instance.collection('main').doc(code);
      var firebaseMainStore = await firebaseInteracionRef.get();
      var data = firebaseMainStore.data()!;
      currentQuestion = data['currentQuestion'];
      mode = data['mode'];
      modeIndex = modes.indexOf(mode);
      noOfQuestions = data['noOfQuestions'];
      snack('You are already active\nCode: $code',
          context: context, color: Colors.green, duration: 2);
    }
    initBottomNavigatorProvider(ref, mode);
    ref.read(codeNotifierProvider.notifier).setCode(code!);
    setState(() {
      isWaiting = false;
    });
  }

  void first() async {
    await initInteractiveModeonFirebase();
  }

  @override
  void initState() {
    super.initState();
    first();
  }

  @override
  Widget build(BuildContext context) {
    final buttonState = ref.watch(bottomNavigationButtonProvider);
    // email = ref.read(emailProvider);
    code = ref.watch(codeProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Interactive Mode'),
      ),
      bottomNavigationBar: Consumer(
        builder: (context, watch, child) {
          final buttonState = ref.watch(bottomNavigationButtonProvider);
          return buttonState.isEnabled
              ? BottomAppBar(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      ElevatedButton(
                        style: warningButtonStyle,
                        child: const Icon(
                          Icons.stop,
                          color: Colors.white,
                        ),
                        onPressed: () =>
                            stopInteractiveMode(context, ref, code, email),
                      ),
                      if (buttonState.isLeftEnabled)
                        ElevatedButton.icon(
                          iconAlignment: IconAlignment.start,
                          onPressed:
                              mode != 'waiting' && buttonState.isLeftEnabled
                                  ? () {
                                      leftNavigatorButtonFunction(modes, ref);
                                    }
                                  : null,
                          style: buttonStyle(context),
                          label: Text(
                            buttonState.leftText,
                            style: const TextStyle(fontSize: 12),
                          ),
                          icon: const Icon(
                            Icons.arrow_left_outlined,
                            size: 35,
                          ),
                        ),
                      if (buttonState.isRightEnabled)
                        ElevatedButton.icon(
                          iconAlignment: IconAlignment.end,
                          onPressed: buttonState.isRightEnabled
                              ? () {
                                  if (mode == 'waiting') {
                                    mode = 'question';
                                    ref
                                        .read(firebaseInteractionProvider)
                                        .update({'mode': mode});

                                    return;
                                  }
                                  modeIndex++;
                                  if (modeIndex >= modes.length) {
                                    modeIndex = 0;
                                  }

                                  mode = modes[modeIndex];

                                  ref
                                      .read(firebaseInteractionProvider)
                                      .update({'mode': mode});
                                }
                              : null,
                          style: buttonStyle(context),
                          label: Text(
                            buttonState.rightText,
                            style: const TextStyle(fontSize: 12),
                          ),
                          icon: const Icon(
                            Icons.arrow_right_alt,
                            size: 35,
                          ),
                        ),
                    ],
                  ),
                )
              : SizedBox.shrink();
        },
      ),
      body: !isWaiting
          ? StreamBuilder(
              stream: ref.watch(firebaseInteractionProvider).snapshots(),
              builder: (context, AsyncSnapshot snapshot) {
                if (snapshot.hasError) {
                  return const Center(
                    child: Text('Error'),
                  );
                }
                if (!snapshot.hasData) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
                var currentQuestion = snapshot.data.data()['currentQuestion'];
                if (snapshot.data.data()['mode'] == 'waiting') {
                  return WaitingInteractiveMode(textData: code);
                }
                if (snapshot.data.data()['mode'] == 'question') {
                  Future.delayed(Durations.short1, () {
                    currentQuestion = snapshot.data.data()['currentQuestion'];
                  });
                  return PresentQuestionInteractiveMode(
                    question: snapshot.data.data()['questions']
                        [currentQuestion],
                    currentQuestion: currentQuestion,
                    snapshot: snapshot.data.reference,
                  );
                }

                if (snapshot.data.data()['mode'] == 'selections') {
                  return ShowSelections(
                      question: snapshot.data.data()['questions']
                          [currentQuestion],
                      response: snapshot.data.data()['responses']
                          [currentQuestion],
                      correctAnswer: snapshot.data.data()['questions'][1]
                          ['correct']);
                }
                if (snapshot.data.data()['mode'] == 'answer') {
                  print(snapshot.data.data()['questions'][currentQuestion]
                      ['correct']);
                  return RevealAnswerMode(
                    question: snapshot.data.data()['questions']
                        [currentQuestion],
                    response: snapshot.data.data()['responses']
                        [currentQuestion],
                    correctAnswer: snapshot.data.data()['questions']
                        [currentQuestion]['correct'],
                  );
                }

                if (snapshot.data.data()!.containsKey('currentQuestion')) {
                  return Center(
                    child: Text(snapshot.data.data()['questions']
                        [snapshot.data.data()['currentQuestion']]['question']),
                  );
                }
                return ListView(
                  children: snapshot.data!.docs.map((document) {
                    return ListTile(
                      title: Text(document['question']),
                      subtitle: Text(document['answer']),
                    );
                  }).toList(),
                );
              },
            )
          : const Center(
              child: CircularProgressIndicator(),
            ),
    );
  }
}

void initBottomNavigatorProvider(ref, mode) {
  final modeIndex = modes.indexOf(mode);
  ref.read(bottomNavigationButtonProvider.notifier).state =
      BottomNavigationButtonState(
    isLeftEnabled: mode == 'waiting' ? false : true,
    isRightEnabled: true,
    leftText: 'Previous',
    rightText: mode == 'waiting' ? 'Start' : 'Next',
    modeIndex: modeIndex,
    isEnabled: true,
  );
}

void leftNavigatorButtonFunction(modes, ref) {
  // final modeIndex = ref.read(bottomNavigationButtonProvider.notifier)
  var modeIndex = ref.read(bottomNavigationButtonProvider).modeIndex ?? 0;
  var mode = modes[modeIndex];
  ref.read(bottomNavigationButtonProvider.notifier).decrementModeIndex();
  // print(mode);
  // print(modeIndex);
  if (modeIndex < 0) {
    modeIndex = modes.length - 1;
  }
  // setState(() {
  //   mode = modes[modeIndex];
  // });
  ref.read(firebaseInteractionProvider).update({'mode': mode});
}

void stopInteractiveMode(context, ref, code, email) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('End Room'),
        content: const Text('Are you sure you want to end the room?'),
        actions: <Widget>[
          TextButton(
            child: const Text('Cancel'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          ElevatedButton(
            style: warningButtonStyle,
            child: const Text(
              'End',
              style: TextStyle(
                color: Colors.white,
              ),
            ),
            onPressed: () {
              Navigator.of(context).pop();
              Navigator.pop(context);
              Future.delayed(Durations.short1, () {
                FirebaseFirestore.instance
                    .collection('main')
                    .doc(code)
                    .delete();

                FirebaseFirestore.instance
                    .collection('main')
                    .doc('active')
                    .set({
                  email!: '',
                });
              });
              ref.read(codeNotifierProvider.notifier).clearCode();
            },
          ),
        ],
      );
    },
  );
}
