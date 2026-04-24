import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';

import 'order_detail_screen.dart';

class CheckoutReviewScreen extends StatelessWidget {
  const CheckoutReviewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF131313),
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            _TopBar(onBack: () => Navigator.of(context).maybePop()),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(24, 32, 24, 40),
                child: Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 768),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const _MiniProgress(),
                        const SizedBox(height: 48),
                        Center(
                          child: Text(
                            'Review & Confirm',
                            style: GoogleFonts.notoSerif(fontSize: 30, height: 36 / 30, letterSpacing: -0.75, color: const Color(0xFFE5E2E1)),
                          ),
                        ),
                        const SizedBox(height: 48),
                        const _OrderSummary(),
                        const SizedBox(height: 32),
                        const _DeliveryCard(),
                        const SizedBox(height: 32),
                        const _PaymentCard(),
                        const SizedBox(height: 32),
                        const _TotalsCard(),
                      ],
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
      color: const Color(0xFF131313),
      padding: const EdgeInsets.fromLTRB(24, 16, 24, 16),
      child: Row(
        children: [
          GestureDetector(
            onTap: onBack,
            child: SvgPicture.asset('assets/images/icon_checkout_back_small.svg', width: 15, height: 15),
          ),
          const Spacer(),
          Text(
            'CHECKOUT',
            style: GoogleFonts.notoSerif(fontSize: 18, height: 28 / 18, letterSpacing: 1.8, color: const Color(0xFFE9C349)),
          ),
          const Spacer(),
        ],
      ),
    );
  }
}

class _MiniProgress extends StatelessWidget {
  const _MiniProgress();

  @override
  Widget build(BuildContext context) {
    Widget dot({required bool active}) => Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(
            color: active ? const Color(0xFFE9C349) : const Color.fromRGBO(73, 71, 64, 0.5),
            borderRadius: BorderRadius.circular(12),
            boxShadow: active ? const [BoxShadow(color: Color.fromRGBO(233, 195, 73, 0.5), blurRadius: 10)] : null,
          ),
        );

    return Center(
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          dot(active: false),
          const SizedBox(width: 24),
          dot(active: false),
          const SizedBox(width: 24),
          dot(active: true),
        ],
      ),
    );
  }
}

class _Card extends StatelessWidget {
  const _Card({required this.child, required this.padding, this.color});
  final Widget child;
  final EdgeInsets padding;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: padding,
      decoration: BoxDecoration(
        color: color ?? const Color(0xFF1C1B1B),
        borderRadius: BorderRadius.circular(4),
      ),
      child: child,
    );
  }
}

class _OrderSummary extends StatelessWidget {
  const _OrderSummary();

  @override
  Widget build(BuildContext context) {
    return _Card(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.only(bottom: 17),
            decoration: const BoxDecoration(border: Border(bottom: BorderSide(color: Color.fromRGBO(78, 70, 57, 0.2), width: 1))),
            child: Text('Order Summary', style: GoogleFonts.notoSerif(fontSize: 20, height: 28 / 20, color: const Color(0xFFE9C349))),
          ),
          const SizedBox(height: 24),
          const _SummaryItem(
            image: 'assets/images/review_item_1.png',
            title: 'Classic White Poplin\nShirt',
            meta: 'Size: M | Qty: 1',
            price: '\$145.00',
          ),
          const SizedBox(height: 24),
          const _SummaryItem(
            image: 'assets/images/review_item_2.png',
            title: 'Tailored Wool\nTrousers',
            meta: 'Size: 32 | Color:\nCharcoal | Qty: 1',
            price: '\$280.00',
          ),
        ],
      ),
    );
  }
}

