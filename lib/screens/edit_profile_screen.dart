import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  static const _bg = Color(0xFF080808);
  static const _text = Color(0xFFF5F0E8);
  static const _muted = Color(0xFFD0C5B2);

  final _firstName = TextEditingController(text: 'Eleanor');
  final _lastName = TextEditingController(text: 'Vance');
  final _bio = TextEditingController(
    text: 'Curator of fine spaces and collector\nof quiet moments. New York based.',
  );
  final _email = TextEditingController(text: 'eleanor.vance@atelier.com');
  final _phone = TextEditingController(text: '+1 (555) 019-2349');

  final Set<String> _styles = {'Classic', 'Avant-Garde'};

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
                  _Avatar(onTap: () {}),
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
                        onPressed: () => Navigator.of(context).maybePop(),
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
                        onTap: () => Navigator.of(context).maybePop(),
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
  const _Avatar({required this.onTap});
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 96,
          height: 96,
          padding: const EdgeInsets.all(5),
          decoration: BoxDecoration(
            border: Border.all(color: const Color(0xFFB8963E), width: 1),
            borderRadius: BorderRadius.circular(9999),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(9999),
            child: Image.asset('assets/images/profile_sofia_reyes.png', fit: BoxFit.cover),
          ),
        ),
        const SizedBox(height: 10),
        GestureDetector(
          onTap: onTap,
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

