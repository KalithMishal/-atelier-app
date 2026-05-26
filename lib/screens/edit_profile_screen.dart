import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';

import '../data/models/user_profile.dart';
import '../state/providers.dart';
import '../widgets/profile_circle_avatar.dart';

class EditProfileScreen extends ConsumerStatefulWidget {
  const EditProfileScreen({super.key});

  @override
  ConsumerState<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends ConsumerState<EditProfileScreen> {
  static const _bg = Color(0xFF080808);
  static const _text = Color(0xFFF5F0E8);
  static const _muted = Color(0xFFD0C5B2);

  final _firstName = TextEditingController();
  final _lastName = TextEditingController();
  final _bio = TextEditingController();
  final _email = TextEditingController();
  final _phone = TextEditingController();

  final Set<String> _styles = {};
  bool _loading = true;
  String? _avatarUrl;
  bool _uploadingPhoto = false;

  @override
  void initState() {
    super.initState();
    _hydrate();
  }

  Future<void> _hydrate() async {
    final user = ref.read(currentUserProvider);
    if (user == null) {
      setState(() => _loading = false);
      return;
    }
    final repo = ref.read(userRepositoryProvider);
    final UserProfile merged;
    if (repo == null) {
      merged = UserProfile.fromFirebaseUser(user);
    } else {
      final fs = await repo.getProfile(user.uid);
      merged = _mergeProfile(user, fs);
    }
    if (!mounted) return;
    final parts = merged.fullName.trim().split(RegExp(r'\s+'));
    _firstName.text = parts.isNotEmpty ? parts.first : '';
    _lastName.text = parts.length > 1 ? parts.sublist(1).join(' ') : '';
    _email.text = merged.email;
    _phone.text = merged.phone ?? '';
    _bio.text = (merged.bio ?? '').trim();
    _styles
      ..clear()
      ..addAll(merged.styles);
    final av = merged.photoUrl?.trim();
    setState(() {
      _loading = false;
      _avatarUrl = (av != null && av.isNotEmpty) ? av : null;
    });
  }

  /// Prefer Firestore `users/{uid}` fields when set; otherwise Firebase Auth (e.g. displayName).
  UserProfile _mergeProfile(User user, UserProfile firestore) {
    final auth = UserProfile.fromFirebaseUser(user);
    return UserProfile(
      uid: auth.uid,
      fullName: firestore.fullName.trim().isNotEmpty ? firestore.fullName.trim() : auth.fullName,
      email: firestore.email.trim().isNotEmpty ? firestore.email.trim() : auth.email,
      phone: (firestore.phone != null && firestore.phone!.trim().isNotEmpty) ? firestore.phone!.trim() : auth.phone,
      createdAt: firestore.createdAt ?? auth.createdAt,
      bio: (firestore.bio != null && firestore.bio!.trim().isNotEmpty) ? firestore.bio!.trim() : auth.bio,
      styles: firestore.styles.isNotEmpty ? List<String>.from(firestore.styles) : List<String>.from(auth.styles),
      photoUrl: (firestore.photoUrl != null && firestore.photoUrl!.trim().isNotEmpty)
          ? firestore.photoUrl!.trim()
          : auth.photoUrl,
    );
  }

  Future<void> _pickAndUploadPhoto() async {
    if (kIsWeb) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Profile photos cannot be changed from the web build yet.')),
      );
      return;
    }
    final user = ref.read(currentUserProvider);
    if (user == null) return;

    final messenger = ScaffoldMessenger.of(context);
    final repo = ref.read(userRepositoryProvider);
    if (repo == null) {
      messenger.showSnackBar(
        const SnackBar(
          content: Text('Profile cloud sync is unavailable on Windows desktop. Use Android or Chrome.'),
        ),
      );
      return;
    }

