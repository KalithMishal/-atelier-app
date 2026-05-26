import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';

import 'product_reviews_screen.dart';
import 'size_guide_screen.dart';
import 'notifications_screen.dart';
import 'search_discovery_screen.dart';
import 'shopping_bag_screen.dart';
import '../data/models/product.dart';
import '../state/providers.dart';
import '../utils/format.dart';
import '../widgets/product_network_image.dart';

/// Product Detail (13) — matches the provided Figma/PNG layout.
class ProductDetailScreen extends StatefulWidget {
  const ProductDetailScreen({super.key, required this.product});

  final Product product;

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  static const _sizes = ['S', 'M', 'L', 'XL', 'XXL'];

  int _selectedSize = 2; // L
  int _selectedColor = 0;
  int _selectedImage = 0;

  static const _bg = Color(0xFF080808);

  static const _overlayMaxW = 520.0;
  static const _overlayMinW = 390.0;

  List<String> get _gallery => widget.product.galleryForColor(_selectedColor);

  String get _heroUrl {
    final g = _gallery;
    if (g.isEmpty) return widget.product.primaryImageUrl;
    return g[_selectedImage.clamp(0, g.length - 1)];
  }

  void _onColorSelected(int index) {
    setState(() {
      _selectedColor = index;
      _selectedImage = 0;
    });
  }

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
                            child: _heroUrl.isEmpty
                                ? Image.asset('assets/images/search_edit_quiet.png', fit: BoxFit.cover)
                                : ProductNetworkImage(
                                    key: ValueKey('$_heroUrl-$_selectedColor-$_selectedImage'),
                                    imageUrl: _heroUrl,
                                    fit: BoxFit.cover,
                                    opacity: 0.95,
                                    fallbackAsset: ProductNetworkImage.fallbackAssetFor(
                                      widget.product.id,
                                      widget.product.categoryId,
                                    ),
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
                          Positioned(
                            left: 24,
                            bottom: 24 + 128,
                            child: _FilmstripLeft(
                              imageUrls: _gallery,
                              selectedIndex: _selectedImage,
                              onSelect: (i) => setState(() => _selectedImage = i),
                              fallbackAsset: ProductNetworkImage.fallbackAssetFor(
                                widget.product.id,
                                widget.product.categoryId,
                              ),
                            ),
                          ),
                          Positioned(
                            left: 24,
                            right: 24,
                            bottom: 24,
                            child: _BottomCtas(
                              product: widget.product,
                              selectedSize: _selectedSize,
                              selectedColor: _selectedColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SliverToBoxAdapter(
                    child: _DetailsCard(
                      product: widget.product,
                      selectedSize: _selectedSize,
                      onSelectSize: (i) => setState(() => _selectedSize = i),
                      selectedColor: _selectedColor,
                      onSelectColor: _onColorSelected,
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
  const _FilmstripLeft({
    required this.imageUrls,
    required this.selectedIndex,
    required this.onSelect,
    required this.fallbackAsset,
  });

  final List<String> imageUrls;
  final int selectedIndex;
  final ValueChanged<int> onSelect;
  final String fallbackAsset;

  @override
  Widget build(BuildContext context) {
    final total = imageUrls.length;
    final counter = total == 0 ? '—' : '${(selectedIndex + 1).toString().padLeft(2, '0')} / ${total.toString().padLeft(2, '0')}';

    Widget thumb({required int index, required bool active, required String url}) => GestureDetector(
          onTap: () => onSelect(index),
          child: Container(
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
                child: ProductNetworkImage(
                  imageUrl: url,
                  fit: BoxFit.cover,
                  height: 64,
                  width: 48,
                  fallbackAsset: fallbackAsset,
                ),
              ),
            ),
          ),
        );

    final n = imageUrls.length;
    const window = 3;
    final start = n <= window ? 0 : (selectedIndex - 1).clamp(0, n - window);
    final visible = n <= window ? imageUrls : imageUrls.sublist(start, start + window);

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
                counter,
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
        if (visible.isEmpty) const SizedBox.shrink() else ...[
          const SizedBox(height: 12),
          for (var i = 0; i < visible.length; i++) ...[
            if (i > 0) const SizedBox(height: 12),
            thumb(
              index: start + i,
              active: start + i == selectedIndex,
              url: visible[i],
            ),
          ],
        ],
      ],
    );
  }
}

class _BottomCtas extends ConsumerWidget {
  const _BottomCtas({
    required this.product,
    required this.selectedSize,
    required this.selectedColor,
  });

