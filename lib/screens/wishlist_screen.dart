import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';

import 'login_screen.dart';
import 'notifications_screen.dart';
import 'product_detail_screen.dart';
import 'search_discovery_screen.dart';
import 'shopping_bag_screen.dart';
import '../data/local_catalogue.dart';
import '../data/models/wishlist_item.dart';
import '../state/providers.dart';
import '../utils/format.dart';
import '../widgets/atelier_bottom_nav.dart';
import '../widgets/product_network_image.dart';
import '../data/fashion_image_urls.dart';

class WishlistScreen extends ConsumerStatefulWidget {
  const WishlistScreen({super.key});

  @override
  ConsumerState<WishlistScreen> createState() => _WishlistScreenState();
}

class _WishlistScreenState extends ConsumerState<WishlistScreen> {
  static const _bg = Color(0xFF080808);
  static const _topBarBg = Color(0xFF080808);
  static const _text = Color(0xFFF5F0E8);
  static const _muted = Color(0xFF99907E);
  static const _card = Color(0xFF2A2420);
  static const _accent = Color(0xFFB8963E);
  static const _accentSoft = Color(0xFFE0C29A);
  static const _separator = Color.fromRGBO(53, 53, 52, 0.4);

  final int _activeBottomIndex = 2;

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(currentUserProvider);
    final wishlistAsync = ref.watch(wishlistItemsProvider);
    return Scaffold(
      backgroundColor: _bg,
      body: SafeArea(
        bottom: false,
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 390),
            child: Stack(
              children: [
                Column(
                  children: [
                    _TopAppBar(backgroundColor: _topBarBg, titleColor: _text),
                    Expanded(
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.fromLTRB(24, 52, 24, 96),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'MY WISHLIST',
                                  style: GoogleFonts.notoSerif(
                                    fontSize: 30,
                                    height: 36 / 30,
                                    letterSpacing: 0.75,
                                    color: _text,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  wishlistAsync.when(
                                    data: (items) => '(${items.length} PIECES)',
                                    loading: () => '(…)',
                                    error: (_, __) => '',
                                  ),
                                  style: GoogleFonts.plusJakartaSans(
                                    fontSize: 14,
                                    height: 20 / 14,
                                    letterSpacing: 1.4,
                                    color: _muted,
                                  ),
                                ),
                              ],
                            ),
                            IconButton(
                              onPressed: () {},
                              icon: SvgPicture.asset(
                                'assets/images/icon_share.svg',
                                width: 14,
                                height: 18,
                                colorFilter: const ColorFilter.mode(_text, BlendMode.srcIn),
                              ),
                              padding: EdgeInsets.zero,
                              constraints: const BoxConstraints.tightFor(width: 32, height: 32),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Container(height: 1, width: double.infinity, color: _separator),
                        const SizedBox(height: 24),
                        if (user == null)
                          _GuestWishlistPrompt(accent: _accent, muted: _muted)
                        else
                          wishlistAsync.when(
                            data: (items) {
                              if (items.isEmpty) {
                                return Text(
                                  'Save items from product pages with the heart icon.',
                                  style: GoogleFonts.manrope(fontSize: 14, color: _muted, height: 22 / 14),
                                );
                              }
                              return GridView.builder(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: items.length,
                                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2,
                                  mainAxisSpacing: 16,
                                  crossAxisSpacing: 16,
                                  childAspectRatio: 1 / 1.68,
                                ),
                                itemBuilder: (context, index) => _FirestoreWishCard(
                                  item: items[index],
                                  card: _card,
                                  accent: _accent,
                                  text: _text,
                                  onRemove: () {
                                    final w = ref.read(wishlistRepositoryProvider);
                                    if (w == null) return;
                                    w.remove(user.uid, items[index].productId);
                                  },
                                  onOpen: () => _openProduct(context, items[index].productId),
                                ),
                              );
                            },
                            loading: () => const Center(child: CircularProgressIndicator()),
                            error: (e, _) => Text('Could not load wishlist.', style: GoogleFonts.manrope(color: _muted)),
                          ),
                        const SizedBox(height: 96),
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
        ),
      ),
    );
  }

  void _navigateBottom(BuildContext context, int idx) {
    if (idx == _activeBottomIndex) return;
    AtelierBottomNav.go(context, idx);
  }

  Future<void> _openProduct(BuildContext context, String productId) async {
    final repo = ref.read(productRepositoryProvider);
    final product = repo != null ? await repo.getById(productId) : LocalCatalogue.productById(productId);
    if (!context.mounted || product == null) return;
    Navigator.of(context).push(MaterialPageRoute(builder: (_) => ProductDetailScreen(product: product)));
  }
}

class _GuestWishlistPrompt extends StatelessWidget {
  const _GuestWishlistPrompt({required this.accent, required this.muted});
  final Color accent;
  final Color muted;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Sign in to save favourites across devices.', style: GoogleFonts.manrope(fontSize: 14, color: muted, height: 22 / 14)),
        const SizedBox(height: 16),
        FilledButton(
          onPressed: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const LoginScreen())),
          style: FilledButton.styleFrom(backgroundColor: accent, foregroundColor: const Color(0xFF2A2420)),
          child: const Text('SIGN IN'),
        ),
      ],
    );
  }
}

class _FirestoreWishCard extends StatelessWidget {
  const _FirestoreWishCard({
    required this.item,
    required this.card,
    required this.accent,
    required this.text,
    required this.onRemove,
    required this.onOpen,
  });

