import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import 'product_detail_screen.dart';
import 'shopping_bag_screen.dart';
import 'notifications_screen.dart';
import 'product_listing_screen.dart';
import '../data/models/product.dart';
import '../state/providers.dart';
import '../utils/format.dart';
import '../config/shop_categories.dart';
import '../data/retailer_storefront_images.dart';
import '../data/fashion_image_urls.dart';
import '../widgets/atelier_bottom_nav.dart';
import '../widgets/product_network_image.dart';

class SearchDiscoveryScreen extends ConsumerStatefulWidget {
  const SearchDiscoveryScreen({super.key});

  @override
  ConsumerState<SearchDiscoveryScreen> createState() => _SearchDiscoveryScreenState();
}

class _SearchDiscoveryScreenState extends ConsumerState<SearchDiscoveryScreen> {
  static const _bg = Color(0xFF131313);
  static const _top = Color(0xFF080808);
  static const _accent = Color(0xFFE8C265);
  static const _luxGold = Color(0xFFB8963E);
  static const _title = Color(0xFFF5F0E8);
  static const double _webMaxWidth = 1100;

  final int _activeBottomIndex = 1; // Categories / browse tab
  final _searchCtrl = TextEditingController();
  String _query = '';

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

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
                            _SearchBar(
                              controller: _searchCtrl,
                              onChanged: (v) => setState(() => _query = v.trim()),
                              onClear: () => setState(() {
                                _searchCtrl.clear();
                                _query = '';
                              }),
                            ),
                            if (_query.isNotEmpty) ...[
                              const SizedBox(height: 18),
                              _SearchResults(query: _query, productsAsync: ref.watch(allProductsProvider)),
                            ] else ...[
                              const SizedBox(height: 40),
                              _Trending(),
                              const SizedBox(height: 28),
                              _CategoriesGrid(),
                              const SizedBox(height: 24),
                              const _MenCasualSpotlight(),
                              const SizedBox(height: 24),
                              _CuratedEdits(),
                              const SizedBox(height: 24),
                              _RecentArrivals(),
                            ],
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
                  child: AtelierBottomNavBar.dock(
                    activeIndex: _activeBottomIndex,
                    onTap: (idx) => _navigateBottom(context, idx),
                    dockTranslucent: true,
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
  const _SearchBar({
    required this.controller,
    required this.onChanged,
    required this.onClear,
  });

  final TextEditingController controller;
  final ValueChanged<String> onChanged;
  final VoidCallback onClear;

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
                child: TextField(
                  controller: controller,
                  onChanged: onChanged,
                  textInputAction: TextInputAction.search,
                  style: GoogleFonts.plusJakartaSans(fontSize: 14, color: const Color(0xFFE5E2E1)),
                  cursorColor: _SearchDiscoveryScreenState._luxGold,
                  decoration: InputDecoration(
                    isDense: true,
                    border: InputBorder.none,
                    hintText: 'Explore collections, designers, items...',
                    hintStyle: GoogleFonts.plusJakartaSans(
                      fontSize: 14,
                      color: const Color.fromRGBO(153, 144, 126, 0.7),
                    ),
                  ),
                ),
              ),
              if (controller.text.isNotEmpty) ...[
                const SizedBox(width: 8),
                IconButton(
                  onPressed: onClear,
                  icon: const Icon(Icons.close_rounded, size: 18, color: Color(0xFF99907E)),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints.tightFor(width: 36, height: 36),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _SearchResults extends StatelessWidget {
  const _SearchResults({required this.query, required this.productsAsync});
  final String query;
  final AsyncValue<List<Product>> productsAsync;

  @override
  Widget build(BuildContext context) {
    return productsAsync.when(
      loading: () => const Padding(
        padding: EdgeInsets.symmetric(horizontal: 24, vertical: 24),
        child: Center(child: CircularProgressIndicator(color: _SearchDiscoveryScreenState._accent)),
      ),
      error: (e, _) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Text('Could not search products. $e', style: GoogleFonts.plusJakartaSans(fontSize: 14, color: const Color(0xFFD0C5B2))),
      ),
      data: (products) {
        final q = query.toLowerCase();
        final results = products.where((p) {
          final hay = '${p.brand} ${p.name} ${p.categoryId} ${p.description}'.toLowerCase();
          return hay.contains(q);
        }).toList();

        if (results.isEmpty) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Text(
              'No results for “$query”',
              style: GoogleFonts.plusJakartaSans(fontSize: 14, height: 20 / 14, color: const Color(0xFFD0C5B2)),
            ),
          );
        }

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'RESULTS',
                style: GoogleFonts.notoSerif(
                  fontSize: 12,
                  height: 16 / 12,
                  letterSpacing: 2.4,
                  color: _SearchDiscoveryScreenState._accent,
                ),
              ),
              const SizedBox(height: 16),
              for (final product in results) ...[
                _ResultRow(product: product),
                const SizedBox(height: 14),
              ],
            ],
          ),
        );
      },
    );
  }
}

