import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../data/home_content.dart';
import '../data/models/product.dart';
import '../data/fashion_image_urls.dart';
import '../screens/product_detail_screen.dart';
import '../screens/product_listing_screen.dart';
import '../screens/search_discovery_screen.dart';
import 'product_network_image.dart';

// ─── Hero carousel (ODEL full-width promos) ───────────────────────────────────

class HomeBannerCarousel extends StatefulWidget {
  const HomeBannerCarousel({
    super.key,
    required this.slides,
    required this.accent,
    required this.titleColor,
    required this.height,
    this.onCtaTap,
    this.edgeToEdge = true,
  });

  final List<HomeBannerSlide> slides;
  final Color accent;
  final Color titleColor;
  final double height;
  final VoidCallback? onCtaTap;
  final bool edgeToEdge;

  @override
  State<HomeBannerCarousel> createState() => _HomeBannerCarouselState();
}

class _HomeBannerCarouselState extends State<HomeBannerCarousel> {
  late final PageController _pageController;
  Timer? _timer;
  int _index = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _timer = Timer.periodic(const Duration(seconds: 5), (_) => _next());
  }

  void _next() {
    if (!mounted || widget.slides.isEmpty) return;
    final next = (_index + 1) % widget.slides.length;
    _pageController.animateToPage(
      next,
      duration: const Duration(milliseconds: 650),
      curve: Curves.easeInOut,
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.slides.isEmpty) return const SizedBox.shrink();

    final radius = widget.edgeToEdge ? 0.0 : 12.0;

    return Column(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(radius),
          child: SizedBox(
            height: widget.height,
            width: double.infinity,
            child: PageView.builder(
              controller: _pageController,
              itemCount: widget.slides.length,
              onPageChanged: (i) => setState(() => _index = i),
              itemBuilder: (context, i) => _BannerSlide(
                slide: widget.slides[i],
                accent: widget.accent,
                titleColor: widget.titleColor,
                onCtaTap: widget.onCtaTap,
              ),
            ),
          ),
        ),
        const SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            for (var i = 0; i < widget.slides.length; i++)
              AnimatedContainer(
                duration: const Duration(milliseconds: 250),
                margin: const EdgeInsets.symmetric(horizontal: 3),
                width: i == _index ? 20 : 7,
                height: 7,
                decoration: BoxDecoration(
                  color: i == _index ? widget.accent : const Color.fromRGBO(78, 70, 57, 0.55),
                  borderRadius: BorderRadius.circular(999),
                ),
              ),
          ],
        ),
      ],
    );
  }
}

class _BannerSlide extends StatelessWidget {
  const _BannerSlide({
    required this.slide,
    required this.accent,
    required this.titleColor,
    this.onCtaTap,
  });

  final HomeBannerSlide slide;
  final Color accent;
  final Color titleColor;
  final VoidCallback? onCtaTap;

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        ProductNetworkImage(
          imageUrl: slide.imageUrl,
          fit: BoxFit.cover,
          fallbackAsset: slide.fallbackAsset,
        ),
        const DecoratedBox(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Color.fromRGBO(8, 8, 8, 0.1),
                Color.fromRGBO(8, 8, 8, 0.45),
                Color(0xE60E0E0E),
              ],
              stops: [0.0, 0.45, 1.0],
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: accent.withValues(alpha: 0.92),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  slide.eyebrow,
                  style: GoogleFonts.manrope(
                    fontSize: 10,
                    letterSpacing: 1.4,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF2A2420),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Text(
                slide.title,
                style: GoogleFonts.notoSerif(
                  fontSize: 32,
                  height: 38 / 32,
                  letterSpacing: -0.3,
                  color: titleColor,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                slide.subtitle,
                style: GoogleFonts.manrope(fontSize: 13, height: 20 / 13, color: const Color(0xFFD1C5B4)),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 16),
              GestureDetector(
                onTap: onCtaTap,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 11),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    slide.cta,
                    style: GoogleFonts.manrope(
                      fontSize: 11,
                      letterSpacing: 1.4,
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFF1A1A1A),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// ─── ODEL search bar ──────────────────────────────────────────────────────────

class OdelHomeSearchBar extends StatelessWidget {
  const OdelHomeSearchBar({super.key, required this.accent});

  final Color accent;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.of(context).push(
        MaterialPageRoute(builder: (_) => const SearchDiscoveryScreen()),
      ),
      child: Container(
        height: 48,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          color: const Color(0xFF1C1B1B),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: const Color.fromRGBO(78, 70, 57, 0.4)),
        ),
        child: Row(
          children: [
            Icon(Icons.search_rounded, size: 22, color: accent),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                'Search menswear, brands, styles…',
                style: GoogleFonts.manrope(fontSize: 14, color: const Color(0xFF8A8278)),
              ),
            ),
            Icon(Icons.tune_rounded, size: 20, color: accent.withValues(alpha: 0.7)),
          ],
        ),
      ),
    );
  }
}