  final WishlistItem item;
  final Color card;
  final Color accent;
  final Color text;
  final VoidCallback onRemove;
  final VoidCallback onOpen;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onOpen,
      child: Container(
        color: card,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Stack(
                fit: StackFit.expand,
                children: [
                  ColoredBox(
                    color: const Color(0xFF0E0E0E),
                    child: item.imageUrl.isNotEmpty
                        ? ProductNetworkImage(
                            imageUrl: item.imageUrl,
                            fit: BoxFit.cover,
                            fallbackAsset: fallbackForProduct(
                              item.productId,
                              LocalCatalogue.productById(item.productId)?.categoryId,
                            ),
                          )
                        : const SizedBox.shrink(),
                  ),
                  Positioned(
                    top: 8,
                    right: 8,
                    child: GestureDetector(
                      onTap: onRemove,
                      child: const Icon(Icons.favorite_rounded, size: 20, color: Color(0xFFE9C349)),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(item.brand.toUpperCase(), style: GoogleFonts.manrope(fontSize: 9, letterSpacing: 1, color: const Color(0xFF8A8278)), maxLines: 1, overflow: TextOverflow.ellipsis),
                  Text(item.name, style: GoogleFonts.manrope(fontSize: 12, color: text), maxLines: 2, overflow: TextOverflow.ellipsis),
                  Text(formatMoney(item.price, currency: item.currency), style: GoogleFonts.manrope(fontSize: 12, color: accent, fontWeight: FontWeight.w600)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TopAppBar extends StatelessWidget {
  const _TopAppBar({required this.backgroundColor, required this.titleColor});

  final Color backgroundColor;
  final Color titleColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: backgroundColor,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Row(
        children: [
          IconButton(
            onPressed: () => Navigator.of(context).maybePop(),
            icon: const Icon(Icons.menu_rounded, color: Color(0xFFB8963E), size: 22),
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints.tightFor(width: 32, height: 32),
          ),
          const Spacer(),
          Text(
            'ATELIER',
            style: GoogleFonts.libreBaskerville(
              fontSize: 24,
              letterSpacing: 7.2,
              color: titleColor,
              fontWeight: FontWeight.w400,
            ),
          ),
          const Spacer(),
          Row(
            children: [
              IconButton(
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(builder: (_) => const SearchDiscoveryScreen()));
                },
                icon: const Icon(Icons.search_rounded, color: Color(0xFFB8963E), size: 22),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints.tightFor(width: 32, height: 32),
              ),
              const SizedBox(width: 16),
              IconButton(
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(builder: (_) => const ShoppingBagScreen()));
                },
                icon: const Icon(Icons.shopping_bag_outlined, color: Color(0xFFB8963E), size: 20),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints.tightFor(width: 32, height: 32),
              ),
              const SizedBox(width: 16),
              IconButton(
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(builder: (_) => const NotificationsScreen()));
                },
                icon: const Icon(Icons.notifications_none_rounded, color: Color(0xFFB8963E), size: 22),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints.tightFor(width: 32, height: 32),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _WishlistCard extends StatelessWidget {
  const _WishlistCard({
    required this.item,
    required this.card,
    required this.imageBg,
    required this.accent,
    required this.accentSoft,
    required this.text,
  });

  final _WishItem item;
  final Color card;
  final Color imageBg;
  final Color accent;
  final Color accentSoft;
  final Color text;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(0),
      child: Container(
        color: card,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                Container(
                  color: imageBg,
                  height: 217.33,
                  width: double.infinity,
                  child: Opacity(
                    opacity: 0.9,
                    child: Image.asset(
                      item.imagePath,
                      fit: BoxFit.cover,
                      width: double.infinity,
                      height: double.infinity,
                      errorBuilder: (context, error, stackTrace) => const ColoredBox(color: Color(0xFF201F1F)),
                    ),
                  ),
                ),
                Positioned(
                  left: 16,
                  top: 16,
                  child: item.lowStock
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(2),
                          child: BackdropFilter(
                            filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 5),
                              decoration: BoxDecoration(
                                color: accent.withValues(alpha: 0.2),
                                border: Border.all(color: accent.withValues(alpha: 0.3), width: 1),
                              ),
                              child: Text(
                                'LOW STOCK',
                                style: GoogleFonts.plusJakartaSans(
                                  fontSize: 9,
                                  height: 13.5 / 9,
                                  letterSpacing: 0.9,
                                  color: const Color(0xFFE8C265),
                                ),
                              ),
                            ),
                          ),
                        )
                      : const SizedBox(),
                ),
                const Positioned(
                  right: 16,
                  top: 16,
                  child: Icon(Icons.favorite_rounded, size: 18, color: Color(0xFFB8963E)),
                ),
              ],
            ),
            Expanded(
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                    colors: [Color(0xFF2A2420), Color.fromRGBO(42, 36, 32, 0.95)],
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.brand,
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 10,
                        height: 15 / 10,
                        letterSpacing: 1,
                        color: accent,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Expanded(
                      child: Text(
                        item.title,
                        style: GoogleFonts.notoSerif(
                          fontSize: 16,
                          height: 20 / 16,
                          color: text,
                        ),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      item.price,
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 14,
                        height: 20 / 14,
                        letterSpacing: 0.7,
                        color: accentSoft,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Container(
                      height: 38,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        border: Border.all(color: accent, width: 1),
                        borderRadius: BorderRadius.circular(9999),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        'ADD TO BAG',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 10,
                          height: 15 / 10,
                          letterSpacing: 1,
                          color: accent,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _WishItem {
  const _WishItem(this.brand, this.title, this.price, this.lowStock, this.imagePath);

  final String brand;
  final String title;
  final String price;
  final bool lowStock;
  final String imagePath;
}

