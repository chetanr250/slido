// ignore_for_file: non_constant_identifier_names

import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
// import 'package:slido/Providers/shared_preferences_provider.dart';
// import 'package:slido/screen/home_screen.dart';
import 'package:slido/util/snack_bar.dart';
import 'package:slido/widgets/common/custom_snack_bar.dart';
import '../../core/models/user.dart';
// import '../../core/providers/user_provider.dart';
import '../landing/landing_screen.dart';

class Auth extends ConsumerStatefulWidget {
  const Auth({super.key});

  @override
  ConsumerState<Auth> createState() => _AuthState();
}

class _AuthState extends ConsumerState<Auth> {
  dynamic info() async {
    var info;
    if (Platform.isAndroid) {
      info = await DeviceInfoPlugin().androidInfo;
    } else if (Platform.isIOS) {
      info = await DeviceInfoPlugin().iosInfo;
    } else {
      info = await DeviceInfoPlugin().webBrowserInfo;
      info.browserName = info.browserName.toString();
    }
    return info.data;
  }

  final controller = TextEditingController();
  final passwordController = TextEditingController();
  bool showRegister = false;

  void createFireContainer(BuildContext context, WidgetRef ref) async {
    if (controller.text.contains('@') &&
        controller.text.contains('.') &&
        controller.text.length > 5) {
      final usersCollection = FirebaseFirestore.instance.collection('users');
      final allUsersDoc = usersCollection.doc('all_users');
      final prefs = await SharedPreferences.getInstance();

      // Get all_mails list
      List allMails = [];
      final allUsersSnapshot = await allUsersDoc.get();
      if (allUsersSnapshot.exists &&
          allUsersSnapshot.data()!.containsKey('all_mails')) {
        allMails = allUsersSnapshot['all_mails'];
      }

      // Check if user exists
      final userDoc = await usersCollection.doc(controller.text).get();
      AppUser user;
      if (allMails.contains(controller.text) && userDoc.exists) {
        // Existing user: fetch and update device info
        final userData = userDoc.data() as Map<String, dynamic>;
        user = AppUser.fromJson(userData);
        await usersCollection.doc(controller.text).update({
          'device': await info(),
        });
        // print(user);
        // ref.read(currentUserProvider.notifier).state = user;
      } else {
        // New user: create document
        user = AppUser(
            email: controller.text,
            device: await info(),
            quizzes: [],
            pastResults: []);
        await usersCollection.doc(controller.text).set(user.toJson());
        await allUsersDoc.set({
          'all_mails': FieldValue.arrayUnion([controller.text]),
        }, SetOptions(merge: true));
        // ref.read(currentUserProvider.notifier).state = user;
      }

      // // Store user in provider and SharedPreferences
      // ref.read(currentUserProvider.notifier).state = user;
      prefs.setString('email', controller.text);

      // Success feedback and navigation
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Successfully Signed in'),
            backgroundColor: Colors.green),
      );

      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const LandingScreen()),
      );
    } else {
      snack('Invalid email!', context: context, color: Colors.red);
    }
  }

  Future<void> firebaseRegister(
      BuildContext context, String email, String password) async {
    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      showCustomSnackBar(
        context: context,
        message: 'Registration successful!',
        backgroundColor: Colors.green,
      );
      // ScaffoldMessenger.of(context).showSnackBar(
      //   const SnackBar(
      //       content: Text('Registration successful!'),
      //       backgroundColor: Colors.green),
      // );
    } on FirebaseAuthException catch (e) {
      showCustomSnackBar(
        context: context,
        message: e.message ?? 'Registration failed',
        backgroundColor: Colors.red,
      );
    }
  }

  Future<void> firebaseSignIn(
      BuildContext context, String email, String password) async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Sign in successful!'),
            backgroundColor: Colors.green),
      );
    } on FirebaseAuthException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text(e.message ?? 'Sign in failed'),
            backgroundColor: Colors.red),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Auth'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 30, right: 30, bottom: 20),
              child: TextField(
                controller: controller,
                decoration: const InputDecoration(label: Text('E-mail')),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 30, right: 30, bottom: 20),
              child: TextField(
                controller: passwordController,
                obscureText: true,
                decoration: const InputDecoration(label: Text('Password')),
              ),
            ),
            // ElevatedButton(
            //     onPressed: () async {
            //       // createFireContainer(context, ref);
            //       firebaseSignIn(
            //           context, controller.text, passwordController.text);
            //     },
            //     child: const Text('Sign in')),
            ElevatedButton(
              onPressed: () async {
                if (showRegister) {
                  await firebaseRegister(
                      context, controller.text, passwordController.text);
                } else {
                  await firebaseSignIn(
                      context, controller.text, passwordController.text);
                }
              },
              child: Text(showRegister ? 'Register' : 'Sign in with Firebase'),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  showRegister = !showRegister;
                });
              },
              child: Text(showRegister
                  ? 'Already have an account? Sign in'
                  : "Don't have an account? Register"),
            ),
          ],
        ),
      ),
    );
  }
}