// ─── Sale ticker (ODEL red promo strip) ───────────────────────────────────────

class OdelSaleStrip extends StatelessWidget {
  const OdelSaleStrip({super.key, required this.accent});

  final Color accent;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [accent, accent.withValues(alpha: 0.75)],
        ),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        children: [
          const Icon(Icons.local_offer_outlined, size: 20, color: Color(0xFF2A2420)),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              'WEEKEND SALE — Up to 30% off formal & casual menswear',
              style: GoogleFonts.manrope(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.3,
                color: const Color(0xFF2A2420),
              ),
            ),
          ),
          Icon(Icons.chevron_right_rounded, size: 22, color: const Color(0xFF2A2420).withValues(alpha: 0.8)),
        ],
      ),
    );
  }
}

// ─── Quick categories (ODEL icon row) ─────────────────────────────────────────

class OdelQuickCategoryStrip extends StatelessWidget {
  const OdelQuickCategoryStrip({
    super.key,
    required this.categories,
    required this.accent,
    required this.onCategoryTap,
  });

  final List<OdelQuickCategory> categories;
  final Color accent;
  final ValueChanged<int> onCategoryTap;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'SHOP MEN',
          style: GoogleFonts.manrope(fontSize: 11, letterSpacing: 2.2, fontWeight: FontWeight.w600, color: accent),
        ),
        const SizedBox(height: 14),
        SizedBox(
          height: 108,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: categories.length,
            separatorBuilder: (_, __) => const SizedBox(width: 14),
            itemBuilder: (context, i) {
              final c = categories[i];
              return GestureDetector(
                onTap: () => onCategoryTap(c.filterIndex),
                child: SizedBox(
                  width: 72,
                  child: Column(
                    children: [
                      ClipOval(
                        child: SizedBox(
                          width: 64,
                          height: 64,
                          child: ProductNetworkImage(
                            imageUrl: c.imageUrl,
                            fit: BoxFit.cover,
                            fallbackAsset: c.fallbackAsset,
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        c.label,
                        textAlign: TextAlign.center,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.manrope(fontSize: 10, height: 13 / 10, color: const Color(0xFFE5E2E1)),
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

// ─── Dual promo row (ODEL two banners side by side) ───────────────────────────

class OdelDualPromoRow extends StatelessWidget {
  const OdelDualPromoRow({
    super.key,
    required this.promos,
    required this.accent,
    required this.onPromoTap,
  });

  final List<OdelDualPromo> promos;
  final Color accent;
  final ValueChanged<int> onPromoTap;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        for (var i = 0; i < promos.length; i++) ...[
          if (i > 0) const SizedBox(width: 10),
          Expanded(
            child: _DualPromoCard(
              promo: promos[i],
              accent: accent,
              onTap: () => onPromoTap(promos[i].filterIndex),
            ),
          ),
        ],
      ],
    );
  }
}

class _DualPromoCard extends StatelessWidget {
  const _DualPromoCard({required this.promo, required this.accent, required this.onTap});

  final OdelDualPromo promo;
  final Color accent;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: AspectRatio(
          aspectRatio: 1.05,
          child: Stack(
            fit: StackFit.expand,
            children: [
              ProductNetworkImage(imageUrl: promo.imageUrl, fit: BoxFit.cover, fallbackAsset: promo.fallbackAsset),
              DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Colors.transparent, Colors.black.withValues(alpha: 0.75)],
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
                    Text(
                      promo.title,
                      style: GoogleFonts.notoSerif(fontSize: 16, color: Colors.white),
                    ),
                    Text(
                      promo.subtitle,
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
  }
}

// ─── Brand grid (ODEL featured brands) ────────────────────────────────────────

class OdelBrandGrid extends StatelessWidget {
  const OdelBrandGrid({super.key, required this.brands, required this.accent});

  final List<String> brands;
  final Color accent;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'FEATURED BRANDS',
          style: GoogleFonts.manrope(fontSize: 11, letterSpacing: 2.2, fontWeight: FontWeight.w600, color: accent),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            for (final b in brands)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                decoration: BoxDecoration(
                  color: const Color(0xFF1C1B1B),
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(color: const Color.fromRGBO(78, 70, 57, 0.45)),
                ),
                child: Text(
                  b,
                  style: GoogleFonts.manrope(
                    fontSize: 11,
                    letterSpacing: 1.2,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFFE5E2E1),
                  ),
                ),
              ),
          ],
        ),
      ],
    );
  }
}

// ─── Brand marquee ────────────────────────────────────────────────────────────

class HomeBrandMarquee extends StatefulWidget {
  const HomeBrandMarquee({super.key, required this.brands, required this.accent});

  final List<String> brands;
  final Color accent;

  @override
  State<HomeBrandMarquee> createState() => _HomeBrandMarqueeState();
}

class _HomeBrandMarqueeState extends State<HomeBrandMarquee> {
  final _scrollController = ScrollController();
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _startScroll());
  }

  void _startScroll() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(milliseconds: 40), (_) {
      if (!_scrollController.hasClients) return;
      final max = _scrollController.position.maxScrollExtent;
      final next = _scrollController.offset + 1.2;
      if (next >= max) {
        _scrollController.jumpTo(0);
      } else {
        _scrollController.jumpTo(next);
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final items = [...widget.brands, ...widget.brands];

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        color: const Color(0xFF1C1B1B),
        border: Border(
          top: BorderSide(color: const Color.fromRGBO(78, 70, 57, 0.35)),
          bottom: BorderSide(color: const Color.fromRGBO(78, 70, 57, 0.35)),
        ),
      ),
      child: SizedBox(
        height: 26,
        child: ListView.separated(
          controller: _scrollController,
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          physics: const NeverScrollableScrollPhysics(),
          itemCount: items.length,
          separatorBuilder: (_, __) => Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Text('·', style: GoogleFonts.manrope(color: widget.accent.withValues(alpha: 0.45))),
          ),
          itemBuilder: (_, i) => Center(
            child: Text(
              items[i],
              style: GoogleFonts.manrope(fontSize: 11, letterSpacing: 2, fontWeight: FontWeight.w600, color: const Color(0xFFE5E2E1)),
            ),
          ),
        ),
      ),
    );
  }
}

