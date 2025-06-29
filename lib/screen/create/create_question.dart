import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:slido/Providers/firebase_provider.dart';
// import 'package:slido/Providers/shared_preferences_provider.dart';
import 'package:slido/util/snack_bar.dart';

class CreateQuestion extends ConsumerStatefulWidget {
  const CreateQuestion({super.key, this.fireData});
  final Map<String, dynamic>? fireData;

  @override
  ConsumerState<CreateQuestion> createState() => _CreateQuestionState();
}

class _CreateQuestionState extends ConsumerState<CreateQuestion> {
  final ScrollController _scrollController = ScrollController();
  final List<FocusNode> _focusNodes = [];
  final TextEditingController questionController = TextEditingController();

  @override
  void dispose() {
    _scrollController.dispose();
    for (var node in _focusNodes) {
      node.dispose();
    }
    super.dispose();
  }

  // String? email;
  List<dynamic> options = ['', ''];
  bool isChanged = false;
  String question = '';
  int correct = 0;
  // SharedPreferences? prefs;
  // void sharedPrefs() async {
  //   prefs = await SharedPreferences.getInstance();
  //   email = prefs?.getString('email') ?? 'chetan250204@gmail.com';
  // }

  @override
  void initState() {
    super.initState();
    // sharedPrefs();
    // If the question is already present (edit)
    if (widget.fireData != null) {
      setState(() {
        question = widget.fireData!['question'];
        correct = widget.fireData!['correct'];
        question = widget.fireData!['question'];
        questionController.text = question;
        options = widget.fireData!['options'];
        for (var i = 0; i < options.length; i++) {
          _focusNodes.add(FocusNode());
        }
      });
      return;
    }
    setState(() {
      options = ['', ''];
      _focusNodes.add(FocusNode());
      _focusNodes.add(FocusNode());
    });
  }

  void saveToFirebase() {
    final id = widget.fireData == null
        ? Random().nextInt(1000000)
        : widget.fireData!['id'];
    snack('Question saved', context: context, color: Colors.green);

    ref.read(firebaseUsersProvider).update({
      "noOfQuestions": FieldValue.increment(1),
      "questions": FieldValue.arrayUnion([
        {
          'id': id,
          'question': question,
          'options': options,
          'correct': correct,
        }
      ])
    });
    Navigator.pop(context);
  }

