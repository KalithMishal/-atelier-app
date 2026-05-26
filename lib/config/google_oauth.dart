/// OAuth 2.0 **Desktop** client ID from Google Cloud Console (Credentials →
/// Create credentials → OAuth client ID → **Desktop**). Required for Google
/// Sign-In on **Windows** / **Linux** via `google_sign_in_dartio`.
///
/// Pass at build/run time, for example:
/// `flutter run -d windows --dart-define=GOOGLE_DESKTOP_CLIENT_ID=xxx.apps.googleusercontent.com`
const kGoogleDesktopOAuthClientId = String.fromEnvironment(
  'GOOGLE_DESKTOP_CLIENT_ID',
  defaultValue: '',
);

bool get kGoogleDesktopSignInConfigured => kGoogleDesktopOAuthClientId.isNotEmpty;
