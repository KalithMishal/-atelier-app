import 'dart:convert';
import 'dart:math';
import 'dart:ui' show PlatformDispatcher;

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crypto/crypto.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart'
    show debugPrint, defaultTargetPlatform, kIsWeb, TargetPlatform;
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

import '../config/google_oauth.dart';

class AuthRepository {
  AuthRepository({
    FirebaseAuth? auth,
    FirebaseFirestore? firestore,
  })  : _auth = auth ?? FirebaseAuth.instance,
        _firestore = firestore;

  final FirebaseAuth _auth;
  final FirebaseFirestore? _firestore;

  Stream<User?> authStateChanges() => _auth.authStateChanges();

  User? get currentUser => _auth.currentUser;

  Future<UserCredential> signInWithEmail({
    required String email,
    required String password,
  }) {
    return _auth.signInWithEmailAndPassword(email: email.trim(), password: password);
  }

  Future<UserCredential> registerWithEmail({
    required String fullName,
    required String email,
    required String password,
  }) async {
    final cred = await _auth.createUserWithEmailAndPassword(
      email: email.trim(),
      password: password,
    );

    final uid = cred.user?.uid;
    final u = cred.user;
    if (u != null && fullName.trim().isNotEmpty) {
      await u.updateDisplayName(fullName.trim());
      await u.reload();
    }
    final fs = _firestore;
    if (uid != null && fs != null) {
      final now = FieldValue.serverTimestamp();
      await fs.collection('users').doc(uid).set({
        'fullName': fullName.trim(),
        'email': email.trim(),
        'phone': null,
        'createdAt': now,
        'updatedAt': now,
      }, SetOptions(merge: true));
    }

    return cred;
  }

  /// Google Sign-In via Firebase. Enable **Google** in Firebase Console → Authentication
  /// → Sign-in method. Android: add SHA-1/256 to Firebase. iOS: add URL scheme from
  /// `REVERSED_CLIENT_ID` in `GoogleService-Info.plist`. Web: authorized JavaScript origins
  /// for your hosting URL + `localhost` in Google Cloud Console OAuth client.
  ///
  /// **Web** uses [FirebaseAuth.signInWithRedirect] only (full-page flow). After Google
  /// returns, call [FirebaseAuth.getRedirectResult] on the next page load (splash/login do this).
  ///
  /// You must still **enable the Google provider** in Firebase Console → Authentication
  /// → Sign-in method, and add your URL (e.g. `http://localhost:PORT`) under **Authorized
  /// JavaScript origins** for the Web OAuth client in Google Cloud Console → Credentials.
  Future<UserCredential> signInWithGoogle() async {
    if (!_platformSupportsGoogleSignIn) {
      throw FirebaseAuthException(
        code: 'operation-not-allowed',
        message:
            'Google sign-in is not supported on this platform. Use email, or run on Android, iOS, macOS, Chrome, or Windows/Linux with --dart-define=GOOGLE_DESKTOP_CLIENT_ID=your-desktop-oauth-client-id.apps.googleusercontent.com',
      );
    }

    if (kIsWeb) {
      final provider = GoogleAuthProvider()
        ..addScope('email')
        ..addScope('profile')
        ..setCustomParameters(const {'prompt': 'select_account'});
      try {
        await _auth.signInWithRedirect(provider);
      } on FirebaseAuthException catch (e, st) {
        debugPrint('signInWithGoogle (web redirect): $e\n$st');
        rethrow;
      } catch (e, st) {
        debugPrint('signInWithGoogle (web): $e\n$st');
        throw FirebaseAuthException(
          code: 'operation-not-allowed',
          message:
              'Google sign-in failed on web. (1) Firebase Console → Authentication → Sign-in method → enable Google. (2) Google Cloud Console → APIs & Services → Credentials → your Web client → Authorized JavaScript origins → add http://localhost:<port> (and your production URL). Error: $e',
        );
      }
      // Page normally unloads for OAuth; if execution continues, treat as redirect started.
      throw FirebaseAuthException(
        code: 'redirect-in-progress',
        message: '',
      );
    }

    final googleSignIn = GoogleSignIn(scopes: const ['email', 'profile']);
    final account = await googleSignIn.signIn();
    if (account == null) {
      throw FirebaseAuthException(code: 'aborted-by-user', message: 'Sign in cancelled');
    }

    final googleAuth = await account.authentication;
    final idToken = googleAuth.idToken;
    final accessToken = googleAuth.accessToken;
    if (idToken == null) {
      throw FirebaseAuthException(
        code: 'invalid-credential',
        message:
            'Google did not return an ID token. Check Firebase Console → Google provider, SHA keys (Android), and OAuth client setup.',
      );
    }

    final credential = GoogleAuthProvider.credential(
      accessToken: accessToken,
      idToken: idToken,
    );
    return _auth.signInWithCredential(credential);
  }

