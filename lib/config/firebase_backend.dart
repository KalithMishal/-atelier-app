import 'package:flutter/foundation.dart';

/// Windows desktop + Firestore C++ often hard-crash the process. We keep
/// Firebase Auth (and Core) but avoid touching [FirebaseFirestore.instance]
/// entirely on Windows so the UI stays usable for local preview. Wishlist is
/// persisted with [SharedPrefsWishlistRepository] instead. Use Android, iOS,
/// Web, or macOS for full cloud behaviour.
bool get useFirestoreBackend {
  if (kIsWeb) return true;
  return defaultTargetPlatform != TargetPlatform.windows;
}
