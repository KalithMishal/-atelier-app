import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'home_screen.dart';
import 'login_screen.dart';
import '../state/providers.dart';

class RegisterScreen extends ConsumerStatefulWidget {
  const RegisterScreen({super.key});

  @override
  ConsumerState<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends ConsumerState<RegisterScreen> {
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

  bool _terms = false;
  bool _loading = false;

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
                      onPressed: (_loading || !_terms)
                          ? null
                          : () async {
                              final fullName = _name.text.trim();
                              final email = _email.text.trim();
                              final password = _password.text;
                              final confirm = _confirm.text;

                              if (fullName.isEmpty || email.isEmpty || password.isEmpty) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text('Please complete all required fields.')),
                                );
                                return;
                              }
                              if (password != confirm) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text('Passwords do not match.')),
                                );
                                return;
                              }

                              final nav = Navigator.of(context);
                              final messenger = ScaffoldMessenger.of(context);

                              setState(() => _loading = true);
                              try {
                                await ref.read(authRepositoryProvider).registerWithEmail(
                                      fullName: fullName,
                                      email: email,
                                      password: password,
                                    );
                                if (!mounted) return;
                                nav.pushReplacement(
                                  MaterialPageRoute(builder: (_) => const HomeScreen()),
                                );
                              } on FirebaseAuthException catch (e) {
                                if (!mounted) return;
                                if (e.code == 'email-already-in-use') {
                                  messenger.showSnackBar(
                                    SnackBar(
                                      content: const Text(
                                        'This email already has an account. Tap SIGN IN below, or use Forgot password on the login screen if you use email & password.',
                                      ),
                                      duration: const Duration(seconds: 8),
                                      action: SnackBarAction(
                                        label: 'SIGN IN',
                                        textColor: const Color(0xFFE8C265),
                                        onPressed: () {
                                          Navigator.of(context).pushReplacement(
                                            MaterialPageRoute(
                                              builder: (_) => LoginScreen(initialEmail: email),
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                                  );
                                } else {
                                  messenger.showSnackBar(
                                    SnackBar(content: Text(_friendlyAuthMessage(e))),
                                  );
                                }
                              } catch (e) {
                                if (!mounted) return;
                                messenger.showSnackBar(
                                  SnackBar(content: Text('Registration failed. ${e.toString()}')),
                                );
                              } finally {
                                if (mounted) setState(() => _loading = false);
                              }
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

String _friendlyAuthMessage(FirebaseAuthException e) {
  // The key one you’re seeing on web.
  if (e.code == 'configuration-not-found') {
    return 'Firebase Auth is not enabled for this project.\n'
        'Fix: Firebase Console → Authentication → Get started → enable Email/Password.\n'
        'Then restart the app.';
  }
  if (e.code == 'email-already-in-use') {
    return 'This email is already registered. Use Sign in, or a different email.';
  }
  if (e.code == 'invalid-email') return 'Please enter a valid email address.';
  if (e.code == 'weak-password') return 'Password is too weak. Use 8+ chars with numbers/symbols.';
  if (e.code == 'network-request-failed') return 'Network error. Check your internet connection.';
  return 'Registration failed. ${e.message ?? e.code}';
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
    return _PasswordFieldWithMeter(
      label: label,
      controller: controller,
      surface: surface,
      border: border,
      labelColor: labelColor,
      accent: accent,
    );
  }
}

class _PasswordFieldWithMeter extends StatefulWidget {
  const _PasswordFieldWithMeter({
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
  State<_PasswordFieldWithMeter> createState() => _PasswordFieldWithMeterState();
}

class _PasswordFieldWithMeterState extends State<_PasswordFieldWithMeter> {
  bool _obscure = true;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<TextEditingValue>(
      valueListenable: widget.controller,
      builder: (context, value, _) {
        final pwd = value.text;
        final score = _passwordScore(pwd); // 0..3
        final strengthLabel = switch (score) {
          0 || 1 => 'WEAK',
          2 => 'GOOD',
          _ => 'STRONG',
        };

        Color segColor(int i) => (score >= i) ? widget.accent : const Color(0xFF353534);

        return Stack(
          children: [
            Container(
              width: double.infinity,
              color: widget.surface,
              padding: const EdgeInsets.fromLTRB(20, 28, 20, 16),
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 11),
                    decoration: BoxDecoration(
                      border: Border.all(color: widget.border, width: 1),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: widget.controller,
                            obscureText: _obscure,
                            style: GoogleFonts.plusJakartaSans(color: const Color(0xFFE5E2E1), fontSize: 18),
                            decoration: const InputDecoration(
                              isDense: true,
                              border: InputBorder.none,
                              hintText: '',
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        IconButton(
                          onPressed: () => setState(() => _obscure = !_obscure),
                          icon: Icon(
                            _obscure ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                            size: 20,
                            color: widget.labelColor.withValues(alpha: 0.9),
                          ),
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints.tightFor(width: 36, height: 36),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(9999),
                          child: Row(
                            children: [
                              Expanded(child: ColoredBox(color: segColor(1), child: const SizedBox(height: 4))),
                              const SizedBox(width: 4),
                              Expanded(child: ColoredBox(color: segColor(2), child: const SizedBox(height: 4))),
                              const SizedBox(width: 4),
                              Expanded(child: ColoredBox(color: segColor(3), child: const SizedBox(height: 4))),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Text(
                        strengthLabel,
                        style: GoogleFonts.manrope(
                          fontSize: 11,
                          height: 14 / 11,
                          letterSpacing: 2.2,
                          color: widget.accent.withValues(alpha: pwd.isEmpty ? 0.35 : 1),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Positioned(
              left: 20,
              top: 20,
              child: Text(
                widget.label,
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 14,
                  height: 20 / 14,
                  letterSpacing: 0.7,
                  color: widget.labelColor,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  int _passwordScore(String s) {
    if (s.isEmpty) return 0;
    int score = 0;
    if (s.length >= 8) score++;
    final hasUpper = RegExp(r'[A-Z]').hasMatch(s);
    final hasLower = RegExp(r'[a-z]').hasMatch(s);
    final hasDigit = RegExp(r'\d').hasMatch(s);
    final hasSymbol = RegExp(r'[^A-Za-z0-9]').hasMatch(s);
    if (hasUpper && hasLower) score++;
    if ((hasDigit && hasSymbol) || (hasDigit && s.length >= 10) || (hasSymbol && s.length >= 10)) score++;
    return score.clamp(0, 3);
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
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => onChanged(!checked),
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 6),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AnimatedContainer(
                duration: const Duration(milliseconds: 150),
                curve: Curves.easeOut,
                height: 24,
                width: 24,
                decoration: BoxDecoration(
                  color: checked ? accent.withValues(alpha: 0.18) : null,
                  border: Border.all(
                    color: checked ? accent : border,
                    width: checked ? 2 : 1,
                  ),
                  borderRadius: BorderRadius.circular(4),
                ),
                alignment: Alignment.center,
                child: checked
                    ? Icon(Icons.check_rounded, size: 18, color: accent)
                    : null,
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
          ),
        ),
      ),
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
  final VoidCallback? onPressed;
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
        child: Opacity(
          opacity: onPressed == null ? 0.7 : 1,
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

