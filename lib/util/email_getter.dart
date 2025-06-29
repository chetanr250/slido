// ignore_for_file: non_constant_identifier_names

import 'package:firebase_auth/firebase_auth.dart';

String? get EMAIL => FirebaseAuth.instance.currentUser?.email;
