import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'order_confirmation_screen.dart';
import '../utils/order_pricing.dart';
import '../data/models/cart_item.dart';
import '../state/providers.dart';
import '../utils/format.dart';
import '../widgets/product_network_image.dart';

class CheckoutReviewScreen extends ConsumerWidget {
  const CheckoutReviewScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: const Color(0xFF131313),
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            _TopBar(onBack: () => Navigator.of(context).maybePop()),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(24, 32, 24, 40),
                child: Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 768),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const _MiniProgress(),
                        const SizedBox(height: 48),
                        Center(
                          child: Text(
                            'Review & Confirm',
                            style: GoogleFonts.notoSerif(fontSize: 30, height: 36 / 30, letterSpacing: -0.75, color: const Color(0xFFE5E2E1)),
                          ),
                        ),
                        const SizedBox(height: 48),
                        const _OrderSummary(),
                        const SizedBox(height: 32),
                        const _DeliveryCard(),
                        const SizedBox(height: 32),
                        const _PaymentCard(),
                        const SizedBox(height: 32),
                        const _TotalsCard(),
                      ],
                    ),
                  ),
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
  const _TopBar({required this.onBack});
  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFF131313),
      padding: const EdgeInsets.fromLTRB(24, 16, 24, 16),
      child: Row(
        children: [
          GestureDetector(
            onTap: onBack,
            child: SvgPicture.asset('assets/images/icon_checkout_back_small.svg', width: 15, height: 15),
          ),
          const Spacer(),
          Text(
            'CHECKOUT',
            style: GoogleFonts.notoSerif(fontSize: 18, height: 28 / 18, letterSpacing: 1.8, color: const Color(0xFFE9C349)),
          ),
          const Spacer(),
        ],
      ),
    );
  }
}

class _MiniProgress extends StatelessWidget {
  const _MiniProgress();

  @override
  Widget build(BuildContext context) {
    Widget dot({required bool active}) => Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(
            color: active ? const Color(0xFFE9C349) : const Color.fromRGBO(73, 71, 64, 0.5),
            borderRadius: BorderRadius.circular(12),
            boxShadow: active ? const [BoxShadow(color: Color.fromRGBO(233, 195, 73, 0.5), blurRadius: 10)] : null,
          ),
        );

    return Center(
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          dot(active: false),
          const SizedBox(width: 24),
          dot(active: false),
          const SizedBox(width: 24),
          dot(active: true),
        ],
      ),
    );
  }
}

class _Card extends StatelessWidget {
  const _Card({required this.child, required this.padding, this.color});
  final Widget child;
  final EdgeInsets padding;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: padding,
      decoration: BoxDecoration(
        color: color ?? const Color(0xFF1C1B1B),
        borderRadius: BorderRadius.circular(4),
      ),
      child: child,
    );
  }
}

