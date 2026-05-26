import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import '../config/department_subcategories.dart';
import '../data/models/product.dart';
import '../state/providers.dart';
import '../widgets/atelier_bottom_nav.dart';
import '../widgets/product_network_image.dart';
import 'product_listing_screen.dart';
import 'search_discovery_screen.dart';
import 'shopping_bag_screen.dart';

/// Department storefront — Men / Women / Kids / Accessories with subcategory grid.
class CategoryLandingScreen extends ConsumerWidget {
  const CategoryLandingScreen({super.key, required this.departmentId});

  final String departmentId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final landing = landingForDepartment(departmentId);
    if (landing == null) {
      return Scaffold(
        backgroundColor: const Color(0xFF131313),
        body: Center(
          child: Text('Unknown department', style: GoogleFonts.manrope(color: Colors.white)),
        ),
      );
    }

    final products = ref.watch(allProductsProvider).value ?? [];
    final deptProducts = products.where((p) => p.categoryId == departmentId).take(8).toList();

    return Scaffold(
      backgroundColor: const Color(0xFF131313),
      body: SafeArea(
        bottom: false,
        child: Stack(
          children: [
            Column(
              children: [
                _TopBar(title: landing.title),
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.only(bottom: 96),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        _Hero(landing: landing),
                        const SizedBox(height: 28),
                        if (landing.subcategories.isNotEmpty) ...[
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: Text(
                              'SHOP BY CATEGORY',
                              style: GoogleFonts.manrope(
                                fontSize: 11,
                                letterSpacing: 2,
                                fontWeight: FontWeight.w700,
                                color: const Color(0xFFE9C349),
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),
                          _SubcategoryGrid(landing: landing),
                        ],
                        if (deptProducts.isNotEmpty) ...[
                          const SizedBox(height: 40),
                          _FeaturedRow(
                            departmentTitle: landing.title,
                            products: deptProducts,
                          ),
                        ],
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
                child: AtelierBottomNavBar.dock(
                  activeIndex: 1,
                  onTap: (i) => AtelierBottomNav.go(context, i),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TopBar extends StatelessWidget {
  const _TopBar({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFF080808),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      child: Row(
        children: [
          IconButton(
            onPressed: () => Navigator.of(context).maybePop(),
            icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20, color: Color(0xFFB8963E)),
          ),
          Expanded(
            child: Text(
              title,
              textAlign: TextAlign.center,
              style: GoogleFonts.libreBaskerville(
                fontSize: 20,
                letterSpacing: 4,
                color: const Color(0xFFF5F0E8),
              ),
            ),
          ),
          IconButton(
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => const SearchDiscoveryScreen()),
            ),
            icon: const Icon(Icons.search_rounded, size: 22, color: Color(0xFFB8963E)),
          ),
          IconButton(
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => const ShoppingBagScreen()),
            ),
            icon: const Icon(Icons.shopping_bag_outlined, size: 20, color: Color(0xFFB8963E)),
          ),
        ],
      ),
    );
  }
}

class _Hero extends StatelessWidget {
  const _Hero({required this.landing});

  final DepartmentLandingData landing;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 220,
      child: Stack(
        fit: StackFit.expand,
        children: [
          ProductNetworkImage(
            imageUrl: landing.heroImageUrl,
            fit: BoxFit.cover,
            fallbackAsset: landing.heroFallbackAsset,
          ),
          DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
                colors: [
                  const Color(0xFF131313),
                  const Color(0xFF131313).withValues(alpha: 0.2),
                ],
              ),
            ),
          ),
          Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  landing.title,
                  style: GoogleFonts.notoSerif(
                    fontSize: 42,
                    letterSpacing: 4,
                    color: const Color(0xFFE5E2E1),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  landing.seasonLabel,
                  style: GoogleFonts.manrope(
                    fontSize: 12,
                    letterSpacing: 2.4,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFFE9C349),
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

class _SubcategoryGrid extends StatelessWidget {
  const _SubcategoryGrid({required this.landing});

  final DepartmentLandingData landing;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final cols = constraints.maxWidth >= 700 ? 3 : 2;
          return GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: landing.subcategories.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: cols,
              crossAxisSpacing: 14,
              mainAxisSpacing: 20,
              childAspectRatio: 0.78,
            ),
            itemBuilder: (_, i) {
              final sub = landing.subcategories[i];
              return _SubcategoryTile(
                sub: sub,
                departmentId: landing.id,
              );
            },
          );
        },
      ),
    );
  }
}

class _SubcategoryTile extends StatelessWidget {
  const _SubcategoryTile({required this.sub, required this.departmentId});

  final DepartmentSubcategory sub;
  final String departmentId;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => ProductListingScreen(
              categoryId: departmentId,
              subCategoryId: sub.id,
              title: sub.label,
            ),
          ),
        );
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: ProductNetworkImage(
                imageUrl: sub.imageUrl,
                fit: BoxFit.cover,
                fallbackAsset: sub.fallbackAsset,
              ),
            ),
          ),
          const SizedBox(height: 12),
          Text(
            sub.label,
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: GoogleFonts.manrope(
              fontSize: 12,
              height: 1.25,
              letterSpacing: 0.4,
              fontWeight: FontWeight.w600,
              color: const Color(0xFFE5E2E1),
            ),
          ),
        ],
      ),
    );
  }
}

class _FeaturedRow extends StatelessWidget {
  const _FeaturedRow({required this.departmentTitle, required this.products});

  final String departmentTitle;
  final List<Product> products;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'POPULAR IN $departmentTitle',
                style: GoogleFonts.notoSerif(fontSize: 18, color: const Color(0xFFE5E2E1)),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => ProductListingScreen(
                        categoryId: products.first.categoryId,
                        title: departmentTitle,
                      ),
                    ),
                  );
                },
                child: Text('View all', style: GoogleFonts.manrope(fontSize: 12, color: const Color(0xFFE9C349))),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 200,
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            scrollDirection: Axis.horizontal,
            itemCount: products.length,
            separatorBuilder: (_, __) => const SizedBox(width: 12),
            itemBuilder: (_, i) {
              final p = products[i];
              return GestureDetector(
                onTap: () => Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => ProductListingScreen(
                      categoryId: p.categoryId,
                      title: departmentTitle,
                    ),
                  ),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: SizedBox(
                    width: 130,
                    child: ProductNetworkImage(
                      imageUrl: p.primaryImageUrl,
                      fit: BoxFit.cover,
                      fallbackAsset: ProductNetworkImage.fallbackAssetFor(p.id, p.categoryId),
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
