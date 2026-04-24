import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'home_screen.dart';
import 'product_listing_screen.dart';
import 'wishlist_screen.dart';
import 'profile_screen.dart';
import 'order_detail_screen.dart';

class OrderHistoryScreen extends StatefulWidget {
  const OrderHistoryScreen({super.key});

  @override
  State<OrderHistoryScreen> createState() => _OrderHistoryScreenState();
}

class _OrderHistoryScreenState extends State<OrderHistoryScreen> {
  static const _bg = Color(0xFF131313);
  static const _title = Color(0xFFF5F0E8);
  static const _luxGold = Color(0xFFB8963E);
  static const double _contentMaxW = 1100;

  int _activeTab = 0; // 0 all, 1 active, 2 delivered
  final int _activeBottomIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bg,
      body: SafeArea(
        bottom: false,
        child: Stack(
          children: [
            Column(
              children: [
                const _TopBar(),
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.fromLTRB(24, 24, 24, 120),
                    child: Center(
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: _contentMaxW),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                GestureDetector(
                                  onTap: () => Navigator.of(context).maybePop(),
                                  child: Row(
                                    children: [
                                      const Icon(Icons.arrow_back_ios_new_rounded, size: 16, color: _luxGold),
                                      const SizedBox(width: 10),
                                      Text(
                                        'Order History',
                                        style: GoogleFonts.notoSerif(
                                          fontSize: 28,
                                          height: 34 / 28,
                                          color: _title,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 18),
                            _Tabs(active: _activeTab, onTap: (i) => setState(() => _activeTab = i)),
                            const SizedBox(height: 24),
                            LayoutBuilder(
                              builder: (context, c) {
                                final w = c.maxWidth;
                                final columns = w >= 900 ? 2 : 1;
                                const gap = 24.0;
                                final itemW = columns == 1 ? w : (w - gap) / 2;

                                Widget card({
                                  required String orderNo,
                                  required String placed,
                                  required String status,
                                  required String total,
                                  required List<String> images,
                                }) {
                                  return SizedBox(
                                    width: itemW,
                                    child: _OrderCard(
                                      orderNo: orderNo,
                                      placed: placed,
                                      status: status,
                                      total: total,
                                      images: images,
                                      onViewDetails: () {
                                        Navigator.of(context).push(MaterialPageRoute(builder: (_) => const OrderDetailScreen()));
                                      },
                                    ),
                                  );
                                }

                                return Wrap(
                                  spacing: gap,
                                  runSpacing: gap,
                                  children: [
                                    card(
                                      orderNo: 'ORDER #AT-8924',
                                      placed: 'Placed on October 12, 2023',
                                      status: 'ON ITS WAY',
                                      total: '\$ 12,480',
                                      images: const ['assets/images/wish_structured_tote.png', 'assets/images/bag_item_pumps.png'],
                                    ),
                                    card(
                                      orderNo: 'ORDER #AT-7512',
                                      placed: 'Placed on September 05, 2023',
                                      status: 'DELIVERED',
                                      total: '\$ 4,200',
                                      images: const ['assets/images/bag_item_necklace.png', 'assets/images/wish_gold_earrings.png'],
                                    ),
                                  ],
                                );
                              },
                            ),
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
              child: SafeArea(
                top: false,
                child: Center(
                  child: _BottomNavBar(
                    activeIndex: _activeBottomIndex,
                    onTap: (idx) => _navigateBottom(context, idx),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _navigateBottom(BuildContext context, int idx) {
    Widget target;
    switch (idx) {
      case 0:
        target = const HomeScreen();
        break;
      case 1:
        target = const ProductListingScreen();
        break;
      case 2:
        target = const WishlistScreen();
        break;
      case 3:
        target = const ProfileScreen();
        break;
      default:
        target = const HomeScreen();
    }
    Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) => target));
  }
}

class _TopBar extends StatelessWidget {
  const _TopBar();

  static const _top = Color(0xFF080808);
  static const _title = Color(0xFFF5F0E8);
  static const _luxGold = Color(0xFFB8963E);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: _top,
      height: 64,
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: _OrderHistoryScreenState._contentMaxW),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: LayoutBuilder(
              builder: (context, constraints) {
          const iconSlot = 40.0;
          const iconGap = 12.0;
          final rightClusterWidth = (iconSlot * 3) + (iconGap * 2);
          final leftClusterWidth = iconSlot;
          final availableForTitle = constraints.maxWidth - leftClusterWidth - rightClusterWidth;

          return Row(
            children: [
              SizedBox(
                width: leftClusterWidth,
                child: IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.menu_rounded, size: 22, color: _luxGold),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints.tightFor(width: iconSlot, height: iconSlot),
                ),
              ),
              SizedBox(
                width: availableForTitle.clamp(0, double.infinity),
                child: Center(
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      'ATELIER',
                      style: GoogleFonts.libreBaskerville(
                        fontSize: 24,
                        letterSpacing: 7.2,
                        color: _title,
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(
                width: rightClusterWidth,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: const [
                    Icon(Icons.search_rounded, size: 22, color: _luxGold),
                    SizedBox(width: iconGap),
                    Icon(Icons.shopping_bag_outlined, size: 20, color: _luxGold),
                    SizedBox(width: iconGap),
                    Icon(Icons.notifications_none_rounded, size: 22, color: _luxGold),
                  ],
                ),
              ),
            ],
          );
              },
            ),
          ),
        ),
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
    Widget pill(String text, int idx) {
      final isActive = idx == active;
      return GestureDetector(
        onTap: () => onTap(idx),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
          decoration: BoxDecoration(
            color: isActive ? const Color(0xFFB8963E) : Colors.transparent,
            borderRadius: BorderRadius.circular(9999),
            border: isActive ? null : Border.all(color: const Color.fromRGBO(78, 70, 57, 0.35)),
          ),
          child: Text(
            text,
            style: GoogleFonts.manrope(
              fontSize: 12,
              height: 16 / 12,
              letterSpacing: 1.2,
              color: isActive ? const Color(0xFF2A2420) : const Color(0xFFD1C5B4),
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      );
    }

    return Row(
      children: [
        pill('ALL', 0),
        const SizedBox(width: 12),
        pill('ACTIVE', 1),
        const SizedBox(width: 12),
        pill('DELIVERED', 2),
      ],
    );
  }
}

class _OrderCard extends StatelessWidget {
  const _OrderCard({
    required this.orderNo,
    required this.placed,
    required this.status,
    required this.total,
    required this.images,
    required this.onViewDetails,
  });

  final String orderNo;
  final String placed;
  final String status;
  final String total;
  final List<String> images;
  final VoidCallback onViewDetails;

  static const _card = Color(0xFF2A2420);
  static const _title = Color(0xFFF5F0E8);
  static const _luxGold = Color(0xFFB8963E);

  @override
  Widget build(BuildContext context) {
    final delivered = status.toUpperCase() == 'DELIVERED';
    final statusBg = delivered ? const Color.fromRGBO(184, 150, 62, 0.22) : const Color.fromRGBO(0, 0, 0, 0.22);

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: _card,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color.fromRGBO(78, 70, 57, 0.25)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(orderNo, style: GoogleFonts.manrope(fontSize: 12, height: 16 / 12, letterSpacing: 1.2, color: _luxGold)),
          const SizedBox(height: 8),
          Text(placed, style: GoogleFonts.notoSerif(fontSize: 18, height: 24 / 18, color: _title)),
          const SizedBox(height: 16),
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(color: statusBg, borderRadius: BorderRadius.circular(9999)),
                child: Text(
                  status,
                  style: GoogleFonts.manrope(fontSize: 10, height: 14 / 10, letterSpacing: 1.2, color: delivered ? _luxGold : const Color(0xFFD1C5B4)),
                ),
              ),
              const Spacer(),
              Text(total, style: GoogleFonts.notoSerif(fontSize: 20, height: 24 / 20, color: _luxGold)),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              for (int i = 0; i < images.length; i++) ...[
                Expanded(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: Container(
                      height: 110,
                      color: const Color(0xFF1C1B1B),
                      child: Opacity(
                        opacity: 0.9,
                        child: Image.asset(
                          images[i],
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) => const ColoredBox(color: Color(0xFF201F1F)),
                        ),
                      ),
                    ),
                  ),
                ),
                if (i != images.length - 1) const SizedBox(width: 16),
              ],
            ],
          ),
          const SizedBox(height: 16),
          GestureDetector(
            onTap: onViewDetails,
            child: Text(
              'VIEW DETAILS  ›',
              style: GoogleFonts.manrope(
                fontSize: 12,
                height: 16 / 12,
                letterSpacing: 1.2,
                color: _luxGold,
                decoration: TextDecoration.underline,
                decorationColor: const Color.fromRGBO(78, 70, 57, 0.35),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _BottomNavBar extends StatelessWidget {
  const _BottomNavBar({required this.activeIndex, required this.onTap});

  final int activeIndex;
  final ValueChanged<int> onTap;

  @override
  Widget build(BuildContext context) {
    const barWidth = 390.0;
    const bg = Color.fromRGBO(42, 36, 32, 0.99);
    const inactive = Color(0xFFE5E2E1);
    const activeBg = Color(0xFFB8963E);
    const activeIcon = Color(0xFF3C2F00);

    Widget btn(int idx, IconData icon) => GestureDetector(
          onTap: () => onTap(idx),
          behavior: HitTestBehavior.opaque,
          child: Container(
            height: 48,
            width: 48,
            decoration: BoxDecoration(
              color: activeIndex == idx ? activeBg : Colors.transparent,
              borderRadius: BorderRadius.circular(10),
            ),
            alignment: Alignment.center,
            child: Icon(icon, size: 22, color: activeIndex == idx ? activeIcon : inactive),
          ),
        );

    return Container(
      width: barWidth,
      margin: const EdgeInsets.only(bottom: 0.2),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFB8963E).withValues(alpha: 0.08),
            blurRadius: 32,
            offset: const Offset(0, -10),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 14),
            color: bg,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                btn(0, Icons.home_rounded),
                btn(1, Icons.grid_view_rounded),
                btn(2, Icons.favorite_border_rounded),
                btn(3, Icons.person_outline_rounded),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