// ─── Flash deals strip ────────────────────────────────────────────────────────

class HomePromoStrip extends StatelessWidget {
  const HomePromoStrip({
    super.key,
    required this.tiles,
    required this.accent,
    this.title = 'FLASH DEALS',
  });

  final List<HomePromoTile> tiles;
  final Color accent;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: GoogleFonts.manrope(fontSize: 11, letterSpacing: 2.2, fontWeight: FontWeight.w600, color: accent),
            ),
            GestureDetector(
              onTap: () => Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const ProductListingScreen()),
              ),
              child: Text(
                'VIEW ALL',
                style: GoogleFonts.manrope(fontSize: 11, letterSpacing: 1, color: const Color(0xFF8A8278)),
              ),
            ),
          ],
        ),
        const SizedBox(height: 14),
        SizedBox(
          height: 230,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: tiles.length,
            separatorBuilder: (_, __) => const SizedBox(width: 12),
            itemBuilder: (context, i) {
              final t = tiles[i];
              return GestureDetector(
                onTap: () => Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => const ProductListingScreen()),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: SizedBox(
                    width: 148,
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        ProductNetworkImage(imageUrl: t.imageUrl, fit: BoxFit.cover, fallbackAsset: t.fallbackAsset),
                        const DecoratedBox(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [Colors.transparent, Color(0xE60E0E0E)],
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
                              Text(t.label, style: GoogleFonts.manrope(fontSize: 12, fontWeight: FontWeight.w600, color: Colors.white)),
                              Text(t.priceHint, style: GoogleFonts.manrope(fontSize: 10, color: const Color(0xFFD1C5B4))),
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

// ─── Department grid (ODEL large tiles) ───────────────────────────────────────

class HomeCategoryGrid extends StatelessWidget {
  const HomeCategoryGrid({
    super.key,
    required this.tiles,
    required this.accent,
    required this.onCategoryTap,
  });

  final List<HomeCategoryTile> tiles;
  final Color accent;
  final ValueChanged<int> onCategoryTap;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'SHOP BY DEPARTMENT',
          style: GoogleFonts.manrope(fontSize: 11, letterSpacing: 2.2, fontWeight: FontWeight.w600, color: accent),
        ),
        const SizedBox(height: 14),
        LayoutBuilder(
          builder: (context, c) {
            final gap = 10.0;
            final w = (c.maxWidth - gap) / 2;
            return Wrap(
              spacing: gap,
              runSpacing: gap,
              children: [
                for (final t in tiles)
                  SizedBox(
                    width: w,
                    height: w * 1.12,
                    child: GestureDetector(
                      onTap: () => onCategoryTap(t.filterIndex),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Stack(
                          fit: StackFit.expand,
                          children: [
                            ProductNetworkImage(imageUrl: t.imageUrl, fit: BoxFit.cover, fallbackAsset: t.fallbackAsset),
                            if (t.showTitleOverlay) ...[
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
                                left: 12,
                                right: 12,
                                bottom: 12,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(t.title, style: GoogleFonts.notoSerif(fontSize: 20, color: Colors.white)),
                                    Text(t.subtitle, style: GoogleFonts.manrope(fontSize: 10, color: const Color(0xFFD1C5B4))),
                                  ],
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                    ),
                  ),
              ],
            );
          },
        ),
      ],
    );
  }
}

// ─── Horizontal product row (ODEL “New Products”) ─────────────────────────────

class OdelProductRow extends StatelessWidget {
  const OdelProductRow({
    super.key,
    required this.title,
    required this.products,
    required this.accent,
    required this.titleColor,
    this.onViewAll,
  });

  final String title;
  final List<Product> products;
  final Color accent;
  final Color titleColor;
  final VoidCallback? onViewAll;

  @override
  Widget build(BuildContext context) {
    if (products.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: GoogleFonts.manrope(fontSize: 11, letterSpacing: 2.2, fontWeight: FontWeight.w600, color: accent),
            ),
            if (onViewAll != null)
              GestureDetector(
                onTap: onViewAll,
                child: Text(
                  'VIEW ALL',
                  style: GoogleFonts.manrope(fontSize: 11, letterSpacing: 1, color: const Color(0xFF8A8278)),
                ),
              ),
          ],
        ),
        const SizedBox(height: 14),
        SizedBox(
          height: 268,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: products.length,
            separatorBuilder: (_, __) => const SizedBox(width: 12),
            itemBuilder: (context, i) {
              final p = products[i];
              return GestureDetector(
                onTap: () => Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => ProductDetailScreen(product: p)),
                ),
                child: SizedBox(
                  width: 148,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: ColoredBox(
                            color: const Color(0xFF1C1B1B),
                            child: p.primaryImageUrl.isEmpty
                                ? const SizedBox.expand()
                                : ProductNetworkImage(
                                    imageUrl: p.primaryImageUrl,
                                    fit: BoxFit.cover,
                                    width: double.infinity,
                                    fallbackAsset: fallbackForProduct(p.id, p.categoryId),
                                  ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        p.name,
                        style: GoogleFonts.manrope(fontSize: 12, color: titleColor, height: 16 / 12),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${p.currency} ${p.price}',
                        style: GoogleFonts.manrope(fontSize: 13, fontWeight: FontWeight.w600, color: accent),
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
