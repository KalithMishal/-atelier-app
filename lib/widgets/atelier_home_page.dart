import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import '../config/atelier_home_config.dart';
import '../config/department_subcategories.dart';
import '../config/shop_categories.dart';
import '../data/fashion_image_urls.dart';
import '../data/models/product.dart';
import '../screens/product_listing_screen.dart';
import '../screens/search_discovery_screen.dart';
import 'home_product_card.dart';
import 'home_shimmer.dart';
import 'home_visual_image.dart';

/// Your customizable ATELIER storefront — driven by [atelier_home_config.dart].
class AtelierHomePage extends ConsumerWidget {
  const AtelierHomePage({
    super.key,
    required this.productsAsync,
    required this.activeCategoryIndex,
    required this.onCategorySelected,
    required this.onSeedCatalogue,
    required this.accent,
    required this.titleColor,
    required this.mutedColor,
    required this.borderColor,
    required this.cardBg,
    required this.bannerHeight,
    required this.maxContentWidth,
    required this.gridCrossAxisCount,
  });

  final AsyncValue<List<Product>> productsAsync;
  final int activeCategoryIndex;
  final ValueChanged<int> onCategorySelected;
  final Widget onSeedCatalogue;
  final Color accent;
  final Color titleColor;
  final Color mutedColor;
  final Color borderColor;
  final Color cardBg;
  final double bannerHeight;
  final double maxContentWidth;
  final int gridCrossAxisCount;

  List<Product> _filter(List<Product> products) => filterProductsByChip(products, activeCategoryIndex);

  void _openDepartment(BuildContext context, int filterIndex) {
    final dept = departmentIdFromChipIndex(filterIndex);
    if (dept != null) {
      openDepartmentLanding(context, dept);
    } else {
      onCategorySelected(filterIndex);
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final sections = activeSections.toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (final section in sections) ...[
          _buildSection(context, section),
        ],
      ],
    );
  }

  Widget _buildSection(BuildContext context, HomeSection section) {
    return switch (section) {
      HomeSection.search => _padded(_SearchBar(accent: accent, hint: kSearchHint)),
      HomeSection.hero => _HeroCarousel(
          banners: kHomeBanners,
          height: bannerHeight,
          accent: accent,
          titleColor: titleColor,
        ),
      HomeSection.trustStrip => _padded(_TrustStrip(items: kTrustStripItems, accent: accent)),
      HomeSection.brandTicker => _BrandTicker(brands: kTickerBrands, accent: accent),
      HomeSection.saleBanner => _padded(_SaleBanner(text: kSaleBannerText, accent: accent)),
      HomeSection.quickLinks => _padded(_QuickLinks(
          title: kQuickLinksTitle,
          links: kQuickLinks,
          accent: accent,
          onTap: (i) => _openDepartment(context, i),
        )),
      HomeSection.departments => _padded(_DepartmentGrid(
          title: kDepartmentsTitle,
          departments: kDepartments,
          accent: accent,
          onTap: (i) => _openDepartment(context, i),
        )),
      HomeSection.dualPromos => _padded(_DualPromos(
          promos: kDualPromos,
          onTap: (i) => _openDepartment(context, i),
        )),
      HomeSection.partnerBrands => _padded(_PartnerBrands(brands: kPartnerBrands, accent: accent)),
      HomeSection.flashDeals => _padded(_FlashDeals(
          title: kFlashDealsTitle,
          deals: kFlashDeals,
          accent: accent,
        )),
      HomeSection.newProducts => _padded(productsAsync.when(
          data: (products) {
            if (products.isEmpty) return onSeedCatalogue;
            final list = products.where((p) => p.isFeatured).take(8).toList();
            final display = list.isNotEmpty ? list : products.take(8).toList();
            return _ProductRow(
              title: kNewProductsTitle,
              products: display,
              accent: accent,
              titleColor: titleColor,
              cardBg: cardBg,
              onViewAll: () => Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const ProductListingScreen()),
              ),
            );
          },
          loading: () => Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                HomeSectionHeader(title: kNewProductsTitle, accent: accent),
                const SizedBox(height: 14),
                const HomeProductRowShimmer(),
              ],
            ),
          error: (_, __) => const SizedBox.shrink(),
        )),
      HomeSection.categoryChips => _padded(_CategoryChips(
          labels: kCategoryChips,
          activeIndex: activeCategoryIndex,
          accent: accent,
          muted: mutedColor,
          border: borderColor,
          onTap: onCategorySelected,
        )),
      HomeSection.trendingGrid => _padded(Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            HomeSectionHeader(
              title: kTrendingTitle,
              subtitle: kTrendingSubtitle,
              accent: accent,
              onViewAll: () => Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const ProductListingScreen()),
              ),
            ),
            const SizedBox(height: 18),
            productsAsync.when(
              data: (products) {
                if (products.isEmpty) return const SizedBox.shrink();
                final filtered = _filter(products);
                if (filtered.isEmpty) {
                  return Text('No items in this category.', style: GoogleFonts.manrope(color: mutedColor));
                }
                return GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: filtered.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: gridCrossAxisCount,
                    mainAxisSpacing: 20,
                    crossAxisSpacing: 16,
                    childAspectRatio: 0.58,
                  ),
                  itemBuilder: (_, i) => HomeProductCard(
                    product: filtered[i],
                    titleColor: titleColor,
                    cardBg: cardBg,
                  ),
                );
              },
              loading: () => HomeProductGridShimmer(crossAxisCount: gridCrossAxisCount),
              error: (_, __) => Text('Could not load products.', style: GoogleFonts.manrope(color: mutedColor)),
            ),
          ],
        )),
    };
  }

  Widget _padded(Widget child) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 32),
      child: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: maxContentWidth),
          child: child,
        ),
      ),
    );
  }
}

