import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:slido/Providers/bottom_navigation_provider.dart';
import 'package:slido/widgets/present_question/present_question_widget.dart';

class PresentQuestionInteractiveMode extends ConsumerStatefulWidget {
  const PresentQuestionInteractiveMode(
      {super.key,
      required this.question,
      required this.currentQuestion,
      required this.snapshot});
  final question;
  final currentQuestion;
  final DocumentReference snapshot;
  @override
  ConsumerState<PresentQuestionInteractiveMode> createState() =>
      _PresentQuestionInteractiveModeState();
}

class _PresentQuestionInteractiveModeState
    extends ConsumerState<PresentQuestionInteractiveMode> {
  @override
  void initState() {
    // TODO: implement initState

    super.initState();
    fireFetchData();
    // Future.delayed(const Duration(seconds: 22), () {
    //   // widget.snapshot.reference.update({'mode': 'answer'});
    // });
  }

  var fire;
  void fireFetchData() async {
    fire = FirebaseFirestore.instance.collection('main').doc();
    time = 10;
    Future.delayed(Durations.short1, () {
      startCountdown();
    });
  }

  Timer? countdownTimer;
  int? time = 20;
  void startCountdown() {
    ref.read(bottomNavigationButtonProvider).isEnabled = false;
    countdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (time! > 0) {
          setState(() {
            time = time! - 1;
          });
        } else {
          setState(() {
            ref.read(bottomNavigationButtonProvider).isEnabled = true;
          });
          FirebaseFirestore.instance
              .collection('main')
              .doc(widget.snapshot.id)
              .update({'mode': 'selections'});
          setState(() {});
          timer.cancel();
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Center(
          child: Container(
            alignment: Alignment.center,
            constraints: const BoxConstraints(
              maxWidth: 600,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ListTile(
                  title: LinearProgressIndicator(
                    borderRadius: BorderRadius.circular(20),
                    valueColor: time! > 5
                        ? const AlwaysStoppedAnimation<Color>(Colors.green)
                        : const AlwaysStoppedAnimation<Color>(Colors.red),
                    backgroundColor: Colors.grey,
                    minHeight: 10,
                    value: time! / 20,
                  ),
                  leading: Text(
                    '$time',
                    style: const TextStyle(
                      fontSize: 24,
                    ),
                  ),
                ),
                PresentQuestionWidget(
                    question: widget.question,
                    currentQuestion: widget.currentQuestion)
              ],
            ),
          ),
        ),
      ),
    );
  }
}