  void addTextField() {
    if (options.last.trim().isEmpty ||
        options[options.length - 2].trim().isEmpty) {
      snack('Please fill the previous option', context: context);
      return;
    }

    isChanged = true;
    setState(() {
      options.add('');
      _focusNodes.add(FocusNode());
    });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Future.delayed(const Duration(milliseconds: 100), () {
        if (_focusNodes.isNotEmpty) {
          _focusNodes.last.requestFocus();
        }
      });
    });
  }

  void removeTextField(int index) {
    isChanged = true;
    if (index == correct) {
      correct = 0;
    }
    setState(() {
      options.removeAt(index);
    });
  }

  void updateText(String text, int index) {
    isChanged = true;
    // setState(() {
    options[index] = text;
    // });
  }

  @override
  Widget build(BuildContext context) {
    // email = ref.read(emailProvider);
    return Scaffold(
      appBar: AppBar(
          title: const Text('Create quiz question'),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              if (isChanged) {
                showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: const Text('Discard changes?'),
                      content: const Text(
                          'Are you sure you want to discard the changes?'),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: const Text('Cancel'),
                        ),
                        TextButton.icon(
                          icon: const Icon(
                            Icons.warning,
                            // color: Colors.white,
                            size: 16,
                          ),
                          onPressed: () {
                            Navigator.pop(context);
                            Navigator.pop(context);
                          },
                          label: const Text('Discard'),
                        ),
                      ],
                    );
                  },
                );
              } else {
                Navigator.pop(context);
              }
            },
          )),
      bottomNavigationBar: BottomAppBar(
        child: Padding(
          // padding: const EdgeInsets.only(left: 20, right: 20, bottom: 10),
          padding: const EdgeInsets.all(0),
          child: ElevatedButton(
            onPressed: () {
              if (question.trim().isEmpty) {
                snack('Question is required',
                    context: context, color: Colors.red);
                return;
              }
              if (options.first.isEmpty || options[1].isEmpty) {
                snack('Two options at least are required',
                    context: context, color: Colors.red);
                return;
              }
              if (options[correct].trim().isEmpty) {
                snack('Selected correct option is empty',
                    context: context, color: Colors.red);
                return;
              }

              saveToFirebase();
            },
            child: const Text('Save Question'),
          ),
        ),
      ),
      body: GestureDetector(
        onTap: () {},
        onVerticalDragUpdate: (d) {
          FocusScope.of(context).unfocus();
        },
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          // reverse: true,
          controller: _scrollController,
          child: Column(
            children: [
              // Container(
              //   constraints: BoxConstraints(
              //     maxHeight: MediaQuery.of(context).size.height - 100,
              //     maxWidth: MediaQuery.of(context).size.width - 30,
              //   ),
              //   child: const TextField(
              //     decoration: InputDecoration(
              //       border: UnderlineInputBorder(
              //         borderSide: BorderSide(width: 2),
              //         borderRadius: BorderRadius.all(
              //           Radius.circular(10),
              //         ),
              //       ),
              //       hintText: 'Enter question',
              //     ),
              //   ),
              // ),
              const SizedBox(height: 10),
              TextField(
                controller: questionController,
                onChanged: (value) {
                  isChanged = true;

                  question = value;
                },
                decoration: InputDecoration(
                  constraints: BoxConstraints(
                      maxWidth: MediaQuery.of(context).size.width * 0.9),
                  contentPadding: const EdgeInsets.all(20),
                  border: const OutlineInputBorder(), // Adds an outline border
                  labelText: 'Question', // Adds a label
                  prefixIcon: const Icon(
                    Icons.question_mark_sharp,
                  ), // Adds an icon inside the TextField
                  suffixIcon: const Icon(Icons.edit),
                ),
              ),
              const SizedBox(height: 10),
              Card(
                shape: RoundedRectangleBorder(
                  side: BorderSide(
                    color: Colors.blue.withOpacity(0.5),
                    width: 1,
                  ),
                  borderRadius: const BorderRadius.all(
                    Radius.circular(10),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(1.0),
                  child: GestureDetector(
                    onTap: () {
                      addTextField();
                    },
                    child: TextButton.icon(
                      onPressed: () {
                        addTextField();
                      },
                      label: const Text('Add new option'),
                      icon: const Icon(
                        Icons.add_circle,
                        color: Colors.blue,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Container(
                constraints: BoxConstraints(
                  maxHeight: MediaQuery.of(context).size.height * 0.50,
                  minHeight: 10,
                  // minWidth:
                ),
                child: ListView.builder(
                  itemCount: options.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.fromLTRB(4, 1, 4, 1),
                      child: Card(
                        color: index == correct
                            ? Colors.green.withOpacity(0.95)
                            : null,
                        elevation: 4,
                        child: ListTile(
                          title: TextField(
                            focusNode: _focusNodes.length > index
                                ? _focusNodes[index]
                                : null,
                            onChanged: (text) => updateText(text, index),
                            controller:
                                TextEditingController(text: options[index]),
                            decoration: InputDecoration(
                              hintText: 'Option ${index + 1}',
                              border: const OutlineInputBorder(),
                            ),
                          ),
                          leading: index == correct
                              ? Radio(
                                  value: index,
                                  groupValue: correct,
                                  onChanged: (int? value) {
                                    setState(() {
                                      isChanged = true;
                                      correct = value!;
                                    });
                                  },
                                )
                              : GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      isChanged = true;
                                      correct = index;
                                    });
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                        left: 18, right: 18),
                                    child: Text(
                                      (index + 1).toString(),
                                      style: const TextStyle(
                                        fontSize: 22,
                                      ),
                                    ),
                                  ),
                                ),
                          trailing: index == 0 && index != 2
                              ? IconButton(
                                  icon: const Icon(Icons.delete,
                                      color: Colors.transparent),
                                  onPressed: () {},
                                )
                              : index == options.length - 1 &&
                                          _focusNodes[index].hasFocus ||
                                      options.length == 2 && index == 2
                                  ? IconButton(
                                      onPressed: () {
                                        addTextField();
                                      },
                                      icon: const Icon(
                                        Icons.add,
                                        color: Colors.white,
                                      ),
                                    )
                                  : index != 1
                                      ? IconButton(
                                          icon: const Icon(Icons.delete),
                                          onPressed: () =>
                                              removeTextField(index),
                                        )
                                      : IconButton(
                                          icon: const Icon(Icons.delete,
                                              color: Colors.transparent),
                                          onPressed: () {},
                                        ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}



/*

import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

// import 'package:uuid/uuid.dart';
// @immutable
class CreateQuestion extends StatefulWidget {
  const CreateQuestion({super.key, this.fireData});
  final Map<String, dynamic>? fireData;
  // void some() {
  //   print(fireData);
  // }

  // some();

  @override
  State<CreateQuestion> createState() => _CreateQuestionState();
}

class _CreateQuestionState extends State<CreateQuestion> {
  final ScrollController _scrollController = ScrollController();
  final List<FocusNode> _focusNodes = [];
  final TextEditingController questionController = TextEditingController();

  @override
  void dispose() {
    _scrollController.dispose();
    _focusNodes.forEach((node) => node.dispose());
    super.dispose();
  }

  String email = '';
  SharedPreferences? prefs;
  void sharedPrefs() async {
    prefs = await SharedPreferences.getInstance();
    email = prefs?.getString('email') ?? 'chetan250204@gmail.com';
  }

  @override
  void initState() {
    super.initState();
    sharedPrefs();
    if (widget.fireData != null) {
      setState(() {
        question = widget.fireData!['question'];
        correct = widget.fireData!['correct'];
        question = widget.fireData!['question'];
        questionController.text = question;
        options = widget.fireData!['options'];
        for (var i = 0; i < options.length; i++) {
          _focusNodes.add(FocusNode());
        }
      });
      return;
    }
    setState(() {
      options = ['', ''];
      _focusNodes.add(FocusNode());
      _focusNodes.add(FocusNode());
    });
  }

  List<dynamic> options = ['', ''];
  bool isChanged = false;
  final String code = '100';
  String question = '';
  int correct = 0;

  void snack(text, {context, Color? color}) {
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        closeIconColor: color != null
            ? Colors.white
            : Theme.of(context).colorScheme.onPrimary,
        backgroundColor: color,
        showCloseIcon: true,
        behavior: SnackBarBehavior.floating,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(40),
          ),
        ),
        content: Padding(
          padding: const EdgeInsets.all(10),
          child: Text(
            text,
            style: TextStyle(
              color: color != null
                  ? Colors.white
                  : Theme.of(context).colorScheme.onPrimary,
              fontSize: 16,
            ),
          ),
        ),
      ),
    );
  }

  void saveToFirebase() {
    // final id = Uuid().v4();
    final id = widget.fireData == null
        ? Random().nextInt(1000000)
        : widget.fireData!['id'];
    snack('Question saved', context: context, color: Colors.green);

    FirebaseFirestore.instance.collection('users').doc(email).update({
      "noOfQuestions": FieldValue.increment(1),
      "questions": FieldValue.arrayUnion([
        {
          'id': id,
          'question': question,
          'options': options,
          'correct': correct,
        }
      ])
    });

    // .update(
    //   {
    //     // 'qno': (widget.fireData!.length + 1),
    //     // 'timeStamp':
    // 'id': id,
    // 'question': question,
    // 'options': options,
    // 'correct': correct,
    //   },
    // );
    Navigator.pop(context);
  }

  void addTextField() {
    if (options.last.trim().isEmpty ||
        options[options.length - 2].trim().isEmpty) {
      snack('Please fill the previous option', context: context);
      return;
    }

    isChanged = true;
    setState(() {
      options.add('');
      _focusNodes.add(FocusNode());
    });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Future.delayed(const Duration(milliseconds: 100), () {
        if (_focusNodes.isNotEmpty) {
          _focusNodes.last.requestFocus();
        }
      });
    });
  }

  void removeTextField(int index) {
    isChanged = true;
    if (index == correct) {
      correct = 0;
    }
    setState(() {
      options.removeAt(index);
    });
  }

  void updateText(String text, int index) {
    isChanged = true;
    // setState(() {
    options[index] = text;
    // });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text('Create quiz question'),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              if (isChanged) {
                showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: const Text('Discard changes?'),
                      content: const Text(
                          'Are you sure you want to discard the changes?'),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: const Text('Cancel'),
                        ),
                        TextButton.icon(
                          icon: const Icon(
                            Icons.warning,
                            // color: Colors.white,
                            size: 16,
                          ),
                          onPressed: () {
                            Navigator.pop(context);
                            Navigator.pop(context);
                          },
                          label: const Text('Discard'),
                        ),
                      ],
                    );
                  },
                );
              } else {
                Navigator.pop(context);
              }
            },
          )),
      bottomNavigationBar: BottomAppBar(
        child: Padding(
          // padding: const EdgeInsets.only(left: 20, right: 20, bottom: 10),
          padding: const EdgeInsets.all(0),
          child: ElevatedButton(
            onPressed: () {
              if (question.trim().isEmpty) {
                snack('Question is required',
                    context: context, color: Colors.red);
                return;
              }
              if (options.first.isEmpty || options[1].isEmpty) {
                snack('Two options at least are required',
                    context: context, color: Colors.red);
                return;
              }
              if (options[correct].trim().isEmpty) {
                snack('Selected correct option is empty',
                    context: context, color: Colors.red);
                return;
              }

              saveToFirebase();
              // Navigator.pushNamed(context, '/create_slido');
              // Navigator.pop(context);
            },
            child: const Text('Save Question'),
          ),
        ),
      ),
      body: GestureDetector(
        onTap: () {},
        // onVerticalDragDown: (d) {
        //   FocusScope.of(context).unfocus();
        // },
        // onPanCancel: () {
        //   FocusScope.of(context).unfocus();
        // },
        // onForcePressUpdate: (details) {
        //   FocusScope.of(context).unfocus();
        //   // print(details);
        // },
        onVerticalDragUpdate: (d) {
          FocusScope.of(context).unfocus();
        },
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          // reverse: true,
          controller: _scrollController,
          child: Column(
            children: [
              // Container(
              //   constraints: BoxConstraints(
              //     maxHeight: MediaQuery.of(context).size.height - 100,
              //     maxWidth: MediaQuery.of(context).size.width - 30,
              //   ),
              //   child: const TextField(
              //     decoration: InputDecoration(
              //       border: UnderlineInputBorder(
              //         borderSide: BorderSide(width: 2),
              //         borderRadius: BorderRadius.all(
              //           Radius.circular(10),
              //         ),
              //       ),
              //       hintText: 'Enter question',
              //     ),
              //   ),
              // ),
              const SizedBox(height: 10),
              TextField(
                controller: questionController,
                onChanged: (value) {
                  isChanged = true;

                  question = value;
                },
                decoration: InputDecoration(
                  constraints: BoxConstraints(
                      maxWidth: MediaQuery.of(context).size.width * 0.9),
                  contentPadding: const EdgeInsets.all(20),
                  border: const OutlineInputBorder(), // Adds an outline border
                  labelText: 'Question', // Adds a label

                  // focusedBorder: const OutlineInputBorder(
                  //     // Border when the TextField is focused
                  //     // borderSide: BorderSide(color: Colors.green, width: 2.0),
                  //     ),
                  prefixIcon: const Icon(
                    Icons.question_mark_sharp,
                  ), // Adds an icon inside the TextField
                  suffixIcon: const Icon(
                      Icons.edit), // Adds an icon at the end of the TextField
                  // You can customize further with properties like hintText, filled, fillColor, etc.
                ),
              ),
              const SizedBox(height: 10),
              Card(
                shape: RoundedRectangleBorder(
                  side: BorderSide(
                    color: Colors.blue.withOpacity(0.5),
                    width: 1,
                  ),
                  borderRadius: const BorderRadius.all(
                    Radius.circular(10),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(1.0),
                  child: GestureDetector(
                    onTap: () {
                      addTextField();
                    },
                    child: TextButton.icon(
                      onPressed: () {
                        addTextField();
                      },
                      label: const Text('Add new option'),
                      icon: const Icon(
                        Icons.add_circle,
                        color: Colors.blue,
                      ),
                    ),
                    // const ListTile(
                    //   leading: Icon(
                    //     Icons.add_circle,
                    //     color: Colors.blue,
                    //   ),
                    //   title: Text('Add new option'),
                    // ),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Container(
                // height: double.maxFinite,
                constraints: BoxConstraints(
                  maxHeight: MediaQuery.of(context).size.height * 0.50,
                  // maxWidth: MediaQuery.of(context).size.width - 30,
                  minHeight: 10,
                  // minWidth:
                ),
                child: ListView.builder(
                  itemCount: options.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.fromLTRB(4, 1, 4, 1),
                      child: Card(
                        color: index == correct
                            ? Colors.green.withOpacity(0.95)
                            : null,
                        elevation: 4,
                        child: ListTile(
                          title: TextField(
                            focusNode: _focusNodes.length > index
                                ? _focusNodes[index]
                                : null,
                            onChanged: (text) => updateText(text, index),
                            controller:
                                TextEditingController(text: options[index]),
                            decoration: InputDecoration(
                              hintText: 'Option ${index + 1}',
                              border: const OutlineInputBorder(),
                            ),
                          ),
                          leading: index == correct
                              ? Radio(
                                  value: index,
                                  groupValue: correct,
                                  onChanged: (int? value) {
                                    setState(() {
                                      // print(index);
                                      isChanged = true;
                                      correct = value!;
                                    });
                                  },
                                )
                              : GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      // print(index);
                                      isChanged = true;
                                      correct = index;
                                    });
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                        left: 18, right: 18),
                                    child: Text(
                                      (index + 1).toString(),
                                      style: const TextStyle(
                                        fontSize: 22,
                                      ),
                                    ),
                                  ),
                                ),
                          trailing: index == 0 && index != 2
                              ? IconButton(
                                  icon: const Icon(Icons.delete,
                                      color: Colors.transparent),
                                  onPressed: () {},
                                )
                              : index == options.length - 1 &&
                                          _focusNodes[index].hasFocus ||
                                      options.length == 2 && index == 2
                                  ? IconButton(
                                      onPressed: () {
                                        addTextField();
                                      },
                                      icon: const Icon(
                                        Icons.add,
                                        color: Colors.white,
                                      ),
                                    )
                                  : index != 1
                                      ? IconButton(
                                          icon: const Icon(Icons.delete),
                                          onPressed: () =>
                                              removeTextField(index),
                                        )
                                      : IconButton(
                                          icon: const Icon(Icons.delete,
                                              color: Colors.transparent),
                                          onPressed: () {},
                                        ),

                          // trailing: !(index != 0 && index != 1 ||
                          //         index == options.length - 1)
                          //     ? index == options.length - 1
                          //         ? IconButton(
                          //             onPressed: () {},
                          //             icon: const Icon(
                          //               Icons.add,
                          //               color: Colors.white,
                          //             ))
                          //         : IconButton(
                          //             onPressed: () {},
                          //             icon: const Icon(
                          //               Icons.delete,
                          //               color: Colors.transparent,
                          //             ),
                          //           )
                          //     : IconButton(
                          //         icon: const Icon(Icons.delete),
                          //         onPressed: () => removeTextField(index),
                          //       ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              // ElevatedButton(
              //   onPressed: addTextField,
              //   child: const Text('Add Option'),
              // ),
              // StreamBuilder(
              //   stream: FirebaseFirestore.instance.collection(code).snapshots(),
              //   // initialData: initialData,
              //   builder: (BuildContext context, AsyncSnapshot snapshot) {
              //     if (snapshot.connectionState == ConnectionState.waiting) {
              //       return const Text('Loading...');
              //     }
              //     if (snapshot.error is FirebaseException) {
              //       FirebaseException error = snapshot.error as FirebaseException;
              //       // Handle FirebaseException specifically
              //       return Text('Firebase Error: ${error.message}');
              //     }
              //   },
              // ),
            ],
          ),
        ),
      ),
    );
  }
}
*/