import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'delete_account_screen.dart';
import 'home_screen.dart';
import 'order_history_screen.dart';
import 'profile_screen.dart';
import 'wishlist_screen.dart';

class PrivacySecurityScreen extends StatefulWidget {
  const PrivacySecurityScreen({super.key});

  @override
  State<PrivacySecurityScreen> createState() => _PrivacySecurityScreenState();
}

class _PrivacySecurityScreenState extends State<PrivacySecurityScreen> {
  static const _bg = Color(0xFF080808);
  static const _text = Color(0xFFF5F0E8);
  static const _muted = Color(0xFFD0C5B2);
  static const _luxGold = Color(0xFFB8963E);

  bool _twoFactor = true;
  bool _personalized = false;

  final int _activeBottomIndex = 3;

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
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const SizedBox(height: 12),
                      const Icon(Icons.lock_outline_rounded, size: 44, color: _luxGold),
                      const SizedBox(height: 14),
                      Text(
                        'Privacy & Security',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.notoSerif(fontSize: 30, height: 36 / 30, color: _text),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        'Safeguarding your exclusive access. Manage your\ncredentials and data preferences with absolute\ndiscretion.',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.poppins(
                          fontSize: 12,
                          height: 18 / 12,
                          color: _muted.withValues(alpha: 0.75),
                        ),
                      ),
                      const SizedBox(height: 26),
                      const _SectionLabel(icon: Icons.key_rounded, text: 'Access Credentials'),
                      const SizedBox(height: 12),
                      _Card(
                        child: Column(
                          children: [
                            _RowAction(
                              title: 'Password',
                              subtitle: 'Last updated 42 days ago',
                              trailing: const Icon(Icons.edit_outlined, size: 18, color: _muted),
                              onTap: () {},
                            ),
                            const _DividerLine(),
                            _RowToggle(
                              title: 'Two-Factor Authentication',
                              subtitle: 'Enhanced security via mobile app',
                              value: _twoFactor,
                              onChanged: (v) => setState(() => _twoFactor = v),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 26),
                      const _SectionLabel(icon: Icons.visibility_off_outlined, text: 'Data Privacy'),
                      const SizedBox(height: 12),
                      _Card(
                        child: Column(
                          children: [
                            _RowToggle(
                              title: 'Personalized Experiences',
                              subtitle: 'Allow us to curate your atelier\nbased on viewing history and\npreferences.',
                              value: _personalized,
                              onChanged: (v) => setState(() => _personalized = v),
                            ),
                            const _DividerLine(),
                            _RowAction(
                              title: 'Export Personal Data',
                              subtitle: 'Download a cryptographic\narchive of your activity.',
                              trailing: _ExportPill(onTap: () {}),
                              onTap: () {},
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),
                      GestureDetector(
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(builder: (_) => const DeleteAccountScreen()));
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.square_outlined, size: 12, color: const Color(0xFFC78B94).withValues(alpha: 0.7)),
                            const SizedBox(width: 10),
                            Text(
                              'REQUEST ACCOUNT DELETION',
                              style: GoogleFonts.poppins(
                                fontSize: 10,
                                height: 16 / 10,
                                letterSpacing: 2.0,
                                color: const Color(0xFFC78B94).withValues(alpha: 0.6),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),
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
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: SafeArea(
                top: false,
                child: Center(
                  child: _BottomNavBar(
                    activeIndex: _activeBottomIndex,
                    onTap: (idx) => _navigateBottom(context, idx),
                    accent: const Color(0xFFE9C349),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _navigateBottom(BuildContext context, int idx) {
    if (idx == _activeBottomIndex) return;
    Widget target;
    switch (idx) {
      case 0:
        target = const HomeScreen();
        break;
      case 1:
        target = const OrderHistoryScreen();
        break;
      case 2:
        target = const WishlistScreen();
        break;
      case 3:
        target = const ProfileScreen();
        break;
      default:
        target = const HomeScreen();
    }
    Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) => target));
  }
}

class _SectionLabel extends StatelessWidget {
  const _SectionLabel({required this.icon, required this.text});
  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 16, color: const Color(0xFFB8963E)),
        const SizedBox(width: 10),
        Text(
          text,
          style: GoogleFonts.poppins(fontSize: 14, height: 20 / 14, color: const Color(0xFFB8963E)),
        ),
      ],
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

class _RowAction extends StatelessWidget {
  const _RowAction({
    required this.title,
    required this.subtitle,
    required this.trailing,
    required this.onTap,
  });

  final String title;
  final String subtitle;
  final Widget trailing;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 2),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: GoogleFonts.poppins(fontSize: 14, height: 20 / 14, color: const Color(0xFFF5F0E8))),
                  const SizedBox(height: 6),
                  Text(subtitle, style: GoogleFonts.poppins(fontSize: 12, height: 16 / 12, color: const Color(0xFFD0C5B2).withValues(alpha: 0.7))),
                ],
              ),
            ),
            const SizedBox(width: 14),
            trailing,
          ],
        ),
      ),
    );
  }
}

