import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';

import 'product_reviews_screen.dart';
import 'size_guide_screen.dart';
import 'notifications_screen.dart';
import 'search_discovery_screen.dart';
import 'shopping_bag_screen.dart';
import 'wishlist_screen.dart';

/// Product Detail (13) — matches the provided Figma/PNG layout.
class ProductDetailScreen extends StatefulWidget {
  const ProductDetailScreen({super.key});

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  int _selectedSize = 1; // IT 38
  int _selectedColor = 0;

  static const _bg = Color(0xFF080808);

  static const _overlayMaxW = 520.0;
  static const _overlayMinW = 390.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bg,
      body: LayoutBuilder(
        builder: (context, viewport) {
          final overlayW = viewport.maxWidth.clamp(_overlayMinW, _overlayMaxW).toDouble();

          return Center(
            child: SizedBox(
              width: overlayW,
              height: viewport.maxHeight,
              child: CustomScrollView(
                slivers: [
                  SliverToBoxAdapter(
                    child: SizedBox(
                      height: 560,
                      child: Stack(
                        children: [
                          Positioned.fill(
                            child: Opacity(
                              opacity: 0.95,
                              child: Image.asset('assets/images/pd_valentino_gown.png', fit: BoxFit.cover),
                            ),
                          ),
                          const Positioned.fill(
                            child: DecoratedBox(
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.bottomCenter,
                                  end: Alignment.topCenter,
                                  colors: [Color(0xFF080808), Color.fromRGBO(8, 8, 8, 0.0)],
                                  stops: [0.0, 0.62],
                                ),
                              ),
                            ),
                          ),
                          const Positioned(left: 0, right: 0, top: 0, child: SafeArea(bottom: false, child: _TopBar())),
                          const Positioned(left: 24, bottom: 24 + 128, child: _FilmstripLeft()),
                          const Positioned(right: 24, bottom: 24 + 128, child: _HeartRight()),
                          const Positioned(left: 24, right: 24, bottom: 24, child: _BottomCtas()),
                        ],
                      ),
                    ),
                  ),
                  SliverToBoxAdapter(
                    child: _DetailsCard(
                      selectedSize: _selectedSize,
                      onSelectSize: (i) => setState(() => _selectedSize = i),
                      selectedColor: _selectedColor,
                      onSelectColor: (i) => setState(() => _selectedColor = i),
                    ),
                  ),
                  const SliverToBoxAdapter(child: SizedBox(height: 24)),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class _TopBar extends StatelessWidget {
  const _TopBar();

  static const _luxGold = Color(0xFFB8963E);
  static const _title = Color(0xFFF5F0E8);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 64,
      color: const Color(0xFF080808),
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
                  onPressed: () => Navigator.of(context).maybePop(),
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
                  children: [
                    IconButton(
                      onPressed: () {
                        Navigator.of(context).push(MaterialPageRoute(builder: (_) => const SearchDiscoveryScreen()));
                      },
                      icon: const Icon(Icons.search_rounded, size: 22, color: _luxGold),
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints.tightFor(width: iconSlot, height: iconSlot),
                    ),
                    const SizedBox(width: iconGap),
                    IconButton(
                      onPressed: () {
                        Navigator.of(context).push(MaterialPageRoute(builder: (_) => const ShoppingBagScreen()));
                      },
                      icon: const Icon(Icons.shopping_bag_outlined, size: 20, color: _luxGold),
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints.tightFor(width: iconSlot, height: iconSlot),
                    ),
                    const SizedBox(width: iconGap),
                    IconButton(
                      onPressed: () {
                        Navigator.of(context).push(MaterialPageRoute(builder: (_) => const NotificationsScreen()));
                      },
                      icon: const Icon(Icons.notifications_none_rounded, size: 22, color: _luxGold),
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
    );
  }
}

class _FilmstripLeft extends StatelessWidget {
  const _FilmstripLeft();

  @override
  Widget build(BuildContext context) {
    Widget thumb({required bool active}) => Container(
          width: 48,
          height: 64,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(6),
            border: Border.all(
              color: active ? const Color(0xFFB8963E) : const Color.fromRGBO(245, 240, 232, 0.3),
              width: active ? 2 : 1,
            ),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: Opacity(
              opacity: active ? 1 : 0.6,
              child: Image.asset('assets/images/pd_valentino_gown.png', fit: BoxFit.cover),
            ),
          ),
        );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(9999),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 2, sigmaY: 2),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              color: const Color.fromRGBO(0, 0, 0, 0.4),
              child: Text(
                '02 / 06',
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  height: 20 / 14,
                  letterSpacing: 1.4,
                  color: const Color(0xFFF5F0E8),
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 12),
        thumb(active: false),
        const SizedBox(height: 12),
        thumb(active: true),
        const SizedBox(height: 12),
        thumb(active: false),
      ],
    );
  }
}

class _HeartRight extends StatelessWidget {
  const _HeartRight();

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(9999),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
        child: GestureDetector(
          onTap: () {
            Navigator.of(context).push(MaterialPageRoute(builder: (_) => const WishlistScreen()));
          },
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: const BoxDecoration(
              color: Color.fromRGBO(255, 255, 255, 0.0),
              boxShadow: [
                BoxShadow(color: Color.fromRGBO(184, 150, 62, 0.1), blurRadius: 40, offset: Offset(0, 10)),
              ],
            ),
            child: SvgPicture.asset(
              'assets/images/icon_heart_fill.svg',
              width: 19,
              height: 17,
              colorFilter: const ColorFilter.mode(Color(0xFFF5F0E8), BlendMode.srcIn),
            ),
          ),
        ),
      ),
    );
  }
}