// ─── Sections ─────────────────────────────────────────────────────────────────

class _SearchBar extends StatelessWidget {
  const _SearchBar({required this.accent, required this.hint});
  final Color accent;
  final String hint;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.of(context).push(
        MaterialPageRoute(builder: (_) => const SearchDiscoveryScreen()),
      ),
      child: Container(
        height: 52,
        padding: const EdgeInsets.symmetric(horizontal: 18),
        decoration: BoxDecoration(
          color: const Color(0xFF1A1918),
          borderRadius: BorderRadius.circular(26),
          border: Border.all(color: const Color.fromRGBO(78, 70, 57, 0.35)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.25),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Icon(Icons.search_rounded, color: accent.withValues(alpha: 0.9), size: 22),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                hint,
                style: GoogleFonts.manrope(fontSize: 14, color: const Color(0xFF9A9288)),
              ),
            ),
            Icon(Icons.tune_rounded, color: accent.withValues(alpha: 0.55), size: 20),
          ],
        ),
      ),
    );
  }
}

class _HeroCarousel extends StatefulWidget {
  const _HeroCarousel({
    required this.banners,
    required this.height,
    required this.accent,
    required this.titleColor,
  });

  final List<HomeBannerData> banners;
  final double height;
  final Color accent;
  final Color titleColor;

  @override
  State<_HeroCarousel> createState() => _HeroCarouselState();
}

