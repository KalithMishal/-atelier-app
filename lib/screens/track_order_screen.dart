import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TrackOrderScreen extends StatelessWidget {
  const TrackOrderScreen({super.key});

  static const _bg = Color(0xFF080808);
  static const _text = Color(0xFFF5F0E8);
  static const _muted = Color(0xFFD0C5B2);
  static const _luxGold = Color(0xFFB8963E);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bg,
      body: SafeArea(
        bottom: false,
        child: Stack(
          children: [
            SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(24, 92, 24, 120),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Track Order',
                    style: GoogleFonts.notoSerif(
                      fontSize: 30,
                      height: 36 / 30,
                      color: _text,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Order #AT-8924',
                    style: GoogleFonts.poppins(
                      fontSize: 12,
                      height: 16 / 12,
                      letterSpacing: 1.2,
                      color: _muted.withValues(alpha: 0.8),
                    ),
                  ),
                  const SizedBox(height: 24),
                  _ProductCard(
                    title: 'Silk Organza Blouse',
                    qty: 1,
                    price: '\$1,250.00',
                  ),
                  const SizedBox(height: 28),
                  const _Timeline(
                    items: [
                      _TimelineItem(title: 'Order Placed', subtitle: 'October 18, 2023', state: _TimelineState.done),
                      _TimelineItem(title: 'Processed', subtitle: 'October 19,\n2023', state: _TimelineState.done),
                      _TimelineItem(
                        title: 'Shipped',
                        subtitle: 'October 21, 2023',
                        state: _TimelineState.done,
                        tracking: 'Tracking: 1299999999999999999',
                      ),
                      _TimelineItem(title: 'Out for Delivery', subtitle: 'Pending', state: _TimelineState.pending),
                    ],
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
            Positioned(
              left: 0,
              right: 0,
              top: 0,
              child: SafeArea(
                bottom: false,
                child: ClipRRect(
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
                    child: Container(
                      height: 64,
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      color: const Color.fromRGBO(8, 8, 8, 0.85),
                      child: Row(
                        children: [
                          IconButton(
                            onPressed: () => Navigator.of(context).maybePop(),
                            icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 18, color: _luxGold),
                          ),
                          Expanded(
                            child: Center(
                              child: Text(
                                'ATELIER',
                                style: GoogleFonts.libreBaskerville(
                                  fontSize: 18,
                                  letterSpacing: 6,
                                  color: _text,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 40),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: SafeArea(
                top: false,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(24, 8, 24, 16),
                  child: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(colors: [Color(0xFFB8963E), Color(0xFFC4A882)]),
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: const [
                        BoxShadow(color: Color.fromRGBO(184, 150, 62, 0.18), blurRadius: 18, offset: Offset(0, 4)),
                      ],
                    ),
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        borderRadius: BorderRadius.circular(12),
                        onTap: () {},
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          child: Center(
                            child: Text(
                              'CONTACT CONCIERGE',
                              style: GoogleFonts.poppins(
                                fontSize: 12,
                                height: 16 / 12,
                                letterSpacing: 2.4,
                                color: const Color(0xFF2A2420),
                                fontWeight: FontWeight.w600,
                              ),
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

class _ProductCard extends StatelessWidget {
  const _ProductCard({required this.title, required this.qty, required this.price});

  final String title;
  final int qty;
  final String price;

  static const _surface = Color(0xFF2A2420);
  static const _text = Color(0xFFF5F0E8);
  static const _muted = Color(0xFFD0C5B2);
  static const _luxGold = Color(0xFFB8963E);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: _surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color.fromRGBO(208, 197, 178, 0.10)),
        boxShadow: const [BoxShadow(color: Color.fromRGBO(0, 0, 0, 0.35), blurRadius: 30, offset: Offset(0, 16))],
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Container(
              width: 74,
              height: 74,
              color: const Color(0xFF1C1B1B),
              child: Image.asset(
                'assets/images/bag_item_blouse.png',
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => const ColoredBox(color: Color(0xFF201F1F)),
              ),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.notoSerif(fontSize: 18, height: 24 / 18, color: _text),
                ),
                const SizedBox(height: 4),
                Text(
                  'QTY: $qty',
                  style: GoogleFonts.poppins(fontSize: 12, height: 16 / 12, color: _muted.withValues(alpha: 0.85)),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Text(
            price,
            style: GoogleFonts.poppins(fontSize: 14, height: 20 / 14, color: _luxGold, fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }
}

enum _TimelineState { done, pending }

class _TimelineItem {
  const _TimelineItem({required this.title, required this.subtitle, required this.state, this.tracking});

  final String title;
  final String subtitle;
  final _TimelineState state;
  final String? tracking;
}

class _Timeline extends StatelessWidget {
  const _Timeline({required this.items});

  final List<_TimelineItem> items;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        for (int i = 0; i < items.length; i++)
          _TimelineRow(
            item: items[i],
            isLast: i == items.length - 1,
          ),
      ],
    );
  }
}

class _TimelineRow extends StatelessWidget {
  const _TimelineRow({required this.item, required this.isLast});

  final _TimelineItem item;
  final bool isLast;

  static const _muted = Color(0xFFD0C5B2);
  static const _luxGold = Color(0xFFB8963E);
  static const _text = Color(0xFFF5F0E8);
  static const _surface = Color(0xFF2A2420);

  @override
  Widget build(BuildContext context) {
    final done = item.state == _TimelineState.done;
    final dotBorder = done ? _luxGold : _muted.withValues(alpha: 0.25);
    final dotFill = done ? const Color.fromRGBO(184, 150, 62, 0.18) : const Color.fromRGBO(0, 0, 0, 0.0);
    final lineColor = done ? _luxGold.withValues(alpha: 0.55) : _muted.withValues(alpha: 0.18);

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 30,
          child: Column(
            children: [
              Container(
                width: 12,
                height: 12,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: dotBorder, width: 2),
                  color: dotFill,
                ),
              ),
              if (!isLast)
                Container(
                  width: 2,
                  height: 58,
                  margin: const EdgeInsets.only(top: 6),
                  decoration: BoxDecoration(
                    color: lineColor,
                    borderRadius: BorderRadius.circular(9999),
                  ),
                ),
            ],
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(top: 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(item.title, style: GoogleFonts.notoSerif(fontSize: 18, height: 24 / 18, color: done ? _text : _text.withValues(alpha: 0.65))),
                const SizedBox(height: 4),
                Text(item.subtitle, style: GoogleFonts.poppins(fontSize: 12, height: 16 / 12, color: _muted.withValues(alpha: 0.8))),
                if (item.tracking != null) ...[
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                    decoration: BoxDecoration(
                      color: _surface.withValues(alpha: 0.4),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: const Color.fromRGBO(208, 197, 178, 0.10)),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.local_shipping_outlined, size: 16, color: _luxGold),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            item.tracking!,
                            style: GoogleFonts.poppins(fontSize: 11, height: 16 / 11, color: _muted.withValues(alpha: 0.9)),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
                const SizedBox(height: 22),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