class _RowToggle extends StatelessWidget {
  const _RowToggle({
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
              Text(subtitle, style: GoogleFonts.poppins(fontSize: 12, height: 16 / 12, color: const Color(0xFFD0C5B2).withValues(alpha: 0.7))),
            ],
          ),
        ),
        const SizedBox(width: 14),
        _GoldToggle(value: value, onChanged: onChanged),
      ],
    );
  }
}

class _GoldToggle extends StatelessWidget {
  const _GoldToggle({required this.value, required this.onChanged});
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
          color: value ? const Color(0xFFB8963E) : const Color(0xFF3A3A3A),
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
          ),
        ),
      ),
    );
  }
}

class _ExportPill extends StatelessWidget {
  const _ExportPill({required this.onTap});
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: const Color.fromRGBO(0, 0, 0, 0.12),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: const Color.fromRGBO(208, 197, 178, 0.15)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.download_rounded, size: 16, color: const Color(0xFFD0C5B2).withValues(alpha: 0.85)),
            const SizedBox(width: 8),
            Text(
              'EXPORT',
              style: GoogleFonts.poppins(
                fontSize: 10,
                height: 16 / 10,
                letterSpacing: 2.0,
                color: const Color(0xFFD0C5B2).withValues(alpha: 0.85),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _BottomNavBar extends StatelessWidget {
  const _BottomNavBar({
    required this.activeIndex,
    required this.onTap,
    required this.accent,
  });

  final int activeIndex;
  final ValueChanged<int> onTap;
  final Color accent;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 390,
      margin: const EdgeInsets.only(bottom: 0.2),
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.only(topLeft: Radius.circular(32), topRight: Radius.circular(32)),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFB8963E).withValues(alpha: 0.06),
            blurRadius: 40,
            offset: const Offset(0, -10),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: const BorderRadius.only(topLeft: Radius.circular(32), topRight: Radius.circular(32)),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 19, vertical: 14),
            color: const Color.fromRGBO(42, 36, 32, 0.99),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _NavButton(active: activeIndex == 0, icon: Icons.home_rounded, onTap: () => onTap(0), accent: accent),
                _NavButton(active: activeIndex == 1, icon: Icons.inventory_2_outlined, onTap: () => onTap(1), accent: accent),
                _NavButton(active: activeIndex == 2, icon: Icons.favorite_border_rounded, onTap: () => onTap(2), accent: accent),
                _NavButton(active: activeIndex == 3, icon: Icons.person_outline_rounded, onTap: () => onTap(3), accent: accent),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _NavButton extends StatelessWidget {
  const _NavButton({required this.active, required this.icon, required this.onTap, required this.accent});

  final bool active;
  final IconData icon;
  final VoidCallback onTap;
  final Color accent;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        height: 48,
        width: 48,
        decoration: BoxDecoration(
          color: active ? const Color.fromRGBO(195, 158, 61, 0.44) : Colors.transparent,
          borderRadius: BorderRadius.circular(10),
        ),
        alignment: Alignment.center,
        child: Icon(icon, color: active ? accent : const Color(0xFFD1C5B4), size: 22),
      ),
    );
  }
}