class _BottomCtas extends StatelessWidget {
  const _BottomCtas();

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: double.infinity,
          decoration: BoxDecoration(
            gradient: const LinearGradient(colors: [Color(0xFFB8963E), Color(0xFFC4A882)]),
            borderRadius: BorderRadius.circular(9999),
            boxShadow: const [
              BoxShadow(color: Color.fromRGBO(184, 150, 62, 0.2), blurRadius: 20, offset: Offset(0, 4)),
            ],
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(9999),
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(builder: (_) => const ShoppingBagScreen()));
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 16),
                child: Center(
                  child: Text(
                    'ADD TO BAG',
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      height: 20 / 14,
                      letterSpacing: 1.4,
                      color: const Color(0xFFF5F0E8),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 16),
        Container(
          width: double.infinity,
          decoration: BoxDecoration(
            border: Border.all(color: const Color.fromRGBO(229, 231, 235, 0.6), width: 1),
            borderRadius: BorderRadius.circular(9999),
          ),
          padding: const EdgeInsets.symmetric(vertical: 17),
          alignment: Alignment.center,
          child: Text(
            'RESERVE IN BOUTIQUE',
            style: GoogleFonts.poppins(
              fontSize: 14,
              height: 20 / 14,
              letterSpacing: 1.4,
              color: const Color(0xFFF5F0E8),
            ),
          ),
        ),
      ],
    );
  }
}

class _DetailsCard extends StatelessWidget {
  const _DetailsCard({
    required this.selectedSize,
    required this.onSelectSize,
    required this.selectedColor,
    required this.onSelectColor,
  });

  final int selectedSize;
  final ValueChanged<int> onSelectSize;
  final int selectedColor;
  final ValueChanged<int> onSelectColor;