class _HeroCarouselState extends State<_HeroCarousel> {
  final _controller = PageController();
  Timer? _timer;
  int _index = 0;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 5), (_) {
      if (!mounted || widget.banners.isEmpty) return;
      final next = (_index + 1) % widget.banners.length;
      _controller.animateToPage(next, duration: const Duration(milliseconds: 600), curve: Curves.easeInOut);
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.banners.isEmpty) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
      child: Column(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: SizedBox(
              height: widget.height,
              width: double.infinity,
              child: PageView.builder(
                controller: _controller,
                itemCount: widget.banners.length,
                onPageChanged: (i) => setState(() => _index = i),
                itemBuilder: (_, i) {
                  final b = widget.banners[i];
                  return Stack(
                    fit: StackFit.expand,
                    children: [
                      HomeVisualImage(visual: b.visual, fit: BoxFit.cover, fallbackAsset: 'assets/images/home_hero.png'),
                      DecoratedBox(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.black.withValues(alpha: 0.05),
                              Colors.black.withValues(alpha: 0.55),
                              Colors.black.withValues(alpha: 0.82),
                            ],
                            stops: const [0.0, 0.55, 1.0],
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(22, 20, 22, 26),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Text(
                              b.eyebrow,
                              style: GoogleFonts.manrope(
                                fontSize: 10,
                                letterSpacing: 2,
                                color: widget.accent,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            const SizedBox(height: 10),
                            Text(
                              b.title,
                              style: GoogleFonts.notoSerif(fontSize: 32, height: 1.1, color: widget.titleColor),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              b.subtitle,
                              style: GoogleFonts.manrope(fontSize: 13, height: 1.4, color: const Color(0xFFD8CEC0)),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 18),
                            GestureDetector(
                              onTap: () {
                                final dept = departmentIdFromChipIndex(b.filterIndex);
                                if (dept != null) {
                                  openDepartmentLanding(context, dept);
                                } else {
                                  Navigator.of(context).push(
                                    MaterialPageRoute(builder: (_) => const ProductListingScreen()),
                                  );
                                }
                              },
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 12),
                                decoration: BoxDecoration(
                                  color: widget.accent,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(
                                  b.cta,
                                  style: GoogleFonts.manrope(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w800,
                                    letterSpacing: 1.4,
                                    color: const Color(0xFF2A2420),
                                  ),
                                ),
                              ),
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
          const SizedBox(height: 14),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              for (var i = 0; i < widget.banners.length; i++)
                AnimatedContainer(
                  duration: const Duration(milliseconds: 280),
                  curve: Curves.easeOut,
                  margin: const EdgeInsets.symmetric(horizontal: 3),
                  width: i == _index ? 22 : 6,
                  height: 6,
                  decoration: BoxDecoration(
                    color: i == _index ? widget.accent : const Color.fromRGBO(78, 70, 57, 0.45),
                    borderRadius: BorderRadius.circular(99),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 12),
        ],
      ),
    );
  }
}

class _BrandTicker extends StatefulWidget {
  const _BrandTicker({required this.brands, required this.accent});
  final List<String> brands;
  final Color accent;

  @override
  State<_BrandTicker> createState() => _BrandTickerState();
}

class _BrandTickerState extends State<_BrandTicker> {
  final _c = ScrollController();
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _timer = Timer.periodic(const Duration(milliseconds: 45), (_) {
        if (!_c.hasClients) return;
        final next = _c.offset + 1.1;
        if (next >= _c.position.maxScrollExtent) {
          _c.jumpTo(0);
        } else {
          _c.jumpTo(next);
        }
      });
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final items = [...widget.brands, ...widget.brands];
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      padding: const EdgeInsets.symmetric(vertical: 10),
      decoration: const BoxDecoration(
        border: Border(top: BorderSide(color: Color.fromRGBO(78, 70, 57, 0.35)), bottom: BorderSide(color: Color.fromRGBO(78, 70, 57, 0.35))),
      ),
      child: SizedBox(
        height: 24,
        child: ListView.separated(
          controller: _c,
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          physics: const NeverScrollableScrollPhysics(),
          itemCount: items.length,
          separatorBuilder: (_, __) => Text(' · ', style: TextStyle(color: widget.accent.withValues(alpha: 0.4))),
          itemBuilder: (_, i) => Center(
            child: Text(items[i], style: GoogleFonts.manrope(fontSize: 11, letterSpacing: 2, fontWeight: FontWeight.w600, color: const Color(0xFFE5E2E1))),
          ),
        ),
      ),
    );
  }
}

class _TrustStrip extends StatelessWidget {
  const _TrustStrip({required this.items, required this.accent});

  final List<(String, String)> items;
  final Color accent;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 4),
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(color: accent.withValues(alpha: 0.12)),
          bottom: BorderSide(color: accent.withValues(alpha: 0.12)),
        ),
      ),
      child: Row(
        children: [
          for (var i = 0; i < items.length; i++) ...[
            if (i > 0)
              Container(
                width: 1,
                height: 28,
                margin: const EdgeInsets.symmetric(horizontal: 6),
                color: const Color.fromRGBO(78, 70, 57, 0.35),
              ),
            Expanded(
              child: Column(
                children: [
                  Icon(_iconFor(items[i].$1), size: 20, color: accent.withValues(alpha: 0.85)),
                  const SizedBox(height: 6),
                  Text(
                    items[i].$2,
                    textAlign: TextAlign.center,
                    style: GoogleFonts.manrope(
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFFB8B0A6),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  IconData _iconFor(String name) => switch (name) {
        'local_shipping_outlined' => Icons.local_shipping_outlined,
        'replay_outlined' => Icons.replay_outlined,
        'verified_user_outlined' => Icons.verified_user_outlined,
        _ => Icons.check_circle_outline,
      };
}

class _SaleBanner extends StatelessWidget {
  const _SaleBanner({required this.text, required this.accent});
  final String text;
  final Color accent;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1918),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: accent.withValues(alpha: 0.35)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: accent.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(Icons.local_offer_outlined, size: 18, color: accent),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: GoogleFonts.manrope(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                height: 1.35,
                color: const Color(0xFFE5E2E1),
              ),
            ),
          ),
          Icon(Icons.arrow_forward_ios_rounded, size: 14, color: accent.withValues(alpha: 0.7)),
        ],
      ),
    );
  }
}