  final Product product;
  final int selectedSize;
  final int selectedColor;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
              onTap: () async {
                final user = ref.read(currentUserProvider);
                if (user == null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Please sign in to add items to your bag.')),
                  );
                  return;
                }

                final sizes = _ProductDetailScreenState._sizes;
                final size = selectedSize < sizes.length ? sizes[selectedSize] : sizes[2];
                final color = product.colorVariants.isNotEmpty && selectedColor < product.colorVariants.length
                    ? product.colorVariants[selectedColor].name
                    : 'Default';

                try {
                  final cart = ref.read(cartRepositoryProvider);
                  if (cart == null) {
                    if (!context.mounted) return;
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Bag sync is unavailable on Windows desktop. Use Android or Chrome.'),
                      ),
                    );
                    return;
                  }
                  await cart.addOrIncrement(
                        uid: user.uid,
                        product: product,
                        qty: 1,
                        variant: {'size': size, 'color': color},
                      );
                  if (!context.mounted) return;
                  Navigator.of(context).push(MaterialPageRoute(builder: (_) => const ShoppingBagScreen()));
                } catch (e) {
                  if (!context.mounted) return;
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Could not add to bag. ${e.toString()}')),
                  );
                }
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
        Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(9999),
            onTap: () => _showReserveInBoutiqueSheet(context, product, selectedSize, selectedColor),
            child: Ink(
              decoration: BoxDecoration(
                border: Border.all(color: const Color.fromRGBO(229, 231, 235, 0.6), width: 1),
                borderRadius: BorderRadius.circular(9999),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 17),
                child: Center(
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
              ),
            ),
          ),
        ),
      ],
    );
  }
}

/// NOLIMIT partner line — same public contact as catalogue [retailerUrl] seeds.
Future<void> _showReserveInBoutiqueSheet(
  BuildContext context,
  Product product,
  int selectedSize,
  int selectedColor,
) async {
  final sizes = _ProductDetailScreenState._sizes;
  final size = selectedSize < sizes.length ? sizes[selectedSize] : sizes[2];
  final color = product.colorVariants.isNotEmpty && selectedColor < product.colorVariants.length
      ? product.colorVariants[selectedColor].name
      : 'Default';
  final storeUri = Uri.tryParse(product.retailerUrl ?? '') ?? Uri.parse('https://www.nolimit.lk/');
  final nolimitCareTel = Uri.parse('tel:+94773540816');

  await showModalBottomSheet<void>(
    context: context,
    backgroundColor: const Color(0xFF2A2420),
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
    ),
    builder: (ctx) {
      return SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 16, 24, 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: const Color.fromRGBO(184, 150, 62, 0.45),
                    borderRadius: BorderRadius.circular(9999),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Text(
                'Reserve in boutique',
                textAlign: TextAlign.center,
                style: GoogleFonts.bodoniModa(
                  fontSize: 22,
                  height: 28 / 22,
                  color: const Color(0xFFF5F0E8),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                '${product.brand} · ${product.name}\nSize $size · $color',
                textAlign: TextAlign.center,
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 13,
                  height: 1.4,
                  color: const Color(0xFFD0C5B2),
                ),
              ),
              const SizedBox(height: 20),
              FilledButton.icon(
                style: FilledButton.styleFrom(
                  backgroundColor: const Color(0xFFB8963E),
                  foregroundColor: const Color(0xFF2A2420),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
                onPressed: () async {
                  try {
                    await launchUrl(nolimitCareTel);
                  } catch (_) {
                    if (ctx.mounted) {
                      ScaffoldMessenger.of(ctx).showSnackBar(
                        const SnackBar(content: Text('Could not start the phone app. Call +94 77 354 0816.')),
                      );
                    }
                  }
                },
                icon: const Icon(Icons.phone_outlined, size: 20),
                label: Text('Call NOLIMIT', style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
              ),
              const SizedBox(height: 10),
              OutlinedButton.icon(
                style: OutlinedButton.styleFrom(
                  foregroundColor: const Color(0xFFF5F0E8),
                  side: const BorderSide(color: Color.fromRGBO(229, 231, 235, 0.35)),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
                onPressed: () async {
                  try {
                    await launchUrl(storeUri, mode: LaunchMode.externalApplication);
                  } catch (_) {
                    if (ctx.mounted) {
                      ScaffoldMessenger.of(ctx).showSnackBar(
                        SnackBar(content: Text('Open this link in a browser:\n$storeUri')),
                      );
                    }
                  }
                },
                icon: const Icon(Icons.open_in_new_rounded, size: 20),
                label: Text('Open store website', style: GoogleFonts.poppins(fontWeight: FontWeight.w500)),
              ),
              const SizedBox(height: 10),
              TextButton(
                onPressed: () async {
                  final text =
                      'Reserve: ${product.brand} ${product.name}\nSize $size · Color $color\n${formatMoney(product.price, currency: product.currency)}\n$storeUri';
                  await Clipboard.setData(ClipboardData(text: text));
                  if (!ctx.mounted) return;
                  Navigator.of(ctx).pop();
                  if (!context.mounted) return;
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Reservation details copied — paste in chat, email, or DM.')),
                  );
                },
                child: Text(
                  'Copy details for concierge',
                  style: GoogleFonts.poppins(fontSize: 13, color: const Color(0xFFB8963E)),
                ),
              ),
            ],
          ),
        ),
      );
    },
  );
}

