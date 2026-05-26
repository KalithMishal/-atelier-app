import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';

import 'splash_screen.dart';
import 'onboarding_experience_screen.dart';

class OnboardingDiscoverScreen extends StatelessWidget {
  const OnboardingDiscoverScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF131313),
      body: Stack(
        fit: StackFit.expand,
        children: [
          Opacity(
            opacity: 0.6,
            child: Image.asset('assets/images/onb_discover_bg.png', fit: BoxFit.cover),
          ),
          const DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color.fromRGBO(19, 19, 19, 0.0),
                  Color.fromRGBO(19, 19, 19, 0.4),
                  Color(0xFF131313),
                ],
                stops: [0.0, 0.5, 1.0],
              ),
            ),
          ),
          SafeArea(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(24, 16, 24, 0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        onPressed: () => Navigator.of(context).maybePop(),
                        icon: SvgPicture.asset(
                          'assets/images/icon_onb_close.svg',
                          width: 12.62,
                          height: 12.62,
                          colorFilter: const ColorFilter.mode(Color(0xFFE9C349), BlendMode.srcIn),
                        ),
                      ),
                      Text(
                        'THE ATELIER',
                        style: GoogleFonts.notoSerif(
                          fontSize: 20,
                          height: 28 / 20,
                          letterSpacing: 2,
                          color: const Color(0xFFE9C349),
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
                            fontSize: 14,
                            height: 20 / 14,
                            letterSpacing: 2.8,
                            color: const Color(0xFFE9C349),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const Spacer(),
                Padding(
                  padding: const EdgeInsets.fromLTRB(32, 0, 32, 48),
                  child: Column(
                    children: [
                      SvgPicture.asset('assets/images/icon_onb_anchor.svg', width: 86, height: 78),
                      const SizedBox(height: 48),
                      Text(
                        'Discover\nRare Pieces',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.notoSerif(
                          fontSize: 48,
                          height: 52.8 / 48,
                          letterSpacing: -1.2,
                          color: const Color(0xFFE5E2E1),
                        ),
                      ),
                      const SizedBox(height: 24),
                      Text(
                        'Step into a world where digital\ncraftsmanship meets the timeless allure of\nthe heritage atelier.',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.manrope(
                          fontSize: 16,
                          height: 26 / 16,
                          color: const Color(0xFFD1C5B4),
                        ),
                      ),
                      const SizedBox(height: 48),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          _Dot(active: true),
                          SizedBox(width: 16),
                          _Dot(active: false),
                          SizedBox(width: 16),
                          _Dot(active: false),
                        ],
                      ),
                      const SizedBox(height: 48),
                      _PrimaryCTA(
                        label: 'NEXT',
                        onPressed: () {
                          Navigator.of(context).pushReplacement(
                            MaterialPageRoute(builder: (_) => const OnboardingExperienceScreen()),
                          );
                        },
                      ),
                    ],
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

class _PrimaryCTA extends StatelessWidget {
  const _PrimaryCTA({required this.label, required this.onPressed});
  final String label;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 20),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFFE9C349), Color(0xFFC5A12A)],
          ),
          borderRadius: BorderRadius.circular(12),
          boxShadow: const [BoxShadow(color: Color.fromRGBO(14, 14, 14, 0.4), blurRadius: 40, offset: Offset(0, 20))],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              label,
              style: GoogleFonts.manrope(
                fontSize: 14,
                height: 20 / 14,
                letterSpacing: 1.4,
                fontWeight: FontWeight.w700,
                color: const Color(0xFF3C2F00),
              ),
            ),
            const SizedBox(width: 8),
            SvgPicture.asset(
              'assets/images/icon_onb_next_arrow.svg',
              width: 10.5,
              height: 10.5,
              colorFilter: const ColorFilter.mode(Color(0xFF3C2F00), BlendMode.srcIn),
            ),
          ],
        ),
      ),
    );
  }
}

class _Dot extends StatelessWidget {
  const _Dot({required this.active});
  final bool active;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 10,
      height: 10,
      decoration: BoxDecoration(
        color: active ? const Color(0xFFE9C349) : const Color.fromRGBO(73, 71, 64, 0.5),
        borderRadius: BorderRadius.circular(12),
        boxShadow: active ? const [BoxShadow(color: Color.fromRGBO(233, 195, 73, 0.5), blurRadius: 10)] : null,
      ),
    );
  }
}

