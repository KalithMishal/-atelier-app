import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'checkout_delivery_screen.dart';
import 'gift_note_sheet.dart';
import 'notifications_screen.dart';
import 'search_discovery_screen.dart';
import '../state/providers.dart';
import '../data/models/cart_item.dart';
import '../utils/format.dart';
import '../utils/order_pricing.dart';
import '../widgets/atelier_bottom_nav.dart';
import '../widgets/product_network_image.dart';
import 'login_screen.dart';

class ShoppingBagScreen extends ConsumerWidget {
  const ShoppingBagScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(currentUserProvider);
    final itemsAsync = ref.watch(cartItemsProvider);
    final canCheckout = itemsAsync.maybeWhen(
      data: (items) => user != null && items.isNotEmpty,
      orElse: () => false,
    );

    return Scaffold(
      backgroundColor: const Color(0xFF131313),
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            const _TopAppBar(),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(16, 24, 16, 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (user == null)
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 32),
                        child: Text(
                          'Please sign in to view your bag.',
                          style: GoogleFonts.manrope(color: const Color(0xFFD1C5B4)),
                        ),
                      )
                    else
                      itemsAsync.when(
                        data: (items) {
                          if (items.isEmpty) {
                            return Padding(
                              padding: const EdgeInsets.symmetric(vertical: 32),
                              child: Text(
                                'Your bag is empty.',
                                style: GoogleFonts.manrope(color: const Color(0xFFD1C5B4)),
                              ),
                            );
                          }
                          return Column(
                            children: [
                              for (int i = 0; i < items.length; i++) ...[
                                _BagItem(
                                  item: items[i],
                                  onQtyChanged: (qty) {
                                    final c = ref.read(cartRepositoryProvider);
                                    if (c == null) return;
                                    c.setQty(
                                        uid: user.uid,
                                        productId: items[i].productId,
                                        qty: qty,
                                      );
                                  },
                                  onRemove: () {
                                    final c = ref.read(cartRepositoryProvider);
                                    if (c == null) return;
                                    c.remove(
                                        uid: user.uid,
                                        productId: items[i].productId,
                                      );
                                  },
                                ),
                                if (i != items.length - 1) const SizedBox(height: 48),
                              ],
                              const SizedBox(height: 48),
                            ],
                          );
                        },
                        loading: () => const Padding(
                          padding: EdgeInsets.symmetric(vertical: 32),
                          child: Center(child: CircularProgressIndicator()),
                        ),
                        error: (e, _) => Padding(
                          padding: const EdgeInsets.symmetric(vertical: 32),
                          child: Text('Could not load bag.', style: GoogleFonts.manrope(color: const Color(0xFFD1C5B4))),
                        ),
                      ),
                    const _PromoCode(),
                    const SizedBox(height: 48),
                    GestureDetector(
                      onTap: () => showGiftNoteSheet(context),
                      child: Text(
                        'Add a gift note +',
                        style: GoogleFonts.manrope(
                          fontSize: 14,
                          height: 20 / 14,
                          letterSpacing: 0.7,
                          color: const Color(0xFFE9C349),
                          decoration: TextDecoration.underline,
                          decorationColor: const Color.fromRGBO(78, 70, 57, 0.2),
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    if (user != null)
                      itemsAsync.when(
                        data: (items) => _Summary(items: items),
                        loading: () => const SizedBox.shrink(),
                        error: (e, _) => const SizedBox.shrink(),
                      ),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
            SafeArea(
              top: false,
              child: AtelierBottomNavBar.dock(
                activeIndex: -1,
                onTap: (i) => AtelierBottomNav.go(context, i),
              ),
            ),
            _CheckoutFooter(
              enabled: canCheckout,
              onCheckout: () {
                if (user == null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Please sign in to checkout.')),
                  );
                  Navigator.of(context).push(MaterialPageRoute(builder: (_) => const LoginScreen()));
                  return;
                }
                final items = itemsAsync.value ?? const <CartItem>[];
                if (items.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Your bag is empty.')),
                  );
                  return;
                }
                Navigator.of(context).push(MaterialPageRoute(builder: (_) => const CheckoutDeliveryScreen()));
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _TopAppBar extends StatelessWidget {
  const _TopAppBar();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFF080808),
      padding: const EdgeInsets.symmetric(horizontal: 24.6, vertical: 16),
      child: Row(
        children: [
          IconButton(
            onPressed: () => Navigator.of(context).maybePop(),
            icon: const Icon(Icons.menu_rounded, size: 22, color: Color(0xFFB8963E)),
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints.tightFor(width: 40, height: 40),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Center(
              child: Text(
                'ATELIER',
                style: GoogleFonts.libreBaskerville(
                  fontSize: 24,
                  letterSpacing: 7.2,
                  color: const Color(0xFFF5F0E8),
                ),
              ),
            ),
          ),
          Row(
            children: [
              IconButton(
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(builder: (_) => const SearchDiscoveryScreen()));
                },
                icon: const Icon(Icons.search_rounded, size: 22, color: Color(0xFFB8963E)),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints.tightFor(width: 40, height: 40),
              ),
              const SizedBox(width: 16),
              IconButton(
                onPressed: () {},
                icon: const Icon(Icons.shopping_bag_outlined, size: 20, color: Color(0xFFB8963E)),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints.tightFor(width: 40, height: 40),
              ),
              const SizedBox(width: 16),
              IconButton(
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(builder: (_) => const NotificationsScreen()));
                },
                icon: const Icon(Icons.notifications_none_rounded, size: 22, color: Color(0xFFB8963E)),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints.tightFor(width: 40, height: 40),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _BagItem extends StatelessWidget {
  const _BagItem({
    required this.item,
    required this.onQtyChanged,
    required this.onRemove,
  });

  final CartItem item;
  final ValueChanged<int> onQtyChanged;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(2),
          child: Container(
            width: 96,
            height: 128,
            color: const Color(0xFF1C1B1B),
            child: item.imageUrlSnapshot.isEmpty
                ? const SizedBox.shrink()
                : Opacity(
                    opacity: 0.85,
                    child: ProductNetworkImage(
                      imageUrl: item.imageUrlSnapshot,
                      width: 96,
                      height: 128,
                      fit: BoxFit.cover,
                      fallbackAsset: 'assets/images/search_edit_quiet.png',
                    ),
                  ),
          ),
        ),
        const SizedBox(width: 24),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Text(
                      item.brandSnapshot,
                      style: GoogleFonts.notoSerif(fontSize: 18, height: 22.5 / 18, color: const Color(0xFFE5E2E1)),
                    ),
                  ),
                  Text(
                    '${item.currency} ${item.unitPrice}',
                    style: GoogleFonts.manrope(
                      fontSize: 16,
                      height: 24 / 16,
                      fontWeight: FontWeight.w500,
                      letterSpacing: 0.4,
                      color: const Color(0xFFE9C349),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Text(item.nameSnapshot, style: GoogleFonts.manrope(fontSize: 14, height: 20 / 14, color: const Color(0xFFD1C5B4))),
              const SizedBox(height: 8),
              if (item.variant.isNotEmpty)
                Text(
                  item.variant.entries.map((e) => '${e.key}: ${e.value}').join(' • '),
                  style: GoogleFonts.manrope(fontSize: 12, height: 16 / 12, color: const Color(0xFF9A8F80)),
                ),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.only(top: 12),
                decoration: const BoxDecoration(
                  border: Border(top: BorderSide(color: Color.fromRGBO(78, 70, 57, 0.2), width: 1)),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _QtyStepper(qty: item.qty, onChanged: onQtyChanged),
                    _RemoveButton(onRemove: onRemove),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _QtyStepper extends StatelessWidget {
  const _QtyStepper({required this.qty, required this.onChanged});

  final int qty;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(color: const Color(0xFF353534), borderRadius: BorderRadius.circular(12)),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => onChanged(qty - 1),
            child: SvgPicture.asset('assets/images/icon_qty_minus.svg', width: 7.58, height: 0.88),
          ),
          const SizedBox(width: 16),
          Text('$qty', style: GoogleFonts.manrope(fontSize: 14, height: 20 / 14, color: const Color(0xFFE5E2E1))),
          const SizedBox(width: 16),
          GestureDetector(
            onTap: () => onChanged(qty + 1),
            child: SvgPicture.asset('assets/images/icon_qty_plus.svg', width: 7.58, height: 7.58),
          ),
        ],
      ),
    );
  }
}

class _RemoveButton extends StatelessWidget {
  const _RemoveButton({required this.onRemove});

  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onRemove,
      child: Row(
        children: [
          SvgPicture.asset('assets/images/icon_remove.svg', width: 8.87, height: 8.87),
          const SizedBox(width: 4),
          Text(
            'REMOVE',
            style: GoogleFonts.manrope(fontSize: 12, height: 16 / 12, letterSpacing: 1.2, color: const Color(0xFFD1C5B4)),
          ),
        ],
      ),
    );
  }
}

