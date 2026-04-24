import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class PreferencesScreen extends StatefulWidget {
  const PreferencesScreen({super.key});

  @override
  State<PreferencesScreen> createState() => _PreferencesScreenState();
}

class _PreferencesScreenState extends State<PreferencesScreen> {
  static const _bg = Color(0xFF080808);
  static const _text = Color(0xFFF5F0E8);
  static const _luxGold = Color(0xFFB8963E);

  bool _emailExclusives = true;
  bool _push = false;
  bool _smsConcierge = true;

  String _language = 'English (US)';
  String _measurement = 'Metric (cm)';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bg,
      body: SafeArea(
        bottom: false,
        child: Stack(
          children: [
            SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(24, 92, 24, 120),
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 390),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Preferences',
                        style: GoogleFonts.notoSerif(fontSize: 30, height: 36 / 30, color: _text),
                      ),
                      const SizedBox(height: 18),
                      _SectionTitle('COMMUNICATIONS'),
                      const SizedBox(height: 12),
                      _Card(
                        child: Column(
                          children: [
                            _ToggleRow(
                              title: 'Email Exclusives',
                              subtitle: 'Curated collections and editorial\ncontent.',
                              value: _emailExclusives,
                              onChanged: (v) => setState(() => _emailExclusives = v),
                            ),
                            const _DividerLine(),
                            _ToggleRow(
                              title: 'Push Notifications',
                              subtitle: 'Real-time updates on your bespoke\norders.',
                              value: _push,
                              onChanged: (v) => setState(() => _push = v),
                            ),
                            const _DividerLine(),
                            _ToggleRow(
                              title: 'SMS Concierge',
                              subtitle: 'Direct messaging with your personal\nstylist.',
                              value: _smsConcierge,
                              onChanged: (v) => setState(() => _smsConcierge = v),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 26),
                      _SectionTitle('REGIONAL DETAILS'),
                      const SizedBox(height: 12),
                      _Card(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _FieldTitle(
                              title: 'Language',
                              subtitle: 'Select your preferred language.',
                            ),
                            const SizedBox(height: 12),
                            _DropdownField<String>(
                              value: _language,
                              items: const ['English (US)', 'English (UK)', 'Français', 'العربية'],
                              onChanged: (v) => setState(() => _language = v),
                            ),
                            const SizedBox(height: 18),
                            _FieldTitle(
                              title: 'Measurement System',
                              subtitle: 'Used for sizing and fit guidance.',
                            ),
                            const SizedBox(height: 12),
                            _DropdownField<String>(
                              value: _measurement,
                              items: const ['Metric (cm)', 'Imperial (in)'],
                              onChanged: (v) => setState(() => _measurement = v),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 22),
                      Align(
                        alignment: Alignment.centerRight,
                        child: _SaveButton(
                          onTap: () => Navigator.of(context).maybePop(),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Positioned(
              left: 0,
              right: 0,
              top: 0,
              child: SafeArea(
                bottom: false,
                child: ClipRRect(
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
                    child: Container(
                      height: 64,
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      color: const Color.fromRGBO(8, 8, 8, 0.85),
                      child: Row(
                        children: [
                          IconButton(
                            onPressed: () => Navigator.of(context).maybePop(),
                            icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 18, color: _luxGold),
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
                          const SizedBox(width: 40),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle(this.text);
  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: GoogleFonts.poppins(
        fontSize: 12,
        height: 16 / 12,
        letterSpacing: 2.4,
        color: const Color(0xFFB8963E),
      ),
    );
  }
}

class _Card extends StatelessWidget {
  const _Card({required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: const Color(0xFF2A2420),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color.fromRGBO(208, 197, 178, 0.10)),
        boxShadow: const [BoxShadow(color: Color.fromRGBO(0, 0, 0, 0.35), blurRadius: 40, offset: Offset(0, 20))],
      ),
      padding: const EdgeInsets.fromLTRB(18, 18, 18, 18),
      child: child,
    );
  }
}

class _DividerLine extends StatelessWidget {
  const _DividerLine();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 14),
      child: Container(
        height: 1,
        width: double.infinity,
        color: const Color.fromRGBO(8, 8, 8, 0.5),
      ),
    );
  }
}

class _ToggleRow extends StatelessWidget {
  const _ToggleRow({
    required this.title,
    required this.subtitle,
    required this.value,
    required this.onChanged,
  });

  final String title;
  final String subtitle;
  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: GoogleFonts.poppins(fontSize: 14, height: 20 / 14, color: const Color(0xFFF5F0E8))),
              const SizedBox(height: 6),
              Text(
                subtitle,
                style: GoogleFonts.poppins(fontSize: 12, height: 16 / 12, color: const Color(0xFFD0C5B2).withValues(alpha: 0.7)),
              ),
            ],
          ),
        ),
        const SizedBox(width: 14),
        _CheckToggle(value: value, onChanged: onChanged),
      ],
    );
  }
}