class _ResultRow extends StatelessWidget {
  const _ResultRow({required this.product});
  final Product product;

  @override
  Widget build(BuildContext context) {
    final imageUrl = product.primaryImageUrl;
    return InkWell(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(builder: (_) => ProductDetailScreen(product: product)),
        );
      },
      borderRadius: BorderRadius.circular(18),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: const Color(0xFF2A2420),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: const Color.fromRGBO(78, 70, 57, 0.25)),
        ),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(14),
              child: Container(
                width: 56,
                height: 56,
                color: const Color(0xFF201F1F),
                child: ProductNetworkImage(
                  imageUrl: imageUrl.isNotEmpty ? imageUrl : 'assets/images/search_recent_gown.png',
                  width: 56,
                  height: 56,
                  fit: BoxFit.cover,
                  fallbackAsset: ProductNetworkImage.fallbackAssetFor(product.id, product.categoryId),
                ),
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(product.name, style: GoogleFonts.plusJakartaSans(fontSize: 14, height: 20 / 14, color: const Color(0xFFE5E2E1))),
                ],
              ),
            ),
            const SizedBox(width: 12),
            Text(formatMoney(product.price, currency: product.currency), style: GoogleFonts.notoSerif(fontSize: 12, height: 16 / 12, color: _SearchDiscoveryScreenState._accent)),
            const SizedBox(width: 8),
            Icon(Icons.chevron_right_rounded, size: 20, color: const Color(0xFFD0C5B2).withValues(alpha: 0.8)),
          ],
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
    String? deptIdForLabel(String label) => switch (label.toUpperCase()) {
          'MEN' => ShopCategoryId.men,
          'WOMEN' => ShopCategoryId.women,
          'KIDS' => ShopCategoryId.children,
          'ACCESSORIES' => ShopCategoryId.accessories,
          _ => null,
        };

    Widget tile(
      String label,
      String imageUrl,
      String fallbackAsset, {
      bool showDepartmentCaption = true,
    }) =>
        GestureDetector(
          onTap: () {
            final dept = deptIdForLabel(label);
            if (dept != null) {
              openDepartmentLanding(context, dept);
            }
          },
          child: ClipRRect(
            child: Stack(
              children: [
                ProductNetworkImage(
                  imageUrl: imageUrl,
                  height: 217.33,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  fallbackAsset: fallbackAsset,
                ),
                if (showDepartmentCaption) ...[
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
                ],
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
                if (showDepartmentCaption)
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
              tile(
                'MEN',
                DepartmentCategoryAssets.men,
                fallbackForDepartment('MEN'),
              ),
              tile(
                'WOMEN',
                categoryImg(FashionPhotos.deptWomen),
                fallbackForDepartment('WOMEN'),
              ),
              tile(
                'KIDS',
                categoryImg(FashionPhotos.deptKids),
                fallbackForDepartment('KIDS'),
              ),
              tile(
                'ACCESSORIES',
                accessoriesDepartmentImage(w: 600, h: 720),
                fallbackForDepartment('ACCESSORIES'),
              ),
            ],
          );
        },
      ),
    );
  }
}

/// NOLIMIT / TOM DAVID men’s casual SKUs — same order as catalogue seed.
const _kMenCasualSpotlightIds = <String>[
  'nolimit-slim-polo-forest',
  'tom-david-oversized-tee-navy',
  'tom-david-oversized-tee-mint',
];

class _MenCasualSpotlight extends ConsumerWidget {
  const _MenCasualSpotlight();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final productsAsync = ref.watch(allProductsProvider);

