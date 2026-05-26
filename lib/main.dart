import 'dart:ui' show PlatformDispatcher;

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'data/app_preferences.dart';
import 'firebase_options.dart';
import 'screens/splash_screen.dart';
import 'utils/desktop_stability.dart';
import 'utils/google_sign_in_desktop.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  PlatformDispatcher.instance.onError = (Object error, StackTrace stack) {
    FlutterError.dumpErrorToConsole(
      FlutterErrorDetails(exception: error, stack: stack),
    );
    return true;
  };

  configureGoogleFontsBeforeFirstPaint();

  await registerGoogleSignInDesktop();

  await initAtelierSharedPreferences();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  if (kIsWeb) {
    try {
      await FirebaseAuth.instance.getRedirectResult();
    } catch (e, st) {
      debugPrint('main getRedirectResult: $e\n$st');
    }
  }

  // Helpful during setup: confirms which Firebase project is being used.
  // ignore: avoid_print
  print('Firebase projectId: ${Firebase.app().options.projectId}');
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ATELIER',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF131313),
        colorScheme: const ColorScheme.dark(
          primary: Color(0xFFE9C349),
          surface: Color(0xFF131313),
        ),
      ),
      home: const SplashScreen(),
    );
  }
}