class _CheckToggle extends StatelessWidget {
  const _CheckToggle({required this.value, required this.onChanged});
  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onChanged(!value),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        width: 38,
        height: 22,
        decoration: BoxDecoration(
          color: value ? const Color(0xFF2F6BFF) : const Color(0xFF3A3A3A),
          borderRadius: BorderRadius.circular(9999),
          border: Border.all(color: const Color.fromRGBO(208, 197, 178, 0.12)),
        ),
        child: Align(
          alignment: value ? Alignment.centerRight : Alignment.centerLeft,
          child: Container(
            width: 18,
            height: 18,
            margin: const EdgeInsets.all(2),
            decoration: BoxDecoration(
              color: const Color(0xFFF5F0E8),
              borderRadius: BorderRadius.circular(9999),
            ),
            child: value
                ? const Icon(Icons.check_rounded, size: 14, color: Color(0xFF2F6BFF))
                : null,
          ),
        ),
      ),
    );
  }
}

class _FieldTitle extends StatelessWidget {
  const _FieldTitle({required this.title, required this.subtitle});
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: GoogleFonts.poppins(fontSize: 14, height: 20 / 14, color: const Color(0xFFF5F0E8))),
        const SizedBox(height: 6),
        Text(
          subtitle,
          style: GoogleFonts.poppins(fontSize: 12, height: 16 / 12, color: const Color(0xFFD0C5B2).withValues(alpha: 0.7)),
        ),
      ],
    );
  }
}

class _DropdownField<T> extends StatelessWidget {
  const _DropdownField({required this.value, required this.items, required this.onChanged});

  final T value;
  final List<T> items;
  final ValueChanged<T> onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 14),
      decoration: BoxDecoration(
        color: const Color.fromRGBO(0, 0, 0, 0.12),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color.fromRGBO(208, 197, 178, 0.15)),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<T>(
          value: value,
          isExpanded: true,
          dropdownColor: const Color(0xFF1C1B1B),
          icon: const Icon(Icons.keyboard_arrow_down_rounded, color: Color(0xFFD0C5B2)),
          items: [
            for (final it in items)
              DropdownMenuItem<T>(
                value: it,
                child: Text(
                  '$it',
                  style: GoogleFonts.poppins(fontSize: 12, height: 16 / 12, color: const Color(0xFFD0C5B2)),
                ),
              ),
          ],
          onChanged: (v) {
            if (v != null) onChanged(v);
          },
        ),
      ),
    );
  }
}

class _SaveButton extends StatelessWidget {
  const _SaveButton({required this.onTap});
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: const LinearGradient(colors: [Color(0xFFB8963E), Color(0xFFC4A882)]),
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [BoxShadow(color: Color.fromRGBO(184, 150, 62, 0.18), blurRadius: 18, offset: Offset(0, 4))],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 14),
            child: Text(
              'SAVE CHANGES',
              style: GoogleFonts.poppins(
                fontSize: 12,
                height: 16 / 12,
                letterSpacing: 2.4,
                color: const Color(0xFF2A2420),
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