    return productsAsync.when(
      loading: () => const SizedBox.shrink(),
      error: (error, stackTrace) => const SizedBox.shrink(),
      data: (products) {
        if (products.isEmpty) return const SizedBox.shrink();
        final byId = {for (final p in products) p.id: p};
        final spotlight = <Product>[];
        for (final id in _kMenCasualSpotlightIds) {
          final p = byId[id];
          if (p != null) spotlight.add(p);
        }
        if (spotlight.isEmpty) return const SizedBox.shrink();

        Widget card(Product p) {
          final imageUrl = p.primaryImageUrl;
          return GestureDetector(
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute<void>(builder: (_) => ProductDetailScreen(product: p)),
              );
            },
            child: SizedBox(
              width: 158,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(24),
                    child: ColoredBox(
                      color: const Color(0xFF201F1F),
                      child: ProductNetworkImage(
                        imageUrl: imageUrl.isNotEmpty ? imageUrl : ProductNetworkImage.fallbackAssetFor(p.id, p.categoryId),
                        width: 158,
                        height: 200,
                        fit: BoxFit.cover,
                        fallbackAsset: ProductNetworkImage.fallbackAssetFor(p.id, p.categoryId),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    '${p.brand} ${p.name}',
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 13,
                      height: 18 / 13,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFFE5E2E1),
                    ),
                  ),
                ],
              ),
            ),
          );
        }

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
                    Text(
                      "MEN'S CASUAL",
                      style: GoogleFonts.notoSerif(
                        fontSize: 12,
                        height: 16 / 12,
                        letterSpacing: 2.4,
                        color: _SearchDiscoveryScreenState._accent,
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute<void>(
                            builder: (_) => const ProductListingScreen(
                              categoryId: ShopCategoryId.men,
                              subCategoryId: 'casual-wear',
                              title: "Men's casual wear",
                            ),
                          ),
                        );
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
              ),
              const SizedBox(height: 20),
              SizedBox(
                height: 280,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: spotlight.length,
                  separatorBuilder: (context, index) => const SizedBox(width: 14),
                  itemBuilder: (context, i) => card(spotlight[i]),
                ),
              ),
            ],
          ),
        );
      },
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
                card('Quiet Luxury', 'Subtle Elegance', 'assets/images/accessories_nextluxury_flatlay.jpg'),
                const SizedBox(width: 24),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _RecentArrivals extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final productsAsync = ref.watch(allProductsProvider);

    return productsAsync.when(
      loading: () => const SizedBox.shrink(),
      error: (e, st) => const SizedBox.shrink(),
      data: (products) {
        if (products.isEmpty) return const SizedBox.shrink();
        /// Horizontal scroll: many "arrival" rows use 6–8 peeking cards; avoids two
        /// [Expanded] tiles stretching across an empty middle on wide layouts.
        const recentArrivalCount = 7;
        final recent = products.take(recentArrivalCount).toList();

        Widget smallProduct(Product p, String fallbackAsset) {
          final imageUrl = p.primaryImageUrl;
          return GestureDetector(
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => ProductDetailScreen(product: p)),
              );
            },
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(32),
                  child: Container(
                    color: const Color(0xFF201F1F),
                    child: Opacity(
                      opacity: 0.8,
                      child: ProductNetworkImage(
                        imageUrl: imageUrl.isNotEmpty ? imageUrl : fallbackAsset,
                        width: 163,
                        height: 217.33,
                        fit: BoxFit.cover,
                        fallbackAsset: fallbackAsset,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Text(p.name, maxLines: 2, overflow: TextOverflow.ellipsis, style: GoogleFonts.plusJakartaSans(fontSize: 14, height: 20 / 14, color: const Color(0xFFE5E2E1))),
                Text(formatMoney(p.price, currency: p.currency), style: GoogleFonts.notoSerif(fontSize: 14, height: 20 / 14, letterSpacing: 0.7, color: _SearchDiscoveryScreenState._accent)),
              ],
            ),
          );
        }

        const fallbacks = [
          'assets/images/search_recent_gown.png',
          'assets/images/search_recent_tote.png',
          'assets/images/deedat_womens_high_neck_tee_light_blue.jpg',
          'assets/images/men_accessories/fossil_grant_chrono.jpg',
          'assets/images/nolimit_offbeat_womens_printed_embroidery_tee_cream.jpg',
          'assets/images/women_casual_wear_category.jpg',
          'assets/images/accessories_nextluxury_flatlay.jpg',
        ];

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
              SizedBox(
                height: 300,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  clipBehavior: Clip.none,
                  padding: const EdgeInsets.only(right: 8),
                  itemCount: recent.length,
                  separatorBuilder: (context, index) => const SizedBox(width: 14),
                  itemBuilder: (context, i) {
                    return SizedBox(
                      width: 163,
                      child: smallProduct(recent[i], fallbacks[i % fallbacks.length]),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}