class _OrderSummary extends ConsumerWidget {
  const _OrderSummary();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cartAsync = ref.watch(cartItemsProvider);
    return _Card(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.only(bottom: 17),
            decoration: const BoxDecoration(border: Border(bottom: BorderSide(color: Color.fromRGBO(78, 70, 57, 0.2), width: 1))),
            child: Text('Order Summary', style: GoogleFonts.notoSerif(fontSize: 20, height: 28 / 20, color: const Color(0xFFE9C349))),
          ),
          const SizedBox(height: 24),
          cartAsync.when(
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (e, _) => Text('Could not load bag. $e', style: GoogleFonts.manrope(color: const Color(0xFFD1C5B4))),
            data: (items) {
              if (items.isEmpty) {
                return Text('Your bag is empty.', style: GoogleFonts.manrope(color: const Color(0xFFD1C5B4)));
              }
              return Column(
                children: [
                  for (var i = 0; i < items.length; i++) ...[
                    if (i > 0) const SizedBox(height: 24),
                    _SummaryItem(item: items[i]),
                  ],
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}

class _SummaryItem extends StatelessWidget {
  const _SummaryItem({required this.item});
  final CartItem item;

  @override
  Widget build(BuildContext context) {
    final variant = item.variant;
    final variantBits = <String>[
      if (variant['size'] != null) 'Size: ${variant['size']}',
      if (variant['color'] != null) 'Color: ${variant['color']}',
      'Qty: ${item.qty}',
    ];
    final imageUrl = item.imageUrlSnapshot;
    return Row(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(2),
          child: Container(
            width: 64,
            height: 96,
            color: const Color(0xFF353534),
            child: ProductNetworkImage(
              imageUrl: imageUrl.isNotEmpty ? imageUrl : 'assets/images/search_edit_quiet.png',
              width: 64,
              height: 96,
              fit: BoxFit.cover,
              fallbackAsset: 'assets/images/search_edit_quiet.png',
            ),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(item.nameSnapshot, style: GoogleFonts.manrope(fontSize: 14, height: 20 / 14, color: const Color(0xFFE5E2E1))),
              const SizedBox(height: 4),
              Text(variantBits.join(' | '), style: GoogleFonts.manrope(fontSize: 12, height: 16 / 12, color: const Color(0xFFE5E2E1))),
            ],
          ),
        ),
        const SizedBox(width: 16),
        Text(
          formatMoney(item.lineTotal, currency: item.currency),
          style: GoogleFonts.notoSerif(fontSize: 18, height: 28 / 18, color: const Color(0xFFE5E2E1)),
        ),
      ],
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({required this.title});
  final String title;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title, style: GoogleFonts.notoSerif(fontSize: 20, height: 28 / 20, color: const Color(0xFFE9C349))),
        Text(
          'EDIT',
          style: GoogleFonts.manrope(
            fontSize: 12,
            height: 16 / 12,
            letterSpacing: 0.6,
            color: const Color(0xFFE9C349),
            decoration: TextDecoration.underline,
            decorationColor: const Color.fromRGBO(78, 70, 57, 0.2),
          ),
        ),
      ],
    );
  }
}

class _DeliveryCard extends ConsumerWidget {
  const _DeliveryCard();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final draft = ref.watch(checkoutDraftProvider);
    final name = '${draft['firstName'] ?? ''} ${draft['lastName'] ?? ''}'.trim();
    final street = draft['street']?.toString() ?? '';
    final apt = draft['apt']?.toString() ?? '';
    final city = draft['city']?.toString() ?? '';
    final postal = draft['postalCode']?.toString() ?? '';
    final country = draft['country']?.toString() ?? '';
    final lines = <String>[
      if (name.isNotEmpty) name,
      if (street.isNotEmpty) street,
      if (apt.isNotEmpty) apt,
      if (city.isNotEmpty || postal.isNotEmpty) [city, postal].where((s) => s.isNotEmpty).join(', '),
      if (country.isNotEmpty) country,
    ];
    final body = lines.isEmpty
        ? 'Complete delivery details on the previous step.'
        : lines.join('\n');

    return _Card(
      padding: const EdgeInsets.fromLTRB(24, 24, 24, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.only(bottom: 17),
            decoration: const BoxDecoration(border: Border(bottom: BorderSide(color: Color.fromRGBO(78, 70, 57, 0.2), width: 1))),
            child: const _SectionHeader(title: 'Delivery'),
          ),
          const SizedBox(height: 16),
          Text(body, style: GoogleFonts.manrope(fontSize: 14, height: 22.75 / 14, color: const Color(0xFFE5E2E1))),
        ],
      ),
    );
  }
}

class _PaymentCard extends StatelessWidget {
  const _PaymentCard();

