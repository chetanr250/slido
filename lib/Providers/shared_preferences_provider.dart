// lib/providers/shared_prefs_provider.dart

// import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
// import 'package:slido/screen/auth/auth.dart';

// Provider for SharedPreferences instance
final sharedPreferencesProvider = Provider<SharedPreferences>((ref) {
  throw UnimplementedError();
});

// Initialize SharedPreferences - Call this in main.dart
final sharedPreferencesInitializerProvider =
    FutureProvider<SharedPreferences>((ref) async {
  final prefs = await SharedPreferences.getInstance();
  ref.read(sharedPreferencesProvider);
  return prefs;
});

// // Provider for email
// final emailProvider = StateProvider<String?>((ref) {
//   final prefs = ref.watch(sharedPreferencesProvider);
//   return prefs.getString('email');
// });

// // Auth state provider
// final isAuthenticatedProvider = StateProvider<bool>((ref) {
//   final email = ref.watch(emailProvider);
//   return email != null && email.isNotEmpty;
// });

// Auth notifier for handling auth-related actions
// class AuthNotifier extends StateNotifier<void> {
//   AuthNotifier(this.ref) : super(null);
//   final Ref ref;

//   Future<void> setEmail(String email) async {
//     final prefs = ref.read(sharedPreferencesProvider);
//     await prefs.setString('email', email);
//     ref.read(emailProvider.notifier).state = email;
//   }

//   Future<void> clearEmail() async {
//     final prefs = ref.read(sharedPreferencesProvider);
//     await prefs.remove('email');
//     ref.read(emailProvider.notifier).state = null;
//   }
// }

// final authNotifierProvider = StateNotifierProvider<AuthNotifier, void>((ref) {
//   return AuthNotifier(ref);
// });

// Future<void> login(WidgetRef ref, String email) async {
//   await ref.read(authNotifierProvider.notifier).setEmail(email);
// }

// // Example: Logging out
// Future<void> logout(WidgetRef ref, context) async {
//   Navigator.pushReplacement(
//     context,
//     MaterialPageRoute(
//       builder: (context) => Auth(),
//     ),
//   );
//   await ref.read(authNotifierProvider.notifier).clearEmail();
// }

// Provider for storing a code
final codeProvider = StateProvider<String?>((ref) {
  final prefs = ref.watch(sharedPreferencesProvider);
  return prefs.getString('code');
});

// Notifier for handling code-related actions
class CodeNotifier extends StateNotifier<void> {
  CodeNotifier(this.ref) : super(null);
  final Ref ref;

  Future<void> setCode(String code) async {
    final prefs = ref.read(sharedPreferencesProvider);
    await prefs.setString('code', code);
    ref.read(codeProvider.notifier).state = code;
  }

  Future<void> clearCode() async {
    final prefs = ref.read(sharedPreferencesProvider);
    await prefs.remove('code');
    ref.read(codeProvider.notifier).state = null;
  }
}

final codeNotifierProvider = StateNotifierProvider<CodeNotifier, void>((ref) {
  return CodeNotifier(ref);
});
