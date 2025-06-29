import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:slido/Providers/shared_preferences_provider.dart';
import 'package:slido/util/email_getter.dart';

final firebaseProvider = Provider((ref) => FirebaseFirestore.instance);

final firebaseInteractionProvider = Provider((ref) {
  // print(ref.read(codeProvider.notifier).state);
  return FirebaseFirestore.instance
      .collection('main')
      .doc(ref.read(codeProvider.notifier).state);
});

final firebaseUsersProvider = Provider((ref) {
  return FirebaseFirestore.instance.collection('users').doc(EMAIL);
});

final firebaseInteractionDataSnapshot = StreamProvider.autoDispose((ref) {
  return ref.watch(firebaseInteractionProvider).snapshots();
});

final firebaseInteractiveData = Provider.autoDispose((ref) {
  final data = ref.watch(firebaseInteractionDataSnapshot);
  return data.when(
    data: (value) => value.data(),
    loading: () => null,
    error: (error, stack) => null,
  );
});