  @override
  Widget build(BuildContext context) {
    return _Card(
      padding: const EdgeInsets.fromLTRB(24, 24, 24, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.only(bottom: 17),
            decoration: const BoxDecoration(border: Border(bottom: BorderSide(color: Color.fromRGBO(78, 70, 57, 0.2), width: 1))),
            child: const _SectionHeader(title: 'Payment'),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              SvgPicture.asset('assets/images/icon_card_small_alt.svg', width: 19, height: 15),
              const SizedBox(width: 12),
              Text(
                'Cash on delivery (COD)\nPay when your order arrives',
                style: GoogleFonts.manrope(fontSize: 14, height: 22.75 / 14, color: const Color(0xFFE5E2E1)),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _TotalsCard extends ConsumerWidget {
  const _TotalsCard();

  Widget _row(String left, String right, {Color? color}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(left, style: GoogleFonts.manrope(fontSize: 14, height: 20 / 14, color: color ?? const Color(0xFFE5E2E1))),
        Text(right, style: GoogleFonts.manrope(fontSize: 14, height: 20 / 14, color: color ?? const Color(0xFFE5E2E1))),
      ],
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cartAsync = ref.watch(cartItemsProvider);
    final items = cartAsync.value ?? const <CartItem>[];
    final totals = computeOrderTotals(items);

    return _Card(
      color: const Color(0xFF0E0E0E),
      padding: const EdgeInsets.all(33),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.only(bottom: 25),
            decoration: const BoxDecoration(border: Border(bottom: BorderSide(color: Color.fromRGBO(78, 70, 57, 0.2), width: 1))),
            child: Column(
              children: [
                _row('Subtotal', formatMoney(totals.subtotal, currency: totals.currency)),
                const SizedBox(height: 16),
                _row('Standard Shipping', formatMoney(totals.shipping, currency: totals.currency)),
                const SizedBox(height: 16),
                _row('Estimated Taxes', formatMoney(totals.tax, currency: totals.currency)),
              ],
            ),
          ),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Total', style: GoogleFonts.notoSerif(fontSize: 20, height: 28 / 20, color: const Color(0xFFE5E2E1))),
              Text(formatMoney(totals.total, currency: totals.currency), style: GoogleFonts.notoSerif(fontSize: 30, height: 36 / 30, letterSpacing: -0.75, color: const Color(0xFFE9C349))),
            ],
          ),
          const SizedBox(height: 16),
          Container(
            width: double.infinity,
            decoration: BoxDecoration(color: const Color(0xFFE9C349), borderRadius: BorderRadius.circular(12)),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.circular(12),
                onTap: () async {
                  final user = ref.read(currentUserProvider);
                  if (user == null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Please sign in to place an order.')),
                    );
                    return;
                  }

                  try {
                    final items = await ref.read(cartItemsProvider.future);
                    if (items.isEmpty) {
                      if (!context.mounted) return;
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Your bag is empty.')),
                      );
                      return;
                    }

                    final delivery = ref.read(checkoutDraftProvider);
                    final totals = computeOrderTotals(items);
                    final orders = ref.read(orderRepositoryProvider);
                    final cart = ref.read(cartRepositoryProvider);
                    if (orders == null || cart == null) {
                      if (!context.mounted) return;
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                            'Orders are unavailable on Windows desktop. Use Android or Chrome to place an order with Firestore.',
                          ),
                        ),
                      );
                      return;
                    }
                    final orderId = await orders.placeOrder(
                          uid: user.uid,
                          items: items,
                          deliveryAddress: delivery,
                        );
                    await cart.clear(user.uid);
                    ref.read(checkoutDraftProvider.notifier).clear();

                    if (!context.mounted) return;
                    Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(
                        builder: (_) => OrderConfirmationScreen(
                          orderId: orderId,
                          total: totals.total,
                          currency: totals.currency,
                        ),
                      ),
                      (_) => false,
                    );
                  } catch (e) {
                    if (!context.mounted) return;
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Could not place order. ${e.toString()}')),
                    );
                  }
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  child: Center(
                    child: Text(
                      'PLACE ORDER',
                      style: GoogleFonts.manrope(fontSize: 14, height: 20 / 14, letterSpacing: 0.7, color: const Color(0xFF131313)),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

