import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'forgot_password_screen.dart';
import 'home_screen.dart';
import 'register_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  static const _bg = Color(0xFF080808);
  static const _textPrimary = Color(0xFFE5E2E1);
  static const _muted = Color(0xFFD0C5B2);
  static const _accent = Color(0xFFE8C265);
  static const _fieldBg = Color.fromRGBO(42, 42, 42, 0.80);
  static const _fieldBorder = Color.fromRGBO(232, 194, 101, 0.30);

  final _email = TextEditingController();
  final _password = TextEditingController();
  bool _obscure = true;

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
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
                            leading: SvgPicture.asset('assets/images/icon_mail.svg', width: 16, height: 16),
                            background: _fieldBg,
                            bottomBorderColor: _fieldBorder,
                            labelColor: _muted.withValues(alpha: 0.5),
                          ),
                          const SizedBox(height: 24),
                          _IconTextField(
                            controller: _password,
                            label: 'Password',
                            leading: SvgPicture.asset('assets/images/icon_lock.svg', width: 16, height: 16),
                            background: _fieldBg,
                            bottomBorderColor: _fieldBorder,
                            labelColor: _muted.withValues(alpha: 0.5),
                            obscureText: _obscure,
                            trailing: IconButton(
                              onPressed: () => setState(() => _obscure = !_obscure),
                              icon: SvgPicture.asset('assets/images/icon_eye.svg', width: 18, height: 18),
                              color: _muted.withValues(alpha: 0.75),
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
                            onPressed: () {
                              Navigator.of(context).pushReplacement(
                                MaterialPageRoute(builder: (_) => const HomeScreen()),
                              );
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
                            leading: SvgPicture.asset('assets/images/icon_google.svg', width: 16, height: 16),
                            onPressed: () {},
                          ),
                          const SizedBox(height: 16),
                          _SocialButton(
                            label: 'Continue with Apple',
                            leading: SvgPicture.asset('assets/images/icon_apple.svg', width: 16, height: 16),
                            onPressed: () {},
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
          Opacity(opacity: 0.75, child: leading),
          const SizedBox(width: 16),
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
  final VoidCallback onPressed;
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
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
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
    );
  }
}

