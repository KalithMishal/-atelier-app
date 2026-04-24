import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';

import 'product_listing_screen.dart';
import 'screens_hub_screen.dart';
import 'search_discovery_screen.dart';
import 'shopping_bag_screen.dart';
import 'category_landing_screen.dart';
import 'product_detail_screen.dart';
import 'wishlist_screen.dart';
import 'profile_screen.dart';
import 'notifications_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _activeBottomIndex = 0;
  int _activeCategoryIndex = 0;

  static const _bg = Color(0xFF131313);
  static const _topBarBg = Color(0xFF080808);
  static const _topBarIcon = Color(0xFFB8963E);
  static const _textPrimary = Color(0xFFE5E2E1);
  static const _textMuted = Color(0xFFD1C5B4);
  static const _accent = Color(0xFFE9C349);

  static const _border = Color.fromRGBO(78, 70, 57, 0.20);
  static const _cardBg = Color(0xFF1C1B1B);

  final _categories = const ['ALL', 'WOMEN', 'MEN', 'ACCESSORIES'];

  final _products = const [
    _Product('The Nude Tote', '\$1,250', 'assets/images/product_nude_tote.png'),
    _Product('Architectural Drops', '\$480', 'assets/images/product_architectural_drops.png'),
    _Product('Silk Slip Dress', '\$890', 'assets/images/product_silk_slip_dress.png'),
    _Product('Sculptural Heels', '\$1,100', 'assets/images/product_sculptural_heels.png'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bg,
      body: LayoutBuilder(
        builder: (context, constraints) {
          // Web mode: use the full available width (no 390px frame).
          return SafeArea(
            bottom: false,
            child: Stack(
              children: [
                Column(
                  children: [
                    _TopAppBar(
                      backgroundColor: _topBarBg,
                      titleColor: const Color(0xFFF5F0E8),
                      iconColor: _topBarIcon,
                    ),
                    Expanded(
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.fromLTRB(16, 24, 16, 96),
                        child: Center(
                          child: ConstrainedBox(
                            constraints: const BoxConstraints(maxWidth: 1100),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _HeroCard(
                                  accent: _accent,
                                  titleColor: _textPrimary,
                                ),
                                const SizedBox(height: 48),
                                _CategoryRow(
                                  categories: _categories,
                                  activeIndex: _activeCategoryIndex,
                                  onTap: (idx) => setState(() => _activeCategoryIndex = idx),
                                  accent: _accent,
                                  muted: _textMuted,
                                  border: _border,
                                ),
                                const SizedBox(height: 48),
                                _SectionHeader(
                                  title: 'ATELIER PICKS',
                                  action: 'VIEW ALL',
                                  titleColor: _textPrimary,
                                  actionColor: _textMuted,
                                  onActionTap: () {
                                    Navigator.of(context).push(
                                      MaterialPageRoute(builder: (_) => const ProductListingScreen()),
                                    );
                                  },
                                ),
                                const SizedBox(height: 24),
                                GridView.builder(
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemCount: _products.length,
                                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: constraints.maxWidth >= 1000 ? 4 : (constraints.maxWidth >= 700 ? 3 : 2),
                                    mainAxisSpacing: 16,
                                    crossAxisSpacing: 16,
                                    childAspectRatio: 1 / 1.38,
                                  ),
                                  itemBuilder: (context, index) {
                                    final p = _products[index];
                                    return _ProductCard(
                                      title: p.title,
                                      price: p.price,
                                      imageAssetPath: p.imageAssetPath,
                                      accent: _accent,
                                      titleColor: _textPrimary,
                                      cardBg: _cardBg,
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
                        onTap: (idx) {
                          setState(() => _activeBottomIndex = idx);
                          _navigateBottom(context, idx);
                        },
                        accent: _accent,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  void _navigateBottom(BuildContext context, int idx) {
    if (idx == 0) return;
    Widget target;
    switch (idx) {
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
  const _TopAppBar({
    required this.backgroundColor,
    required this.titleColor,
    required this.iconColor,
  });

  final Color backgroundColor;
  final Color titleColor;
  final Color iconColor;
  static const double _iconSlot = 40;
  static const double _iconGap = 12;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 64,
      width: double.infinity,
      child: DecoratedBox(
        decoration: BoxDecoration(color: backgroundColor),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 1100),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final rightClusterWidth = (_iconSlot * 3) + (_iconGap * 2);
                  final leftClusterWidth = _iconSlot;
                  final availableForTitle = constraints.maxWidth - leftClusterWidth - rightClusterWidth;

                  return Row(
                    children: [
                      SizedBox(
                        width: leftClusterWidth,
                        child: IconButton(
                          onPressed: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(builder: (_) => const ScreensHubScreen()),
                            );
                          },
                          icon: Icon(Icons.menu_rounded, color: iconColor, size: 22),
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints.tightFor(width: _iconSlot, height: _iconSlot),
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
                                color: titleColor,
                                fontWeight: FontWeight.w400,
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
                                Navigator.of(context).push(
                                  MaterialPageRoute(builder: (_) => const SearchDiscoveryScreen()),
                                );
                              },
                              icon: Icon(Icons.search_rounded, color: iconColor, size: 22),
                              padding: EdgeInsets.zero,
                              constraints: const BoxConstraints.tightFor(width: _iconSlot, height: _iconSlot),
                            ),
                            const SizedBox(width: _iconGap),
                            IconButton(
                              onPressed: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(builder: (_) => const ShoppingBagScreen()),
                                );
                              },
                              icon: Icon(Icons.shopping_bag_outlined, color: iconColor, size: 20),
                              padding: EdgeInsets.zero,
                              constraints: const BoxConstraints.tightFor(width: _iconSlot, height: _iconSlot),
                            ),
                            const SizedBox(width: _iconGap),
                            IconButton(
                              onPressed: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(builder: (_) => const NotificationsScreen()),
                                );
                              },
                              icon: Icon(Icons.notifications_none_rounded, color: iconColor, size: 22),
                              padding: EdgeInsets.zero,
                              constraints: const BoxConstraints.tightFor(width: _iconSlot, height: _iconSlot),
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
      ),
    );
  }
}

class _HeroCard extends StatelessWidget {
  const _HeroCard({
    required this.accent,
    required this.titleColor,
  });

  final Color accent;
  final Color titleColor;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: AspectRatio(
        aspectRatio: 358 / 530,
        child: Stack(
          fit: StackFit.expand,
          children: [
            Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Color(0xFF111111),
                    Color(0xFF0E0E0E),
                  ],
                ),
              ),
              child: Opacity(
                opacity: 0.9,
                child: Image.asset(
                  'assets/images/home_hero.png',
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  stops: [0.0, 0.55, 1.0],
                  colors: [
                    Color.fromRGBO(14, 14, 14, 0.0),
                    Color.fromRGBO(14, 14, 14, 0.5),
                    Color(0xFF0E0E0E),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    'FALL / WINTER COLLECTION',
                    style: GoogleFonts.manrope(
                      fontSize: 16,
                      letterSpacing: 3.2,
                      color: accent,
                      height: 24 / 16,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'The New\nSilhouette',
                    style: GoogleFonts.notoSerif(
                      fontSize: 36,
                      letterSpacing: -0.9,
                      height: 45 / 36,
                      color: titleColor,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  const SizedBox(height: 16),
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(builder: (_) => const CategoryLandingScreen()),
                      );
                    },
                    child: _UnderlinedLink(text: 'DISCOVER MORE', color: accent),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _UnderlinedLink extends StatelessWidget {
  const _UnderlinedLink({required this.text, required this.color});

  final String text;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return IntrinsicWidth(
      child: Container(
        padding: const EdgeInsets.only(bottom: 5),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: _HomeScreenState._border,
              width: 1,
            ),
          ),
        ),
        child: Text(
          text,
          style: GoogleFonts.manrope(
            fontSize: 14,
            letterSpacing: 1.4,
            color: color,
            height: 20 / 14,
          ),
        ),
      ),
    );
  }
}

class _CategoryRow extends StatelessWidget {
  const _CategoryRow({
    required this.categories,
    required this.activeIndex,
    required this.onTap,
    required this.accent,
    required this.muted,
    required this.border,
  });

  final List<String> categories;
  final int activeIndex;
  final ValueChanged<int> onTap;
  final Color accent;
  final Color muted;
  final Color border;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: categories.length,
        separatorBuilder: (context, index) => const SizedBox(width: 12),
        itemBuilder: (context, index) {
          final isActive = index == activeIndex;
          return GestureDetector(
            onTap: () {
              onTap(index);
              if (index != 0) {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => const CategoryLandingScreen()),
                );
              }
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 160),
              padding: EdgeInsets.symmetric(horizontal: isActive ? 24 : 25, vertical: isActive ? 9.5 : 9),
              decoration: BoxDecoration(
                color: isActive ? const Color(0xFF2A2A2A) : Colors.transparent,
                borderRadius: BorderRadius.circular(12),
                border: isActive ? null : Border.all(color: border, width: 1),
              ),
              alignment: Alignment.center,
              child: Text(
                categories[index],
                style: GoogleFonts.manrope(
                  fontSize: 12,
                  letterSpacing: 1.2,
                  color: isActive ? accent : muted,
                  height: 16 / 12,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({
    required this.title,
    required this.action,
    required this.titleColor,
    required this.actionColor,
    required this.onActionTap,
  });

  final String title;
  final String action;
  final Color titleColor;
  final Color actionColor;
  final VoidCallback onActionTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: GoogleFonts.notoSerif(
              fontSize: 24,
              letterSpacing: 0.6,
              color: titleColor,
              height: 32 / 24,
              fontWeight: FontWeight.w400,
            ),
          ),
          InkWell(
            onTap: onActionTap,
            borderRadius: BorderRadius.circular(8),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
              child: Text(
                action,
                style: GoogleFonts.manrope(
                  fontSize: 12,
                  letterSpacing: 1.2,
                  color: actionColor,
                  height: 16 / 12,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ProductCard extends StatelessWidget {
  const _ProductCard({
    required this.title,
    required this.price,
    required this.imageAssetPath,
    required this.accent,
    required this.titleColor,
    required this.cardBg,
  });

  final String title;
  final String price;
  final String imageAssetPath;
  final Color accent;
  final Color titleColor;
  final Color cardBg;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(builder: (_) => const ProductDetailScreen()));
      },
      child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(0),
            child: Container(
              color: cardBg,
              child: Opacity(
                opacity: 0.8,
                child: Image.asset(
                  imageAssetPath,
                  fit: BoxFit.cover,
                  width: double.infinity,
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 16),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: GoogleFonts.manrope(
                  fontSize: 14,
                  color: titleColor,
                  height: 20 / 14,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                price,
                style: GoogleFonts.manrope(
                  fontSize: 14,
                  color: accent,
                  height: 20 / 14,
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
    // Compact pill style (like the user's 2nd screenshot).
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
                  activeBg: activeBg,
                  icon: Icons.home_rounded,
                  onTap: () => onTap(0),
                  iconColor: activeIndex == 0 ? activeIcon : inactive,
                ),
                _NavButton(
                  active: activeIndex == 1,
                  activeBg: activeBg,
                  icon: Icons.grid_view_rounded,
                  onTap: () => onTap(1),
                  iconColor: activeIndex == 1 ? activeIcon : inactive,
                ),
                _NavButton(
                  active: activeIndex == 2,
                  activeBg: activeBg,
                  icon: Icons.favorite_border_rounded,
                  onTap: () => onTap(2),
                  iconColor: activeIndex == 2 ? activeIcon : inactive,
                ),
                _NavButton(
                  active: activeIndex == 3,
                  activeBg: activeBg,
                  icon: Icons.person_outline_rounded,
                  onTap: () => onTap(3),
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
    required this.activeBg,
    required this.icon,
    required this.onTap,
    required this.iconColor,
  });

  final bool active;
  final Color activeBg;
  final IconData icon;
  final VoidCallback onTap;
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

class _Product {
  const _Product(this.title, this.price, this.imageAssetPath);

  final String title;
  final String price;
  final String imageAssetPath;
}

