import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';

import 'checkout_payment_screen.dart';

class CheckoutDeliveryScreen extends StatelessWidget {
  const CheckoutDeliveryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF131313),
      body: SafeArea(
        bottom: false,
        child: Stack(
          children: [
            Column(
              children: [
                _TopBar(onBack: () => Navigator.of(context).maybePop()),
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.fromLTRB(16, 32, 16, 160),
                    child: Center(
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 768),
                        child: Column(
                          children: const [
                            _ProgressIndicatorRow(active: 0),
                            SizedBox(height: 40),
                            _Headline(),
                            SizedBox(height: 40),
                            _FormCard(),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: ClipRect(
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
                  child: Container(
                    padding: const EdgeInsets.fromLTRB(16, 17, 16, 16),
                    decoration: const BoxDecoration(
                      color: Color.fromRGBO(19, 19, 19, 0.95),
                      border: Border(top: BorderSide(color: Color.fromRGBO(78, 70, 57, 0.2), width: 1)),
                    ),
                    child: Center(
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 448),
                        child: GestureDetector(
                          onTap: () {
                            Navigator.of(context).push(MaterialPageRoute(builder: (_) => const CheckoutPaymentScreen()));
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              gradient: const LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: [Color(0xFFD4AF37), Color(0xFFF1D37E), Color(0xFFB8860B)],
                              ),
                              boxShadow: const [BoxShadow(color: Color.fromRGBO(212, 175, 55, 0.4), blurRadius: 20, offset: Offset(0, 4))],
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'CONTINUE TO PAYMENT',
                                  style: GoogleFonts.manrope(
                                    fontSize: 14,
                                    height: 20 / 14,
                                    letterSpacing: 0.7,
                                    fontWeight: FontWeight.w600,
                                    color: const Color(0xFF1A1A1A),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                SvgPicture.asset('assets/images/icon_cta_arrow.svg', width: 9.9, height: 9.9),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TopBar extends StatelessWidget {
  const _TopBar({required this.onBack});
  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(24, 16, 48, 17),
      decoration: const BoxDecoration(
        color: Color(0xFF131313),
        border: Border(bottom: BorderSide(color: Color.fromRGBO(78, 70, 57, 0.2), width: 1)),
      ),
      child: Row(
        children: [
          GestureDetector(
            onTap: onBack,
            child: SvgPicture.asset('assets/images/icon_checkout_back.svg', width: 14, height: 14),
          ),
          const Spacer(),
          Text(
            'CHECKOUT',
            style: GoogleFonts.notoSerif(
              fontSize: 18,
              height: 28 / 18,
              letterSpacing: 1.8,
              color: const Color(0xFFE9C349),
            ),
          ),
          const Spacer(),
        ],
      ),
    );
  }
}

class _ProgressIndicatorRow extends StatelessWidget {
  const _ProgressIndicatorRow({required this.active});
  final int active;

  @override
  Widget build(BuildContext context) {
    Color labelColor(int index) => index == active ? const Color(0xFFE9C349) : const Color(0xFFE5E2E1);
    double labelOpacity(int index) => index == active ? 1 : 0.5;
    Color dotColor(int index) => index == active ? const Color(0xFFE9C349) : const Color(0xFF494740);
    double dotOpacity(int index) => index == active ? 1 : 0.5;

    Widget dot(int index) {
      final isActive = index == active;
      return Container(
        width: 8,
        height: 8,
        decoration: BoxDecoration(
          color: dotColor(index).withValues(alpha: dotOpacity(index)),
          borderRadius: BorderRadius.circular(12),
          boxShadow: isActive ? const [BoxShadow(color: Color.fromRGBO(233, 195, 73, 0.5), blurRadius: 8)] : null,
        ),
      );
    }

    Widget divider() => Container(width: 48, height: 1, color: const Color(0xFF4E4639).withValues(alpha: 0.5));

    Widget step(String text, int index) {
      return Column(
        children: [
          dot(index),
          const SizedBox(height: 8),
          Opacity(
            opacity: labelOpacity(index),
            child: Text(
              text,
              style: GoogleFonts.manrope(fontSize: 10, height: 15 / 10, letterSpacing: 1.0, color: labelColor(index)),
            ),
          ),
        ],
      );
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        step('DELIVERY', 0),
        const SizedBox(width: 16),
        divider(),
        const SizedBox(width: 16),
        step('PAYMENT', 1),
        const SizedBox(width: 16),
        divider(),
        const SizedBox(width: 16),
        step('REVIEW', 2),
      ],
    );
  }
}

class _Headline extends StatelessWidget {
  const _Headline();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          'Shipping Details',
          style: GoogleFonts.notoSerif(fontSize: 30, height: 36 / 30, letterSpacing: -0.75, color: const Color(0xFFE5E2E1)),
        ),
        const SizedBox(height: 8),
        Text(
          'Where should we deliver your selection?',
          textAlign: TextAlign.center,
          style: GoogleFonts.manrope(fontSize: 14, height: 20 / 14, color: const Color.fromRGBO(229, 226, 225, 0.7)),
        ),
      ],
    );
  }
}

class _FormCard extends StatelessWidget {
  const _FormCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(25, 25, 25, 41),
      decoration: BoxDecoration(
        color: const Color(0xFF1C1B1B),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color.fromRGBO(78, 70, 57, 0.2)),
        boxShadow: const [BoxShadow(color: Color.fromRGBO(14, 14, 14, 0.4), blurRadius: 40, offset: Offset(0, 20))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          _SectionTitle('CONTACT INFO'),
          SizedBox(height: 16),
          _InputField(label: 'First Name', value: 'Jane'),
          SizedBox(height: 24),
          _InputField(label: 'Last Name', value: 'Doe'),
          SizedBox(height: 24),
          _InputField(label: 'Email Address', value: 'jane.doe@example.com'),
          SizedBox(height: 24),
          _InputField(label: 'Phone Number', value: '+1 (555) 000-0000'),
          SizedBox(height: 40),
          _SectionTitle('DELIVERY ADDRESS'),
          SizedBox(height: 16),
          _InputField(label: 'Street Address', value: '123 Luxury Lane'),
          SizedBox(height: 24),
          _InputField(label: 'Apt, Suite, Unit (Optional)', value: 'Penthouse B'),
          SizedBox(height: 24),
          Row(
            children: [
              Expanded(child: _InputField(label: 'City', value: 'New York')),
              SizedBox(width: 24),
              Expanded(child: _InputField(label: 'Postal Code', value: '10001')),
            ],
          ),
          SizedBox(height: 24),
          _CountrySelect(),
        ],
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle(this.text);
  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(bottom: 9),
      decoration: const BoxDecoration(border: Border(bottom: BorderSide(color: Color.fromRGBO(78, 70, 57, 0.2), width: 1))),
      child: Text(
        text,
        style: GoogleFonts.manrope(fontSize: 12, height: 16 / 12, letterSpacing: 2.4, color: const Color(0xFFE9C349)),
      ),
    );
  }
}

class _InputField extends StatelessWidget {
  const _InputField({required this.label, required this.value});
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4),
          child: Text(label, style: GoogleFonts.manrope(fontSize: 12, height: 16 / 12, color: const Color(0xFFE5E2E1))),
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.fromLTRB(17, 15, 17, 14),
          decoration: BoxDecoration(
            color: const Color(0xFF2A2A2A),
            borderRadius: BorderRadius.circular(2),
            border: Border.all(color: const Color(0xFF4E4639)),
          ),
          child: Text(
            value,
            style: GoogleFonts.manrope(fontSize: 14, color: const Color.fromRGBO(229, 226, 225, 0.5)),
          ),
        ),
      ],
    );
  }
}

class _CountrySelect extends StatelessWidget {
  const _CountrySelect();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4),
          child: Text('Country', style: GoogleFonts.manrope(fontSize: 12, height: 16 / 12, color: const Color(0xFFE5E2E1))),
        ),
        const SizedBox(height: 8),
        Stack(
          children: [
            Container(
              padding: const EdgeInsets.fromLTRB(17, 13, 17, 13),
              decoration: BoxDecoration(
                color: const Color(0xFF2A2A2A),
                borderRadius: BorderRadius.circular(2),
                border: Border.all(color: const Color(0xFF4E4639)),
              ),
              child: Row(
                children: [
                  Expanded(child: Text('United States', style: GoogleFonts.manrope(fontSize: 14, color: const Color(0xFFE5E2E1)))),
                  const SizedBox(width: 12),
                  SvgPicture.asset('assets/images/icon_country_chev.svg', width: 7, height: 4.32),
                ],
              ),
            ),
            Positioned(
              right: 9,
              top: 12.5,
              child: SvgPicture.asset('assets/images/icon_country_flag.svg', width: 21, height: 21),
            ),
          ],
        ),
      ],
    );
  }
}

