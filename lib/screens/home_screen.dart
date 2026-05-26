import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'screens_hub_screen.dart';
import 'search_discovery_screen.dart';
import 'shopping_bag_screen.dart';
import 'notifications_screen.dart';
import 'login_screen.dart';
import '../state/providers.dart';
import '../data/models/user_profile.dart';
import '../widgets/atelier_bottom_nav.dart';
import '../widgets/atelier_home_page.dart';

/// Home — layout and content are controlled by [atelier_home_config.dart].
class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  int _activeBottomIndex = 0;
  int _activeCategoryIndex = 0;

  static const _bg = Color(0xFF131313);
  static const _topBarBg = Color(0xFF080808);
  static const _topBarIcon = Color(0xFFB8963E);
  static const _textPrimary = Color(0xFFE5E2E1);
  static const _textMuted = Color(0xFFD1C5B4);
  static const _accent = Color(0xFFE9C349);
  static const _border = Color.fromRGBO(78, 70, 57, 0.20);
  static const _cardBg = Color(0xFF1C1B1B);

  void _selectCategory(int index) => setState(() => _activeCategoryIndex = index);

  @override
  Widget build(BuildContext context) {
    final featuredAsync = ref.watch(featuredProductsProvider);

    return Scaffold(
      backgroundColor: _bg,
      body: LayoutBuilder(
        builder: (context, constraints) {
          final bannerHeight = constraints.maxWidth >= 900 ? 380.0 : 280.0;
          final gridCols = constraints.maxWidth >= 1000 ? 4 : (constraints.maxWidth >= 700 ? 3 : 2);

          return SafeArea(
            bottom: false,
            child: Stack(
              children: [
                Column(
                  children: [
                    _TopAppBar(
                      backgroundColor: _topBarBg,
                      titleColor: const Color(0xFFF5F0E8),
                      iconColor: _topBarIcon,
                    ),
                    Expanded(
                      child: RefreshIndicator(
                        color: _accent,
                        onRefresh: () async {
                          ref.invalidate(featuredProductsProvider);
                          ref.invalidate(allProductsProvider);
                          await ref.read(featuredProductsProvider.future);
                        },
                        child: SingleChildScrollView(
                        physics: const AlwaysScrollableScrollPhysics(),
                        padding: const EdgeInsets.only(top: 8, bottom: 96),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.fromLTRB(16, 4, 16, 20),
                              child: Center(
                                child: ConstrainedBox(
                                  constraints: const BoxConstraints(maxWidth: 1100),
                                  child: _HomeGreeting(accent: _accent, muted: _textMuted),
                                ),
                              ),
                            ),
                            AtelierHomePage(
                          productsAsync: featuredAsync,
                          activeCategoryIndex: _activeCategoryIndex,
                          onCategorySelected: _selectCategory,
                          onSeedCatalogue: _SampleCatalogueSeed(accent: _accent, muted: _textMuted),
                          accent: _accent,
                          titleColor: _textPrimary,
                          mutedColor: _textMuted,
                          borderColor: _border,
                          cardBg: _cardBg,
                          bannerHeight: bannerHeight,
                          maxContentWidth: 1100,
                          gridCrossAxisCount: gridCols,
                            ),
                          ],
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
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: AtelierBottomNavBar.pill(
                          activeIndex: _activeBottomIndex,
                          onTap: (idx) {
                            setState(() => _activeBottomIndex = idx);
                            _navigateBottom(context, idx);
                          },
                          accent: _accent,
                          maxWidth: constraints.maxWidth - 32,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  void _navigateBottom(BuildContext context, int idx) {
    if (idx == 0) return;
    AtelierBottomNav.go(context, idx);
  }
}

class _TopAppBar extends StatelessWidget {
  const _TopAppBar({
    required this.backgroundColor,
    required this.titleColor,
    required this.iconColor,
  });

  final Color backgroundColor;
  final Color titleColor;
  final Color iconColor;
  static const double _iconSlot = 40;
  static const double _iconGap = 12;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 64,
      width: double.infinity,
      child: DecoratedBox(
        decoration: BoxDecoration(color: backgroundColor),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 1100),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final rightClusterWidth = (_iconSlot * 3) + (_iconGap * 2);
                  final availableForTitle = constraints.maxWidth - _iconSlot - rightClusterWidth;

                  return Row(
                    children: [
                      SizedBox(
                        width: _iconSlot,
                        child: IconButton(
                          onPressed: kDebugMode
                              ? () => Navigator.of(context).push(
                                    MaterialPageRoute(builder: (_) => const ScreensHubScreen()),
                                  )
                              : null,
                          icon: Icon(Icons.menu_rounded, color: iconColor, size: 22),
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints.tightFor(width: _iconSlot, height: _iconSlot),
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
                                color: titleColor,
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
                              onPressed: () => Navigator.of(context).push(
                                MaterialPageRoute(builder: (_) => const SearchDiscoveryScreen()),
                              ),
                              icon: Icon(Icons.search_rounded, color: iconColor, size: 22),
                              padding: EdgeInsets.zero,
                              constraints: const BoxConstraints.tightFor(width: _iconSlot, height: _iconSlot),
                            ),
                            const SizedBox(width: _iconGap),
                            _CartIconButton(iconColor: iconColor, slot: _iconSlot),
                            const SizedBox(width: _iconGap),
                            IconButton(
                              onPressed: () => Navigator.of(context).push(
                                MaterialPageRoute(builder: (_) => const NotificationsScreen()),
                              ),
                              icon: Icon(Icons.notifications_none_rounded, color: iconColor, size: 22),
                              padding: EdgeInsets.zero,
                              constraints: const BoxConstraints.tightFor(width: _iconSlot, height: _iconSlot),
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
      ),
    );
  }
}

class _HomeGreeting extends ConsumerWidget {
  const _HomeGreeting({required this.accent, required this.muted});

  final Color accent;
  final Color muted;

  String _timeGreeting() {
    final h = DateTime.now().hour;
    if (h < 12) return 'Good morning';
    if (h < 17) return 'Good afternoon';
    return 'Good evening';
  }

  static String _firstName(String full) {
    final t = full.trim();
    if (t.isEmpty) return '';
    return t.split(RegExp(r'\s+')).first;
  }

  static String _localPart(String? email) {
    if (email == null) return '';
    final t = email.trim();
    final at = t.indexOf('@');
    if (at <= 0) return '';
    return t.substring(0, at);
  }

  static String _prettyLocal(String local) {
    if (local.isEmpty) return '';
    final clean = local.replaceAll(RegExp(r'[._-]+'), ' ').trim();
    if (clean.isEmpty) return '';
    return clean[0].toUpperCase() + clean.substring(1).toLowerCase();
  }

  /// Firestore profile → Auth displayName / email — never generic “there”.
  static String displayName(User? user, UserProfile? profile) {
    if (profile != null) {
      final n = _firstName(profile.fullName);
      if (n.isNotEmpty) return n;
      final fromProf = _prettyLocal(_localPart(profile.email));
      if (fromProf.isNotEmpty) return fromProf;
    }
    if (user != null) {
      final dn = _firstName(user.displayName ?? '');
      if (dn.isNotEmpty) return dn;
      final fromMail = _prettyLocal(_localPart(user.email));
      if (fromMail.isNotEmpty) return fromMail;
    }
    return 'friend';
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(currentUserProvider);
    final profile = ref.watch(userProfileProvider).value;
    final displayName = _HomeGreeting.displayName(user, profile);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '${_timeGreeting()}, $displayName',
          style: GoogleFonts.notoSerif(fontSize: 26, height: 1.2, color: const Color(0xFFE5E2E1)),
        ),
        const SizedBox(height: 6),
        Text(
          'Shop men, women, kids & accessories from Sri Lankan brands',
          style: GoogleFonts.manrope(fontSize: 13, color: muted),
        ),
        const SizedBox(height: 14),
        Container(height: 1, color: accent.withValues(alpha: 0.15)),
      ],
    );
  }
}

class _CartIconButton extends ConsumerWidget {
  const _CartIconButton({required this.iconColor, required this.slot});

  final Color iconColor;
  final double slot;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final count = ref.watch(cartItemsProvider).value?.length ?? 0;

    return SizedBox(
      width: slot,
      height: slot,
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.center,
        children: [
          IconButton(
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => const ShoppingBagScreen()),
            ),
            icon: Icon(Icons.shopping_bag_outlined, color: iconColor, size: 20),
            padding: EdgeInsets.zero,
            constraints: BoxConstraints.tightFor(width: slot, height: slot),
          ),
          if (count > 0)
            Positioned(
              top: 6,
              right: 4,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                decoration: BoxDecoration(
                  color: const Color(0xFFE9C349),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  count > 9 ? '9+' : '$count',
                  style: GoogleFonts.manrope(fontSize: 9, fontWeight: FontWeight.w800, color: const Color(0xFF2A2420)),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _SampleCatalogueSeed extends ConsumerStatefulWidget {
  const _SampleCatalogueSeed({required this.accent, required this.muted});

  final Color accent;
  final Color muted;

  @override
  ConsumerState<_SampleCatalogueSeed> createState() => _SampleCatalogueSeedState();
}

class _SampleCatalogueSeedState extends ConsumerState<_SampleCatalogueSeed> {
  bool _loading = false;

  Future<void> _seed() async {
    final user = ref.read(currentUserProvider);
    if (user == null) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Sign in first, then load sample products.')),
      );
      Navigator.of(context).push(MaterialPageRoute(builder: (_) => const LoginScreen()));
      return;
    }

    setState(() => _loading = true);
    try {
      final repo = ref.read(productRepositoryProvider);
      if (repo == null) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Cloud catalogue is unavailable on Windows desktop. Build for Android or run in Chrome to sync with Firestore.',
            ),
          ),
        );
        return;
      }
      await repo.seedSampleCatalogue();
      ref.invalidate(allProductsProvider);
      ref.invalidate(featuredProductsProvider);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Catalogue updated — old demo products removed. Each category now has its own items.',
          ),
          duration: Duration(seconds: 4),
        ),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Could not load samples. $e')));
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF1C1B1B),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color.fromRGBO(78, 70, 57, 0.35)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('No products yet', style: GoogleFonts.notoSerif(fontSize: 18, color: const Color(0xFFE5E2E1))),
          const SizedBox(height: 8),
          Text(
            'Load sample catalogue — men, women, kids & accessories (LKR prices).',
            style: GoogleFonts.manrope(fontSize: 13, color: widget.muted),
          ),
          const SizedBox(height: 16),
          FilledButton(
            onPressed: _loading ? null : _seed,
            style: FilledButton.styleFrom(backgroundColor: widget.accent, foregroundColor: const Color(0xFF2A2420)),
            child: _loading
                ? const SizedBox(width: 22, height: 22, child: CircularProgressIndicator(strokeWidth: 2))
                : const Text('LOAD SAMPLE CATALOGUE'),
          ),
        ],
      ),
    );
  }
}
