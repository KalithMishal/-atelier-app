import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';

import 'reset_password_success_screen.dart';

class ResetPasswordScreen extends StatefulWidget {
  const ResetPasswordScreen({super.key});

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  bool _obscure1 = true;
  bool _obscure2 = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF131313),
      body: SafeArea(
        child: Stack(
          children: [
            Positioned(
              left: -80,
              top: -80,
              child: Container(
                width: 280,
                height: 280,
                decoration: BoxDecoration(
                  color: const Color.fromRGBO(184, 150, 62, 0.1),
                  borderRadius: BorderRadius.circular(9999),
                ),
              ),
            ),
            Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'ATELIER',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 12,
                        height: 16 / 12,
                        letterSpacing: 3.6,
                        color: const Color(0xFFD0C5B2),
                      ),
                    ),
                    const SizedBox(height: 24),
                    SvgPicture.asset(
                      'assets/images/icon_key.svg',
                      width: 42,
                      height: 20,
                      colorFilter: const ColorFilter.mode(Color(0xFFE8C265), BlendMode.srcIn),
                    ),
                    const SizedBox(height: 48),
                    Text(
                      'Create New Password',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.notoSerif(
                        fontSize: 30,
                        height: 36 / 30,
                        letterSpacing: 0.75,
                        color: const Color(0xFFE5E2E1),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Enter your new secure password below.',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 14,
                        height: 20 / 14,
                        letterSpacing: 0.35,
                        color: const Color.fromRGBO(208, 197, 178, 0.7),
                      ),
                    ),
                    const SizedBox(height: 48),
                    _PasswordPill(
                      label: 'NEW PASSWORD',
                      obscure: _obscure1,
                      onToggle: () => setState(() => _obscure1 = !_obscure1),
                      showStrength: true,
                    ),
                    const SizedBox(height: 24),
                    _PasswordPill(
                      label: 'CONFIRM PASSWORD',
                      obscure: _obscure2,
                      onToggle: () => setState(() => _obscure2 = !_obscure2),
                      showStrength: false,
                    ),
                    const SizedBox(height: 24),
                    _RuleRow(
                      iconAsset: 'assets/images/icon_rule_ok.svg',
                      text: 'At least 8 characters long',
                      active: true,
                    ),
                    const SizedBox(height: 8),
                    _RuleRow(
                      iconAsset: 'assets/images/icon_rule_ok.svg',
                      text: 'Contains a number or symbol',
                      active: true,
                    ),
                    const SizedBox(height: 8),
                    _RuleRow(
                      iconAsset: 'assets/images/icon_rule_off.svg',
                      text: 'Contains an uppercase letter',
                      active: false,
                    ),
                    const SizedBox(height: 48),
                    GestureDetector(
                      onTap: () {
                        Navigator.of(context).pushReplacement(
                          MaterialPageRoute(builder: (_) => const ResetPasswordSuccessScreen()),
                        );
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SvgPicture.asset(
                            'assets/images/icon_back.svg',
                            width: 10,
                            height: 10,
                            colorFilter: const ColorFilter.mode(Color(0xFFD0C5B2), BlendMode.srcIn),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'UPDATE PASSWORD',
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 12,
                              height: 16 / 12,
                              letterSpacing: 1.2,
                              color: const Color(0xFFD0C5B2),
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
      ),
    );
  }
}

class _PasswordPill extends StatelessWidget {
  const _PasswordPill({
    required this.label,
    required this.obscure,
    required this.onToggle,
    required this.showStrength,
  });

  final String label;
  final bool obscure;
  final VoidCallback onToggle;
  final bool showStrength;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF2A2420),
        borderRadius: BorderRadius.circular(48),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 10,
              height: 15 / 10,
              letterSpacing: 0.5,
              color: const Color(0xFFD0C5B2),
            ),
          ),
          const SizedBox(height: 4),
          Row(
            children: [
              Expanded(
                child: Text(
                  obscure ? '••••••••' : 'password',
                  style: GoogleFonts.notoSerif(
                    fontSize: 18,
                    color: const Color.fromRGBO(208, 197, 178, 0.3),
                  ),
                ),
              ),
              GestureDetector(
                onTap: onToggle,
                child: SvgPicture.asset(
                  'assets/images/icon_eye_small.svg',
                  width: 16,
                  height: 14,
                  colorFilter: const ColorFilter.mode(Color(0xFFD0C5B2), BlendMode.srcIn),
                ),
              ),
            ],
          ),
          if (showStrength) ...[
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(child: _StrengthSeg(active: true)),
                const SizedBox(width: 4),
                Expanded(child: _StrengthSeg(active: true)),
                const SizedBox(width: 4),
                Expanded(child: _StrengthSeg(active: true, dim: true)),
                const SizedBox(width: 4),
                Expanded(child: _StrengthSeg(active: false)),
              ],
            ),
          ],
        ],
      ),
    );
  }
}

class _StrengthSeg extends StatelessWidget {
  const _StrengthSeg({required this.active, this.dim = false});
  final bool active;
  final bool dim;

  @override
  Widget build(BuildContext context) {
    final c = active
        ? (dim ? const Color.fromRGBO(232, 194, 101, 0.3) : const Color(0xFFE8C265))
        : const Color(0xFF353534);
    return Container(height: 16, decoration: BoxDecoration(color: c, borderRadius: BorderRadius.circular(9999)));
  }
}

class _RuleRow extends StatelessWidget {
  const _RuleRow({required this.iconAsset, required this.text, required this.active});

  final String iconAsset;
  final String text;
  final bool active;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SvgPicture.asset(
          iconAsset,
          width: 13,
          height: 13,
          colorFilter: ColorFilter.mode(
            active ? const Color(0xFFE8C265) : const Color.fromRGBO(208, 197, 178, 0.5),
            BlendMode.srcIn,
          ),
        ),
        const SizedBox(width: 12),
        Text(
          text,
          style: GoogleFonts.plusJakartaSans(
            fontSize: 14,
            height: 20 / 14,
            letterSpacing: 0.35,
            color: active ? const Color(0xFFD0C5B2) : const Color.fromRGBO(208, 197, 178, 0.5),
          ),
        ),
      ],
    );
  }
}

