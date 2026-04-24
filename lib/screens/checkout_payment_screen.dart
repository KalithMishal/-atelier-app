import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';

import 'checkout_review_screen.dart';

class CheckoutPaymentScreen extends StatefulWidget {
  const CheckoutPaymentScreen({super.key});

  @override
  State<CheckoutPaymentScreen> createState() => _CheckoutPaymentScreenState();
}

class _CheckoutPaymentScreenState extends State<CheckoutPaymentScreen> {
  int _selected = 0;

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
                _TopBar(
                  onBack: () => Navigator.of(context).maybePop(),
                ),
                Expanded(
                  child: Stack(
                    children: [
                      Positioned.fill(
                        top: -72,
                        bottom: -96,
                        child: Opacity(
                          opacity: 0.2,
                          child: DecoratedBox(
                            decoration: BoxDecoration(
                              gradient: RadialGradient(
                                center: const Alignment(0, -1),
                                radius: 1.2,
                                colors: const [Color(0xFF353534), Color(0x00353534)],
                                stops: const [0.0, 0.7],
                              ),
                            ),
                          ),
                        ),
                      ),
                      SingleChildScrollView(
                        padding: const EdgeInsets.fromLTRB(24, 48, 24, 140),
                        child: Center(
                          child: ConstrainedBox(
                            constraints: const BoxConstraints(maxWidth: 768),
                            child: Column(
                              children: [
                                const _TinyProgress(),
                                const SizedBox(height: 16),
                                Text(
                                  'Payment Method',
                                  style: GoogleFonts.notoSerif(
                                    fontSize: 36,
                                    height: 40 / 36,
                                    letterSpacing: -0.9,
                                    color: const Color(0xFFE5E2E1),
                                  ),
                                ),
                                const SizedBox(height: 16),
                                Text(
                                  'Secure your reservation with your preferred\npayment option.',
                                  textAlign: TextAlign.center,
                                  style: GoogleFonts.manrope(fontSize: 14, height: 20 / 14, letterSpacing: 0.35, color: const Color(0xFFD1C5B4)),
                                ),
                                const SizedBox(height: 32),
                                Container(
                                  padding: const EdgeInsets.all(24),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFF1C1B1B),
                                    borderRadius: BorderRadius.circular(8),
                                    boxShadow: const [BoxShadow(color: Color.fromRGBO(14, 14, 14, 0.4), blurRadius: 40, offset: Offset(0, 20))],
                                  ),
                                  child: Column(
                                    children: [
                                      _OptionTile(
                                        active: _selected == 0,
                                        label: 'CREDIT CARD',
                                        iconAsset: 'assets/images/icon_credit_card.svg',
                                        iconSize: const Size(22.5, 29.5),
                                        onTap: () => setState(() => _selected = 0),
                                      ),
                                      const SizedBox(height: 16),
                                      _OptionTile(
                                        active: _selected == 1,
                                        label: 'APPLE PAY',
                                        iconAsset: 'assets/images/icon_applepay.svg',
                                        iconSize: const Size(21.25, 20),
                                        onTap: () => setState(() => _selected = 1),
                                      ),
                                      const SizedBox(height: 16),
                                      _OptionTile(
                                        active: _selected == 2,
                                        label: 'PAYPAL',
                                        iconAsset: 'assets/images/icon_paypal.svg',
                                        iconSize: const Size(23.27, 16.73),
                                        onTap: () => setState(() => _selected = 2),
                                      ),
                                      const SizedBox(height: 32),
                                      Container(height: 1, color: const Color.fromRGBO(78, 70, 57, 0.2)),
                                      const SizedBox(height: 24),
                                      const _CardForm(),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 32),
                                GestureDetector(
                                  onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const CheckoutReviewScreen())),
                                  child: Container(
                                    width: double.infinity,
                                    padding: const EdgeInsets.symmetric(vertical: 16),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(12),
                                      gradient: const LinearGradient(colors: [Color(0xFFE9C349), Color(0xFFC5A12A)]),
                                      boxShadow: const [BoxShadow(color: Color.fromRGBO(233, 195, 73, 0.2), blurRadius: 14, offset: Offset(0, 4))],
                                    ),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          'REVIEW ORDER',
                                          style: GoogleFonts.manrope(fontSize: 14, height: 20 / 14, letterSpacing: 1.4, color: const Color(0xFF3C2F00)),
                                        ),
                                        const SizedBox(width: 8),
                                        SvgPicture.asset('assets/images/icon_review_arrow.svg', width: 12, height: 12),
                                      ],
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 24),
                                Container(
                                  decoration: const BoxDecoration(
                                    border: Border(bottom: BorderSide(color: Color.fromRGBO(233, 195, 73, 0.3), width: 1)),
                                  ),
                                  padding: const EdgeInsets.only(bottom: 5),
                                  child: Text(
                                    'RETURN TO SHIPPING',
                                    style: GoogleFonts.manrope(fontSize: 14, height: 20 / 14, letterSpacing: 0.7, color: const Color(0xFFE9C349)),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
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
      color: const Color(0xFF131313),
      padding: const EdgeInsets.fromLTRB(24, 16, 24, 16),
      child: Row(
        children: [
          GestureDetector(
            onTap: onBack,
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(12)),
              child: SvgPicture.asset('assets/images/icon_checkout_back_small.svg', width: 15, height: 15),
            ),
          ),
          const Spacer(),
          Text(
            'CHECKOUT',
            style: GoogleFonts.notoSerif(fontSize: 18, height: 28 / 18, letterSpacing: 3.6, color: const Color(0xFFE9C349)),
          ),
          const Spacer(),
        ],
      ),
    );
  }
}

class _TinyProgress extends StatelessWidget {
  const _TinyProgress();

  @override
  Widget build(BuildContext context) {
    Widget dot({required bool active}) => Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(
            color: active ? const Color(0xFFE9C349) : const Color.fromRGBO(73, 71, 64, 0.5),
            borderRadius: BorderRadius.circular(12),
            boxShadow: active ? const [BoxShadow(color: Color.fromRGBO(233, 195, 73, 0.6), blurRadius: 8)] : null,
          ),
        );

    Widget bar({required bool filled}) => ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Container(
            width: 64,
            height: 8,
            color: const Color(0xFF353534),
            child: filled ? Container(color: const Color(0xFFE9C349).withValues(alpha: 0.5)) : null,
          ),
        );

    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 16, 0, 32),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          dot(active: false),
          const SizedBox(width: 24),
          bar(filled: true),
          const SizedBox(width: 24),
          dot(active: true),
          const SizedBox(width: 24),
          bar(filled: false),
          const SizedBox(width: 24),
          dot(active: false),
        ],
      ),
    );
  }
}

