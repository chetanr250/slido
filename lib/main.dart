// import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:slido/Providers/shared_preferences_provider.dart';
import 'package:slido/firebase_options.dart';
import 'package:slido/util/email_getter.dart';
import 'screen/landing/landing_screen.dart';
// import 'screen/landing/create_quiz_screen.dart';
import 'screen/landing/join_quiz_screen.dart';
// import 'screen/landing/past_results_screen.dart';
import 'package:slido/screen/auth/auth.dart';
import 'core/theme/app_theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((_) async {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );

    SharedPreferences prefs = await SharedPreferences.getInstance();
    runApp(
      ProviderScope(
        overrides: [
          sharedPreferencesProvider.overrideWithValue(prefs),
        ],
        child: const MyApp(),
      ),
    );
  });
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // final auth = FirebaseAuth.instance;
    // final email = auth.currentUser?.email;
    // print(EMAIL);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Quiz App',
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system,
      home: EMAIL != null ? const LandingScreen() : const Auth(),
      routes: {
        // '/createQuiz': (context) => const CreateQuizScreen(),
        '/joinQuiz': (context) => const JoinQuizScreen(),
        // '/pastResults': (context) => const PastResultsScreen(),
      },
    );
  }
}