  static const _sizes = ['IT 36', 'IT 38', 'IT 40', 'IT 42', 'IT 44'];

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(24, 24, 24, 24),
      decoration: const BoxDecoration(
        color: Color(0xFF2A2420),
        borderRadius: BorderRadius.only(topLeft: Radius.circular(32), topRight: Radius.circular(32)),
        boxShadow: [BoxShadow(color: Color.fromRGBO(0, 0, 0, 0.5), blurRadius: 40, offset: Offset(0, -20))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: 64,
            height: 6,
            decoration: BoxDecoration(
              color: const Color.fromRGBO(184, 150, 62, 0.4),
              borderRadius: BorderRadius.circular(9999),
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'VALENTINO',
            style: GoogleFonts.poppins(
              fontSize: 12,
              height: 16 / 12,
              letterSpacing: 3.0,
              color: const Color(0xFFB8963E),
            ),
          ),
          const SizedBox(height: 10),
          Text(
            'Silk Crepe De Chine\nEvening Gown',
            textAlign: TextAlign.center,
            style: GoogleFonts.bodoniModa(
              fontSize: 30,
              height: 37.5 / 30,
              letterSpacing: 0.75,
              color: const Color(0xFFF5F0E8),
            ),
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              for (int i = 0; i < 4; i++)
                Padding(
                  padding: const EdgeInsets.only(right: 4),
                  child: SvgPicture.asset(
                    'assets/images/icon_star_full.svg',
                    width: 13,
                    height: 13,
                    colorFilter: const ColorFilter.mode(Color(0xFFB8963E), BlendMode.srcIn),
                  ),
                ),
              SvgPicture.asset(
                'assets/images/icon_star_half.svg',
                width: 13,
                height: 13,
                colorFilter: const ColorFilter.mode(Color(0xFFB8963E), BlendMode.srcIn),
              ),
              const SizedBox(width: 8),
              GestureDetector(
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(builder: (_) => const ProductReviewsScreen()));
                },
                child: Text(
                  '(24 Reviews)',
                  style: GoogleFonts.poppins(fontSize: 12, height: 16 / 12, letterSpacing: 0.6, color: const Color(0xFFB8963E)),
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          Text(
            'SGD 8,900',
            style: GoogleFonts.bodoniModa(fontSize: 30, height: 36 / 30, letterSpacing: 3, color: const Color(0xFFB8963E)),
          ),
          const SizedBox(height: 16),
          Opacity(
            opacity: 0.9,
            child: Text(
              'A masterclass in effortless elegance. This floor-\nsweeping gown is crafted from fluid silk crepe de\nchine, featuring a dramatic plunge neckline and\ndelicate pleated details that cascade down the\nasymmetrical hemline.',
              style: GoogleFonts.cormorantGaramond(fontSize: 18, height: 29.25 / 18, color: const Color(0xFFF5F0E8)),
            ),
          ),
          const SizedBox(height: 28),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'SELECT SIZE',
                style: GoogleFonts.poppins(fontSize: 12, height: 16 / 12, letterSpacing: 2.4, color: const Color(0xFFF5F0E8)),
              ),
              GestureDetector(
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(builder: (_) => const SizeGuideScreen()));
                },
                child: Text(
                  'Size Guide',
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    height: 16 / 12,
                    color: const Color(0xFFB8963E),
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                for (int i = 0; i < _sizes.length; i++)
                  Padding(
                    padding: const EdgeInsets.only(right: 12),
                    child: _SizePill(
                      label: _sizes[i],
                      selected: i == selectedSize,
                      onTap: () => onSelectSize(i),
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 28),
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'COLOR',
              style: GoogleFonts.poppins(fontSize: 12, height: 16 / 12, letterSpacing: 2.4, color: const Color(0xFFF5F0E8)),
            ),
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              _Swatch(color: const Color(0xFF111111), selected: selectedColor == 0, onTap: () => onSelectColor(0)),
              const SizedBox(width: 16),
              _Swatch(color: const Color(0xFF8A2A2B), selected: selectedColor == 1, onTap: () => onSelectColor(1)),
              const SizedBox(width: 16),
              _Swatch(color: const Color(0xFFE5E0D8), selected: selectedColor == 2, onTap: () => onSelectColor(2)),
            ],
          ),
          const SizedBox(height: 24),
          const _AccordionRow(label: 'COMPOSITION & CARE'),
          const _AccordionRow(label: "EDITOR'S NOTES"),
          const _AccordionRow(label: 'DELIVERY & RETURNS'),
        ],
      ),
    );
  }
}

class _SizePill extends StatelessWidget {
  const _SizePill({required this.label, required this.selected, required this.onTap});
  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 56,
        height: 56,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(9999),
          gradient: selected ? const LinearGradient(colors: [Color(0xFFB8963E), Color(0xFFC4A882)]) : null,
          boxShadow: selected
              ? const [BoxShadow(color: Color.fromRGBO(184, 150, 62, 0.3), blurRadius: 15, offset: Offset(0, 4))]
              : null,
          border: selected ? null : Border.all(color: const Color.fromRGBO(77, 70, 55, 0.3), width: 1),
        ),
        alignment: Alignment.center,
        child: Text(
          label,
          style: GoogleFonts.poppins(
            fontSize: 14,
            height: 20 / 14,
            color: const Color(0xFFF5F0E8),
            fontWeight: selected ? FontWeight.w500 : FontWeight.w400,
          ),
        ),
      ),
    );
  }
}

class _Swatch extends StatelessWidget {
  const _Swatch({required this.color, required this.selected, required this.onTap});
  final Color color;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(9999),
          border: selected ? Border.all(color: const Color(0xFFB8963E), width: 2) : null,
          boxShadow: selected ? const [BoxShadow(color: Color.fromRGBO(184, 150, 62, 0.2), blurRadius: 10)] : null,
        ),
      ),
    );
  }
}

class _AccordionRow extends StatelessWidget {
  const _AccordionRow({required this.label});
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 20),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: Color.fromRGBO(77, 70, 55, 0.2), width: 1)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: GoogleFonts.poppins(fontSize: 12, height: 16 / 12, letterSpacing: 2.4, color: const Color(0xFFF5F0E8)),
          ),
          const Icon(Icons.add_rounded, size: 18, color: Color(0xFFB8963E)),
        ],
      ),
    );
  }
}