class _OptionTile extends StatelessWidget {
  const _OptionTile({
    required this.active,
    required this.label,
    required this.iconAsset,
    required this.iconSize,
    required this.onTap,
  });

  final bool active;
  final String label;
  final String iconAsset;
  final Size iconSize;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(17),
        decoration: BoxDecoration(
          color: active ? const Color.fromRGBO(53, 53, 52, 0.4) : const Color(0xFF353534),
          borderRadius: BorderRadius.circular(4),
          border: Border.all(color: active ? const Color(0xFFE9C349) : const Color.fromRGBO(78, 70, 57, 0.2)),
        ),
        child: Column(
          children: [
            SvgPicture.asset(iconAsset, width: iconSize.width, height: iconSize.height),
            const SizedBox(height: 12),
            Text(
              label,
              style: GoogleFonts.manrope(
                fontSize: 14,
                height: 20 / 14,
                letterSpacing: 0.7,
                color: active ? const Color(0xFFE5E2E1) : const Color(0xFFD1C5B4),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CardForm extends StatelessWidget {
  const _CardForm();

  Widget _label(String text) => Text(
        text,
        style: GoogleFonts.manrope(fontSize: 12, height: 16 / 12, letterSpacing: 1.2, color: const Color(0xFFD1C5B4)),
      );

  Widget _input(String text, {Widget? trailing, TextAlign align = TextAlign.left, EdgeInsets? padding}) {
    return Container(
      padding: padding ?? const EdgeInsets.symmetric(horizontal: 16, vertical: 13),
      decoration: const BoxDecoration(
        color: Color(0xFF353534),
        borderRadius: BorderRadius.only(topLeft: Radius.circular(2), topRight: Radius.circular(2)),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              text,
              textAlign: align,
              style: GoogleFonts.manrope(fontSize: 16, color: const Color.fromRGBO(209, 197, 180, 0.3)),
            ),
          ),
          trailing ?? const SizedBox(),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _label('NAME ON CARD'),
        const SizedBox(height: 8),
        _input('JOHN DOE'),
        const SizedBox(height: 24),
        _label('CARD NUMBER'),
        const SizedBox(height: 8),
        _input(
          '0000 0000 0000 0000',
          trailing: SvgPicture.asset('assets/images/icon_card_brand.svg', width: 19, height: 15),
          padding: const EdgeInsets.fromLTRB(16, 13, 16, 13),
        ),
        const SizedBox(height: 24),
        Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _label('EXPIRY'),
                  const SizedBox(height: 8),
                  _input('MM/YY', align: TextAlign.center),
                ],
              ),
            ),
            const SizedBox(width: 24),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _label('CVV'),
                  const SizedBox(height: 8),
                  _input(
                    '•••',
                    align: TextAlign.center,
                    trailing: SvgPicture.asset('assets/images/icon_cvv_info.svg', width: 11.08, height: 11.08),
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}