  /// Apple Sign-In via Firebase. Enable **Apple** in Firebase Console → Authentication.
  /// Requires **iOS/macOS** (bundle / Services ID configured in Apple Developer + Firebase).
  Future<UserCredential> signInWithApple() async {
    if (defaultTargetPlatform != TargetPlatform.iOS && defaultTargetPlatform != TargetPlatform.macOS) {
      throw FirebaseAuthException(
        code: 'operation-not-allowed',
        message: 'Apple Sign-In is only available on iPhone, iPad, and Mac. Use Google or email here.',
      );
    }

    final rawNonce = _randomNonceString();
    final nonce = sha256.convert(utf8.encode(rawNonce)).toString();

    final appleCredential = await SignInWithApple.getAppleIDCredential(
      scopes: const [
        AppleIDAuthorizationScopes.email,
        AppleIDAuthorizationScopes.fullName,
      ],
      nonce: nonce,
    );

    final idToken = appleCredential.identityToken;
    if (idToken == null) {
      throw FirebaseAuthException(
        code: 'invalid-credential',
        message: 'Apple did not return an identity token. Check Apple provider in Firebase and Xcode Sign in with Apple capability.',
      );
    }

    final oauthCredential = OAuthProvider('apple.com').credential(
      idToken: idToken,
      rawNonce: rawNonce,
    );
    return _auth.signInWithCredential(oauthCredential);
  }

  Future<void> signOut() async {
    try {
      if (_platformSupportsGoogleSignIn) {
        await GoogleSignIn().signOut();
      }
    } catch (_) {}
    await _auth.signOut();
  }

  /// Sends Firebase’s password-reset message. Uses [ActionCodeSettings] with your
  /// project’s auth domain so the link in the email is valid on all platforms.
  Future<void> sendPasswordResetEmail(String email) async {
    final trimmed = email.trim();
    try {
      await _auth.setLanguageCode(PlatformDispatcher.instance.locale.languageCode);
    } catch (_) {}

    final options = _auth.app.options;
    final domain = options.authDomain;
    final continueUrl = (domain != null && domain.isNotEmpty)
        ? 'https://$domain'
        : 'https://${options.projectId}.firebaseapp.com';

    try {
      await _auth.sendPasswordResetEmail(
        email: trimmed,
        actionCodeSettings: ActionCodeSettings(
          url: continueUrl,
          handleCodeInApp: false,
        ),
      );
    } on FirebaseAuthException catch (e) {
      final c = e.code;
      if (c == 'invalid-continue-uri' || c == 'unauthorized-continue-uri' || c == 'missing-continue-uri') {
        await _auth.sendPasswordResetEmail(email: trimmed);
        return;
      }
      rethrow;
    }
  }
}

bool get _platformSupportsGoogleSignIn {
  if (kIsWeb) return true;
  if (kGoogleDesktopSignInConfigured &&
      (defaultTargetPlatform == TargetPlatform.windows || defaultTargetPlatform == TargetPlatform.linux)) {
    return true;
  }
  switch (defaultTargetPlatform) {
    case TargetPlatform.android:
    case TargetPlatform.iOS:
    case TargetPlatform.macOS:
      return true;
    default:
      return false;
  }
}

String _randomNonceString([int length = 32]) {
  const charset = '0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz-._';
  final random = Random.secure();
  return List.generate(length, (_) => charset[random.nextInt(charset.length)]).join();
}
