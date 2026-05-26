import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'login_screen.dart';
import 'forgot_password_success_screen.dart';
import '../state/providers.dart';
import '../utils/auth_messages.dart';

class ForgotPasswordScreen extends ConsumerStatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  ConsumerState<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends ConsumerState<ForgotPasswordScreen> {
  final _email = TextEditingController();
  bool _loading = false;

  @override
  void dispose() {
    _email.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final email = _email.text.trim();
    if (email.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter your email address.')),
      );
      return;
    }
    if (!_isValidEmailFormat(email)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Enter a valid email address (e.g. name@example.com).')),
      );
      return;
    }

    setState(() => _loading = true);
    try {
      await ref.read(authRepositoryProvider).sendPasswordResetEmail(email);
      if (!mounted) return;
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => ForgotPasswordSuccessScreen(email: email)),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(friendlyPasswordResetError(e)),
          duration: const Duration(seconds: 8),
        ),
      );
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  bool _isValidEmailFormat(String value) {
    if (value.length > 254) return false;
    return RegExp(r'^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$').hasMatch(value);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF080808),
      body: SafeArea(
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 32, 24, 0),
              child: Align(
                alignment: Alignment.topCenter,
                child: Text(
                  'ATELIER',
                  style: GoogleFonts.notoSerif(
                    fontSize: 24,
                    height: 32 / 24,
                    letterSpacing: 7.2,
                    color: const Color(0xFFF5F0E8),
                  ),
                ),
              ),
            ),
            Center(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(24, 0, 24, 0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: const Color(0xFF1C1B1B),
                        borderRadius: BorderRadius.circular(9999),
                        boxShadow: const [
                          BoxShadow(
                            color: Color.fromRGBO(184, 150, 62, 0.15),
                            blurRadius: 40,
                          ),
                        ],
                      ),
                      child: SvgPicture.asset(
                        'assets/images/icon_forgot_mail.svg',
                        width: 26,
                        height: 20,
                        colorFilter: const ColorFilter.mode(Color(0xFFE8C265), BlendMode.srcIn),
                      ),
                    ),
                    const SizedBox(height: 32),
                    Text(
                      'Forgot Password?',
                      style: GoogleFonts.notoSerif(
                        fontSize: 36,
                        height: 40 / 36,
                        color: const Color(0xFFF5F0E8),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Opacity(
                      opacity: 0.7,
                      child: Text(
                        "Enter the email address associated with\nyour account, and we'll send you a\nsecure link to reset your password.",
                        textAlign: TextAlign.center,
                        style: GoogleFonts.notoSerif(
                          fontSize: 16,
                          height: 26 / 16,
                          color: const Color(0xFFF5F0E8),
                        ),
                      ),
                    ),
                    const SizedBox(height: 32),
                    _ResetFormCard(
                      controller: _email,
                      loading: _loading,
                      onSubmit: _submit,
                    ),
                    const SizedBox(height: 49),
                    GestureDetector(
                      onTap: () {
                        Navigator.of(context).pushReplacement(
                          MaterialPageRoute(builder: (_) => const LoginScreen()),
                        );
                      },
                      child: Text(
                        'RETURN TO SIGN IN',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 14,
                          height: 20 / 14,
                          letterSpacing: 1.4,
                          color: const Color(0xFFF5F0E8),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
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

class _ResetFormCard extends StatelessWidget {
  const _ResetFormCard({
    required this.controller,
    required this.loading,
    required this.onSubmit,
  });

  final TextEditingController controller;
  final bool loading;
  final VoidCallback onSubmit;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: const Color(0xFF2A2420),
        borderRadius: BorderRadius.circular(48),
        boxShadow: const [BoxShadow(color: Color.fromRGBO(0, 0, 0, 0.5), blurRadius: 40, offset: Offset(0, 10))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'EMAIL ADDRESS',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 12,
              height: 16 / 12,
              letterSpacing: 1.2,
              color: const Color(0xFFC4A882),
            ),
          ),
          const SizedBox(height: 8),
          TextField(
            controller: controller,
            keyboardType: TextInputType.emailAddress,
            style: GoogleFonts.notoSerif(fontSize: 18, color: const Color(0xFFF5F0E8)),
            decoration: const InputDecoration(
              hintText: 'your@email.com',
              hintStyle: TextStyle(color: Color.fromRGBO(245, 240, 232, 0.35)),
              border: UnderlineInputBorder(borderSide: BorderSide(color: Color(0xFF6B7280))),
              enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Color(0xFF6B7280))),
              focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Color(0xFFB8963E))),
            ),
          ),
          const SizedBox(height: 32),
          GestureDetector(
            onTap: loading ? null : onSubmit,
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 16),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: loading
                      ? const [Color(0xFF5A5A5A), Color(0xFF4A4A4A)]
                      : const [Color(0xFFB8963E), Color(0xFFC4A882)],
                ),
                borderRadius: BorderRadius.circular(9999),
              ),
              alignment: Alignment.center,
              child: loading
                  ? const SizedBox(width: 22, height: 22, child: CircularProgressIndicator(strokeWidth: 2))
                  : Text(
                      'SEND RESET LINK',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 14,
                        height: 20 / 14,
                        letterSpacing: 2.1,
                        color: const Color(0xFF2A2420),
                      ),
                    ),
            ),
          ),
          const SizedBox(height: 24),
          Opacity(
            opacity: 0.4,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SvgPicture.asset(
                  'assets/images/icon_secure.svg',
                  width: 17,
                  height: 12,
                  colorFilter: const ColorFilter.mode(Color(0xFFE5E2E1), BlendMode.srcIn),
                ),
                const SizedBox(width: 8),
                Text(
                  'SECURE CONNECTION',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 12,
                    height: 16 / 12,
                    letterSpacing: 0.6,
                    color: const Color(0xFFE5E2E1),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
