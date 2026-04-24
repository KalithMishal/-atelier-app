import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';

import 'home_screen.dart';
import 'product_listing_screen.dart';
import 'wishlist_screen.dart';
import 'profile_screen.dart';
import 'search_discovery_screen.dart';
import 'shopping_bag_screen.dart';
import 'notifications_screen.dart';

class CategoryLandingScreen extends StatefulWidget {
  const CategoryLandingScreen({super.key});

  @override
  State<CategoryLandingScreen> createState() => _CategoryLandingScreenState();
}

class _CategoryLandingScreenState extends State<CategoryLandingScreen> {
  final int _activeBottomIndex = 0;

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
                _TopAppBar(),
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.only(bottom: 96),
                    child: Column(
                      children: [
                        _Hero(),
                        const SizedBox(height: 32),
                        _TileGrid(),
                        const SizedBox(height: 48),
                        _NewArrivals(),
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
  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFF080808),
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Row(
        children: [
          IconButton(
            onPressed: () => Navigator.of(context).maybePop(),
            icon: SvgPicture.asset(
              'assets/images/icon_menu.svg',
              width: 18,
              height: 12,
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
            ),
          ),
          const Spacer(),
          Row(
            children: [
              IconButton(
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(builder: (_) => const SearchDiscoveryScreen()));
                },
                icon: SvgPicture.asset(
                  'assets/images/icon_search.svg',
                  width: 24,
                  height: 24,
                  colorFilter: const ColorFilter.mode(Color(0xFFF5F0E8), BlendMode.srcIn),
                ),
              ),
              const SizedBox(width: 8),
              IconButton(
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(builder: (_) => const ShoppingBagScreen()));
                },
                icon: SvgPicture.asset(
                  'assets/images/icon_bag.svg',
                  width: 16,
                  height: 20,
                  colorFilter: const ColorFilter.mode(Color(0xFFF5F0E8), BlendMode.srcIn),
                ),
              ),
              const SizedBox(width: 8),
              IconButton(
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(builder: (_) => const NotificationsScreen()));
                },
                icon: SvgPicture.asset(
                  'assets/images/icon_bell.svg',
                  width: 24,
                  height: 24,
                  colorFilter: const ColorFilter.mode(Color(0xFFF5F0E8), BlendMode.srcIn),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _Hero extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 260,
      width: double.infinity,
      color: const Color(0xFF1C1B1B),
      child: Stack(
        fit: StackFit.expand,
        children: [
          Opacity(
            opacity: 0.6,
            child: Image.asset('assets/images/cat_hero_women.png', fit: BoxFit.cover),
          ),
          const DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
                colors: [Color(0xFF131313), Color.fromRGBO(19, 19, 19, 0.0)],
                stops: [0.0, 1.0],
              ),
            ),
          ),
          Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'WOMEN',
                  style: GoogleFonts.notoSerif(
                    fontSize: 48,
                    height: 48 / 48,
                    letterSpacing: 4.8,
                    color: const Color(0xFFE5E2E1),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'SPRING SUMMER 2025',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 14,
                    height: 20 / 14,
                    letterSpacing: 2.8,
                    color: const Color(0xFFE0C29A),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _TileGrid extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Widget tile(String label, String asset) => GestureDetector(
          onTap: () {
            Navigator.of(context).push(MaterialPageRoute(builder: (_) => const ProductListingScreen()));
          },
          child: Column(
          children: [
            Expanded(
              child: Container(
                color: const Color(0xFF201F1F),
                child: Opacity(opacity: 0.8, child: Image.asset(asset, fit: BoxFit.cover, width: double.infinity)),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              label,
              style: GoogleFonts.plusJakartaSans(
                fontSize: 12,
                height: 16 / 12,
                letterSpacing: 1.2,
                color: const Color(0xFFE5E2E1),
              ),
            ),
          ],
          ),
        );

    return SizedBox(
      width: 342,
      height: 235.75 * 2 + 16,
      child: GridView.count(
        crossAxisCount: 2,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 1 / 1.1,
        physics: const NeverScrollableScrollPhysics(),
        children: [
          tile('DRESSES', 'assets/images/cat_dresses.png'),
          tile('TOPS', 'assets/images/cat_tops.png'),
          tile('TROUSERS', 'assets/images/cat_trousers.png'),
          tile('OUTERWEAR', 'assets/images/cat_outerwear.png'),
        ],
      ),
    );
  }
}

class _NewArrivals extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Widget product(String name, String color, String price, String asset) => GestureDetector(
          onTap: () {
            Navigator.of(context).push(MaterialPageRoute(builder: (_) => const ProductListingScreen()));
          },
          child: SizedBox(
          width: 240,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                color: const Color(0xFF201F1F),
                height: 320,
                child: Opacity(opacity: 0.8, child: Image.asset(asset, fit: BoxFit.cover, width: double.infinity)),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(name, style: GoogleFonts.notoSerif(fontSize: 14, height: 20 / 14, color: const Color(0xFFE5E2E1))),
                      Opacity(
                        opacity: 0.7,
                        child: Text(color, style: GoogleFonts.plusJakartaSans(fontSize: 12, height: 16 / 12, color: const Color(0xFFD0C5B2))),
                      ),
                    ],
                  ),
                  Text(price, style: GoogleFonts.plusJakartaSans(fontSize: 14, height: 20 / 14, color: const Color(0xFFE0C29A))),
                ],
              ),
            ],
          ),
          ),
        );

    return Padding(
      padding: const EdgeInsets.only(left: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(right: 24),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('NEW ARRIVALS', style: GoogleFonts.notoSerif(fontSize: 24, height: 32 / 24, letterSpacing: 1.2, color: const Color(0xFFE5E2E1))),
                Text('VIEW ALL', style: GoogleFonts.plusJakartaSans(fontSize: 12, height: 16 / 12, letterSpacing: 1.2, color: const Color(0xFFE0C29A))),
              ],
            ),
          ),
          const SizedBox(height: 32),
          SizedBox(
            height: 408,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                product('Silk Georgette Gown', 'Midnight', '\$1,250', 'assets/images/cat_new_gown.png'),
                const SizedBox(width: 24),
                product('Tailored Wool Blazer', 'Oat', '\$890', 'assets/images/cat_new_blazer.png'),
                const SizedBox(width: 24),
                product('Pleated Wide-Leg Trouser', 'Graphite', '\$540', 'assets/images/cat_new_trouser.png'),
                const SizedBox(width: 24),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _BottomNavBar extends StatelessWidget {
  const _BottomNavBar({required this.activeIndex, required this.onTap, required this.accent});
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
          BoxShadow(color: const Color(0xFFB8963E).withValues(alpha: 0.06), blurRadius: 40, offset: const Offset(0, -10)),
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

