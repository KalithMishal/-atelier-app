import 'dart:ui';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'forgot_password_screen.dart';
import 'home_screen.dart';
import 'register_screen.dart';
import '../state/providers.dart';
import '../utils/auth_messages.dart';
import '../utils/google_sign_in_setup_dialog.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key, this.initialEmail});

  /// When set (e.g. from Register), the email field is prefilled.
  final String? initialEmail;

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  static const _bg = Color(0xFF080808);
  static const _textPrimary = Color(0xFFE5E2E1);
  static const _muted = Color(0xFFD0C5B2);
  static const _accent = Color(0xFFE8C265);
  static const _fieldBg = Color.fromRGBO(42, 42, 42, 0.80);
  static const _fieldBorder = Color.fromRGBO(232, 194, 101, 0.30);

  final _email = TextEditingController();
  final _password = TextEditingController();
  bool _obscure = true;
  bool _loading = false;

  @override
  void initState() {
    super.initState();
    final init = widget.initialEmail;
    if (init != null && init.trim().isNotEmpty) {
      _email.text = init.trim();
    }
    if (kIsWeb) {
      WidgetsBinding.instance.addPostFrameCallback((_) => _completeWebGoogleRedirectIfNeeded());
    }
  }

  /// If the user lands on Login after a web OAuth redirect, attach the session here too.
  Future<void> _completeWebGoogleRedirectIfNeeded() async {
    if (!kIsWeb || !mounted) return;
    try {
      final result = await FirebaseAuth.instance.getRedirectResult();
      if (!mounted) return;
      if (result.user != null) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute<void>(builder: (_) => const HomeScreen()),
        );
      }
    } catch (e, st) {
      debugPrint('LoginScreen getRedirectResult: $e\n$st');
    }
  }

  bool _isFirebaseGoogleProviderDisabled(FirebaseAuthException e) {
    if (e.code != 'operation-not-allowed') return false;
    final m = (e.message ?? '').toLowerCase();
    return m.contains('disabled') && m.contains('provider');
  }

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  void _showAuthSnackBar(BuildContext context, Object e, {SnackBarAction? action}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.fromLTRB(16, 0, 16, 24),
        backgroundColor: const Color(0xFF1A1A1A),
        elevation: 8,
        content: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Icon(Icons.error_outline_rounded, color: Color(0xFFE8C265), size: 22),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                friendlyAuthError(e),
                style: GoogleFonts.plusJakartaSans(
                  color: const Color(0xFFF5F0E8),
                  fontSize: 14,
                  height: 1.35,
                ),
              ),
            ),
          ],
        ),
        duration: const Duration(seconds: 6),
        action: action,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bg,
      body: SafeArea(
        child: Stack(
          children: [
            Positioned.fill(
              child: Opacity(
                opacity: 0.18,
                child: SvgPicture.asset(
                  'assets/images/login_bg.svg',
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Positioned.fill(
              child: IgnorePointer(
                child: Center(
                  child: ImageFiltered(
                    imageFilter: ImageFilter.blur(sigmaX: 60, sigmaY: 60),
                    child: Container(
                      width: 520,
                      height: 520,
                      decoration: BoxDecoration(
                        color: const Color.fromRGBO(232, 194, 101, 0.05),
                        borderRadius: BorderRadius.circular(9999),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            LayoutBuilder(
              builder: (context, constraints) {
                return SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(24, 48, 24, 32),
                  child: ConstrainedBox(
                    constraints: BoxConstraints(minHeight: constraints.maxHeight - 48 - 32),
                    child: IntrinsicHeight(
                      child: Column(
                        children: [
                          _HeaderSection(
                            accent: _accent,
                            primary: _textPrimary,
                            muted: _muted,
                          ),
                          const SizedBox(height: 24),
                          _IconTextField(
                            controller: _email,
                            label: 'Email Address',
                            leading: Icon(Icons.mail_outline_rounded, size: 22, color: _accent),
                            background: _fieldBg,
                            bottomBorderColor: _fieldBorder,
                            labelColor: _muted.withValues(alpha: 0.5),
                          ),
                          const SizedBox(height: 24),
                          _IconTextField(
                            controller: _password,
                            label: 'Password',
                            leading: Icon(Icons.lock_outline_rounded, size: 22, color: _accent),
                            background: _fieldBg,
                            bottomBorderColor: _fieldBorder,
                            labelColor: _muted.withValues(alpha: 0.5),
                            obscureText: _obscure,
                            trailing: IconButton(
                              onPressed: () => setState(() => _obscure = !_obscure),
                              tooltip: _obscure ? 'Show password' : 'Hide password',
                              style: IconButton.styleFrom(
                                foregroundColor: _accent,
                                padding: const EdgeInsets.all(10),
                                minimumSize: const Size(48, 48),
                                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                              ),
                              icon: Icon(
                                _obscure ? Icons.visibility_outlined : Icons.visibility_off_outlined,
                                size: 22,
                                color: _accent,
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),
                          Align(
                            alignment: Alignment.centerRight,
                            child: TextButton(
                              onPressed: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(builder: (_) => const ForgotPasswordScreen()),
                                );
                              },
                              style: TextButton.styleFrom(
                                padding: const EdgeInsets.only(bottom: 3),
                                minimumSize: Size.zero,
                                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                              ),
                              child: Text(
                                'Forgot Password?',
                                style: GoogleFonts.plusJakartaSans(
                                  fontSize: 12,
                                  height: 16 / 12,
                                  color: _muted,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),
                          _PrimaryGradientButton(
                            text: 'SIGN IN',
                            onPressed: _loading
                                ? null
                                : () async {
                                    final email = _email.text.trim();
                                    final password = _password.text;
                                    if (email.isEmpty || password.isEmpty) {
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(
                                          behavior: SnackBarBehavior.floating,
                                          margin: const EdgeInsets.fromLTRB(16, 0, 16, 24),
                                          backgroundColor: const Color(0xFF1A1A1A),
                                          content: Row(
                                            children: [
                                              const Icon(Icons.info_outline_rounded,
                                                  color: Color(0xFFE8C265), size: 22),
                                              const SizedBox(width: 12),
                                              Expanded(
                                                child: Text(
                                                  'Please enter email and password.',
                                                  style: GoogleFonts.plusJakartaSans(
                                                    color: const Color(0xFFF5F0E8),
                                                    fontSize: 14,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      );
                                      return;
                                    }

                                    final nav = Navigator.of(context);

                                    setState(() => _loading = true);
                                    try {
                                      await ref.read(authRepositoryProvider).signInWithEmail(
                                            email: email,
                                            password: password,
                                          );
                                      if (!mounted) return;
                                      nav.pushReplacement(
                                        MaterialPageRoute(builder: (_) => const HomeScreen()),
                                      );
                                    } catch (e) {
                                      if (!mounted || !context.mounted) return;
                                      _showAuthSnackBar(
                                        context,
                                        e,
                                        action: e is FirebaseAuthException &&
                                                (e.code == 'invalid-credential' ||
                                                    e.code == 'user-not-found' ||
                                                    e.code == 'wrong-password')
                                            ? SnackBarAction(
                                                label: 'Sign up',
                                                textColor: const Color(0xFFE8C265),
                                                onPressed: () {
                                                  Navigator.of(context).push(
                                                    MaterialPageRoute(builder: (_) => const RegisterScreen()),
                                                  );
                                                },
                                              )
                                            : null,
                                      );
                                    } finally {
                                      if (mounted) setState(() => _loading = false);
                                    }
                                  },
                            from: const Color(0xFFB8963E),
                            to: const Color(0xFFC4A882),
                            textColor: const Color(0xFF3E2E00),
                            shadowColor: const Color.fromRGBO(184, 150, 62, 0.15),
                          ),
                          const Spacer(),
                          _OrDivider(muted: _muted.withValues(alpha: 0.5)),
                          const SizedBox(height: 16),
                          _SocialButton(
                            label: 'Continue with Google',
                            leading: SvgPicture.asset(
                              'assets/images/icon_google.svg',
                              width: 24,
                              height: 24,
                            ),
                            onPressed: _loading
                                ? null
                                : () async {
                                    final nav = Navigator.of(context);
                                    setState(() => _loading = true);
                                    try {
                                      await ref.read(authRepositoryProvider).signInWithGoogle();
                                      if (!mounted) return;
                                      nav.pushReplacement(
                                        MaterialPageRoute(builder: (_) => const HomeScreen()),
                                      );
                                    } on FirebaseAuthException catch (e) {
                                      if (!mounted || !context.mounted) return;
                                      // Full-page OAuth redirect has started; avoid error UI.
                                      if (e.code == 'redirect-in-progress') return;
                                      if (_isFirebaseGoogleProviderDisabled(e)) {
                                        await showGoogleSignInSetupDialog(context);
                                        return;
                                      }
                                      _showAuthSnackBar(context, e);
                                    } catch (e) {
                                      if (!mounted || !context.mounted) return;
                                      _showAuthSnackBar(context, e);
                                    } finally {
                                      if (mounted) setState(() => _loading = false);
                                    }
                                  },
                          ),
                          const SizedBox(height: 16),
                          _SocialButton(
                            label: 'Continue with Apple',
                            leading: SvgPicture.asset(
                              'assets/images/icon_apple.svg',
                              width: 24,
                              height: 24,
                              colorFilter: const ColorFilter.mode(Color(0xFFF5F0E8), BlendMode.srcIn),
                            ),
                            onPressed: _loading
                                ? null
                                : () async {
                                    final nav = Navigator.of(context);
                                    setState(() => _loading = true);
                                    try {
                                      await ref.read(authRepositoryProvider).signInWithApple();
                                      if (!mounted) return;
                                      nav.pushReplacement(
                                        MaterialPageRoute(builder: (_) => const HomeScreen()),
                                      );
                                    } catch (e) {
                                      if (!mounted || !context.mounted) return;
                                      _showAuthSnackBar(context, e);
                                    } finally {
                                      if (mounted) setState(() => _loading = false);
                                    }
                                  },
                          ),
                          const SizedBox(height: 24),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'New to ATELIER? ',
                                style: GoogleFonts.plusJakartaSans(
                                  fontSize: 14,
                                  height: 20 / 14,
                                  color: _muted.withValues(alpha: 0.8),
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  Navigator.of(context).push(
                                    MaterialPageRoute(builder: (_) => const RegisterScreen()),
                                  );
                                },
                                child: Container(
                                  padding: const EdgeInsets.only(bottom: 2),
                                  decoration: const BoxDecoration(
                                    border: Border(
                                      bottom: BorderSide(color: Color.fromRGBO(232, 194, 101, 0.30), width: 1),
                                    ),
                                  ),
                                  child: Text(
                                    'Create Account',
                                    style: GoogleFonts.plusJakartaSans(
                                      fontSize: 14,
                                      height: 20 / 14,
                                      color: _accent,
                                      letterSpacing: 0.35,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _HeaderSection extends StatelessWidget {
  const _HeaderSection({
    required this.accent,
    required this.primary,
    required this.muted,
  });

  final Color accent;
  final Color primary;
  final Color muted;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          'ATELIER',
          textAlign: TextAlign.center,
          style: GoogleFonts.notoSerif(
            fontSize: 32,
            height: 48 / 32,
            letterSpacing: 12.8,
            color: accent,
          ),
        ),
        const SizedBox(height: 24),
        SizedBox(
          width: 64,
          height: 1,
          child: DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  accent.withValues(alpha: 0.0),
                  accent.withValues(alpha: 0.4),
                  accent.withValues(alpha: 0.0),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(height: 40),
        Container(
          width: 72,
          height: 72,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: accent.withValues(alpha: 0.65), width: 2),
            color: const Color.fromRGBO(232, 194, 101, 0.14),
            boxShadow: [
              BoxShadow(
                color: accent.withValues(alpha: 0.22),
                blurRadius: 28,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          alignment: Alignment.center,
          child: Icon(
            Icons.lock_person_rounded,
            size: 38,
            color: accent,
            shadows: const [
              Shadow(color: Color.fromRGBO(0, 0, 0, 0.45), blurRadius: 12, offset: Offset(0, 2)),
            ],
          ),
        ),
        const SizedBox(height: 28),
        Text(
          'Welcome Back',
          textAlign: TextAlign.center,
          style: GoogleFonts.notoSerif(
            fontSize: 30,
            height: 36 / 30,
            letterSpacing: 0.75,
            color: primary,
          ),
        ),
        const SizedBox(height: 12),
        Text(
          'Sign in to your private account',
          textAlign: TextAlign.center,
          style: GoogleFonts.plusJakartaSans(
            fontSize: 14,
            height: 20 / 14,
            letterSpacing: 0.35,
            color: muted,
          ),
        ),
      ],
    );
  }
}

class _IconTextField extends StatelessWidget {
  const _IconTextField({
    required this.controller,
    required this.label,
    required this.leading,
    required this.background,
    required this.bottomBorderColor,
    required this.labelColor,
    this.obscureText = false,
    this.trailing,
  });

  final TextEditingController controller;
  final String label;
  final Widget leading;
  final Color background;
  final Color bottomBorderColor;
  final Color labelColor;
  final bool obscureText;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: background,
        border: Border(
          bottom: BorderSide(color: bottomBorderColor, width: 1),
        ),
        boxShadow: const [
          BoxShadow(color: Color.fromRGBO(0, 0, 0, 0.05), blurRadius: 2, offset: Offset(0, 1)),
        ],
      ),
      padding: EdgeInsets.fromLTRB(20, 16, trailing == null ? 20 : 8, 16),
      child: Row(
        children: [
          leading,
          const SizedBox(width: 14),
          Expanded(
            child: TextField(
              controller: controller,
              obscureText: obscureText,
              style: GoogleFonts.plusJakartaSans(color: const Color(0xFFE5E2E1), fontSize: 16),
              decoration: InputDecoration(
                isDense: true,
                border: InputBorder.none,
                hintText: label,
                hintStyle: GoogleFonts.plusJakartaSans(color: labelColor, fontSize: 14),
              ),
            ),
          ),
          trailing ?? const SizedBox(),
        ],
      ),
    );
  }
}

class _PrimaryGradientButton extends StatelessWidget {
  const _PrimaryGradientButton({
    required this.text,
    required this.onPressed,
    required this.from,
    required this.to,
    required this.textColor,
    required this.shadowColor,
  });

  final String text;
  final VoidCallback? onPressed;
  final Color from;
  final Color to;
  final Color textColor;
  final Color shadowColor;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        height: 52,
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(colors: [from, to]),
          borderRadius: BorderRadius.circular(9999),
          boxShadow: [BoxShadow(color: shadowColor, blurRadius: 20, offset: const Offset(0, 4))],
        ),
        alignment: Alignment.center,
        child: Opacity(
          opacity: onPressed == null ? 0.7 : 1,
          child: Text(
            text,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 14,
              height: 20 / 14,
              letterSpacing: 2.1,
              color: textColor,
            ),
          ),
        ),
      ),
    );
  }
}

class _OrDivider extends StatelessWidget {
  const _OrDivider({required this.muted});

  final Color muted;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Container(
            height: 1,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  const Color.fromRGBO(77, 70, 55, 0.0),
                  muted.withValues(alpha: 0.6),
                ],
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            'OR',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 12,
              letterSpacing: 0.6,
              color: muted,
            ),
          ),
        ),
        Expanded(
          child: Container(
            height: 1,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  muted.withValues(alpha: 0.6),
                  const Color.fromRGBO(77, 70, 55, 0.0),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _SocialButton extends StatelessWidget {
  const _SocialButton({
    required this.label,
    required this.leading,
    required this.onPressed,
  });

  final String label;
  final Widget leading;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    final enabled = onPressed != null;
    return Opacity(
      opacity: enabled ? 1 : 0.45,
      child: GestureDetector(
        onTap: onPressed,
        child: Container(
          height: 50,
          width: double.infinity,
          decoration: BoxDecoration(
            color: const Color.fromRGBO(19, 19, 19, 0.5),
            borderRadius: BorderRadius.circular(9999),
            border: Border.all(color: const Color.fromRGBO(77, 70, 55, 0.3), width: 1),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              leading,
              const SizedBox(width: 12),
              Text(
                label,
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 14,
                  height: 20 / 14,
                  color: const Color(0xFFE5E2E1),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

