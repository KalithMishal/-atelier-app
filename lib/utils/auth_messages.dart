import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';

/// User-friendly messages for Firebase Auth errors.
String friendlyAuthError(Object error) {
  if (error is PlatformException) {
    final m = error.message ?? error.code;
    return 'Sign-in failed ($m). If this was Google, check that Google is enabled in Firebase Console and that your app domain is listed under Authorized JavaScript origins (web) or SHA keys (Android).';
  }
  if (error is FirebaseAuthException) {
    return switch (error.code) {
      'invalid-credential' ||
      'wrong-password' ||
      'user-not-found' ||
      'invalid-email' =>
        'Email or password is wrong, or there is no password account for this email yet. Tap Sign up to create one, or use Forgot Password if you already registered.',
      'email-already-in-use' =>
        'An account with this email already exists. Try signing in instead.',
      'weak-password' => 'Password is too weak. Use at least 6 characters.',
      'too-many-requests' => 'Too many attempts. Wait a few minutes and try again.',
      'network-request-failed' => 'No internet connection. Check your network and try again.',
      'user-disabled' => 'This account has been disabled. Contact support.',
      'aborted-by-user' => 'Sign in was cancelled.',
      'operation-not-allowed' =>
        (error.message != null && error.message!.trim().isNotEmpty)
            ? error.message!.trim()
            : 'This sign-in method is not available. Enable it in Firebase Console → Authentication, or use email.',
      _ => 'Authentication failed (${error.code}). Please try again.',
    };
  }
  return 'Something went wrong. Please try again.';
}

/// Messages for password reset — [user-not-found] can appear when enumeration
/// protection is off; otherwise Firebase may succeed without sending mail.
String friendlyPasswordResetError(Object error) {
  if (error is FirebaseAuthException) {
    final c = error.code;
    if (c == 'invalid-continue-uri' || c == 'unauthorized-continue-uri' || c == 'missing-continue-uri') {
      return 'Reset email could not be sent: the continue URL is not allowed. In Firebase Console → Authentication → Settings, add your project’s '
          '`*.firebaseapp.com` domain under Authorized domains.';
    }
    return switch (c) {
      'invalid-email' => 'That email address is not valid. Check for typos.',
      'user-not-found' =>
        'No password account exists for this email. Register with email and password, or use “Continue with Google” if you signed up that way.',
      'network-request-failed' => 'No internet connection. Check your network and try again.',
      'too-many-requests' => 'Too many reset attempts. Wait a few minutes and try again.',
      _ => friendlyAuthError(error),
    };
  }
  return friendlyAuthError(error);
}