class _PromoCode extends StatelessWidget {
  const _PromoCode();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(color: const Color(0xFF1C1B1B), borderRadius: BorderRadius.circular(4)),
      child: Row(
        children: [
          Expanded(
            child: Container(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 14),
              decoration: BoxDecoration(color: const Color(0xFF353534), borderRadius: BorderRadius.circular(2)),
              child: Text(
                'Promo Code / Gift Card',
                style: GoogleFonts.manrope(fontSize: 14, color: const Color.fromRGBO(209, 197, 180, 0.5)),
              ),
            ),
          ),
          const SizedBox(width: 16),
          Text(
            'APPLY',
            style: GoogleFonts.manrope(
              fontSize: 12,
              height: 16 / 12,
              letterSpacing: 1.2,
              fontWeight: FontWeight.w600,
              color: const Color(0xFFE9C349),
            ),
          ),
        ],
      ),
    );
  }
}

class _Summary extends StatelessWidget {
  const _Summary({required this.items});

  final List<CartItem> items;

  Widget _row(String left, String right, {Color? rightColor, double? rightSize}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(left, style: GoogleFonts.manrope(fontSize: 14, height: 20 / 14, color: const Color(0xFFD1C5B4))),
        Text(
          right,
          style: GoogleFonts.manrope(
            fontSize: rightSize ?? 14,
            height: 20 / 14,
            color: rightColor ?? const Color(0xFFD1C5B4),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final totals = computeOrderTotals(items);
    return Column(
      children: [
        _row('Subtotal', formatMoney(totals.subtotal, currency: totals.currency)),
        const SizedBox(height: 16),
        _row('Standard Shipping', formatMoney(totals.shipping, currency: totals.currency)),
        const SizedBox(height: 16),
        _row('Estimated Taxes', formatMoney(totals.tax, currency: totals.currency)),
        const SizedBox(height: 33),
        Container(height: 1, color: const Color.fromRGBO(78, 70, 57, 0.2)),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('TOTAL', style: GoogleFonts.manrope(fontSize: 14, height: 20 / 14, letterSpacing: 1.4, color: const Color(0xFFE5E2E1))),
            Text(
              formatMoney(totals.total, currency: totals.currency),
              style: GoogleFonts.notoSerif(fontSize: 30, height: 36 / 30, color: const Color(0xFFE9C349)),
            ),
          ],
        ),
      ],
    );
  }
}

