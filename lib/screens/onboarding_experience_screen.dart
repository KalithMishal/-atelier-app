import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';

import 'splash_screen.dart';
import 'onboarding_belong_screen.dart';

class OnboardingExperienceScreen extends StatelessWidget {
  const OnboardingExperienceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF131313),
      body: Stack(
        fit: StackFit.expand,
        children: [
          Align(
            alignment: Alignment.topRight,
            child: Opacity(
              opacity: 0.4,
              child: SizedBox(
                width: 292.5,
                height: 618,
                child: Image.asset('assets/images/onb_experience_bg.png', fit: BoxFit.cover),
              ),
            ),
          ),
          const DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.centerRight,
                end: Alignment.centerLeft,
                colors: [Color.fromRGBO(19, 19, 19, 0.0), Color(0xFF131313)],
              ),
            ),
          ),
          const DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Color.fromRGBO(19, 19, 19, 0.0), Color(0xFF131313)],
              ),
            ),
          ),
          SafeArea(
            child: LayoutBuilder(
              builder: (context, constraints) {
                return SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(32, 249, 32, 128),
                    child: ConstrainedBox(
                      constraints: BoxConstraints(minHeight: constraints.maxHeight - 249 - 128),
                      child: IntrinsicHeight(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SvgPicture.asset(
                              'assets/images/icon_diamond.svg',
                              width: 36.9,
                              height: 32.65,
                              colorFilter: const ColorFilter.mode(Color(0xFFE9C349), BlendMode.srcIn),
                            ),
                            const SizedBox(height: 24),
                            Text(
                              'White Glove',
                              style: GoogleFonts.notoSerif(
                                fontSize: 48,
                                height: 60 / 48,
                                color: const Color(0xFFE5E2E1),
                              ),
                            ),
                            Text(
                              'Experience',
                              style: GoogleFonts.notoSerif(
                                fontSize: 48,
                                height: 60 / 48,
                                color: const Color(0xFFE5E2E1),
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                            const SizedBox(height: 16),
                            Opacity(
                              opacity: 0.8,
                              child: Text(
                                'Tailored to your singular taste, our\nconsultants curate a journey as unique\nas your personal legacy. Precision in\nevery stitch, excellence in every detail.',
                                style: GoogleFonts.manrope(
                                  fontSize: 18,
                                  height: 29.25 / 18,
                                  color: const Color(0xFFD1C5B4),
                                ),
                              ),
                            ),
                            const Spacer(),
                            _PrimaryCTA(
                              label: 'NEXT →',
                              onPressed: () {
                                Navigator.of(context).pushReplacement(
                                  MaterialPageRoute(builder: (_) => const OnboardingBelongScreen()),
                                );
                              },
                            ),
                            const SizedBox(height: 48),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: const [
                                _SmallDot(active: false),
                                SizedBox(width: 16),
                                _BigDot(active: true),
                                SizedBox(width: 16),
                                _SmallDot(active: false),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
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
                        'assets/images/icon_onb_close_alt.svg',
                        width: 12.62,
                        height: 12.62,
                        colorFilter: const ColorFilter.mode(Color(0xFFE9C349), BlendMode.srcIn),
                      ),
                    ),
                    Text(
                      'THE ATELIER',
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
          gradient: const LinearGradient(colors: [Color(0xFFE9C349), Color(0xFFC5A12A)]),
          borderRadius: BorderRadius.circular(12),
          boxShadow: const [BoxShadow(color: Color.fromRGBO(0, 0, 0, 0.25), blurRadius: 50, offset: Offset(0, 25))],
        ),
        alignment: Alignment.center,
        child: Text(
          label,
          style: GoogleFonts.manrope(
            fontSize: 14,
            height: 20 / 14,
            letterSpacing: 2.1,
            color: const Color(0xFF3C2F00),
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }
}

class _SmallDot extends StatelessWidget {
  const _SmallDot({required this.active});
  final bool active;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 6,
      height: 6,
      decoration: BoxDecoration(
        color: const Color(0xFF494740).withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(12),
      ),
    );
  }
}

class _BigDot extends StatelessWidget {
  const _BigDot({required this.active});
  final bool active;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 10,
      height: 10,
      decoration: BoxDecoration(
        color: const Color(0xFFE9C349),
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [BoxShadow(color: Color.fromRGBO(233, 195, 73, 0.6), blurRadius: 12)],
      ),
    );
  }
}

