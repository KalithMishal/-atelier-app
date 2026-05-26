import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import 'home_screen.dart';
import 'product_listing_screen.dart';
import 'wishlist_screen.dart';
import 'profile_screen.dart';
import 'order_detail_screen.dart';
import 'login_screen.dart';
import '../data/models/store_order.dart';
import '../state/providers.dart';
import '../utils/format.dart';

class OrderHistoryScreen extends ConsumerStatefulWidget {
  const OrderHistoryScreen({super.key});

  @override
  ConsumerState<OrderHistoryScreen> createState() => _OrderHistoryScreenState();
}

class _OrderHistoryScreenState extends ConsumerState<OrderHistoryScreen> {
  static const _bg = Color(0xFF131313);
  static const _title = Color(0xFFF5F0E8);
  static const _luxGold = Color(0xFFB8963E);
  static const double _contentMaxW = 1100;

  int _activeTab = 0; // 0 all, 1 active, 2 delivered
  final int _activeBottomIndex = 0;

  List<StoreOrder> _filterOrders(List<StoreOrder> orders) {
    switch (_activeTab) {
      case 1:
        return orders.where((o) => o.isActive).toList();
      case 2:
        return orders.where((o) => o.isDelivered).toList();
      default:
        return orders;
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(currentUserProvider);
    final ordersAsync = ref.watch(userOrdersProvider);

    return Scaffold(
      backgroundColor: _bg,
      body: SafeArea(
        bottom: false,
        child: Stack(
          children: [
            Column(
              children: [
                const _TopBar(),
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.fromLTRB(24, 24, 24, 120),
                    child: Center(
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: _contentMaxW),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                GestureDetector(
                                  onTap: () => Navigator.of(context).maybePop(),
                                  child: Row(
                                    children: [
                                      const Icon(Icons.arrow_back_ios_new_rounded, size: 16, color: _luxGold),
                                      const SizedBox(width: 10),
                                      Text(
                                        'Order History',
                                        style: GoogleFonts.notoSerif(
                                          fontSize: 28,
                                          height: 34 / 28,
                                          color: _title,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 18),
                            _Tabs(active: _activeTab, onTap: (i) => setState(() => _activeTab = i)),
                            const SizedBox(height: 24),
                            if (user == null)
                              Padding(
                                padding: const EdgeInsets.only(top: 8),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Sign in to view your orders.',
                                      style: GoogleFonts.manrope(fontSize: 14, color: const Color(0xFFD1C5B4)),
                                    ),
                                    const SizedBox(height: 16),
                                    TextButton(
                                      onPressed: () => Navigator.of(context).push(
                                        MaterialPageRoute(builder: (_) => const LoginScreen()),
                                      ),
                                      child: Text('SIGN IN', style: GoogleFonts.manrope(color: _luxGold)),
                                    ),
                                  ],
                                ),
                              )
                            else
                              ordersAsync.when(
                                loading: () => const Padding(
                                  padding: EdgeInsets.symmetric(vertical: 48),
                                  child: Center(child: CircularProgressIndicator(color: _luxGold)),
                                ),
                                error: (e, _) => Text(
                                  'Could not load orders. ${e.toString()}',
                                  style: GoogleFonts.manrope(fontSize: 14, color: const Color(0xFFD1C5B4)),
                                ),
                                data: (orders) {
                                  final filtered = _filterOrders(orders);
                                  if (filtered.isEmpty) {
                                    return Text(
                                      orders.isEmpty
                                          ? 'No orders yet. Start shopping to see your history here.'
                                          : 'No orders in this tab.',
                                      style: GoogleFonts.manrope(fontSize: 14, color: const Color(0xFFD1C5B4)),
                                    );
                                  }
                                  return LayoutBuilder(
                                    builder: (context, c) {
                                      final w = c.maxWidth;
                                      final columns = w >= 900 ? 2 : 1;
                                      const gap = 24.0;
                                      final itemW = columns == 1 ? w : (w - gap) / 2;

                                      return Wrap(
                                        spacing: gap,
                                        runSpacing: gap,
                                        children: [
                                          for (final order in filtered)
                                            SizedBox(
                                              width: itemW,
                                              child: _OrderCard(
                                                orderNo: 'ORDER #${shortOrderId(order.id)}',
                                                placed: 'Placed on ${formatOrderDate(order.createdAt?.toDate())}',
                                                status: order.displayStatus,
                                                total: formatMoney(order.total, currency: order.currency),
                                                imageUrls: order.previewImageUrls,
                                                onViewDetails: () {
                                                  Navigator.of(context).push(
                                                    MaterialPageRoute(
                                                      builder: (_) => OrderDetailScreen(orderId: order.id),
                                                    ),
                                                  );
                                                },
                                              ),
                                            ),
                                        ],
                                      );
                                    },
                                  );
                                },
                              ),
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
                  child: _BottomNavBar(
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
    Widget target;
    switch (idx) {
      case 0:
        target = const HomeScreen();
        break;
      case 1:
        target = const ProductListingScreen();
        break;
      case 2:
        target = const WishlistScreen();
        break;
      case 3:
        target = const ProfileScreen();
        break;
      default:
        target = const HomeScreen();
    }
    Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) => target));
  }
}

class _TopBar extends StatelessWidget {
  const _TopBar();

  static const _top = Color(0xFF080808);
  static const _title = Color(0xFFF5F0E8);
  static const _luxGold = Color(0xFFB8963E);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: _top,
      height: 64,
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: _OrderHistoryScreenState._contentMaxW),
          child: Padding(
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
                  onPressed: () {},
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
                  children: const [
                    Icon(Icons.search_rounded, size: 22, color: _luxGold),
                    SizedBox(width: iconGap),
                    Icon(Icons.shopping_bag_outlined, size: 20, color: _luxGold),
                    SizedBox(width: iconGap),
                    Icon(Icons.notifications_none_rounded, size: 22, color: _luxGold),
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

class _Tabs extends StatelessWidget {
  const _Tabs({required this.active, required this.onTap});
  final int active;
  final ValueChanged<int> onTap;

  @override
  Widget build(BuildContext context) {
    Widget pill(String text, int idx) {
      final isActive = idx == active;
      return GestureDetector(
        onTap: () => onTap(idx),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
          decoration: BoxDecoration(
            color: isActive ? const Color(0xFFB8963E) : Colors.transparent,
            borderRadius: BorderRadius.circular(9999),
            border: isActive ? null : Border.all(color: const Color.fromRGBO(78, 70, 57, 0.35)),
          ),
          child: Text(
            text,
            style: GoogleFonts.manrope(
              fontSize: 12,
              height: 16 / 12,
              letterSpacing: 1.2,
              color: isActive ? const Color(0xFF2A2420) : const Color(0xFFD1C5B4),
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      );
    }

    return Row(
      children: [
        pill('ALL', 0),
        const SizedBox(width: 12),
        pill('ACTIVE', 1),
        const SizedBox(width: 12),
        pill('DELIVERED', 2),
      ],
    );
  }
}

class _OrderCard extends StatelessWidget {
  const _OrderCard({
    required this.orderNo,
    required this.placed,
    required this.status,
    required this.total,
    required this.imageUrls,
    required this.onViewDetails,
  });

  final String orderNo;
  final String placed;
  final String status;
  final String total;
  final List<String> imageUrls;
  final VoidCallback onViewDetails;

  static const _card = Color(0xFF2A2420);
  static const _title = Color(0xFFF5F0E8);
  static const _luxGold = Color(0xFFB8963E);

  @override
  Widget build(BuildContext context) {
    final delivered = status.toUpperCase() == 'DELIVERED';
    final statusBg = delivered ? const Color.fromRGBO(184, 150, 62, 0.22) : const Color.fromRGBO(0, 0, 0, 0.22);

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: _card,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color.fromRGBO(78, 70, 57, 0.25)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(orderNo, style: GoogleFonts.manrope(fontSize: 12, height: 16 / 12, letterSpacing: 1.2, color: _luxGold)),
          const SizedBox(height: 8),
          Text(placed, style: GoogleFonts.notoSerif(fontSize: 18, height: 24 / 18, color: _title)),
          const SizedBox(height: 16),
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(color: statusBg, borderRadius: BorderRadius.circular(9999)),
                child: Text(
                  status,
                  style: GoogleFonts.manrope(fontSize: 10, height: 14 / 10, letterSpacing: 1.2, color: delivered ? _luxGold : const Color(0xFFD1C5B4)),
                ),
              ),
              const Spacer(),
              Text(total, style: GoogleFonts.notoSerif(fontSize: 20, height: 24 / 20, color: _luxGold)),
            ],
          ),
          const SizedBox(height: 16),
          if (imageUrls.isNotEmpty)
            Row(
              children: [
                for (int i = 0; i < imageUrls.length && i < 2; i++) ...[
                  Expanded(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: Container(
                        height: 110,
                        color: const Color(0xFF1C1B1B),
                        child: Opacity(
                          opacity: 0.9,
                          child: CachedNetworkImage(
                            imageUrl: imageUrls[i],
                            fit: BoxFit.cover,
                            errorWidget: (context, url, error) => const ColoredBox(color: Color(0xFF201F1F)),
                          ),
                        ),
                      ),
                    ),
                  ),
                  if (i != imageUrls.length - 1 && imageUrls.length > 1) const SizedBox(width: 16),
                ],
              ],
            ),
          const SizedBox(height: 16),
          GestureDetector(
            onTap: onViewDetails,
            child: Text(
              'VIEW DETAILS  ›',
              style: GoogleFonts.manrope(
                fontSize: 12,
                height: 16 / 12,
                letterSpacing: 1.2,
                color: _luxGold,
                decoration: TextDecoration.underline,
                decorationColor: const Color.fromRGBO(78, 70, 57, 0.35),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _BottomNavBar extends StatelessWidget {
  const _BottomNavBar({required this.activeIndex, required this.onTap});

  final int activeIndex;
  final ValueChanged<int> onTap;

  @override
  Widget build(BuildContext context) {
    const barWidth = 390.0;
    const bg = Color.fromRGBO(42, 36, 32, 0.99);
    const inactive = Color(0xFFE5E2E1);
    const activeBg = Color(0xFFB8963E);
    const activeIcon = Color(0xFF3C2F00);

    Widget btn(int idx, IconData icon) => GestureDetector(
          onTap: () => onTap(idx),
          behavior: HitTestBehavior.opaque,
          child: Container(
            height: 48,
            width: 48,
            decoration: BoxDecoration(
              color: activeIndex == idx ? activeBg : Colors.transparent,
              borderRadius: BorderRadius.circular(10),
            ),
            alignment: Alignment.center,
            child: Icon(icon, size: 22, color: activeIndex == idx ? activeIcon : inactive),
          ),
        );

    return Container(
      width: barWidth,
      margin: const EdgeInsets.only(bottom: 0.2),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFB8963E).withValues(alpha: 0.08),
            blurRadius: 32,
            offset: const Offset(0, -10),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 14),
            color: bg,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                btn(0, Icons.home_rounded),
                btn(1, Icons.grid_view_rounded),
                btn(2, Icons.favorite_border_rounded),
                btn(3, Icons.person_outline_rounded),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