class _CheckoutFooter extends StatelessWidget {
  const _CheckoutFooter({required this.onCheckout, required this.enabled});
  final VoidCallback onCheckout;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    return ClipRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
        child: Container(
          padding: const EdgeInsets.fromLTRB(16, 25, 16, 32),
          decoration: const BoxDecoration(
            color: Color.fromRGBO(14, 14, 14, 0.9),
            border: Border(top: BorderSide(color: Color.fromRGBO(78, 70, 57, 0.1), width: 1)),
          ),
          child: Column(
            children: [
              ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 448),
                child: GestureDetector(
                  onTap: enabled ? onCheckout : null,
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: enabled
                            ? const [Color(0xFFE9C349), Color(0xFFC5A12A)]
                            : const [Color(0xFF4A4A4A), Color(0xFF3A3A3A)],
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      'PROCEED TO CHECKOUT',
                      style: GoogleFonts.manrope(
                        fontSize: 14,
                        height: 20 / 14,
                        letterSpacing: 1.4,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF3C2F00),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SvgPicture.asset('assets/images/icon_lock_small.svg', width: 8.75, height: 11.38),
                  const SizedBox(width: 8),
                  Text('Secure Encrypted Transaction', style: GoogleFonts.manrope(fontSize: 12, height: 16 / 12, color: const Color(0xFF9A8F80))),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

