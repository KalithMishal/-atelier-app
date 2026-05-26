import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'login_screen.dart';

class ForgotPasswordSuccessScreen extends StatelessWidget {
  const ForgotPasswordSuccessScreen({super.key, required this.email});

  /// Email the user asked to reset (for confirmation copy only).
  final String email;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF080808),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('ATELIER', style: GoogleFonts.notoSerif(fontSize: 24, letterSpacing: 7.2, color: const Color(0xFFF5F0E8))),
              const SizedBox(height: 24),
              Text(
                'Reset link sent',
                style: GoogleFonts.notoSerif(fontSize: 30, height: 36 / 30, color: const Color(0xFFE5E2E1)),
              ),
              const SizedBox(height: 12),
              Text(
                email,
                textAlign: TextAlign.center,
                style: GoogleFonts.manrope(fontSize: 14, height: 20 / 14, fontWeight: FontWeight.w600, color: const Color(0xFFE9C349)),
              ),
              const SizedBox(height: 16),
              Text(
                'If an account exists for this address, Firebase has sent a reset message.\n\n'
                '• Check your spam / junk folder.\n'
                '• Use the exact email you registered with (including Google sign-in if you never set a password).\n'
                '• If nothing arrives after several minutes, you may need to register first, or sign in with Google.',
                textAlign: TextAlign.center,
                style: GoogleFonts.manrope(fontSize: 14, height: 22 / 14, color: const Color(0xFF9A8F80)),
              ),
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFE9C349),
                    foregroundColor: const Color(0xFF131313),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  onPressed: () {
                    Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(builder: (_) => const LoginScreen()),
                      (route) => false,
                    );
                  },
                  child: Text('RETURN TO SIGN IN', style: GoogleFonts.manrope(letterSpacing: 1.2)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
