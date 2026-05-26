import 'dart:ui';

import 'package:flutter/material.dart';

import '../screens/home_screen.dart';
import '../screens/profile_screen.dart';
import '../screens/search_discovery_screen.dart';
import '../screens/wishlist_screen.dart';
import '../utils/desktop_stability.dart';

/// Central accent used across main-tab bottom navigation.
class AtelierBottomNav {
  AtelierBottomNav._();

  static const Color accent = Color(0xFFE9C349);

  /// Replaces the current route with one of the four main tabs.
  static void go(BuildContext context, int index) {
    if (index < 0 || index > 3) return;
    final Widget screen = switch (index) {
      0 => const HomeScreen(),
      1 => const SearchDiscoveryScreen(),
      2 => const WishlistScreen(),
      3 => const ProfileScreen(),
      _ => const HomeScreen(),
    };
    Navigator.of(context).pushReplacement(
      MaterialPageRoute<void>(builder: (_) => screen),
    );
  }
}

enum AtelierBottomNavKind { pill, dock }

/// Shared bottom bar: [pill] for Home, [dock] for listing / browse / wishlist / profile.
class AtelierBottomNavBar extends StatelessWidget {
  const AtelierBottomNavBar.pill({
    super.key,
    required this.activeIndex,
    required this.onTap,
    this.accent = AtelierBottomNav.accent,
    required this.maxWidth,
  })  : kind = AtelierBottomNavKind.pill,
        dockTranslucent = false;

  const AtelierBottomNavBar.dock({
    super.key,
    required this.activeIndex,
    required this.onTap,
    this.accent = AtelierBottomNav.accent,
    this.dockTranslucent = false,
  })  : kind = AtelierBottomNavKind.dock,
        maxWidth = null;

  final int activeIndex;
  final ValueChanged<int> onTap;
  final Color accent;
  final AtelierBottomNavKind kind;
  final double? maxWidth;
  final bool dockTranslucent;

  bool _isActive(int index) => index >= 0 && index == activeIndex;

  @override
  Widget build(BuildContext context) {
    final bar = kind == AtelierBottomNavKind.pill ? _buildPill(context) : _buildDock(context);

    if (kind == AtelierBottomNavKind.pill && maxWidth != null) {
      return Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: maxWidth!),
          child: bar,
        ),
      );
    }
    return bar;
  }

  Widget _buildPill(BuildContext context) {
    final blur = !avoidHeavyBackdropBlurOnThisPlatform;
    return ClipRRect(
      borderRadius: BorderRadius.circular(18),
      child: blur
          ? BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
              child: _pillInner(),
            )
          : _pillInner(),
    );
  }

  Widget _pillInner() {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: const Color(0xFF1B1B1B).withValues(alpha: 0.92),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.white.withValues(alpha: 0.06)),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _NavTile(
              active: _isActive(0),
              pill: true,
              accent: accent,
              icon: Icons.home_rounded,
              onTap: () => onTap(0),
            ),
            _NavTile(
              active: _isActive(1),
              pill: true,
              accent: accent,
              icon: Icons.grid_view_rounded,
              onTap: () => onTap(1),
            ),
            _NavTile(
              active: _isActive(2),
              pill: true,
              accent: accent,
              icon: Icons.favorite_border_rounded,
              onTap: () => onTap(2),
            ),
            _NavTile(
              active: _isActive(3),
              pill: true,
              accent: accent,
              icon: Icons.person_outline_rounded,
              onTap: () => onTap(3),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDock(BuildContext context) {
    return LayoutBuilder(
      builder: (context, c) {
        final w = (c.maxWidth - 32).clamp(0.0, 390.0);
        final blur = !avoidHeavyBackdropBlurOnThisPlatform;
        return Center(
          child: SizedBox(
            width: w,
            child: ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(22)),
              child: blur
                  ? BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
                      child: _dockInner(),
                    )
                  : _dockInner(),
            ),
          ),
        );
      },
    );
  }

  Widget _dockInner() {
    final base = dockTranslucent
        ? const Color(0xFF1B1B1B).withValues(alpha: 0.55)
        : const Color(0xFF1B1B1B).withValues(alpha: 0.92);
    return DecoratedBox(
      decoration: BoxDecoration(
        color: base,
        border: Border(
          top: BorderSide(color: Colors.white.withValues(alpha: 0.06)),
          left: BorderSide(color: Colors.white.withValues(alpha: 0.06)),
          right: BorderSide(color: Colors.white.withValues(alpha: 0.06)),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(10, 12, 10, 14),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _NavTile(
              active: _isActive(0),
              pill: false,
              accent: accent,
              icon: Icons.home_rounded,
              onTap: () => onTap(0),
            ),
            _NavTile(
              active: _isActive(1),
              pill: false,
              accent: accent,
              icon: Icons.grid_view_rounded,
              onTap: () => onTap(1),
            ),
            _NavTile(
              active: _isActive(2),
              pill: false,
              accent: accent,
              icon: Icons.favorite_border_rounded,
              onTap: () => onTap(2),
            ),
            _NavTile(
              active: _isActive(3),
              pill: false,
              accent: accent,
              icon: Icons.person_outline_rounded,
              onTap: () => onTap(3),
            ),
          ],
        ),
      ),
    );
  }
}

class _NavTile extends StatelessWidget {
  const _NavTile({
    required this.active,
    required this.pill,
    required this.accent,
    required this.icon,
    required this.onTap,
  });

  final bool active;
  final bool pill;
  final Color accent;
  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final Color bg;
    final Color fg;
    if (pill) {
      bg = active ? const Color(0xFFB8963E) : Colors.transparent;
      fg = active ? const Color(0xFF3C2F00) : const Color(0xFFE9E9E9);
    } else {
      bg = active ? accent.withValues(alpha: 0.18) : Colors.transparent;
      fg = active ? accent : const Color(0xFFE9E9E9);
    }

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: SizedBox(
          width: 56,
          height: 44,
          child: Center(
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 180),
              curve: Curves.easeOutCubic,
              width: 44,
              height: 36,
              decoration: BoxDecoration(
                color: bg,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, size: 22, color: fg),
            ),
          ),
        ),
      ),
    );
  }
}