class _DetailsCard extends StatelessWidget {
  const _DetailsCard({
    required this.product,
    required this.selectedSize,
    required this.onSelectSize,
    required this.selectedColor,
    required this.onSelectColor,
  });

  final Product product;
  final int selectedSize;
  final ValueChanged<int> onSelectSize;
  final int selectedColor;
  final ValueChanged<int> onSelectColor;

  @override
  Widget build(BuildContext context) {
    final sizes = _ProductDetailScreenState._sizes;
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
            product.brand.toUpperCase(),
            style: GoogleFonts.poppins(
              fontSize: 12,
              height: 16 / 12,
              letterSpacing: 3.0,
              color: const Color(0xFFB8963E),
            ),
          ),
          const SizedBox(height: 10),
          Text(
            product.name,
            textAlign: TextAlign.center,
            style: GoogleFonts.bodoniModa(
              fontSize: 30,
              height: 37.5 / 30,
              letterSpacing: 0.75,
              color: const Color(0xFFF5F0E8),
            ),
          ),
          const SizedBox(height: 8),
          TextButton.icon(
            onPressed: () {
              final msg = '${product.brand} — ${product.name}\n${formatMoney(product.price, currency: product.currency)}';
              Clipboard.setData(ClipboardData(text: msg));
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Product details copied to clipboard')),
              );
            },
            icon: const Icon(Icons.ios_share_rounded, size: 18, color: Color(0xFFB8963E)),
            label: Text('SHARE', style: GoogleFonts.manrope(fontSize: 12, letterSpacing: 1.2, color: const Color(0xFFB8963E))),
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
            formatMoney(product.price, currency: product.currency),
            style: GoogleFonts.bodoniModa(fontSize: 30, height: 36 / 30, letterSpacing: 1, color: const Color(0xFFB8963E)),
          ),
          if (product.retailerUrl != null && product.retailerUrl!.isNotEmpty) ...[
            const SizedBox(height: 8),
            Text(
              'Inspired by ${product.brand} · nolimit.lk',
              style: GoogleFonts.poppins(fontSize: 11, color: const Color(0xFF9A8F80)),
            ),
          ],
          const SizedBox(height: 16),
          if (product.description.isNotEmpty)
            Opacity(
              opacity: 0.9,
              child: Text(
                product.description,
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
                for (int i = 0; i < sizes.length; i++)
                  Padding(
                    padding: const EdgeInsets.only(right: 12),
                    child: _SizePill(
                      label: sizes[i],
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
          if (product.colorVariants.isEmpty)
            Text(
              'One colour available',
              style: GoogleFonts.poppins(fontSize: 12, color: const Color(0xFF9A8F80)),
            )
          else
            Wrap(
              spacing: 16,
              runSpacing: 12,
              children: [
                for (var i = 0; i < product.colorVariants.length; i++)
                  _ColorChip(
                    label: product.colorVariants[i].name,
                    color: product.colorAt(i) ?? const Color(0xFF111111),
                    selected: selectedColor == i,
                    onTap: () => onSelectColor(i),
                  ),
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

class _ColorChip extends StatelessWidget {
  const _ColorChip({
    required this.label,
    required this.color,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final Color color;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(9999),
              border: Border.all(
                color: selected ? const Color(0xFFB8963E) : const Color.fromRGBO(245, 240, 232, 0.25),
                width: selected ? 2 : 1,
              ),
            ),
          ),
          const SizedBox(height: 6),
          Text(
            label,
            style: GoogleFonts.poppins(
              fontSize: 10,
              color: selected ? const Color(0xFFB8963E) : const Color(0xFF9A8F80),
            ),
          ),
        ],
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

