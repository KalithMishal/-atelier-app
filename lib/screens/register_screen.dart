import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'home_screen.dart';
import 'login_screen.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  static const _bg = Color(0xFF131313);
  static const _surface = Color(0xFF201F1F);
  static const _border = Color.fromRGBO(77, 70, 55, 0.30);
  static const _primary = Color(0xFFE5E2E1);
  static const _muted = Color(0xFFD0C5B2);
  static const _accent = Color(0xFFE8C265);

  final _name = TextEditingController();
  final _email = TextEditingController();
  final _password = TextEditingController();
  final _confirm = TextEditingController();

  bool _terms = true;

  @override
  void dispose() {
    _name.dispose();
    _email.dispose();
    _password.dispose();
    _confirm.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bg,
      body: SafeArea(
        child: Column(
          children: [
            SizedBox(
              height: 56,
              child: Align(
                alignment: Alignment.centerLeft,
                child: IconButton(
                  onPressed: () => Navigator.of(context).maybePop(),
                  icon: const Icon(Icons.arrow_back_ios_new_rounded),
                  color: _muted.withValues(alpha: 0.9),
                ),
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(24, 0, 24, 32),
                child: Column(
                  children: [
                    const SizedBox(height: 56),
                    _Headline(primary: _primary, accent: _accent),
                    const SizedBox(height: 48),
                    _LabeledField(
                      label: 'FULL NAME',
                      controller: _name,
                      surface: _surface,
                      border: _border,
                      labelColor: _muted,
                    ),
                    const SizedBox(height: 20),
                    _LabeledField(
                      label: 'EMAIL ADDRESS',
                      controller: _email,
                      surface: _surface,
                      border: _border,
                      labelColor: _muted,
                      keyboardType: TextInputType.emailAddress,
                    ),
                    const SizedBox(height: 20),
                    _PasswordWithStrength(
                      label: 'PASSWORD',
                      controller: _password,
                      surface: _surface,
                      border: _border,
                      labelColor: _muted,
                      accent: _accent,
                    ),
                    const SizedBox(height: 20),
                    _LabeledField(
                      label: 'CONFIRM PASSWORD',
                      controller: _confirm,
                      surface: _surface,
                      border: _border,
                      labelColor: _muted,
                      obscureText: true,
                    ),
                    const SizedBox(height: 16),
                    Padding(
                      padding: const EdgeInsets.only(top: 16, bottom: 32),
                      child: _TermsRow(
                        checked: _terms,
                        onChanged: (v) => setState(() => _terms = v),
                        muted: _muted,
                        accent: _accent,
                        border: _border,
                      ),
                    ),
                    _PrimaryCTA(
                      label: 'JOIN THE ATELIER',
                      onPressed: () {
                        Navigator.of(context).pushReplacement(
                          MaterialPageRoute(builder: (_) => const HomeScreen()),
                        );
                      },
                      from: _accent,
                      to: const Color(0xFFE0C29A),
                    ),
                    const SizedBox(height: 32),
                    _FooterLink(
                      muted: _muted,
                      accent: _accent,
                      onSignIn: () {
                        Navigator.of(context).pushReplacement(
                          MaterialPageRoute(builder: (_) => const LoginScreen()),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Headline extends StatelessWidget {
  const _Headline({required this.primary, required this.accent});

  final Color primary;
  final Color accent;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          'Create Your',
          textAlign: TextAlign.center,
          style: GoogleFonts.notoSerif(
            fontSize: 36,
            height: 45 / 36,
            letterSpacing: 0.9,
            color: primary,
          ),
        ),
        Text(
          'Account',
          textAlign: TextAlign.center,
          style: GoogleFonts.notoSerif(
            fontSize: 36,
            height: 45 / 36,
            letterSpacing: 0.9,
            fontStyle: FontStyle.italic,
            color: accent,
          ),
        ),
      ],
    );
  }
}

class _LabeledField extends StatelessWidget {
  const _LabeledField({
    required this.label,
    required this.controller,
    required this.surface,
    required this.border,
    required this.labelColor,
    this.keyboardType,
    this.obscureText = false,
  });

  final String label;
  final TextEditingController controller;
  final Color surface;
  final Color border;
  final Color labelColor;
  final TextInputType? keyboardType;
  final bool obscureText;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          width: double.infinity,
          color: surface,
          padding: const EdgeInsets.fromLTRB(20, 28, 20, 12),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 11),
            decoration: BoxDecoration(
              border: Border.all(color: border, width: 1),
            ),
            child: TextField(
              controller: controller,
              obscureText: obscureText,
              keyboardType: keyboardType,
              style: GoogleFonts.plusJakartaSans(color: const Color(0xFFE5E2E1), fontSize: 18),
              decoration: const InputDecoration(
                isDense: true,
                border: InputBorder.none,
                hintText: '',
              ),
            ),
          ),
        ),
        Positioned(
          left: 20,
          top: 20,
          child: Text(
            label,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 14,
              height: 20 / 14,
              letterSpacing: 0.7,
              color: labelColor,
            ),
          ),
        ),
      ],
    );
  }
}