class _QuickLinks extends StatelessWidget {
  const _QuickLinks({required this.title, required this.links, required this.accent, required this.onTap});
  final String title;
  final List<HomeLinkData> links;
  final Color accent;
  final ValueChanged<int> onTap;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: GoogleFonts.manrope(fontSize: 11, letterSpacing: 2, fontWeight: FontWeight.w600, color: accent)),
        const SizedBox(height: 14),
        SizedBox(
          height: 100,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: links.length,
            separatorBuilder: (_, __) => const SizedBox(width: 16),
            itemBuilder: (_, i) {
              final link = links[i];
              return GestureDetector(
                onTap: () => onTap(link.filterIndex),
                child: SizedBox(
                  width: 68,
                  child: Column(
                    children: [
                      ClipOval(
                        child: SizedBox(
                          width: 60,
                          height: 60,
                          child: HomeVisualImage(visual: link.visual, fit: BoxFit.cover),
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(link.label, textAlign: TextAlign.center, style: GoogleFonts.manrope(fontSize: 10, color: const Color(0xFFE5E2E1)), maxLines: 2),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

class _DepartmentGrid extends StatelessWidget {
  const _DepartmentGrid({required this.title, required this.departments, required this.accent, required this.onTap});
  final String title;
  final List<HomeDepartmentData> departments;
  final Color accent;
  final ValueChanged<int> onTap;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        HomeSectionHeader(title: title, accent: accent),
        const SizedBox(height: 16),
        SizedBox(
          height: 200,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: departments.length,
            separatorBuilder: (_, __) => const SizedBox(width: 12),
            itemBuilder: (_, i) {
              final d = departments[i];
              return GestureDetector(
                onTap: () => onTap(d.filterIndex),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(14),
                  child: SizedBox(
                    width: 168,
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        HomeVisualImage(
                          visual: d.visual,
                          fit: BoxFit.cover,
                          fallbackAsset: fallbackForDepartment(d.title),
                        ),
                        DecoratedBox(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [Colors.transparent, Colors.black.withValues(alpha: 0.82)],
                            ),
                          ),
                        ),
                        Positioned(
                          left: 14,
                          right: 14,
                          bottom: 14,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              FittedBox(
                                fit: BoxFit.scaleDown,
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  d.title,
                                  maxLines: 1,
                                  style: GoogleFonts.notoSerif(fontSize: 21, color: Colors.white),
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                d.subtitle,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: GoogleFonts.manrope(fontSize: 10, color: const Color(0xFFD1C5B4)),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

class _DualPromos extends StatelessWidget {
  const _DualPromos({required this.promos, required this.onTap});
  final List<HomeDualPromoData> promos;
  final ValueChanged<int> onTap;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        for (var i = 0; i < promos.length; i++) ...[
          if (i > 0) const SizedBox(width: 10),
          Expanded(
            child: GestureDetector(
              onTap: () => onTap(promos[i].filterIndex),
              child: AspectRatio(
                aspectRatio: 1.05,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      HomeVisualImage(visual: promos[i].visual, fit: BoxFit.cover),
                      DecoratedBox(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [Colors.transparent, Colors.black.withValues(alpha: 0.75)],
                          ),
                        ),
                      ),
                      Positioned(left: 10, right: 10, bottom: 10, child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(promos[i].title, style: GoogleFonts.notoSerif(fontSize: 15, color: Colors.white)),
                          Text(promos[i].subtitle, style: GoogleFonts.manrope(fontSize: 10, color: const Color(0xFFD1C5B4))),
                        ],
                      )),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ],
    );
  }
}

class _PartnerBrands extends StatelessWidget {
  const _PartnerBrands({required this.brands, required this.accent});
  final List<String> brands;
  final Color accent;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('PARTNER BRANDS', style: GoogleFonts.manrope(fontSize: 11, letterSpacing: 2, fontWeight: FontWeight.w600, color: accent)),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            for (final b in brands)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  border: Border.all(color: const Color.fromRGBO(78, 70, 57, 0.45)),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(b, style: GoogleFonts.manrope(fontSize: 11, letterSpacing: 1, fontWeight: FontWeight.w600, color: const Color(0xFFE5E2E1))),
              ),
          ],
        ),
      ],
    );
  }
}

class _FlashDeals extends StatelessWidget {
  const _FlashDeals({required this.title, required this.deals, required this.accent});
  final String title;
  final List<HomeDealData> deals;
  final Color accent;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: GoogleFonts.manrope(fontSize: 11, letterSpacing: 2, fontWeight: FontWeight.w600, color: accent)),
        const SizedBox(height: 14),
        SizedBox(
          height: 220,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: deals.length,
            separatorBuilder: (_, __) => const SizedBox(width: 12),
            itemBuilder: (_, i) {
              final d = deals[i];
              return ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: SizedBox(
                  width: 140,
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      HomeVisualImage(visual: d.visual, fit: BoxFit.cover),
                      DecoratedBox(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [Colors.transparent, Colors.black.withValues(alpha: 0.8)],
                          ),
                        ),
                      ),
                      Positioned(
                        left: 10,
                        right: 10,
                        bottom: 10,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(d.label, style: GoogleFonts.manrope(fontSize: 12, fontWeight: FontWeight.w600, color: Colors.white)),
                            Text(d.priceHint, style: GoogleFonts.manrope(fontSize: 10, color: const Color(0xFFD1C5B4))),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

class _ProductRow extends StatelessWidget {
  const _ProductRow({
    required this.title,
    required this.products,
    required this.accent,
    required this.titleColor,
    required this.cardBg,
    this.onViewAll,
  });

  final String title;
  final List<Product> products;
  final Color accent;
  final Color titleColor;
  final Color cardBg;
  final VoidCallback? onViewAll;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        HomeSectionHeader(title: title, accent: accent, onViewAll: onViewAll),
        const SizedBox(height: 16),
        SizedBox(
          height: 290,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: products.length,
            separatorBuilder: (_, __) => const SizedBox(width: 14),
            itemBuilder: (_, i) => HomeProductCard(
              product: products[i],
              titleColor: titleColor,
              cardBg: cardBg,
              width: 148,
              compact: true,
            ),
          ),
        ),
      ],
    );
  }
}

class _CategoryChips extends StatelessWidget {
  const _CategoryChips({
    required this.labels,
    required this.activeIndex,
    required this.accent,
    required this.muted,
    required this.border,
    required this.onTap,
  });

  final List<String> labels;
  final int activeIndex;
  final Color accent;
  final Color muted;
  final Color border;
  final ValueChanged<int> onTap;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 44,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: labels.length,
        separatorBuilder: (_, __) => const SizedBox(width: 10),
        itemBuilder: (_, i) {
          final active = i == activeIndex;
          return GestureDetector(
            onTap: () => onTap(i),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 11),
              decoration: BoxDecoration(
                color: active ? accent.withValues(alpha: 0.12) : const Color(0xFF1A1918),
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: active ? accent.withValues(alpha: 0.5) : border),
              ),
              child: Text(
                labels[i],
                style: GoogleFonts.manrope(
                  fontSize: 11,
                  letterSpacing: 0.8,
                  color: active ? accent : muted,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

/// Reusable section title row (Zara / ASOS style).
class HomeSectionHeader extends StatelessWidget {
  const HomeSectionHeader({
    super.key,
    required this.title,
    required this.accent,
    this.subtitle,
    this.onViewAll,
  });

  final String title;
  final String? subtitle;
  final Color accent;
  final VoidCallback? onViewAll;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: GoogleFonts.notoSerif(fontSize: 24, height: 1.15, color: const Color(0xFFE5E2E1)),
              ),
              if (subtitle != null) ...[
                const SizedBox(height: 4),
                Text(subtitle!, style: GoogleFonts.manrope(fontSize: 12, color: const Color(0xFF8A8278))),
              ],
            ],
          ),
        ),
        if (onViewAll != null)
          TextButton(
            onPressed: onViewAll,
            style: TextButton.styleFrom(
              foregroundColor: accent,
              padding: const EdgeInsets.symmetric(horizontal: 8),
              minimumSize: Size.zero,
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
            child: Text('View all', style: GoogleFonts.manrope(fontSize: 12, fontWeight: FontWeight.w600)),
          ),
      ],
    );
  }
}
