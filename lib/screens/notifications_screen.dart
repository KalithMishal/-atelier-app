import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  static const _bg = Color(0xFF131313);
  static const _top = Color(0xFF080808);
  static const _title = Color(0xFFF5F0E8);
  static const _muted = Color(0xFF9A8F80);
  static const _luxGold = Color(0xFFB8963E);
  static const _card = Color(0xFF2A2420);
  static const double _phoneWidth = 390;

  int _tab = 0; // 0 all, 1 orders, 2 offers, 3 arrivals

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bg,
      body: SafeArea(
        bottom: false,
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: _phoneWidth),
            child: Column(
              children: [
                _TopBar(
                  onBack: () => Navigator.of(context).maybePop(),
                ),
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.fromLTRB(24, 24, 24, 48),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Expanded(
                              child: Text(
                                'Notifications',
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: GoogleFonts.notoSerif(
                                  fontSize: 36,
                                  height: 40 / 36,
                                  letterSpacing: 0.9,
                                  color: _title,
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Padding(
                              padding: const EdgeInsets.only(bottom: 6),
                              child: FittedBox(
                                fit: BoxFit.scaleDown,
                                child: Text(
                                  'MARK ALL READ',
                                  style: GoogleFonts.manrope(
                                    fontSize: 12,
                                    height: 16 / 12,
                                    letterSpacing: 2.4,
                                    color: _luxGold,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        _Tabs(
                          active: _tab,
                          onTap: (i) => setState(() => _tab = i),
                        ),
                        const SizedBox(height: 20),
                        _NotifCard(
                          barColor: _luxGold,
                          icon: Icons.local_shipping_outlined,
                          title: 'ORDER SHIPPED',
                          time: '2H AGO',
                          body:
                              'Your order #AT-9982 containing the\nSilk Noir Slip Dress has been\ndispatched and is en route.',
                          cta: 'TRACK ORDER',
                          thumb: 'assets/images/wish_silk_slip_dress.png',
                        ),
                        const SizedBox(height: 16),
                        _NotifCard(
                          barColor: _luxGold,
                          icon: Icons.diamond_outlined,
                          title: 'EXCLUSIVE OFFER',
                          time: '1D AGO',
                          body:
                              'Private Access: Enjoy an exclusive 15%\ncourtesy on the new "Midnight"\nevening wear collection.',
                          cta: 'SHOP NOW',
                          thumb: 'assets/images/search_recent_gown.png',
                        ),
                        const SizedBox(height: 16),
                        _NotifCard(
                          barColor: _luxGold,
                          icon: Icons.auto_awesome_outlined,
                          title: 'NEW ARRIVALS',
                          time: '2D AGO',
                          body:
                              'The Autumn/Winter Edit has arrived.\nDiscover structural silhouettes and\nrich textures.',
                          cta: 'VIEW COLLECTION',
                          thumb: 'assets/images/search_cat_men.png',
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
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
      height: 64,
      color: const Color(0xFF080808),
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Row(
        children: [
          IconButton(
            onPressed: onBack,
            icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 18, color: Color(0xFFB8963E)),
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints.tightFor(width: 40, height: 40),
          ),
          const Spacer(),
          Text(
            'ATELIER',
            style: GoogleFonts.libreBaskerville(
              fontSize: 24,
              letterSpacing: 7.2,
              color: const Color(0xFFF5F0E8),
            ),
          ),
          const Spacer(),
          const SizedBox(width: 40),
        ],
      ),
    );
  }
}

class _Tabs extends StatelessWidget {
  const _Tabs({required this.active, required this.onTap});
  final int active;
  final ValueChanged<int> onTap;

  @override
  Widget build(BuildContext context) {
    final labels = const ['ALL', 'ORDERS', 'OFFERS', 'ARRIVALS'];

    Widget tab(String text, int idx) {
      final isActive = idx == active;
      return GestureDetector(
        onTap: () => onTap(idx),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
          child: Column(
            children: [
              Text(
                text,
                style: GoogleFonts.manrope(
                  fontSize: 12,
                  height: 16 / 12,
                  letterSpacing: 2.4,
                  color: isActive ? const Color(0xFFB8963E) : const Color.fromRGBO(153, 144, 126, 0.8),
                ),
              ),
              const SizedBox(height: 8),
              AnimatedContainer(
                duration: const Duration(milliseconds: 160),
                height: 2,
                width: 22,
                color: isActive ? const Color(0xFFB8963E) : Colors.transparent,
              ),
            ],
          ),
        ),
      );
    }

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          for (int i = 0; i < labels.length; i++) ...[
            tab(labels[i], i),
            if (i != labels.length - 1) const SizedBox(width: 8),
          ],
        ],
      ),
    );
  }
}

class _NotifCard extends StatelessWidget {
  const _NotifCard({
    required this.barColor,
    required this.icon,
    required this.title,
    required this.time,
    required this.body,
    required this.cta,
    required this.thumb,
  });

  final Color barColor;
  final IconData icon;
  final String title;
  final String time;
  final String body;
  final String cta;
  final String thumb;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF2A2420),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 4,
            height: 160,
            decoration: BoxDecoration(
              color: barColor,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(16),
                bottomLeft: Radius.circular(16),
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(icon, size: 18, color: const Color(0xFFB8963E)),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          title,
                          style: GoogleFonts.manrope(
                            fontSize: 12,
                            height: 16 / 12,
                            letterSpacing: 2.4,
                            color: const Color(0xFFD0C5B2),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      Text(
                        time,
                        style: GoogleFonts.manrope(
                          fontSize: 10,
                          height: 14 / 10,
                          letterSpacing: 1.0,
                          color: const Color.fromRGBO(208, 197, 178, 0.6),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Text(
                    body,
                    style: GoogleFonts.notoSerif(
                      fontSize: 16,
                      height: 24 / 16,
                      color: const Color(0xFFE5E2E1),
                    ),
                  ),
                  const SizedBox(height: 14),
                  Row(
                    children: [
                      Text(
                        cta,
                        style: GoogleFonts.manrope(
                          fontSize: 12,
                          height: 16 / 12,
                          letterSpacing: 2.4,
                          color: const Color(0xFFB8963E),
                        ),
                      ),
                      const Spacer(),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Container(
                          width: 56,
                          height: 56,
                          color: const Color(0xFF201F1F),
                          child: Opacity(
                            opacity: 0.9,
                            child: Image.asset(
                              thumb,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) => const ColoredBox(color: Color(0xFF201F1F)),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

