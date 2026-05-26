import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import '../data/models/store_order.dart';
import '../state/providers.dart';
import '../utils/format.dart';
import '../widgets/product_network_image.dart';
import 'home_screen.dart';
import 'order_history_screen.dart';
import 'login_screen.dart';

void _trackOrderBack(BuildContext context) {
  final nav = Navigator.of(context);
  if (nav.canPop()) {
    nav.pop();
    return;
  }
  nav.pushAndRemoveUntil(
    MaterialPageRoute<void>(builder: (_) => const HomeScreen()),
    (_) => false,
  );
}

class TrackOrderScreen extends ConsumerWidget {
  const TrackOrderScreen({super.key, this.orderId});

  final String? orderId;

  static const _bg = Color(0xFF080808);
  static const _text = Color(0xFFF5F0E8);
  static const _muted = Color(0xFFD0C5B2);
  static const _luxGold = Color(0xFFB8963E);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(currentUserProvider);
    final id = orderId;

    return Scaffold(
      backgroundColor: _bg,
      body: SafeArea(
        bottom: false,
        child: Stack(
          children: [
            SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(24, 92, 24, 120),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Track Order',
                    style: GoogleFonts.notoSerif(fontSize: 30, height: 36 / 30, color: _text),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    id == null ? 'Select an order to track' : 'Order #${shortOrderId(id)}',
                    style: GoogleFonts.poppins(
                      fontSize: 12,
                      height: 16 / 12,
                      letterSpacing: 1.2,
                      color: _muted.withValues(alpha: 0.8),
                    ),
                  ),
                  const SizedBox(height: 24),
                  if (user == null)
                    _EmptyState(
                      message: 'Sign in to track your packages.',
                      actionLabel: 'SIGN IN',
                      onAction: () => Navigator.of(context).push(
                        MaterialPageRoute(builder: (_) => const LoginScreen()),
                      ),
                    )
                  else if (id == null)
                    _EmptyState(
                      message: 'Open an order from your history to see tracking updates.',
                      actionLabel: 'ORDER HISTORY',
                      onAction: () => Navigator.of(context).push(
                        MaterialPageRoute(builder: (_) => const OrderHistoryScreen()),
                      ),
                    )
                  else
                    _TrackOrderBody(orderId: id),
                ],
              ),
            ),
            Positioned(
              left: 0,
              right: 0,
              top: 0,
              child: SafeArea(
                bottom: false,
                child: ClipRRect(
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
                    child: Container(
                      height: 64,
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      color: const Color.fromRGBO(8, 8, 8, 0.85),
                      child: Row(
                        children: [
                          IconButton(
                            onPressed: () => _trackOrderBack(context),
                            icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 18, color: _luxGold),
                            padding: EdgeInsets.zero,
                            constraints: const BoxConstraints(minWidth: 48, minHeight: 48),
                          ),
                          Expanded(
                            child: Center(
                              child: Text(
                                'ATELIER',
                                style: GoogleFonts.libreBaskerville(
                                  fontSize: 18,
                                  letterSpacing: 6,
                                  color: _text,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 40),
                        ],
                      ),
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

class _EmptyState extends StatelessWidget {
  const _EmptyState({required this.message, required this.actionLabel, required this.onAction});

  final String message;
  final String actionLabel;
  final VoidCallback onAction;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(message, style: GoogleFonts.manrope(fontSize: 14, color: TrackOrderScreen._muted)),
        const SizedBox(height: 16),
        TextButton(onPressed: onAction, child: Text(actionLabel, style: GoogleFonts.manrope(color: TrackOrderScreen._luxGold))),
      ],
    );
  }
}

class _TrackOrderBody extends ConsumerWidget {
  const _TrackOrderBody({required this.orderId});

  final String orderId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final orderAsync = ref.watch(_orderProvider(orderId));
    final itemsAsync = ref.watch(_orderItemsProvider(orderId));
    final eventsAsync = ref.watch(_orderEventsProvider(orderId));

    return orderAsync.when(
      loading: () => const Center(child: CircularProgressIndicator(color: TrackOrderScreen._luxGold)),
      error: (e, _) => Text('Could not load order. $e', style: GoogleFonts.manrope(color: TrackOrderScreen._muted)),
      data: (order) {
        if (order == null) {
          return Text('Order not found.', style: GoogleFonts.manrope(color: TrackOrderScreen._muted));
        }
        final user = ref.watch(currentUserProvider);
        if (user != null && order.userId != user.uid) {
          return Text('This order is not available.', style: GoogleFonts.manrope(color: TrackOrderScreen._muted));
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            itemsAsync.when(
              loading: () => const SizedBox.shrink(),
              error: (e, st) => const SizedBox.shrink(),
              data: (items) {
                if (items.isEmpty) {
                  return _ProductCard(
                    title: 'Order items',
                    qty: 1,
                    price: formatMoney(order.total, currency: order.currency),
                  );
                }
                final first = items.first;
                return _ProductCard(
                  title: first.nameSnapshot,
                  qty: first.qty,
                  price: formatMoney(first.unitPrice * first.qty, currency: first.currency),
                  imageUrl: first.imageUrlSnapshot,
                );
              },
            ),
            const SizedBox(height: 28),
            eventsAsync.when(
              loading: () => const Center(child: CircularProgressIndicator(color: TrackOrderScreen._luxGold)),
              error: (e, _) => Text('Could not load tracking. $e', style: GoogleFonts.manrope(color: TrackOrderScreen._muted)),
              data: (events) {
                if (events.isEmpty) {
                  return Text('No tracking updates yet.', style: GoogleFonts.manrope(color: TrackOrderScreen._muted));
                }
                final timelineItems = <_TimelineItem>[
                  for (var i = 0; i < events.length; i++)
                    _TimelineItem(
                      title: events[i].label,
                      subtitle: formatOrderDate(events[i].timestamp?.toDate()),
                      state: _TimelineState.done,
                      tracking: events[i].tracking,
                    ),
                ];
                if (!order.isDelivered) {
                  timelineItems.add(
                    const _TimelineItem(
                      title: 'Out for delivery',
                      subtitle: 'Pending',
                      state: _TimelineState.pending,
                    ),
                  );
                }
                return _Timeline(items: timelineItems);
              },
            ),
            const SizedBox(height: 24),
            Text(
              'Status: ${order.displayStatus}',
              style: GoogleFonts.manrope(fontSize: 12, letterSpacing: 1.2, color: TrackOrderScreen._luxGold),
            ),
          ],
        );
      },
    );
  }
}

final _orderProvider = StreamProvider.family<StoreOrder?, String>((ref, orderId) {
  final repo = ref.watch(orderRepositoryProvider);
  if (repo == null) return Stream<StoreOrder?>.value(null);
  return repo.watchOrder(orderId);
});

final _orderItemsProvider = StreamProvider.family<List<OrderLineItem>, String>((ref, orderId) {
  final repo = ref.watch(orderRepositoryProvider);
  if (repo == null) return Stream.value(const <OrderLineItem>[]);
  return repo.watchOrderItems(orderId);
});

final _orderEventsProvider = StreamProvider.family<List<OrderStatusEvent>, String>((ref, orderId) {
  final repo = ref.watch(orderRepositoryProvider);
  if (repo == null) return Stream.value(const <OrderStatusEvent>[]);
  return repo.watchStatusEvents(orderId);
});

class _ProductCard extends StatelessWidget {
  const _ProductCard({
    required this.title,
    required this.qty,
    required this.price,
    this.imageUrl,
  });

  final String title;
  final int qty;
  final String price;
  final String? imageUrl;

  static const _surface = Color(0xFF2A2420);
  static const _text = Color(0xFFF5F0E8);
  static const _muted = Color(0xFFD0C5B2);
  static const _luxGold = Color(0xFFB8963E);

  @override
  Widget build(BuildContext context) {
    Widget imageChild;
    if (imageUrl != null && imageUrl!.trim().isNotEmpty) {
      imageChild = ProductNetworkImage(
        imageUrl: imageUrl!,
        fit: BoxFit.cover,
        fallbackAsset: 'assets/images/bag_item_shirt.png',
      );
    } else {
      imageChild = Image.asset(
        'assets/images/bag_item_shirt.png',
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) => const ColoredBox(color: Color(0xFF201F1F)),
      );
    }

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: _surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color.fromRGBO(208, 197, 178, 0.10)),
        boxShadow: const [BoxShadow(color: Color.fromRGBO(0, 0, 0, 0.35), blurRadius: 30, offset: Offset(0, 16))],
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: SizedBox(width: 74, height: 74, child: imageChild),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: GoogleFonts.notoSerif(fontSize: 18, height: 24 / 18, color: _text)),
                const SizedBox(height: 4),
                Text('QTY: $qty', style: GoogleFonts.poppins(fontSize: 12, height: 16 / 12, color: _muted.withValues(alpha: 0.85))),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Text(price, style: GoogleFonts.poppins(fontSize: 14, height: 20 / 14, color: _luxGold, fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
}

enum _TimelineState { done, pending }

class _TimelineItem {
  const _TimelineItem({required this.title, required this.subtitle, required this.state, this.tracking});

  final String title;
  final String subtitle;
  final _TimelineState state;
  final String? tracking;
}

class _Timeline extends StatelessWidget {
  const _Timeline({required this.items});

  final List<_TimelineItem> items;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        for (int i = 0; i < items.length; i++)
          _TimelineRow(item: items[i], isLast: i == items.length - 1),
      ],
    );
  }
}

