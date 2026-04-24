import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';

import 'checkout_delivery_screen.dart';
import 'gift_note_sheet.dart';
import 'notifications_screen.dart';
import 'search_discovery_screen.dart';

class ShoppingBagScreen extends StatelessWidget {
  const ShoppingBagScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF131313),
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            const _TopAppBar(),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(16, 24, 16, 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const _BagItem(
                      image: 'assets/images/bag_item_shirt.png',
                      brand: 'Maison Margiela',
                      name: 'Oversized Silk Organza Shirt',
                      price: '\$890',
                      meta1: 'Color: Ivory',
                      meta2: 'Size: M',
                    ),
                    const SizedBox(height: 48),
                    const _BagItem(
                      image: 'assets/images/bag_item_necklace.png',
                      brand: 'Sophie Bille Brahe',
                      name: 'Petite Croissant de Lune Necklace',
                      price: '\$1,250',
                      meta1: '18K Yellow Gold',
                    ),
                    const SizedBox(height: 48),
                    const _BagItem(
                      image: 'assets/images/bag_item_pumps.png',
                      brand: 'Saint Laurent',
                      name: 'Opyum Leather Pumps',
                      price: '\$1,100',
                      meta1: 'Color: Black',
                      meta2: 'Size: 38 IT',
                    ),
                    const SizedBox(height: 48),
                    const _PromoCode(),
                    const SizedBox(height: 48),
                    GestureDetector(
                      onTap: () => showGiftNoteSheet(context),
                      child: Text(
                        'Add a gift note +',
                        style: GoogleFonts.manrope(
                          fontSize: 14,
                          height: 20 / 14,
                          letterSpacing: 0.7,
                          color: const Color(0xFFE9C349),
                          decoration: TextDecoration.underline,
                          decorationColor: const Color.fromRGBO(78, 70, 57, 0.2),
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    const _Summary(),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
            _CheckoutFooter(
              onCheckout: () {
                Navigator.of(context).push(MaterialPageRoute(builder: (_) => const CheckoutDeliveryScreen()));
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _TopAppBar extends StatelessWidget {
  const _TopAppBar();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFF080808),
      padding: const EdgeInsets.symmetric(horizontal: 24.6, vertical: 16),
      child: Row(
        children: [
          IconButton(
            onPressed: () => Navigator.of(context).maybePop(),
            icon: const Icon(Icons.menu_rounded, size: 22, color: Color(0xFFB8963E)),
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints.tightFor(width: 40, height: 40),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Center(
              child: Text(
                'ATELIER',
                style: GoogleFonts.libreBaskerville(
                  fontSize: 24,
                  letterSpacing: 7.2,
                  color: const Color(0xFFF5F0E8),
                ),
              ),
            ),
          ),
          Row(
            children: [
              IconButton(
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(builder: (_) => const SearchDiscoveryScreen()));
                },
                icon: const Icon(Icons.search_rounded, size: 22, color: Color(0xFFB8963E)),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints.tightFor(width: 40, height: 40),
              ),
              const SizedBox(width: 16),
              IconButton(
                onPressed: () {},
                icon: const Icon(Icons.shopping_bag_outlined, size: 20, color: Color(0xFFB8963E)),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints.tightFor(width: 40, height: 40),
              ),
              const SizedBox(width: 16),
              IconButton(
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(builder: (_) => const NotificationsScreen()));
                },
                icon: const Icon(Icons.notifications_none_rounded, size: 22, color: Color(0xFFB8963E)),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints.tightFor(width: 40, height: 40),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _BagItem extends StatelessWidget {
  const _BagItem({
    required this.image,
    required this.brand,
    required this.name,
    required this.price,
    required this.meta1,
    this.meta2,
  });

  final String image;
  final String brand;
  final String name;
  final String price;
  final String meta1;
  final String? meta2;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(2),
          child: Container(
            width: 96,
            height: 128,
            color: const Color(0xFF1C1B1B),
            child: Opacity(opacity: 0.8, child: Image.asset(image, fit: BoxFit.cover)),
          ),
        ),
        const SizedBox(width: 24),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Text(
                      brand,
                      style: GoogleFonts.notoSerif(fontSize: 18, height: 22.5 / 18, color: const Color(0xFFE5E2E1)),
                    ),
                  ),
                  Text(
                    price,
                    style: GoogleFonts.manrope(
                      fontSize: 16,
                      height: 24 / 16,
                      fontWeight: FontWeight.w500,
                      letterSpacing: 0.4,
                      color: const Color(0xFFE9C349),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Text(name, style: GoogleFonts.manrope(fontSize: 14, height: 20 / 14, color: const Color(0xFFD1C5B4))),
              const SizedBox(height: 8),
              Text(meta1, style: GoogleFonts.manrope(fontSize: 12, height: 16 / 12, color: const Color(0xFF9A8F80))),
              if (meta2 != null)
                Text(meta2!, style: GoogleFonts.manrope(fontSize: 12, height: 16 / 12, color: const Color(0xFF9A8F80))),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.only(top: 12),
                decoration: const BoxDecoration(
                  border: Border(top: BorderSide(color: Color.fromRGBO(78, 70, 57, 0.2), width: 1)),
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _QtyStepper(),
                    _RemoveButton(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _QtyStepper extends StatelessWidget {
  const _QtyStepper();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(color: const Color(0xFF353534), borderRadius: BorderRadius.circular(12)),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: Row(
        children: [
          SvgPicture.asset('assets/images/icon_qty_minus.svg', width: 7.58, height: 0.88),
          const SizedBox(width: 16),
          Text('1', style: GoogleFonts.manrope(fontSize: 14, height: 20 / 14, color: const Color(0xFFE5E2E1))),
          const SizedBox(width: 16),
          SvgPicture.asset('assets/images/icon_qty_plus.svg', width: 7.58, height: 7.58),
        ],
      ),
    );
  }
}

class _RemoveButton extends StatelessWidget {
  const _RemoveButton();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SvgPicture.asset('assets/images/icon_remove.svg', width: 8.87, height: 8.87),
        const SizedBox(width: 4),
        Text(
          'REMOVE',
          style: GoogleFonts.manrope(fontSize: 12, height: 16 / 12, letterSpacing: 1.2, color: const Color(0xFFD1C5B4)),
        ),
      ],
    );
  }
}

class _PromoCode extends StatelessWidget {
  const _PromoCode();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(color: const Color(0xFF1C1B1B), borderRadius: BorderRadius.circular(4)),
      child: Row(
        children: [
          Expanded(
            child: Container(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 14),
              decoration: BoxDecoration(color: const Color(0xFF353534), borderRadius: BorderRadius.circular(2)),
              child: Text(
                'Promo Code / Gift Card',
                style: GoogleFonts.manrope(fontSize: 14, color: const Color.fromRGBO(209, 197, 180, 0.5)),
              ),
            ),
          ),
          const SizedBox(width: 16),
          Text(
            'APPLY',
            style: GoogleFonts.manrope(
              fontSize: 12,
              height: 16 / 12,
              letterSpacing: 1.2,
              fontWeight: FontWeight.w600,
              color: const Color(0xFFE9C349),
            ),
          ),
        ],
      ),
    );
  }
}

class _Summary extends StatelessWidget {
  const _Summary();

  Widget _row(String left, String right, {Color? rightColor, double? rightSize}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(left, style: GoogleFonts.manrope(fontSize: 14, height: 20 / 14, color: const Color(0xFFD1C5B4))),
        Text(
          right,
          style: GoogleFonts.manrope(
            fontSize: rightSize ?? 14,
            height: 20 / 14,
            color: rightColor ?? const Color(0xFFD1C5B4),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _row('Subtotal', '\$3,240.00'),
        const SizedBox(height: 16),
        _row('Estimated Shipping', 'Complimentary', rightColor: const Color(0xFFE5E2E1)),
        const SizedBox(height: 16),
        _row('Taxes', 'Calculated at checkout', rightColor: const Color(0xFF9A8F80), rightSize: 12),
        const SizedBox(height: 33),
        Container(height: 1, color: const Color.fromRGBO(78, 70, 57, 0.2)),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('TOTAL', style: GoogleFonts.manrope(fontSize: 14, height: 20 / 14, letterSpacing: 1.4, color: const Color(0xFFE5E2E1))),
            Text(
              '\$3,240.00',
              style: GoogleFonts.notoSerif(fontSize: 30, height: 36 / 30, color: const Color(0xFFE9C349)),
            ),
          ],
        ),
      ],
    );
  }
}

class _CheckoutFooter extends StatelessWidget {
  const _CheckoutFooter({required this.onCheckout});
  final VoidCallback onCheckout;

  @override
  Widget build(BuildContext context) {
    return ClipRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
        child: Container(
          padding: const EdgeInsets.fromLTRB(16, 25, 16, 32),
          decoration: const BoxDecoration(
            color: Color.fromRGBO(14, 14, 14, 0.9),
            border: Border(top: BorderSide(color: Color.fromRGBO(78, 70, 57, 0.1), width: 1)),
          ),
          child: Column(
            children: [
              ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 448),
                child: GestureDetector(
                  onTap: onCheckout,
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(colors: [Color(0xFFE9C349), Color(0xFFC5A12A)]),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      'PROCEED TO CHECKOUT',
                      style: GoogleFonts.manrope(
                        fontSize: 14,
                        height: 20 / 14,
                        letterSpacing: 1.4,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF3C2F00),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SvgPicture.asset('assets/images/icon_lock_small.svg', width: 8.75, height: 11.38),
                  const SizedBox(width: 8),
                  Text('Secure Encrypted Transaction', style: GoogleFonts.manrope(fontSize: 12, height: 16 / 12, color: const Color(0xFF9A8F80))),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