    final picker = ImagePicker();
    final xFile = await picker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 1024,
      maxHeight: 1024,
      imageQuality: 85,
    );
    if (xFile == null || !mounted) return;

    setState(() => _uploadingPhoto = true);
    try {
      final file = File(xFile.path);
      final refStorage = FirebaseStorage.instance
          .ref()
          .child('users/${user.uid}/profile_${DateTime.now().millisecondsSinceEpoch}.jpg');
      await refStorage.putFile(file, SettableMetadata(contentType: 'image/jpeg'));
      final url = await refStorage.getDownloadURL();
      await user.updatePhotoURL(url);
      await user.reload();
      await repo.updateProfile(user.uid, {'photoUrl': url});
      if (!mounted) return;
      setState(() {
        _avatarUrl = url;
        _uploadingPhoto = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() => _uploadingPhoto = false);
      messenger.showSnackBar(SnackBar(content: Text('Could not update photo. $e')));
    }
  }

  @override
  void dispose() {
    _firstName.dispose();
    _lastName.dispose();
    _bio.dispose();
    _email.dispose();
    _phone.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bg,
      body: SafeArea(
        bottom: false,
        child: Stack(
          children: [
            SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(24, 92, 24, 140),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    'EDIT PROFILE',
                    style: GoogleFonts.bodoniModa(
                      fontSize: 22,
                      height: 28 / 22,
                      letterSpacing: 2.2,
                      color: _text,
                    ),
                  ),
                  const SizedBox(height: 22),
                  _Avatar(
                    imageUrl: _avatarUrl,
                    uploading: _uploadingPhoto,
                    onChangePhoto: _pickAndUploadPhoto,
                  ),
                  const SizedBox(height: 20),
                  _SectionCard(
                    title: 'PERSONAL DETAILS',
                    child: Column(
                      children: [
                        _Field(label: 'FIRST NAME', controller: _firstName),
                        const SizedBox(height: 16),
                        _Field(label: 'LAST NAME', controller: _lastName),
                        const SizedBox(height: 16),
                        _Field(label: 'BIO', controller: _bio, maxLines: 3),
                      ],
                    ),
                  ),
                  const SizedBox(height: 18),
                  _SectionCard(
                    title: 'CONTACT INFO',
                    child: Column(
                      children: [
                        _Field(label: 'EMAIL ADDRESS', controller: _email),
                        const SizedBox(height: 16),
                        _Field(label: 'PHONE NUMBER', controller: _phone),
                      ],
                    ),
                  ),
                  const SizedBox(height: 18),
                  _SectionCard(
                    title: 'STYLE\nPREFERENCES',
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Select the aesthetics that best define\nyour curated wardrobe.',
                          style: GoogleFonts.notoSerif(
                            fontSize: 14,
                            height: 22 / 14,
                            color: _muted,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Wrap(
                          spacing: 10,
                          runSpacing: 10,
                          children: [
                            _StyleChip(label: 'CLASSIC', selected: _styles.contains('Classic'), onTap: () => _toggleStyle('Classic')),
                            _StyleChip(label: 'MINIMALIST', selected: _styles.contains('Minimalist'), onTap: () => _toggleStyle('Minimalist')),
                            _StyleChip(label: 'AVANT-GARDE', selected: _styles.contains('Avant-Garde'), onTap: () => _toggleStyle('Avant-Garde')),
                            _StyleChip(label: 'STREETWEAR', selected: _styles.contains('Streetwear'), onTap: () => _toggleStyle('Streetwear')),
                            _StyleChip(label: 'BOHEMIAN', selected: _styles.contains('Bohemian'), onTap: () => _toggleStyle('Bohemian')),
                            _StyleChip(label: 'TAILORED', selected: _styles.contains('Tailored'), onTap: () => _toggleStyle('Tailored')),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              left: 0,
              right: 0,
              top: 0,
              child: SafeArea(
                bottom: false,
                child: Container(
                  height: 64,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  color: const Color.fromRGBO(8, 8, 8, 0.85),
                  child: Row(
                    children: [
                      IconButton(
                        onPressed: () => Navigator.of(context).maybePop(),
                        icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 18, color: _text),
                      ),
                      Expanded(
                        child: Center(
                          child: Text(
                            'ATELIER',
                            style: GoogleFonts.libreBaskerville(
                              fontSize: 18,
                              letterSpacing: 6,
                              color: _text,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                      ),
                      TextButton(
                        onPressed: _loading
                            ? null
                            : () async {
                                final nav = Navigator.of(context);
                                final messenger = ScaffoldMessenger.of(context);
                                final user = ref.read(currentUserProvider);
                                if (user == null) return;
                                final fullName = '${_firstName.text.trim()} ${_lastName.text.trim()}'.trim();
                                final repo = ref.read(userRepositoryProvider);
                                if (repo == null) {
                                  messenger.showSnackBar(
                                    const SnackBar(
                                      content: Text(
                                        'Profile cloud sync is unavailable on Windows desktop. Use Android or Chrome.',
                                      ),
                                    ),
                                  );
                                  nav.maybePop();
                                  return;
                                }
                                try {
                                  await repo.updateProfile(user.uid, {
                                        'fullName': fullName,
                                        'email': _email.text.trim(),
                                        'phone': _phone.text.trim(),
                                        'bio': _bio.text.trim(),
                                        'styles': _styles.toList(),
                                      });
                                  if (!mounted) return;
                                  nav.maybePop();
                                } catch (e) {
                                  if (!mounted) return;
                                  messenger.showSnackBar(
                                    SnackBar(content: Text('Could not save profile. ${e.toString()}')),
                                  );
                                }
                              },
                        child: Text('SAVE', style: GoogleFonts.poppins(fontSize: 12, letterSpacing: 2.4, color: _text)),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: SafeArea(
                top: false,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(24, 8, 24, 16),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      _PrimaryButton(
                        label: 'SAVE CHANGES',
                        onTap: _loading
                            ? () {}
                            : () async {
                                final nav = Navigator.of(context);
                                final messenger = ScaffoldMessenger.of(context);
                                final user = ref.read(currentUserProvider);
                                if (user == null) return;
                                final fullName = '${_firstName.text.trim()} ${_lastName.text.trim()}'.trim();
                                final repo = ref.read(userRepositoryProvider);
                                if (repo == null) {
                                  messenger.showSnackBar(
                                    const SnackBar(
                                      content: Text(
                                        'Profile cloud sync is unavailable on Windows desktop. Use Android or Chrome.',
                                      ),
                                    ),
                                  );
                                  nav.maybePop();
                                  return;
                                }
                                try {
                                  await repo.updateProfile(user.uid, {
                                        'fullName': fullName,
                                        'email': _email.text.trim(),
                                        'phone': _phone.text.trim(),
                                        'bio': _bio.text.trim(),
                                        'styles': _styles.toList(),
                                      });
                                  if (!mounted) return;
                                  nav.maybePop();
                                } catch (e) {
                                  if (!mounted) return;
                                  messenger.showSnackBar(
                                    SnackBar(content: Text('Could not save profile. ${e.toString()}')),
                                  );
                                }
                              },
                      ),
                      const SizedBox(height: 12),
                      _SecondaryButton(
                        label: 'CHANGE PASSWORD',
                        onTap: () {},
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _toggleStyle(String label) {
    setState(() {
      if (_styles.contains(label)) {
        _styles.remove(label);
      } else {
        _styles.add(label);
      }
    });
  }
}

class _Avatar extends StatelessWidget {
  const _Avatar({required this.imageUrl, required this.uploading, required this.onChangePhoto});

  final String? imageUrl;
  final bool uploading;
  final VoidCallback onChangePhoto;

  @override
  Widget build(BuildContext context) {
    const outer = 96.0;
    const pad = 5.0;
    final inner = outer - pad * 2;
    return Column(
      children: [
        Container(
          width: outer,
          height: outer,
          padding: const EdgeInsets.all(pad),
          decoration: BoxDecoration(
            border: Border.all(color: const Color(0xFFB8963E), width: 1),
            borderRadius: BorderRadius.circular(9999),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(9999),
            child: Stack(
              fit: StackFit.expand,
              children: [
                ProfileCircleAvatar(url: imageUrl, size: inner),
                if (uploading)
                  const ColoredBox(
                    color: Color(0x66000000),
                    child: Center(
                      child: SizedBox(
                        width: 28,
                        height: 28,
                        child: CircularProgressIndicator(strokeWidth: 2, color: Color(0xFFB8963E)),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 10),
        GestureDetector(
          onTap: uploading ? null : onChangePhoto,
          child: Text(
            'CHANGE PHOTO',
            style: GoogleFonts.poppins(fontSize: 10, height: 16 / 10, letterSpacing: 2, color: const Color(0xFFB8963E)),
          ),
        ),
      ],
    );
  }
}

class _SectionCard extends StatelessWidget {
  const _SectionCard({required this.title, required this.child});
  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(18, 18, 18, 18),
      decoration: BoxDecoration(
        color: const Color(0xFF2A2420),
        borderRadius: BorderRadius.circular(22),
        boxShadow: const [BoxShadow(color: Color.fromRGBO(0, 0, 0, 0.35), blurRadius: 40, offset: Offset(0, 20))],
        border: Border.all(color: const Color.fromRGBO(184, 150, 62, 0.12)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: GoogleFonts.bodoniModa(fontSize: 18, height: 20 / 18, letterSpacing: 1.8, color: const Color(0xFFD0C5B2)),
          ),
          const SizedBox(height: 14),
          child,
        ],
      ),
    );
  }
}

class _Field extends StatelessWidget {
  const _Field({required this.label, required this.controller, this.maxLines = 1});
  final String label;
  final TextEditingController controller;
  final int maxLines;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.poppins(fontSize: 10, height: 16 / 10, letterSpacing: 2.0, color: const Color(0xFFB8963E).withValues(alpha: 0.9)),
        ),
        const SizedBox(height: 10),
        TextField(
          controller: controller,
          maxLines: maxLines,
          style: GoogleFonts.poppins(fontSize: 14, height: 20 / 14, color: const Color(0xFFF5F0E8)),
          cursorColor: const Color(0xFFB8963E),
          decoration: const InputDecoration(
            isDense: true,
            border: UnderlineInputBorder(borderSide: BorderSide(color: Color.fromRGBO(208, 197, 178, 0.25))),
            enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Color.fromRGBO(208, 197, 178, 0.25))),
            focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Color.fromRGBO(184, 150, 62, 0.7))),
          ),
        ),
      ],
    );
  }
}

class _StyleChip extends StatelessWidget {
  const _StyleChip({required this.label, required this.selected, required this.onTap});
  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: selected ? const Color.fromRGBO(184, 150, 62, 0.35) : const Color.fromRGBO(0, 0, 0, 0.0),
          borderRadius: BorderRadius.circular(9999),
          border: Border.all(color: selected ? const Color(0xFFB8963E) : const Color.fromRGBO(208, 197, 178, 0.25)),
        ),
        child: Text(
          label,
          style: GoogleFonts.poppins(
            fontSize: 10,
            height: 16 / 10,
            letterSpacing: 2.0,
            color: selected ? const Color(0xFFF5F0E8) : const Color(0xFFD0C5B2),
          ),
        ),
      ),
    );
  }
}

class _PrimaryButton extends StatelessWidget {
  const _PrimaryButton({required this.label, required this.onTap});
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: const LinearGradient(colors: [Color(0xFFB8963E), Color(0xFFC4A882)]),
        borderRadius: BorderRadius.circular(9999),
        boxShadow: const [BoxShadow(color: Color.fromRGBO(184, 150, 62, 0.18), blurRadius: 18, offset: Offset(0, 4))],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(9999),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: Center(
              child: Text(
                label,
                style: GoogleFonts.poppins(fontSize: 12, height: 16 / 12, letterSpacing: 2.4, color: const Color(0xFFF5F0E8)),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _SecondaryButton extends StatelessWidget {
  const _SecondaryButton({required this.label, required this.onTap});
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        border: Border.all(color: const Color.fromRGBO(229, 231, 235, 0.6)),
        borderRadius: BorderRadius.circular(9999),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(9999),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: Center(
              child: Text(
                label,
                style: GoogleFonts.poppins(fontSize: 12, height: 16 / 12, letterSpacing: 2.4, color: const Color(0xFFF5F0E8)),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

