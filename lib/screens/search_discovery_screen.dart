import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';

import 'home_screen.dart';
import 'wishlist_screen.dart';
import 'profile_screen.dart';
import 'category_landing_screen.dart';
import 'product_detail_screen.dart';
import 'shopping_bag_screen.dart';
import 'notifications_screen.dart';
import 'product_listing_screen.dart';

class SearchDiscoveryScreen extends StatefulWidget {
  const SearchDiscoveryScreen({super.key});

  @override
  State<SearchDiscoveryScreen> createState() => _SearchDiscoveryScreenState();
}

class _SearchDiscoveryScreenState extends State<SearchDiscoveryScreen> {
  static const _bg = Color(0xFF131313);
  static const _top = Color(0xFF080808);
  static const _accent = Color(0xFFE8C265);
  static const _luxGold = Color(0xFFB8963E);
  static const _title = Color(0xFFF5F0E8);
  static const double _webMaxWidth = 1100;

  final int _activeBottomIndex = 1; // search icon position in this screen's Figma

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
                _TopBar(),
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.fromLTRB(0, 24, 0, 96),
                    child: Center(
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: _webMaxWidth),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 4),
                            _SearchBar(),
                            const SizedBox(height: 40),
                            _Trending(),
                            const SizedBox(height: 28),
                            _CategoriesGrid(),
                            const SizedBox(height: 24),
                            _CuratedEdits(),
                            const SizedBox(height: 24),
                            _RecentArrivals(),
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
                    accent: const Color(0xFFE9C349),
                    translucent: true,
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
        target = const SearchDiscoveryScreen();
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
  @override
  Widget build(BuildContext context) {
    return Container(
      color: _SearchDiscoveryScreenState._top,
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: _SearchDiscoveryScreenState._webMaxWidth),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            child: LayoutBuilder(
              builder: (context, constraints) {
                const iconSlot = 40.0;
                const iconGap = 12.0;
                final rightClusterWidth = (iconSlot * 2) + iconGap;
                final leftClusterWidth = iconSlot;
                final availableForTitle = constraints.maxWidth - leftClusterWidth - rightClusterWidth;

                return Row(
                  children: [
                    SizedBox(
                      width: leftClusterWidth,
                      child: IconButton(
                        onPressed: () => Navigator.of(context).maybePop(),
                        icon: const Icon(Icons.menu_rounded, size: 22, color: _SearchDiscoveryScreenState._luxGold),
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
                              color: _SearchDiscoveryScreenState._title,
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: rightClusterWidth,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          IconButton(
                            onPressed: () {
                              Navigator.of(context).push(MaterialPageRoute(builder: (_) => const ShoppingBagScreen()));
                            },
                            icon: const Icon(Icons.shopping_bag_outlined, size: 20, color: _SearchDiscoveryScreenState._luxGold),
                            padding: EdgeInsets.zero,
                            constraints: const BoxConstraints.tightFor(width: iconSlot, height: iconSlot),
                          ),
                          const SizedBox(width: iconGap),
                          IconButton(
                            onPressed: () {
                              Navigator.of(context).push(MaterialPageRoute(builder: (_) => const NotificationsScreen()));
                            },
                            icon: const Icon(Icons.notifications_none_rounded, size: 22, color: _SearchDiscoveryScreenState._luxGold),
                            padding: EdgeInsets.zero,
                            constraints: const BoxConstraints.tightFor(width: iconSlot, height: iconSlot),
                          ),
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

class _SearchBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 560),
        child: Container(
          width: double.infinity,
          height: 56,
          padding: const EdgeInsets.symmetric(horizontal: 20),
          decoration: BoxDecoration(
            color: const Color(0xFF201F1F),
            borderRadius: BorderRadius.circular(9999),
            boxShadow: const [
              BoxShadow(color: Color.fromRGBO(0, 0, 0, 0.2), blurRadius: 20, offset: Offset(0, 4)),
            ],
          ),
          child: Row(
            children: [
              SvgPicture.asset(
                'assets/images/icon_searchbar.svg',
                width: 18,
                height: 18,
                colorFilter: const ColorFilter.mode(Color(0xFF99907E), BlendMode.srcIn),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  'Explore collections, designers, items...',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 14,
                    color: const Color.fromRGBO(153, 144, 126, 0.7),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Trending extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Widget chip(String text) => Container(
          padding: const EdgeInsets.symmetric(horizontal: 21, vertical: 9),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(9999),
            border: Border.all(color: const Color.fromRGBO(232, 194, 101, 0.4), width: 1),
          ),
          child: Text(
            text,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 12,
              height: 16 / 12,
              letterSpacing: 0.6,
              color: const Color(0xFFE5E2E1),
            ),
          ),
        );

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'TRENDING',
            style: GoogleFonts.notoSerif(
              fontSize: 12,
              height: 16 / 12,
              letterSpacing: 2.4,
              color: _SearchDiscoveryScreenState._accent,
            ),
          ),
          const SizedBox(height: 20),
          Wrap(
            spacing: 12,
            runSpacing: 14,
            children: [
              chip('Evening Dresses'),
              chip('Leather Goods'),
              chip('Cashmere'),
              chip('Fine Jewelry'),
            ],
          ),
        ],
      ),
    );
  }
}

class _CategoriesGrid extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Widget tile(String label, String asset) => GestureDetector(
          onTap: () {
            Navigator.of(context).push(MaterialPageRoute(builder: (_) => const CategoryLandingScreen()));
          },
          child: ClipRRect(
          child: Stack(
            children: [
              Image.asset(asset, height: 217.33, width: double.infinity, fit: BoxFit.cover),
              const DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                    colors: [Color.fromRGBO(19, 19, 19, 0.9), Color.fromRGBO(19, 19, 19, 0.0)],
                    stops: [0.0, 1.0],
                  ),
                ),
                child: SizedBox.expand(),
              ),
              Positioned.fill(
                child: Padding(
                  padding: const EdgeInsets.all(8),
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: const Color.fromRGBO(232, 194, 101, 0.2)),
                    ),
                  ),
                ),
              ),
              Positioned(
                left: 0,
                right: 0,
                bottom: 20,
                child: Center(
                  child: Text(
                    label,
                    style: GoogleFonts.notoSerif(
                      fontSize: 14,
                      height: 20 / 14,
                      letterSpacing: 2.8,
                      color: const Color(0xFFE5E2E1),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        );

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final cols = constraints.maxWidth >= 900 ? 4 : (constraints.maxWidth >= 560 ? 3 : 2);
          return GridView(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: cols,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              childAspectRatio: 1,
            ),
            children: [
              tile('WOMEN', 'assets/images/search_cat_women.png'),
              tile('MEN', 'assets/images/search_cat_men.png'),
              tile('HOME', 'assets/images/search_cat_home.png'),
              tile('JEWELRY', 'assets/images/search_cat_jewelry.png'),
            ],
          );
        },
      ),
    );
  }
}

