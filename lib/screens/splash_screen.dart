import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'home_screen.dart';
import 'login_screen.dart';
import 'onboarding_discover_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  static const _bg = Color(0xFF131313);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _completeWebGoogleRedirect());
  }

  /// After [AuthRepository.signInWithGoogle] uses redirect on web, Firebase returns here;
  /// [getRedirectResult] attaches the Google account to the session.
  Future<void> _completeWebGoogleRedirect() async {
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
      debugPrint('SplashScreen getRedirectResult: $e\n$st');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: SplashScreen._bg,
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            'assets/images/splash_bg.png',
            fit: BoxFit.cover,
          ),
          const DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color.fromRGBO(19, 19, 19, 0.2),
                  Color.fromRGBO(19, 19, 19, 0.7),
                  Color(0xFF131313),
                ],
                stops: [0.0, 0.5, 1.0],
              ),
            ),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 96),
                    child: Column(
                      children: [
                        Text(
                          'ATELIER',
                          style: GoogleFonts.bodoniModa(
                            fontSize: 32,
                            height: 48 / 32,
                            letterSpacing: 9.6,
                            color: const Color(0xFFE5E2E1),
                          ),
                        ),
                        const SizedBox(height: 24),
                        Container(height: 1, width: 80, color: const Color.fromRGBO(184, 150, 62, 0.8)),
                        const SizedBox(height: 24),
                        Text(
                          'Crafted for the Extraordinary',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.cormorantGaramond(
                            fontSize: 20,
                            height: 28 / 20,
                            letterSpacing: 0.5,
                            fontStyle: FontStyle.italic,
                            fontWeight: FontWeight.w300,
                            color: const Color(0xFFD0C5B2),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 64),
                    child: Column(
                      children: [
                        _PrimaryButton(
                          label: 'BEGIN YOUR JOURNEY',
                          onPressed: () {
                            Navigator.of(context).pushReplacement(
                              MaterialPageRoute(builder: (_) => const OnboardingDiscoverScreen()),
                            );
                          },
                        ),
                        const SizedBox(height: 16),
                        _SecondaryButton(
                          label: 'I ALREADY HAVE AN ACCOUNT',
                          onPressed: () {
                            Navigator.of(context).pushReplacement(
                              MaterialPageRoute(builder: (_) => const LoginScreen()),
                            );
                          },
                        ),
                        const SizedBox(height: 12),
                        GestureDetector(
                          onTap: () {
                            Navigator.of(context).pushReplacement(
                              MaterialPageRoute(builder: (_) => const HomeScreen()),
                            );
                          },
                          child: Text(
                            'BROWSE AS GUEST',
                            style: GoogleFonts.poppins(
                              fontSize: 12,
                              letterSpacing: 1.4,
                              fontWeight: FontWeight.w500,
                              color: const Color(0xFF8A8278),
                              decoration: TextDecoration.underline,
                              decorationColor: Color.fromRGBO(138, 130, 120, 0.6),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _PrimaryButton extends StatelessWidget {
  const _PrimaryButton({required this.label, required this.onPressed});
  final String label;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        height: 56,
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: const LinearGradient(colors: [Color(0xFFB8963E), Color(0xFFC4A882)]),
          borderRadius: BorderRadius.circular(9999),
        ),
        alignment: Alignment.center,
        child: Text(
          label,
          style: GoogleFonts.poppins(
            fontSize: 12,
            height: 18 / 12,
            letterSpacing: 1.2,
            fontWeight: FontWeight.w500,
            color: const Color(0xFF3E2E00),
          ),
        ),
      ),
    );
  }
}

class _SecondaryButton extends StatelessWidget {
  const _SecondaryButton({required this.label, required this.onPressed});
  final String label;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        height: 56,
        width: double.infinity,
        decoration: BoxDecoration(
          border: Border.all(color: const Color.fromRGBO(184, 150, 62, 0.4), width: 1),
          borderRadius: BorderRadius.circular(9999),
        ),
        alignment: Alignment.center,
        child: Text(
          label,
          textAlign: TextAlign.center,
          style: GoogleFonts.poppins(
            fontSize: 12,
            height: 18 / 12,
            letterSpacing: 1.2,
            fontWeight: FontWeight.w500,
            color: const Color(0xFFE5E2E1),
          ),
        ),
      ),
    );
  }
}
