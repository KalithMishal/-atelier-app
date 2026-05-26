import 'package:flutter/foundation.dart';
import 'package:google_fonts/google_fonts.dart';

/// Windows desktop builds can crash from: runtime font HTTP fetches and heavy
/// [BackdropFilter] paths. Firestore is fully bypassed on Windows — see
/// [useFirestoreBackend] in `firebase_backend.dart`.
void configureGoogleFontsBeforeFirstPaint() {
  if (kIsWeb) return;
  if (defaultTargetPlatform != TargetPlatform.windows) return;
  GoogleFonts.config.allowRuntimeFetching = false;
}

bool get avoidHeavyBackdropBlurOnThisPlatform {
  if (kIsWeb) return false;
  return defaultTargetPlatform == TargetPlatform.windows;
}