class _CuratedEdits extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Widget card(String title, String subtitle, String asset) => ClipRRect(
          borderRadius: BorderRadius.circular(48),
          child: Stack(
            children: [
              Image.asset(asset, width: 280, height: 175, fit: BoxFit.cover),
              const DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                    colors: [Color(0xFF131313), Color.fromRGBO(19, 19, 19, 0.0)],
                    stops: [0.0, 1.0],
                  ),
                ),
                child: SizedBox(width: 280, height: 175),
              ),
              Positioned(
                left: 24,
                bottom: 24,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: GoogleFonts.notoSerif(fontSize: 24, height: 32 / 24, color: const Color(0xFFE5E2E1))),
                    Text(subtitle, style: GoogleFonts.plusJakartaSans(fontSize: 12, height: 16 / 12, letterSpacing: 0.6, color: const Color(0xFFD0C5B2))),
                  ],
                ),
              ),
            ],
          ),
        );

    return Padding(
      padding: const EdgeInsets.only(left: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'CURATED EDITS',
            style: GoogleFonts.notoSerif(fontSize: 12, height: 16 / 12, letterSpacing: 2.4, color: _SearchDiscoveryScreenState._accent),
          ),
          const SizedBox(height: 24),
          SizedBox(
            height: 191,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                card('The Classic Edit', 'Timeless Foundations', 'assets/images/search_edit_classic.png'),
                const SizedBox(width: 20),
                card('Quiet Luxury', 'Subtle Elegance', 'assets/images/search_edit_quiet.png'),
                const SizedBox(width: 24),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _RecentArrivals extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Widget smallProduct(String brand, String title, String price, String asset) => GestureDetector(
          onTap: () {
            Navigator.of(context).push(MaterialPageRoute(builder: (_) => const ProductDetailScreen()));
          },
          child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(32),
              child: Stack(
                children: [
                  Container(
                    color: const Color(0xFF201F1F),
                    child: Opacity(
                      opacity: 0.8,
                      child: Image.asset(asset, width: 163, height: 217.33, fit: BoxFit.cover),
                    ),
                  ),
                  Positioned(
                    right: 12,
                    top: 12,
                    child: SvgPicture.asset(
                      'assets/images/icon_fav_small.svg',
                      width: 20,
                      height: 18.35,
                      colorFilter: const ColorFilter.mode(Color(0xFFE5E2E1), BlendMode.srcIn),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            Text(brand, style: GoogleFonts.notoSerif(fontSize: 12, height: 16 / 12, letterSpacing: 1.2, color: _SearchDiscoveryScreenState._accent)),
            Text(title, style: GoogleFonts.plusJakartaSans(fontSize: 14, height: 20 / 14, color: const Color(0xFFE5E2E1))),
            Text(price, style: GoogleFonts.notoSerif(fontSize: 14, height: 20 / 14, letterSpacing: 0.7, color: _SearchDiscoveryScreenState._accent)),
          ],
        ),
        );

    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 24, 24, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('RECENT ARRIVALS', style: GoogleFonts.notoSerif(fontSize: 12, height: 16 / 12, letterSpacing: 2.4, color: _SearchDiscoveryScreenState._accent)),
              InkWell(
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(builder: (_) => const ProductListingScreen()));
                },
                borderRadius: BorderRadius.circular(8),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                  child: Text(
                    'VIEW ALL',
                    style: GoogleFonts.notoSerif(
                      fontSize: 12,
                      height: 16 / 12,
                      letterSpacing: 2.4,
                      color: const Color(0xFF99907E),
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              Expanded(child: smallProduct('MAISON NOIR', 'Silk Crepe Evening Gown', '\$3,200', 'assets/images/search_recent_gown.png')),
              const SizedBox(width: 16),
              Expanded(child: smallProduct('AURELIA', 'Structured Calfskin Tote', '\$1,850', 'assets/images/search_recent_tote.png')),
            ],
          ),
        ],
      ),
    );
  }
}

class _BottomNavBar extends StatelessWidget {
  const _BottomNavBar({
    required this.activeIndex,
    required this.onTap,
    required this.accent,
    required this.translucent,
  });

  final int activeIndex;
  final ValueChanged<int> onTap;
  final Color accent;
  final bool translucent;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 390,
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
            height: 80,
            color: translucent ? const Color.fromRGBO(42, 36, 32, 0.6) : const Color.fromRGBO(42, 36, 32, 0.99),
            padding: const EdgeInsets.symmetric(horizontal: 19, vertical: 14),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _NavButton(active: activeIndex == 0, icon: Icons.home_rounded, onTap: () => onTap(0), accent: accent),
                _NavButton(active: activeIndex == 1, icon: Icons.search_rounded, onTap: () => onTap(1), accent: accent),
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

