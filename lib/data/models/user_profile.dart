import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;

class UserProfile {
  const UserProfile({
    required this.uid,
    required this.fullName,
    required this.email,
    required this.phone,
    required this.createdAt,
    this.bio,
    this.styles = const [],
    this.photoUrl,
  });

  final String uid;
  final String fullName;
  final String email;
  final String? phone;
  final Timestamp? createdAt;
  final String? bio;
  final List<String> styles;
  /// Profile image (Firestore `photoUrl`, or Firebase Auth `photoURL` when merged in UI).
  final String? photoUrl;

  factory UserProfile.fromDoc(String uid, Map<String, dynamic>? data) {
    final d = data ?? const <String, dynamic>{};
    final stylesRaw = d['styles'];
    final styles = stylesRaw is Iterable
        ? stylesRaw.map((e) => e.toString()).where((e) => e.isNotEmpty).toList()
        : const <String>[];
    return UserProfile(
      uid: uid,
      fullName: (d['fullName'] ?? '').toString(),
      email: (d['email'] ?? '').toString(),
      phone: d['phone']?.toString(),
      createdAt: d['createdAt'] is Timestamp ? d['createdAt'] as Timestamp : null,
      bio: d['bio']?.toString(),
      styles: styles,
      photoUrl: d['photoUrl']?.toString(),
    );
  }

  /// Profile fields when Firestore is unavailable (e.g. Windows desktop preview).
  factory UserProfile.fromFirebaseUser(auth.User user) {
    final email = user.email ?? '';
    final display = user.displayName?.trim();
    final derivedName = (display != null && display.isNotEmpty)
        ? display
        : (email.isNotEmpty ? email.split('@').first : 'Member');
    return UserProfile(
      uid: user.uid,
      fullName: derivedName,
      email: email,
      phone: user.phoneNumber,
      createdAt: null,
      bio: null,
      styles: const [],
      photoUrl: user.photoURL,
    );
  }
}
