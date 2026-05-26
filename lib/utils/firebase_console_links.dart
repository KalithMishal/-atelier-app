import 'package:firebase_core/firebase_core.dart';

/// Firebase Console → Authentication → Sign-in method (enable Google here).
Uri firebaseConsoleAuthProvidersUri() {
  final id = Firebase.app().options.projectId ?? '';
  return Uri.parse('https://console.firebase.google.com/project/$id/authentication/providers');
}

/// Google Cloud Console → APIs & Services → Credentials (Web client JS origins).
Uri googleCloudConsoleCredentialsUri() {
  final id = Firebase.app().options.projectId ?? '';
  return Uri.parse('https://console.cloud.google.com/apis/credentials?project=$id');
}
