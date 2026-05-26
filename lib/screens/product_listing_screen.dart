import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'filter_drawer_sheet.dart';
import '../state/providers.dart';
import '../data/models/product.dart';
import '../config/shop_categories.dart';
import '../widgets/atelier_bottom_nav.dart';
import '../widgets/home_product_card.dart';

class ProductListingScreen extends ConsumerStatefulWidget {
  const ProductListingScreen({
    super.key,
    this.categoryId,
    this.subCategoryId,
    this.title,
  });

  final String? categoryId;
  final String? subCategoryId;
  final String? title;

  @override
  ConsumerState<ProductListingScreen> createState() => _ProductListingScreenState();
}

class _ProductListingScreenState extends ConsumerState<ProductListingScreen> {
  static const _bg = Color(0xFF131313);
  static const _topBarBg = Color.fromRGBO(0, 0, 0, 0.8);
  static const _imageBg = Color(0xFF0E0E0E);
  static const _text = Color(0xFFF5F0E8);
  static const _muted = Color(0xFFD0C5B2);
  static const _pillBorder = Color.fromRGBO(77, 70, 55, 0.30);
  static const _pillBorderInactive = Color.fromRGBO(77, 70, 55, 0.15);

  final int _activeBottomIndex = 1;
  int _activeChipIndex = 0;

  final _chips = const ['NEW ARRIVALS', 'PRICE', 'SIZE', 'COLOR', 'MATERIAL'];

  @override
  Widget build(BuildContext context) {
    final productsAsync = ref.watch(allProductsProvider);
    final all = productsAsync.value ?? [];
    final filtered = filterProductsForListing(
      all,
      categoryId: widget.categoryId,
      subCategoryId: widget.subCategoryId,
    );
    final count = filtered.length;
    final headerTitle = widget.title?.toUpperCase() ??
        (widget.categoryId != null ? categoryLabel(widget.categoryId!).toUpperCase() : 'SHOP ALL');
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
                            headerTitle.contains('\n') ? headerTitle : '$headerTitle\nCOLLECTION',
                            textAlign: TextAlign.center,
                            style: GoogleFonts.notoSerif(
                              fontSize: 28,
                              height: 1.2,
                              letterSpacing: 2,
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
                                count == 1 ? '1 PIECE' : '$count PIECES',
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
                        productsAsync.when(
                          data: (_) => filtered.isEmpty
                              ? Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 48),
                                  child: Center(
                                    child: Text(
                                      'No products in this category yet.\nLoad the sample catalogue from Home.',
                                      textAlign: TextAlign.center,
                                      style: GoogleFonts.plusJakartaSans(color: _muted, height: 1.5),
                                    ),
                                  ),
                                )
                              : _ProductGrid(
                                  items: filtered,
                                  cardBg: _imageBg,
                                  titleColor: _text,
                                ),
                          loading: () => const Padding(
                            padding: EdgeInsets.symmetric(vertical: 40),
                            child: Center(child: CircularProgressIndicator()),
                          ),
                          error: (e, _) => Padding(
                            padding: const EdgeInsets.symmetric(vertical: 40),
                            child: Text(
                              'Could not load products. $e',
                              style: GoogleFonts.plusJakartaSans(color: _muted),
                            ),
                          ),
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
                  child: AtelierBottomNavBar.dock(
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
    if (idx == _activeBottomIndex) return;
    AtelierBottomNav.go(context, idx);
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
            tooltip: MaterialLocalizations.of(context).backButtonTooltip,
            icon: const Icon(
              Icons.arrow_back_ios_new_rounded,
              size: 22,
              color: Color(0xFFB8963E),
            ),
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints.tightFor(width: 44, height: 44),
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

class _ProductGrid extends StatelessWidget {
  const _ProductGrid({
    required this.items,
    required this.cardBg,
    required this.titleColor,
  });

  final List<Product> items;
  final Color cardBg;
  final Color titleColor;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final cols = constraints.maxWidth >= 700 ? 3 : 2;
        return GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: items.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: cols,
            mainAxisSpacing: 20,
            crossAxisSpacing: 16,
            childAspectRatio: 0.58,
          ),
          itemBuilder: (_, i) => HomeProductCard(
            product: items[i],
            titleColor: titleColor,
            cardBg: cardBg,
          ),
        );
      },
    );
  }
}
