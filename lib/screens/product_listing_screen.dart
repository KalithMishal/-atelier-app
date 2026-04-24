import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';

import 'filter_drawer_sheet.dart';
import 'product_detail_screen.dart';
import 'wishlist_screen.dart';
import 'profile_screen.dart';
import 'home_screen.dart';

class ProductListingScreen extends StatefulWidget {
  const ProductListingScreen({super.key});

  @override
  State<ProductListingScreen> createState() => _ProductListingScreenState();
}

class _ProductListingScreenState extends State<ProductListingScreen> {
  static const _bg = Color(0xFF131313);
  static const _topBarBg = Color.fromRGBO(0, 0, 0, 0.8);
  static const _card = Color(0xFF2A2420);
  static const _imageBg = Color(0xFF0E0E0E);
  static const _accent = Color(0xFFB8963E);
  static const _text = Color(0xFFF5F0E8);
  static const _muted = Color(0xFFD0C5B2);
  static const _pillBorder = Color.fromRGBO(77, 70, 55, 0.30);
  static const _pillBorderInactive = Color.fromRGBO(77, 70, 55, 0.15);

  final int _activeBottomIndex = 1;
  int _activeChipIndex = 0;

  final _chips = const ['NEW ARRIVALS', 'PRICE', 'SIZE', 'COLOR', 'MATERIAL'];