class _PasswordWithStrength extends StatelessWidget {
  const _PasswordWithStrength({
    required this.label,
    required this.controller,
    required this.surface,
    required this.border,
    required this.labelColor,
    required this.accent,
  });

  final String label;
  final TextEditingController controller;
  final Color surface;
  final Color border;
  final Color labelColor;
  final Color accent;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          width: double.infinity,
          color: surface,
          padding: const EdgeInsets.fromLTRB(20, 28, 20, 16),
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 11),
                decoration: BoxDecoration(
                  border: Border.all(color: border, width: 1),
                ),
                child: TextField(
                  controller: controller,
                  obscureText: true,
                  style: GoogleFonts.plusJakartaSans(color: const Color(0xFFE5E2E1), fontSize: 18),
                  decoration: const InputDecoration(
                    isDense: true,
                    border: InputBorder.none,
                    hintText: '',
                  ),
                ),
              ),
              const SizedBox(height: 12),
              ClipRRect(
                borderRadius: BorderRadius.circular(9999),
                child: Row(
                  children: const [
                    Expanded(child: ColoredBox(color: Color(0xFFE8C265), child: SizedBox(height: 4))),
                    SizedBox(width: 4),
                    Expanded(child: ColoredBox(color: Color(0xFF353534), child: SizedBox(height: 4))),
                    SizedBox(width: 4),
                    Expanded(child: ColoredBox(color: Color(0xFF353534), child: SizedBox(height: 4))),
                  ],
                ),
              ),
            ],
          ),
        ),
        Positioned(
          left: 20,
          top: 20,
          child: Text(
            label,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 14,
              height: 20 / 14,
              letterSpacing: 0.7,
              color: labelColor,
            ),
          ),
        ),
      ],
    );
  }
}

class _TermsRow extends StatelessWidget {
  const _TermsRow({
    required this.checked,
    required this.onChanged,
    required this.muted,
    required this.accent,
    required this.border,
  });

  final bool checked;
  final ValueChanged<bool> onChanged;
  final Color muted;
  final Color accent;
  final Color border;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GestureDetector(
          onTap: () => onChanged(!checked),
          child: Container(
            height: 24,
            width: 24,
            decoration: BoxDecoration(
              border: Border.all(color: const Color(0xFF4D4637), width: 1),
              borderRadius: BorderRadius.circular(2),
            ),
            alignment: Alignment.center,
            child: checked
                ? SvgPicture.asset(
                    'assets/images/icon_check.svg',
                    width: 12,
                    height: 10,
                    colorFilter: ColorFilter.mode(accent, BlendMode.srcIn),
                  )
                : const SizedBox(),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Text.rich(
            TextSpan(
              children: [
                TextSpan(
                  text: 'I agree to the ',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 14,
                    height: 22.75 / 14,
                    color: muted,
                    letterSpacing: 0.35,
                  ),
                ),
                TextSpan(
                  text: 'Terms of Service',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 14,
                    height: 22.75 / 14,
                    color: accent,
                    decoration: TextDecoration.underline,
                    decorationColor: accent.withValues(alpha: 0.3),
                  ),
                ),
                TextSpan(
                  text: ' and ',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 14,
                    height: 22.75 / 14,
                    color: muted,
                    letterSpacing: 0.35,
                  ),
                ),
                TextSpan(
                  text: 'Privacy Policy',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 14,
                    height: 22.75 / 14,
                    color: accent,
                    decoration: TextDecoration.underline,
                    decorationColor: accent.withValues(alpha: 0.3),
                  ),
                ),
                TextSpan(
                  text: '.',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 14,
                    height: 22.75 / 14,
                    color: muted,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _PrimaryCTA extends StatelessWidget {
  const _PrimaryCTA({
    required this.label,
    required this.onPressed,
    required this.from,
    required this.to,
  });

  final String label;
  final VoidCallback onPressed;
  final Color from;
  final Color to;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        height: 60,
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(colors: [from, to]),
          borderRadius: BorderRadius.circular(9999),
          boxShadow: const [
            BoxShadow(
              color: Color.fromRGBO(184, 150, 62, 0.15),
              blurRadius: 30,
              offset: Offset(0, 10),
            ),
          ],
        ),
        alignment: Alignment.center,
        child: Text(
          label,
          style: GoogleFonts.plusJakartaSans(
            fontSize: 14,
            height: 20 / 14,
            letterSpacing: 2.8,
            color: const Color(0xFF3E2E00),
          ),
        ),
      ),
    );
  }
}

class _FooterLink extends StatelessWidget {
  const _FooterLink({required this.muted, required this.accent, required this.onSignIn});

  final Color muted;
  final Color accent;
  final VoidCallback onSignIn;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'Already a member? ',
          style: GoogleFonts.plusJakartaSans(
            fontSize: 14,
            height: 20 / 14,
            letterSpacing: 0.35,
            color: muted,
          ),
        ),
        GestureDetector(
          onTap: onSignIn,
          child: Text(
            'SIGN IN',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 14,
              height: 20 / 14,
              letterSpacing: 1.4,
              color: accent,
              decoration: TextDecoration.underline,
              decorationColor: accent.withValues(alpha: 0.4),
            ),
          ),
        ),
      ],
    );
  }
}