class _TimelineRow extends StatelessWidget {
  const _TimelineRow({required this.item, required this.isLast});

  final _TimelineItem item;
  final bool isLast;

  static const _muted = Color(0xFFD0C5B2);
  static const _luxGold = Color(0xFFB8963E);
  static const _text = Color(0xFFF5F0E8);
  static const _surface = Color(0xFF2A2420);

  @override
  Widget build(BuildContext context) {
    final done = item.state == _TimelineState.done;
    final dotBorder = done ? _luxGold : _muted.withValues(alpha: 0.25);
    final dotFill = done ? const Color.fromRGBO(184, 150, 62, 0.18) : const Color.fromRGBO(0, 0, 0, 0.0);
    final lineColor = done ? _luxGold.withValues(alpha: 0.55) : _muted.withValues(alpha: 0.18);

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 30,
          child: Column(
            children: [
              Container(
                width: 12,
                height: 12,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: dotBorder, width: 2),
                  color: dotFill,
                ),
              ),
              if (!isLast)
                Container(
                  width: 2,
                  height: 58,
                  margin: const EdgeInsets.only(top: 6),
                  decoration: BoxDecoration(color: lineColor, borderRadius: BorderRadius.circular(9999)),
                ),
            ],
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(item.title, style: GoogleFonts.notoSerif(fontSize: 18, height: 24 / 18, color: done ? _text : _text.withValues(alpha: 0.65))),
              const SizedBox(height: 4),
              Text(item.subtitle, style: GoogleFonts.poppins(fontSize: 12, height: 16 / 12, color: _muted.withValues(alpha: 0.8))),
              if (item.tracking != null) ...[
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                  decoration: BoxDecoration(
                    color: _surface.withValues(alpha: 0.4),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: const Color.fromRGBO(208, 197, 178, 0.10)),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.local_shipping_outlined, size: 16, color: _luxGold),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          item.tracking!,
                          style: GoogleFonts.poppins(fontSize: 11, height: 16 / 11, color: _muted.withValues(alpha: 0.9)),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
              const SizedBox(height: 22),
            ],
          ),
        ),
      ],
    );
  }
}
