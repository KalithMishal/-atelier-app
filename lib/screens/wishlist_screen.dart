import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';

import 'home_screen.dart';
import 'product_listing_screen.dart';
import 'profile_screen.dart';
import 'notifications_screen.dart';
import 'search_discovery_screen.dart';
import 'shopping_bag_screen.dart';

class WishlistScreen extends StatefulWidget {
  const WishlistScreen({super.key});

  @override
  State<WishlistScreen> createState() => _WishlistScreenState();
}

class _WishlistScreenState extends State<WishlistScreen> {
  static const _bg = Color(0xFF080808);
  static const _topBarBg = Color(0xFF080808);
  static const _text = Color(0xFFF5F0E8);
  static const _muted = Color(0xFF99907E);
  static const _card = Color(0xFF2A2420);
  static const _accent = Color(0xFFB8963E);
  static const _accentSoft = Color(0xFFE0C29A);
  static const _separator = Color.fromRGBO(53, 53, 52, 0.4);

  final int _activeBottomIndex = 2;

  final _items = const [
    _WishItem(
      "L'ÉDITION",
      'The Bias Cut\nSilk Column…\nDress',
      '\$ 1,250',
      true,
      'assets/images/wish_silk_slip_dress.png',
    ),
    _WishItem(
      'MAISON NOIR',
      'Architectural\nCalfskin Tote',
      '\$ 2,800',
      false,
      'assets/images/wish_structured_tote.png',
    ),
    _WishItem(
      'AURA BIJOUX',
      'Molten Gold\nStatement…\nHoops',
      '\$ 850',
      false,
      'assets/images/wish_gold_earrings.png',
    ),
    _WishItem(
      'VANGUARD',
      'Oversized\nCashmere…\nOvercoat',
      '\$ 3,400',
      true,
      'assets/images/wish_cashmere_trench.png',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bg,
      body: SafeArea(
        bottom: false,
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 390),
            child: Stack(
              children: [
                Column(
                  children: [
                    _TopAppBar(backgroundColor: _topBarBg, titleColor: _text),
                    Expanded(
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.fromLTRB(24, 52, 24, 96),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'MY WISHLIST',
                                  style: GoogleFonts.notoSerif(
                                    fontSize: 30,
                                    height: 36 / 30,
                                    letterSpacing: 0.75,
                                    color: _text,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  '(12 PIECES)',
                                  style: GoogleFonts.plusJakartaSans(
                                    fontSize: 14,
                                    height: 20 / 14,
                                    letterSpacing: 1.4,
                                    color: _muted,
                                  ),
                                ),
                              ],
                            ),
                            IconButton(
                              onPressed: () {},
                              icon: SvgPicture.asset(
                                'assets/images/icon_share.svg',
                                width: 14,
                                height: 18,
                                colorFilter: const ColorFilter.mode(_text, BlendMode.srcIn),
                              ),
                              padding: EdgeInsets.zero,
                              constraints: const BoxConstraints.tightFor(width: 32, height: 32),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Container(height: 1, width: double.infinity, color: _separator),
                        const SizedBox(height: 24),
                        GridView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: _items.length,
                          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            mainAxisSpacing: 16,
                            crossAxisSpacing: 16,
                            childAspectRatio: 1 / 1.68,
                          ),
                          itemBuilder: (context, index) {
                            final item = _items[index];
                            return _WishlistCard(
                              item: item,
                              card: _card,
                              imageBg: const Color(0xFF0E0E0E),
                              accent: _accent,
                              accentSoft: _accentSoft,
                              text: _text,
                            );
                          },
                        ),
                        const SizedBox(height: 96),
                          ],
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
                        accent: const Color(0xFFE9C349),
                      ),
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

  void _navigateBottom(BuildContext context, int idx) {
    if (idx == _activeBottomIndex) return;
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

class _TopAppBar extends StatelessWidget {
  const _TopAppBar({required this.backgroundColor, required this.titleColor});

  final Color backgroundColor;
  final Color titleColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: backgroundColor,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Row(
        children: [
          IconButton(
            onPressed: () => Navigator.of(context).maybePop(),
            icon: const Icon(Icons.menu_rounded, color: Color(0xFFB8963E), size: 22),
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints.tightFor(width: 32, height: 32),
          ),
          const Spacer(),
          Text(
            'ATELIER',
            style: GoogleFonts.libreBaskerville(
              fontSize: 24,
              letterSpacing: 7.2,
              color: titleColor,
              fontWeight: FontWeight.w400,
            ),
          ),
          const Spacer(),
          Row(
            children: [
              IconButton(
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(builder: (_) => const SearchDiscoveryScreen()));
                },
                icon: const Icon(Icons.search_rounded, color: Color(0xFFB8963E), size: 22),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints.tightFor(width: 32, height: 32),
              ),
              const SizedBox(width: 16),
              IconButton(
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(builder: (_) => const ShoppingBagScreen()));
                },
                icon: const Icon(Icons.shopping_bag_outlined, color: Color(0xFFB8963E), size: 20),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints.tightFor(width: 32, height: 32),
              ),
              const SizedBox(width: 16),
              IconButton(
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(builder: (_) => const NotificationsScreen()));
                },
                icon: const Icon(Icons.notifications_none_rounded, color: Color(0xFFB8963E), size: 22),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints.tightFor(width: 32, height: 32),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _WishlistCard extends StatelessWidget {
  const _WishlistCard({
    required this.item,
    required this.card,
    required this.imageBg,
    required this.accent,
    required this.accentSoft,
    required this.text,
  });

  final _WishItem item;
  final Color card;
  final Color imageBg;
  final Color accent;
  final Color accentSoft;
  final Color text;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(0),
      child: Container(
        color: card,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                Container(
                  color: imageBg,
                  height: 217.33,
                  width: double.infinity,
                  child: Opacity(
                    opacity: 0.9,
                    child: Image.asset(
                      item.imagePath,
                      fit: BoxFit.cover,
                      width: double.infinity,
                      height: double.infinity,
                      errorBuilder: (context, error, stackTrace) => const ColoredBox(color: Color(0xFF201F1F)),
                    ),
                  ),
                ),
                Positioned(
                  left: 16,
                  top: 16,
                  child: item.lowStock
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(2),
                          child: BackdropFilter(
                            filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 5),
                              decoration: BoxDecoration(
                                color: accent.withValues(alpha: 0.2),
                                border: Border.all(color: accent.withValues(alpha: 0.3), width: 1),
                              ),
                              child: Text(
                                'LOW STOCK',
                                style: GoogleFonts.plusJakartaSans(
                                  fontSize: 9,
                                  height: 13.5 / 9,
                                  letterSpacing: 0.9,
                                  color: const Color(0xFFE8C265),
                                ),
                              ),
                            ),
                          ),
                        )
                      : const SizedBox(),
                ),
                const Positioned(
                  right: 16,
                  top: 16,
                  child: Icon(Icons.favorite_rounded, size: 18, color: Color(0xFFB8963E)),
                ),
              ],
            ),
            Expanded(
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                    colors: [Color(0xFF2A2420), Color.fromRGBO(42, 36, 32, 0.95)],
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.brand,
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 10,
                        height: 15 / 10,
                        letterSpacing: 1,
                        color: accent,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Expanded(
                      child: Text(
                        item.title,
                        style: GoogleFonts.notoSerif(
                          fontSize: 16,
                          height: 20 / 16,
                          color: text,
                        ),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      item.price,
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 14,
                        height: 20 / 14,
                        letterSpacing: 0.7,
                        color: accentSoft,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Container(
                      height: 38,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        border: Border.all(color: accent, width: 1),
                        borderRadius: BorderRadius.circular(9999),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        'ADD TO BAG',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 10,
                          height: 15 / 10,
                          letterSpacing: 1,
                          color: accent,
                        ),
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

class _BottomNavBar extends StatelessWidget {
  const _BottomNavBar({
    required this.activeIndex,
    required this.onTap,
    required this.accent,
  });

  final int activeIndex;
  final ValueChanged<int> onTap;
  final Color accent;

  @override
  Widget build(BuildContext context) {
    // Compact centered pill style (matches Home).
    const barWidth = 390.0;
    const bg = Color.fromRGBO(42, 36, 32, 0.99);
    const inactive = Color(0xFFE5E2E1);
    const activeBg = Color(0xFFB8963E);
    const activeIcon = Color(0xFF3C2F00);

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
                _NavButton(
                  active: activeIndex == 0,
                  icon: Icons.home_rounded,
                  onTap: () => onTap(0),
                  activeBg: activeBg,
                  iconColor: activeIndex == 0 ? activeIcon : inactive,
                ),
                _NavButton(
                  active: activeIndex == 1,
                  icon: Icons.grid_view_rounded,
                  onTap: () => onTap(1),
                  activeBg: activeBg,
                  iconColor: activeIndex == 1 ? activeIcon : inactive,
                ),
                _NavButton(
                  active: activeIndex == 2,
                  icon: Icons.favorite_border_rounded,
                  onTap: () => onTap(2),
                  activeBg: activeBg,
                  iconColor: activeIndex == 2 ? activeIcon : inactive,
                ),
                _NavButton(
                  active: activeIndex == 3,
                  icon: Icons.person_outline_rounded,
                  onTap: () => onTap(3),
                  activeBg: activeBg,
                  iconColor: activeIndex == 3 ? activeIcon : inactive,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _NavButton extends StatelessWidget {
  const _NavButton({
    required this.active,
    required this.icon,
    required this.onTap,
    required this.activeBg,
    required this.iconColor,
  });

  final bool active;
  final IconData icon;
  final VoidCallback onTap;
  final Color activeBg;
  final Color iconColor;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        height: 48,
        width: 48,
        decoration: BoxDecoration(
          color: active ? activeBg : Colors.transparent,
          borderRadius: BorderRadius.circular(10),
        ),
        alignment: Alignment.center,
        child: Icon(icon, color: iconColor, size: 22),
      ),
    );
  }
}

class _WishItem {
  const _WishItem(this.brand, this.title, this.price, this.lowStock, this.imagePath);

  final String brand;
  final String title;
  final String price;
  final bool lowStock;
  final String imagePath;
}

