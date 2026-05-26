import 'dart:io' show Platform;

import 'package:google_sign_in_dartio/google_sign_in_dartio.dart';

import '../config/google_oauth.dart';

/// Registers pure-Dart Google Sign-In for Windows/Linux (browser-based OAuth).
Future<void> registerGoogleSignInDesktop() async {
  if (!kGoogleDesktopSignInConfigured) return;
  if (!Platform.isWindows && !Platform.isLinux) return;
  await GoogleSignInDart.register(clientId: kGoogleDesktopOAuthClientId);
}