  final _items = const [
    _ListingItem('ATELIER', 'Silk Noir\nEvening Gown', '\$1,250', true, 3, 'assets/images/pl_silk_noir_gown.png'),
    _ListingItem('ATELIER', 'Oversized\nWool Trench', '\$2,800', false, 3, 'assets/images/pl_oversized_wool_trench.png'),
    _ListingItem('ACCESSORIES', 'Structured\nMonolith Bag', '\$3,400', true, 1, 'assets/images/pl_monolith_bag.png'),
    _ListingItem('ATELIER', 'Draped Crepe\nTrousers', '\$850', false, 3, 'assets/images/pl_draped_crepe_trousers.png'),
    _ListingItem('', '', '', false, 0, 'assets/images/pl_gold_jewelry.png'), // partial card row 3
  ];

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
                _TopBar(
                  backgroundColor: _topBarBg,
                  onBack: () => Navigator.of(context).maybePop(),
                ),
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.fromLTRB(16, 67 - 56, 16, 96),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 24),
                        Center(
                          child: Text(
                            "WOMEN'S\nCOLLECTION",
                            textAlign: TextAlign.center,
                            style: GoogleFonts.notoSerif(
                              fontSize: 30,
                              height: 36 / 30,
                              letterSpacing: 3,
                              color: const Color(0xFFE5E2E1),
                            ),
                          ),
                        ),
                        const SizedBox(height: 24),
                        Padding(
                          padding: const EdgeInsets.only(top: 8),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                '92 PIECES',
                                style: GoogleFonts.plusJakartaSans(
                                  fontSize: 14,
                                  height: 20 / 14,
                                  letterSpacing: 0.7,
                                  color: _muted,
                                ),
                              ),
                              Row(
                                children: [
                                  Text(
                                    'Sort: Newest',
                                    style: GoogleFonts.plusJakartaSans(
                                      fontSize: 14,
                                      height: 20 / 14,
                                      letterSpacing: 0.7,
                                      color: _muted,
                                    ),
                                  ),
                                  const SizedBox(width: 4),
                                  SvgPicture.asset(
                                    'assets/images/icon_sort_chev.svg',
                                    width: 7,
                                    height: 4.32,
                                    colorFilter: const ColorFilter.mode(Color(0xFFD0C5B2), BlendMode.srcIn),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 16),
                        SizedBox(
                          height: 42,
                          child: ListView.separated(
                            scrollDirection: Axis.horizontal,
                            itemCount: _chips.length,
                            separatorBuilder: (context, index) => const SizedBox(width: 12),
                            itemBuilder: (context, index) {
                              final active = index == _activeChipIndex;
                              return GestureDetector(
                            onTap: () {
                              setState(() => _activeChipIndex = index);
                              if (index != 0) {
                                showFilterDrawerSheet(context);
                              }
                            },
                                child: Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 9),
                                  decoration: BoxDecoration(
                                    color: active ? const Color(0xFF1C1B1B) : Colors.transparent,
                                    borderRadius: BorderRadius.circular(9999),
                                    border: Border.all(
                                      color: active ? _pillBorder : _pillBorderInactive,
                                      width: 1,
                                    ),
                                  ),
                                  alignment: Alignment.center,
                                  child: Text(
                                    _chips[index],
                                    style: GoogleFonts.plusJakartaSans(
                                      fontSize: 12,
                                      height: 16 / 12,
                                      letterSpacing: 0.6,
                                      color: active ? const Color(0xFFE0C29A) : const Color(0xFFE5E2E1),
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                        const SizedBox(height: 16),
                        _StaggeredGrid(
                          items: _items,
                          cardColor: _card,
                          imageBg: _imageBg,
                          accent: _accent,
                          text: _text,
                        ),
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

class _TopBar extends StatelessWidget {
  const _TopBar({required this.backgroundColor, required this.onBack});

  final Color backgroundColor;
  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: backgroundColor,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Row(
        children: [
          IconButton(
            onPressed: onBack,
            icon: SvgPicture.asset(
              'assets/images/icon_pl_back.svg',
              width: 16,
              height: 16,
              colorFilter: const ColorFilter.mode(Color(0xFFF5F0E8), BlendMode.srcIn),
            ),
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints.tightFor(width: 32, height: 32),
          ),
          const Spacer(),
          Text(
            'ATELIER',
            style: GoogleFonts.libreBaskerville(
              fontSize: 24,
              letterSpacing: 7.2,
              color: const Color(0xFFF5F0E8),
              fontWeight: FontWeight.w400,
            ),
          ),
          const Spacer(),
          IconButton(
            onPressed: () {},
            icon: SvgPicture.asset(
              'assets/images/icon_pl_bag.svg',
              width: 16,
              height: 20,
              colorFilter: const ColorFilter.mode(Color(0xFFF5F0E8), BlendMode.srcIn),
            ),
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints.tightFor(width: 32, height: 32),
          ),
        ],
      ),
    );
  }
}

class _StaggeredGrid extends StatelessWidget {
  const _StaggeredGrid({
    required this.items,
    required this.cardColor,
    required this.imageBg,
    required this.accent,
    required this.text,
  });

  final List<_ListingItem> items;
  final Color cardColor;
  final Color imageBg;
  final Color accent;
  final Color text;

  @override
  Widget build(BuildContext context) {
    // Mimic Figma’s stagger: right column offset on rows 1 & 2.
    return LayoutBuilder(
      builder: (context, constraints) {
        final gap = 16.0;
        final w = (constraints.maxWidth - gap) / 2;
        return Wrap(
          spacing: gap,
          runSpacing: gap,
          children: [
            SizedBox(width: w, child: _ListingCard(item: items[0], tall: true, offsetTop: 0, cardColor: cardColor, imageBg: imageBg, accent: accent, text: text)),
            SizedBox(width: w, child: _ListingCard(item: items[1], tall: true, offsetTop: 32, cardColor: cardColor, imageBg: imageBg, accent: accent, text: text)),
            SizedBox(width: w, child: _ListingCard(item: items[2], tall: true, offsetTop: 0, cardColor: cardColor, imageBg: imageBg, accent: accent, text: text)),
            SizedBox(width: w, child: _ListingCard(item: items[3], tall: true, offsetTop: 32, cardColor: cardColor, imageBg: imageBg, accent: accent, text: text)),
            SizedBox(width: w, child: _PartialImageCard(cardColor: cardColor, imageBg: imageBg, imageAssetPath: items[4].imageAssetPath)),
          ],
        );
      },
    );
  }
}

class _ListingCard extends StatelessWidget {
  const _ListingCard({
    required this.item,
    required this.tall,
    required this.offsetTop,
    required this.cardColor,
    required this.imageBg,
    required this.accent,
    required this.text,
  });

  final _ListingItem item;
  final bool tall;
  final double offsetTop;
  final Color cardColor;
  final Color imageBg;
  final Color accent;
  final Color text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: offsetTop),
      child: GestureDetector(
        onTap: () {
          Navigator.of(context).push(MaterialPageRoute(builder: (_) => const ProductDetailScreen()));
        },
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Container(
            color: cardColor,
            child: Stack(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      color: imageBg,
                      height: 228,
                      width: double.infinity,
                      child: Opacity(
                        opacity: 0.9,
                        child: Image.asset(
                          item.imageAssetPath,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item.brand,
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 12,
                              height: 16 / 12,
                              letterSpacing: 1.2,
                              color: const Color(0xFFE0C29A),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            item.title,
                            style: GoogleFonts.notoSerif(
                              fontSize: 18,
                              height: 22.5 / 18,
                              color: text,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            item.price,
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 14,
                              height: 20 / 14,
                              color: accent,
                            ),
                          ),
                          const SizedBox(height: 16),
                          Row(
                            children: List.generate(
                              item.dots,
                              (i) => Padding(
                                padding: const EdgeInsets.only(right: 8),
                                child: Container(
                                  width: 8,
                                  height: 8,
                                  decoration: BoxDecoration(
                                    color: i == 0 ? const Color(0xFFE0C29A) : const Color.fromRGBO(224, 194, 154, 0.3),
                                    shape: BoxShape.circle,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                Positioned(
                  right: 16,
                  top: 16,
                  child: SvgPicture.asset(
                    'assets/images/icon_heart_outline.svg',
                    width: 20,
                    height: 18.35,
                    colorFilter: const ColorFilter.mode(Color(0xFFF5F0E8), BlendMode.srcIn),
                  ),
                ),
                if (item.isNew)
                  Positioned(
                    left: 16,
                    top: 16,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                      decoration: BoxDecoration(
                        color: accent,
                        borderRadius: BorderRadius.circular(9999),
                      ),
                      child: Text(
                        'NEW',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 10,
                          height: 15 / 10,
                          letterSpacing: 1,
                          color: const Color(0xFF403000),
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
}

class _PartialImageCard extends StatelessWidget {
  const _PartialImageCard({required this.cardColor, required this.imageBg, required this.imageAssetPath});

  final Color cardColor;
  final Color imageBg;
  final String imageAssetPath;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 16),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Container(
          color: cardColor,
          height: 244,
          child: Stack(
            children: [
              Positioned.fill(
                child: Container(
                  color: imageBg,
                  child: Opacity(
                    opacity: 0.9,
                    child: Image.asset(
                      imageAssetPath,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
              Positioned(
                right: 16,
                top: 16,
                child: SvgPicture.asset(
                  'assets/images/icon_heart_outline.svg',
                  width: 20,
                  height: 18.35,
                  colorFilter: const ColorFilter.mode(Color(0xFFF5F0E8), BlendMode.srcIn),
                ),
              ),
            ],
          ),
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
    return Container(
      width: 390,
      margin: const EdgeInsets.only(bottom: 0.2),
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.only(topLeft: Radius.circular(32), topRight: Radius.circular(32)),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFB8963E).withValues(alpha: 0.06),
            blurRadius: 40,
            offset: const Offset(0, -10),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: const BorderRadius.only(topLeft: Radius.circular(32), topRight: Radius.circular(32)),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 19, vertical: 14),
            color: const Color.fromRGBO(42, 36, 32, 0.99),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _NavButton(active: activeIndex == 0, icon: Icons.home_rounded, onTap: () => onTap(0), accent: accent),
                _NavButton(active: activeIndex == 1, icon: Icons.grid_view_rounded, onTap: () => onTap(1), accent: accent),
                _NavButton(active: activeIndex == 2, icon: Icons.favorite_border_rounded, onTap: () => onTap(2), accent: accent),
                _NavButton(active: activeIndex == 3, icon: Icons.person_outline_rounded, onTap: () => onTap(3), accent: accent),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _NavButton extends StatelessWidget {
  const _NavButton({required this.active, required this.icon, required this.onTap, required this.accent});

  final bool active;
  final IconData icon;
  final VoidCallback onTap;
  final Color accent;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        height: 48,
        width: 48,
        decoration: BoxDecoration(
          color: active ? const Color.fromRGBO(195, 158, 61, 0.44) : Colors.transparent,
          borderRadius: BorderRadius.circular(10),
        ),
        alignment: Alignment.center,
        child: Icon(icon, color: active ? accent : const Color(0xFFD1C5B4), size: 22),
      ),
    );
  }
}

class _ListingItem {
  const _ListingItem(this.brand, this.title, this.price, this.isNew, this.dots, this.imageAssetPath);

  final String brand;
  final String title;
  final String price;
  final bool isNew;
  final int dots;
  final String imageAssetPath;
}