class _SummaryItem extends StatelessWidget {
  const _SummaryItem({required this.image, required this.title, required this.meta, required this.price});
  final String image;
  final String title;
  final String meta;
  final String price;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(2),
          child: Container(
            width: 64,
            height: 96,
            color: const Color(0xFF353534),
            child: Image.asset(image, fit: BoxFit.cover),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: GoogleFonts.manrope(fontSize: 14, height: 20 / 14, color: const Color(0xFFE5E2E1))),
              const SizedBox(height: 4),
              Text(meta, style: GoogleFonts.manrope(fontSize: 12, height: 16 / 12, color: const Color(0xFFE5E2E1))),
            ],
          ),
        ),
        const SizedBox(width: 16),
        Text(price, style: GoogleFonts.notoSerif(fontSize: 18, height: 28 / 18, color: const Color(0xFFE5E2E1))),
      ],
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({required this.title});
  final String title;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title, style: GoogleFonts.notoSerif(fontSize: 20, height: 28 / 20, color: const Color(0xFFE9C349))),
        Text(
          'EDIT',
          style: GoogleFonts.manrope(
            fontSize: 12,
            height: 16 / 12,
            letterSpacing: 0.6,
            color: const Color(0xFFE9C349),
            decoration: TextDecoration.underline,
            decorationColor: const Color.fromRGBO(78, 70, 57, 0.2),
          ),
        ),
      ],
    );
  }
}

class _DeliveryCard extends StatelessWidget {
  const _DeliveryCard();

  @override
  Widget build(BuildContext context) {
    return _Card(
      padding: const EdgeInsets.fromLTRB(24, 24, 24, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.only(bottom: 17),
            decoration: const BoxDecoration(border: Border(bottom: BorderSide(color: Color.fromRGBO(78, 70, 57, 0.2), width: 1))),
            child: const _SectionHeader(title: 'Delivery'),
          ),
          const SizedBox(height: 16),
          Text(
            'Alexander Wright\n123 Luxury Lane, Apt 4B\nNew York, NY 10021\nUnited States',
            style: GoogleFonts.manrope(fontSize: 14, height: 22.75 / 14, color: const Color(0xFFE5E2E1)),
          ),
        ],
      ),
    );
  }
}

class _PaymentCard extends StatelessWidget {
  const _PaymentCard();

  @override
  Widget build(BuildContext context) {
    return _Card(
      padding: const EdgeInsets.fromLTRB(24, 24, 24, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.only(bottom: 17),
            decoration: const BoxDecoration(border: Border(bottom: BorderSide(color: Color.fromRGBO(78, 70, 57, 0.2), width: 1))),
            child: const _SectionHeader(title: 'Payment'),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              SvgPicture.asset('assets/images/icon_card_small_alt.svg', width: 19, height: 15),
              const SizedBox(width: 12),
              Text(
                'Amex ending in •••• 1024\nExp: 12/26',
                style: GoogleFonts.manrope(fontSize: 14, height: 22.75 / 14, color: const Color(0xFFE5E2E1)),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _TotalsCard extends StatelessWidget {
  const _TotalsCard();

  Widget _row(String left, String right, {Color? color}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(left, style: GoogleFonts.manrope(fontSize: 14, height: 20 / 14, color: color ?? const Color(0xFFE5E2E1))),
        Text(right, style: GoogleFonts.manrope(fontSize: 14, height: 20 / 14, color: color ?? const Color(0xFFE5E2E1))),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return _Card(
      color: const Color(0xFF0E0E0E),
      padding: const EdgeInsets.all(33),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.only(bottom: 25),
            decoration: const BoxDecoration(border: Border(bottom: BorderSide(color: Color.fromRGBO(78, 70, 57, 0.2), width: 1))),
            child: Column(
              children: [
                _row('Subtotal', '\$425.00'),
                const SizedBox(height: 16),
                _row('Standard Shipping', '\$15.00'),
                const SizedBox(height: 16),
                _row('Estimated Taxes', '\$38.25'),
              ],
            ),
          ),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Total', style: GoogleFonts.notoSerif(fontSize: 20, height: 28 / 20, color: const Color(0xFFE5E2E1))),
              Text('\$478.25', style: GoogleFonts.notoSerif(fontSize: 30, height: 36 / 30, letterSpacing: -0.75, color: const Color(0xFFE9C349))),
            ],
          ),
          const SizedBox(height: 16),
          Container(
            width: double.infinity,
            decoration: BoxDecoration(color: const Color(0xFFE9C349), borderRadius: BorderRadius.circular(12)),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.circular(12),
                onTap: () {
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (_) => const OrderDetailScreen()),
                  );
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  child: Center(
                    child: Text(
                      'PLACE ORDER',
                      style: GoogleFonts.manrope(fontSize: 14, height: 20 / 14, letterSpacing: 0.7, color: const Color(0xFF131313)),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

