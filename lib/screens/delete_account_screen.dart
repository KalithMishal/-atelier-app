import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';

class DeleteAccountScreen extends StatelessWidget {
  const DeleteAccountScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF080808),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(24, 24, 24, 32),
          child: Column(
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: IconButton(
                  onPressed: () => Navigator.of(context).maybePop(),
                  icon: SvgPicture.asset(
                    'assets/images/icon_delete_back.svg',
                    width: 12.5,
                    height: 12.5,
                    colorFilter: const ColorFilter.mode(Color(0xFFD0C5B2), BlendMode.srcIn),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              SvgPicture.asset(
                'assets/images/icon_heart_break.svg',
                width: 60,
                height: 57,
                colorFilter: const ColorFilter.mode(Color(0xFFE8C265), BlendMode.srcIn),
              ),
              const SizedBox(height: 32),
              Text(
                'Delete Your\nAccount',
                textAlign: TextAlign.center,
                style: GoogleFonts.notoSerif(
                  fontSize: 36,
                  height: 40 / 36,
                  letterSpacing: 0.9,
                  color: const Color(0xFFF5F0E8),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'This action is permanent and cannot be undone. All\nyour curated collections, preferences, and order\nhistory will be lost forever.',
                textAlign: TextAlign.center,
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 14,
                  height: 22.75 / 14,
                  color: const Color(0xFFD0C5B2),
                ),
              ),
              const SizedBox(height: 24),
              _WarningCard(),
              const SizedBox(height: 24),
              Text.rich(
                TextSpan(
                  children: [
                    TextSpan(
                      text: 'TYPE ',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 12,
                        height: 16 / 12,
                        letterSpacing: 1.2,
                        color: const Color(0xFFD0C5B2),
                      ),
                    ),
                    TextSpan(
                      text: 'DELETE',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 12,
                        height: 16 / 12,
                        letterSpacing: 1.2,
                        color: const Color(0xFFFFB4AB),
                      ),
                    ),
                    TextSpan(
                      text: ' TO CONFIRM',
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
              const SizedBox(height: 16),
              Container(
                height: 45,
                width: 320,
                decoration: const BoxDecoration(
                  border: Border(bottom: BorderSide(color: Color.fromRGBO(184, 150, 62, 0.3), width: 1)),
                ),
              ),
              const SizedBox(height: 32),
              _PrimaryButton(label: 'KEEP MY ACCOUNT', onTap: () {}),
              const SizedBox(height: 16),
              _DangerButton(label: 'PERMANENTLY DELETE', onTap: () {}),
              const SizedBox(height: 64),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SvgPicture.asset(
                    'assets/images/icon_concierge.svg',
                    width: 12,
                    height: 10.5,
                    colorFilter: const ColorFilter.mode(Color(0xFFD0C5B2), BlendMode.srcIn),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'CONTACT CONCIERGE BEFORE LEAVING',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 12,
                      height: 16 / 12,
                      letterSpacing: 1.2,
                      color: const Color(0xFFD0C5B2),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _WarningCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.fromLTRB(34, 32, 32, 32),
          decoration: BoxDecoration(
            color: const Color(0xFF2A2420),
            borderRadius: BorderRadius.circular(16),
            border: const Border(left: BorderSide(color: Color(0xFFB8963E), width: 2)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  SvgPicture.asset(
                    'assets/images/icon_warning_triangle.svg',
                    width: 13,
                    height: 11,
                    colorFilter: const ColorFilter.mode(Color(0xFFE8C265), BlendMode.srcIn),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    'YOU WILL LOSE ACCESS TO',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 14,
                      height: 20 / 14,
                      letterSpacing: 1.4,
                      color: const Color(0xFFF5F0E8),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              _LossItem(icon: 'assets/images/icon_loss_1.svg', text: 'Exclusive early access to seasonal\ncollections and limited drops.'),
              const SizedBox(height: 16),
              _LossItem(icon: 'assets/images/icon_loss_2.svg', text: 'Your complete purchase history and\ndigital receipts.'),
              const SizedBox(height: 16),
              _LossItem(icon: 'assets/images/icon_loss_3.svg', text: 'Personalized styling\nrecommendations and concierge\nhistory.'),
            ],
          ),
        ),
        Positioned(
          top: 0,
          right: 0,
          child: Container(
            width: 128,
            height: 128,
            decoration: BoxDecoration(
              color: const Color.fromRGBO(184, 150, 62, 0.05),
              borderRadius: BorderRadius.circular(9999),
            ),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 32, sigmaY: 32),
              child: const SizedBox(),
            ),
          ),
        ),
      ],
    );
  }
}

class _LossItem extends StatelessWidget {
  const _LossItem({required this.icon, required this.text});
  final String icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SvgPicture.asset(
          icon,
          width: 16,
          height: 16,
          colorFilter: const ColorFilter.mode(Color(0xFFE8C265), BlendMode.srcIn),
        ),
        const SizedBox(width: 16),
        Text(
          text,
          style: GoogleFonts.plusJakartaSans(
            fontSize: 14,
            height: 20 / 14,
            color: const Color(0xFFD0C5B2),
          ),
        ),
      ],
    );
  }
}

class _PrimaryButton extends StatelessWidget {
  const _PrimaryButton({required this.label, required this.onTap});
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          gradient: const LinearGradient(colors: [Color(0xFFB8963E), Color(0xFFC4A882)]),
          borderRadius: BorderRadius.circular(9999),
          boxShadow: const [BoxShadow(color: Color.fromRGBO(184, 150, 62, 0.15), blurRadius: 30)],
        ),
        alignment: Alignment.center,
        child: Text(
          label,
          style: GoogleFonts.plusJakartaSans(
            fontSize: 14,
            height: 20 / 14,
            letterSpacing: 2.8,
            color: const Color(0xFF2A2420),
          ),
        ),
      ),
    );
  }
}

class _DangerButton extends StatelessWidget {
  const _DangerButton({required this.label, required this.onTap});
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 17),
        decoration: BoxDecoration(
          color: const Color(0xFF201F1F),
          borderRadius: BorderRadius.circular(9999),
          border: Border.all(color: const Color.fromRGBO(255, 180, 171, 0.2), width: 1),
        ),
        alignment: Alignment.center,
        child: Text(
          label,
          style: GoogleFonts.plusJakartaSans(
            fontSize: 14,
            height: 20 / 14,
            letterSpacing: 2.8,
            color: const Color.fromRGBO(255, 180, 171, 0.5),
          ),
        ),
      ),
    );
  }
}

