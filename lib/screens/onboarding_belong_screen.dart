import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';

import 'register_screen.dart';
import 'home_screen.dart';
import 'login_screen.dart';
import 'splash_screen.dart';

class OnboardingBelongScreen extends StatelessWidget {
  const OnboardingBelongScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF131313),
      body: Stack(
        fit: StackFit.expand,
        children: [
          Opacity(
            opacity: 0.4,
            child: Image.asset('assets/images/onb_belong_bg.png', fit: BoxFit.cover),
          ),
          const DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color.fromRGBO(19, 19, 19, 0.0),
                  Color.fromRGBO(19, 19, 19, 0.0),
                  Color(0xFF131313),
                ],
                stops: [0.0, 0.5, 1.0],
              ),
            ),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(32, 24, 32, 48),
              child: Column(
                children: [
                  const SizedBox(height: 0),
                  SvgPicture.asset('assets/images/icon_crown.svg', width: 52, height: 46),
                  const SizedBox(height: 72),
                  Text(
                    'Inner Circle',
                    style: GoogleFonts.notoSerif(
                      fontSize: 48,
                      height: 60 / 48,
                      letterSpacing: -1.2,
                      color: const Color(0xFFE5E2E1),
                    ),
                    textAlign: TextAlign.center,
                  ),
                  Text(
                    'Belonging',
                    style: GoogleFonts.notoSerif(
                      fontSize: 48,
                      height: 60 / 48,
                      letterSpacing: -1.2,
                      fontStyle: FontStyle.italic,
                      color: const Color(0xFFE5E2E1),
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Step into an exclusive community where digital\ncraftsmanship meets the timeless elegance of\nthe traditional atelier.',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.manrope(
                      fontSize: 14,
                      height: 22.75 / 14,
                      letterSpacing: 0.35,
                      color: const Color.fromRGBO(231, 226, 217, 0.7),
                    ),
                  ),
                  const Spacer(),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
                      child: Container(
                        padding: const EdgeInsets.all(33),
                        decoration: BoxDecoration(
                          color: const Color.fromRGBO(53, 53, 52, 0.6),
                          border: Border.all(color: const Color.fromRGBO(78, 70, 57, 0.1), width: 1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Column(
                          children: [
                            _PillButton(
                              label: 'CREATE MY ACCOUNT',
                              filled: true,
                              onTap: () {
                                Navigator.of(context).pushReplacement(
                                  MaterialPageRoute(builder: (_) => const RegisterScreen()),
                                );
                              },
                            ),
                            const SizedBox(height: 16),
                            _PillButton(
                              label: 'SIGN IN',
                              filled: false,
                              onTap: () {
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
                                'BROWSE THE STORE',
                                style: GoogleFonts.manrope(
                                  fontSize: 12,
                                  letterSpacing: 1.2,
                                  color: const Color(0xFFB5983C),
                                  decoration: TextDecoration.underline,
                                ),
                              ),
                            ),
                            const SizedBox(height: 24),
                            Opacity(
                              opacity: 0.4,
                              child: Text(
                                'BY CONTINUING, YOU AGREE TO OUR TERMS OF\nSERVICE',
                                textAlign: TextAlign.center,
                                style: GoogleFonts.manrope(
                                  fontSize: 10,
                                  height: 15 / 10,
                                  letterSpacing: 0.5,
                                  color: const Color(0xFFCBC6BE),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 48),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SvgPicture.asset(
                        'assets/images/icon_dot_small.svg',
                        width: 5,
                        height: 5,
                        colorFilter: const ColorFilter.mode(Color(0xFF494740), BlendMode.srcIn),
                      ),
                      const SizedBox(width: 16),
                      SvgPicture.asset(
                        'assets/images/icon_dot_small.svg',
                        width: 5,
                        height: 5,
                        colorFilter: const ColorFilter.mode(Color(0xFF494740), BlendMode.srcIn),
                      ),
                      const SizedBox(width: 16),
                      SvgPicture.asset(
                        'assets/images/icon_dot_big.svg',
                        width: 6,
                        height: 6,
                        colorFilter: const ColorFilter.mode(Color(0xFFE9C349), BlendMode.srcIn),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          SafeArea(
            child: Align(
              alignment: Alignment.topCenter,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(24, 16, 24, 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      onPressed: () => Navigator.of(context).maybePop(),
                      icon: SvgPicture.asset(
                        'assets/images/icon_onb_belong_close.svg',
                        width: 12.62,
                        height: 12.62,
                        colorFilter: const ColorFilter.mode(Color(0xFFE9C349), BlendMode.srcIn),
                      ),
                    ),
                    Text(
                      'ATELIER',
                      style: GoogleFonts.libreBaskerville(
                        fontSize: 20,
                        height: 28 / 20,
                        letterSpacing: 2,
                        color: const Color(0xFFE9C349),
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pushReplacement(
                          MaterialPageRoute(builder: (_) => const SplashScreen()),
                        );
                      },
                      child: Text(
                        'SKIP',
                        style: GoogleFonts.manrope(
                          fontSize: 12,
                          height: 16 / 12,
                          letterSpacing: 2.4,
                          color: const Color(0xFFB5983C),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _PillButton extends StatelessWidget {
  const _PillButton({required this.label, required this.filled, required this.onTap});
  final String label;
  final bool filled;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          gradient: filled
              ? const LinearGradient(colors: [Color(0xFFE9C349), Color(0xFFC5A12A)])
              : null,
          border: filled ? null : Border.all(color: const Color.fromRGBO(78, 70, 57, 0.3), width: 1),
          borderRadius: BorderRadius.circular(9999),
          boxShadow: filled
              ? const [
                  BoxShadow(color: Color.fromRGBO(233, 195, 73, 0.1), blurRadius: 25, offset: Offset(0, 20)),
                  BoxShadow(color: Color.fromRGBO(233, 195, 73, 0.1), blurRadius: 10, offset: Offset(0, 8)),
                ]
              : null,
        ),
        alignment: Alignment.center,
        child: Text(
          label,
          style: GoogleFonts.manrope(
            fontSize: 14,
            height: 20 / 14,
            letterSpacing: 1.4,
            fontWeight: FontWeight.w700,
            color: filled ? const Color(0xFF3C2F00) : const Color(0xFFE5E2E1),
          ),
        ),
      ),
    );
  }
}
