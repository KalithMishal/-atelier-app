import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SavedAddressesScreen extends StatelessWidget {
  const SavedAddressesScreen({super.key});

  static const _bg = Color(0xFF080808);
  static const _text = Color(0xFFF5F0E8);
  static const _muted = Color(0xFFD0C5B2);
  static const _luxGold = Color(0xFFB8963E);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bg,
      body: SafeArea(
        bottom: false,
        child: Stack(
          children: [
            SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(24, 96, 24, 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    'Saved Addresses',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.bodoniModa(
                      fontSize: 30,
                      height: 36 / 30,
                      color: _text,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Where shall we deliver your\nacquisitions?',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.cormorantGaramond(
                      fontSize: 18,
                      height: 28 / 18,
                      color: _muted.withValues(alpha: 0.85),
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                  const SizedBox(height: 24),
                  _AddressCard(
                    selected: true,
                    tag: 'HOME',
                    showDefault: true,
                    name: 'Eleanor Vance',
                    addressLines: const [
                      '1242 Parallax Avenue',
                      'Suite 400',
                      'New York, NY 10012',
                      'United States',
                    ],
                    phone: '+1 (555) 019-2834',
                  ),
                  const SizedBox(height: 22),
                  _AddressCard(
                    selected: false,
                    tag: 'OFFICE',
                    showDefault: false,
                    name: 'Eleanor Vance',
                    addressLines: const [
                      'The Crain Building',
                      '880 Corporate Blvd, Floor 42',
                      'Chicago, IL 60601',
                      'United States',
                    ],
                    phone: '+1 (555) 832-1100',
                  ),
                  const SizedBox(height: 24),
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
          ],
        ),
      ),
    );
  }
}

class _AddressCard extends StatelessWidget {
  const _AddressCard({
    required this.selected,
    required this.tag,
    required this.showDefault,
    required this.name,
    required this.addressLines,
    required this.phone,
  });

  final bool selected;
  final String tag;
  final bool showDefault;
  final String name;
  final List<String> addressLines;
  final String phone;

  static const _surface = Color(0xFF2A2420);
  static const _text = Color(0xFFF5F0E8);
  static const _muted = Color(0xFFD0C5B2);

  @override
  Widget build(BuildContext context) {
    final border = selected ? const Color.fromRGBO(184, 150, 62, 0.55) : const Color.fromRGBO(208, 197, 178, 0.12);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(18, 18, 18, 16),
      decoration: BoxDecoration(
        color: _surface,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: border, width: 1),
        boxShadow: const [BoxShadow(color: Color.fromRGBO(0, 0, 0, 0.35), blurRadius: 40, offset: Offset(0, 20))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _TagPill(label: tag, filled: selected),
              const SizedBox(width: 12),
              if (showDefault) ...[
                const Icon(Icons.check_circle_rounded, size: 14, color: _muted),
                const SizedBox(width: 6),
                Text(
                  'DEFAULT',
                  style: GoogleFonts.poppins(fontSize: 10, height: 16 / 10, letterSpacing: 2, color: _muted),
                ),
              ] else ...[
                const Spacer(),
                Icon(Icons.radio_button_unchecked_rounded, size: 18, color: _muted.withValues(alpha: 0.7)),
              ],
            ],
          ),
          const SizedBox(height: 16),
          Text(
            name,
            style: GoogleFonts.bodoniModa(fontSize: 22, height: 28 / 22, color: _text),
          ),
          const SizedBox(height: 10),
          for (final line in addressLines)
            Padding(
              padding: const EdgeInsets.only(bottom: 4),
              child: Text(
                line,
                style: GoogleFonts.cormorantGaramond(fontSize: 16, height: 22 / 16, color: _muted.withValues(alpha: 0.9)),
              ),
            ),
          const SizedBox(height: 2),
          Text(
            phone,
            style: GoogleFonts.poppins(fontSize: 12, height: 18 / 12, color: _muted.withValues(alpha: 0.9)),
          ),
          const SizedBox(height: 18),
          Row(
            children: [
              _ActionLink(icon: Icons.edit_outlined, label: 'EDIT', onTap: () {}),
              const SizedBox(width: 22),
              _ActionLink(icon: Icons.delete_outline_rounded, label: 'DELETE', onTap: () {}, muted: !selected),
              const Spacer(),
              if (selected)
                Container(
                  width: 3,
                  height: 0, // placeholder to keep layout similar, left strip is drawn outside
                  color: Colors.transparent,
                ),
            ],
          ),
        ],
      ),
    );
  }
}

class _TagPill extends StatelessWidget {
  const _TagPill({required this.label, required this.filled});
  final String label;
  final bool filled;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: filled ? const Color.fromRGBO(184, 150, 62, 0.25) : const Color.fromRGBO(0, 0, 0, 0.0),
        borderRadius: BorderRadius.circular(9999),
        border: Border.all(color: const Color.fromRGBO(208, 197, 178, 0.18)),
      ),
      child: Text(
        label,
        style: GoogleFonts.poppins(fontSize: 10, height: 16 / 10, letterSpacing: 2.0, color: const Color(0xFFD0C5B2)),
      ),
    );
  }
}

class _ActionLink extends StatelessWidget {
  const _ActionLink({required this.icon, required this.label, required this.onTap, this.muted = false});
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final bool muted;

  @override
  Widget build(BuildContext context) {
    final color = muted ? const Color(0xFFD0C5B2).withValues(alpha: 0.55) : const Color(0xFFB8963E);
    return GestureDetector(
      onTap: onTap,
      child: Row(
        children: [
          Icon(icon, size: 16, color: color),
          const SizedBox(width: 8),
          Text(label, style: GoogleFonts.poppins(fontSize: 12, height: 16 / 12, letterSpacing: 2.4, color: color)),
        ],
      ),
    );
  }
}

