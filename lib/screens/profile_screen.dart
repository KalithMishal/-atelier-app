import 'dart:ui';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import '../data/models/user_profile.dart';
import '../state/providers.dart';
import '../widgets/atelier_bottom_nav.dart';
import '../widgets/profile_circle_avatar.dart';
import 'edit_profile_screen.dart';
import 'saved_addresses_screen.dart';
import 'payment_methods_screen.dart';
import 'order_history_screen.dart';
import 'login_screen.dart';
import 'sign_out_sheet.dart';
import 'preferences_screen.dart';
import 'privacy_security_screen.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  static const _bg = Color(0xFF080808);
  static const _surface = Color(0xFF2A2420);
  static const _accent = Color(0xFFE8C265);
  static const _text = Color(0xFFF5F0E8);
  static const _muted = Color(0xFFD0C5B2);

  final int _activeBottomIndex = 3;

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(currentUserProvider);
    final profileAsync = ref.watch(userProfileProvider);
    return Scaffold(
      backgroundColor: _bg,
      body: SafeArea(
        bottom: false,
        child: Stack(
          children: [
            SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(24, 79, 24, 120),
              child: Column(
                children: [
                  _FallbackHeader(),
                  const SizedBox(height: 24),
                  if (user == null)
                    _GuestProfilePrompt(accent: _accent, muted: _muted)
                  else
                    profileAsync.when(
                      data: (p) => _ProfileHeader(
                        accent: _accent,
                        fullName: p.fullName.isEmpty ? 'Member' : p.fullName,
                        memberSince: p.createdAt == null ? '' : 'Member since ${p.createdAt!.toDate().year}',
                        photoUrl: _effectiveAvatarUrl(p, user),
                      ),
                      loading: () => _ProfileHeader(
                        accent: _accent,
                        fullName: 'Loading...',
                        memberSince: '',
                        photoUrl: user.photoURL?.trim(),
                      ),
                      error: (e, _) => _ProfileHeader(
                        accent: _accent,
                        fullName: 'Member',
                        memberSince: '',
                        photoUrl: user.photoURL?.trim(),
                      ),
                    ),
                  const SizedBox(height: 24),
                  _StatsRow(surface: _surface, accent: _accent, muted: _muted),
                  const SizedBox(height: 24),
                  _MenuSections(surface: _surface, accent: _accent),
                  const SizedBox(height: 32),
                  if (user != null)
                    GestureDetector(
                    onTap: () => showSignOutSheet(context, ref),
                    child: Container(
                      padding: const EdgeInsets.only(bottom: 5),
                      decoration: const BoxDecoration(
                        border: Border(bottom: BorderSide(color: Color.fromRGBO(199, 139, 148, 0.3), width: 1)),
                      ),
                      child: Text(
                        'SIGN OUT',
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          height: 20 / 14,
                          letterSpacing: 1.4,
                          color: const Color(0xFFC78B94),
                        ),
                      ),
                    ),
                  ),
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
                      color: const Color.fromRGBO(8, 8, 8, 0.8),
                      padding: const EdgeInsets.all(24),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'PROFILE',
                          style: GoogleFonts.bodoniModa(
                            fontSize: 20,
                            height: 28 / 20,
                            letterSpacing: 2,
                            color: _text,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
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
    );
  }

  void _navigateBottom(BuildContext context, int idx) {
    if (idx == _activeBottomIndex) return;
    AtelierBottomNav.go(context, idx);
  }

  String? _effectiveAvatarUrl(UserProfile p, User user) {
    final fromFs = p.photoUrl?.trim();
    if (fromFs != null && fromFs.isNotEmpty) return fromFs;
    final fromAuth = user.photoURL?.trim();
    if (fromAuth != null && fromAuth.isNotEmpty) return fromAuth;
    return null;
  }
}

class _FallbackHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Spacer matching Figma intent; actual title is in the blurred header overlay.
    return const SizedBox(height: 0);
  }
}

class _ProfileHeader extends StatelessWidget {
  const _ProfileHeader({
    required this.accent,
    required this.fullName,
    required this.memberSince,
    this.photoUrl,
  });

  final Color accent;
  final String fullName;
  final String memberSince;
  final String? photoUrl;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Stack(
          clipBehavior: Clip.none,
          children: [
            Container(
              width: 80,
              height: 80,
              padding: const EdgeInsets.all(5),
              decoration: BoxDecoration(
                border: Border.all(color: accent, width: 1),
                borderRadius: BorderRadius.circular(9999),
              ),
              child: ProfileCircleAvatar(url: photoUrl, size: 70),
            ),
            Positioned(
              right: -8,
              bottom: -8,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(
                  color: accent,
                  borderRadius: BorderRadius.circular(9999),
                  boxShadow: const [
                    BoxShadow(color: Color.fromRGBO(232, 194, 101, 0.2), blurRadius: 15, offset: Offset(0, 10)),
                    BoxShadow(color: Color.fromRGBO(232, 194, 101, 0.2), blurRadius: 6, offset: Offset(0, 4)),
                  ],
                ),
                child: Row(
                  children: [
                    const Icon(Icons.star_rounded, size: 14, color: Color(0xFF2A2420)),
                    const SizedBox(width: 4),
                    Text(
                      'Elite',
                      style: GoogleFonts.poppins(
                        fontSize: 12,
                        height: 16 / 12,
                        letterSpacing: 0.6,
                        fontWeight: FontWeight.w500,
                        color: const Color(0xFF2A2420),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Text(
          fullName,
          textAlign: TextAlign.center,
          style: GoogleFonts.bodoniModa(
            fontSize: 30,
            height: 36 / 30,
            color: const Color(0xFFF5F0E8),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          memberSince.isEmpty ? 'Member' : memberSince,
          textAlign: TextAlign.center,
          style: GoogleFonts.poppins(
            fontSize: 14,
            height: 20 / 14,
            letterSpacing: 0.35,
            color: const Color(0xFFD0C5B2),
          ),
        ),
      ],
    );
  }
}

class _StatsRow extends ConsumerWidget {
  const _StatsRow({required this.surface, required this.accent, required this.muted});
  final Color surface;
  final Color accent;
  final Color muted;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final orders = ref.watch(userOrdersProvider).value?.length ?? 0;
    final saved = ref.watch(wishlistItemsProvider).value?.length ?? 0;
    final user = ref.watch(currentUserProvider);

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: surface,
        boxShadow: const [BoxShadow(color: Color.fromRGBO(0, 0, 0, 0.4), blurRadius: 40, offset: Offset(0, 20))],
      ),
      child: Row(
        children: [
          Expanded(child: _Stat(value: user == null ? '—' : '$orders', label: 'ORDERS')),
          const _Divider(),
          Expanded(child: _Stat(value: user == null ? '—' : '$saved', label: 'SAVED')),
          const _Divider(),
          const Expanded(child: _Stat(value: '—', label: 'REVIEWS')),
        ],
      ),
    );
  }
}

class _Divider extends StatelessWidget {
  const _Divider();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 1,
      height: 60,
      color: const Color.fromRGBO(232, 194, 101, 0.2),
    );
  }
}

class _Stat extends StatelessWidget {
  const _Stat({required this.value, required this.label});

  final String value;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          value,
          style: GoogleFonts.bodoniModa(
            fontSize: 36,
            height: 40 / 36,
            color: const Color(0xFFE8C265),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: GoogleFonts.poppins(
            fontSize: 12,
            height: 16 / 12,
            letterSpacing: 1.2,
            color: const Color(0xFFD0C5B2),
          ),
        ),
      ],
    );
  }
}

class _MenuSections extends StatelessWidget {
  const _MenuSections({required this.surface, required this.accent});

  final Color surface;
  final Color accent;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _Section(
          title: 'ACCOUNT',
          items: const [
            _MenuItem(Icons.person_outline_rounded, 'Personal Information'),
            _MenuItem(Icons.location_on_outlined, 'Address Book'),
            _MenuItem(Icons.credit_card_rounded, 'Payment Methods'),
          ],
          surface: surface,
          accent: accent,
        ),
        const SizedBox(height: 24),
        _Section(
          title: 'MY ORDERS',
          items: const [
            _MenuItem(Icons.inventory_2_outlined, 'Order History'),
            _MenuItem(Icons.local_shipping_outlined, 'Track Order'),
          ],
          surface: surface,
          accent: accent,
        ),
        const SizedBox(height: 24),
        _Section(
          title: 'SETTINGS',
          items: const [
            _MenuItem(Icons.tune_rounded, 'Preferences'),
            _MenuItem(Icons.lock_outline_rounded, 'Privacy & Security'),
          ],
          surface: surface,
          accent: accent,
        ),
      ],
    );
  }
}

class _Section extends StatelessWidget {
  const _Section({
    required this.title,
    required this.items,
    required this.surface,
    required this.accent,
  });

  final String title;
  final List<_MenuItem> items;
  final Color surface;
  final Color accent;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 16, bottom: 8),
          child: Text(
            title,
            style: GoogleFonts.poppins(
              fontSize: 12,
              height: 16 / 12,
              letterSpacing: 2.4,
              color: accent.withValues(alpha: 0.7),
            ),
          ),
        ),
        Container(
          color: surface,
          child: Column(
            children: [
              for (int i = 0; i < items.length; i++) ...[
                _RowButton(item: items[i]),
                if (i != items.length - 1)
                  Align(
                    alignment: Alignment.centerRight,
                    child: Container(
                      height: 1,
                      width: 302,
                      color: const Color.fromRGBO(8, 8, 8, 0.5),
                    ),
                  ),
              ],
            ],
          ),
        ),
      ],
    );
  }
}

class _RowButton extends StatelessWidget {
  const _RowButton({required this.item});

  final _MenuItem item;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        switch (item.label) {
          case 'Personal Information':
            Navigator.of(context).push(MaterialPageRoute(builder: (_) => const EditProfileScreen()));
            return;
          case 'Address Book':
            Navigator.of(context).push(MaterialPageRoute(builder: (_) => const SavedAddressesScreen()));
            return;
          case 'Payment Methods':
            Navigator.of(context).push(MaterialPageRoute(builder: (_) => const PaymentMethodsScreen()));
            return;
          case 'Order History':
            Navigator.of(context).push(MaterialPageRoute(builder: (_) => const OrderHistoryScreen()));
            return;
          case 'Track Order':
            Navigator.of(context).push(MaterialPageRoute(builder: (_) => const OrderHistoryScreen()));
            return;
          case 'Preferences':
            Navigator.of(context).push(MaterialPageRoute(builder: (_) => const PreferencesScreen()));
            return;
          case 'Privacy & Security':
            Navigator.of(context).push(MaterialPageRoute(builder: (_) => const PrivacySecurityScreen()));
            return;
        }
      },
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Icon(item.icon, size: 18, color: const Color(0xFFE8C265)),
                const SizedBox(width: 16),
                Text(
                  item.label,
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    height: 20 / 14,
                    letterSpacing: 0.35,
                    color: const Color(0xFFF5F0E8),
                  ),
                ),
              ],
            ),
            Icon(Icons.chevron_right_rounded, size: 18, color: const Color(0xFFD0C5B2).withValues(alpha: 0.7)),
          ],
        ),
      ),
    );
  }
}

class _MenuItem {
  const _MenuItem(this.icon, this.label);

  final IconData icon;
  final String label;
}

class _GuestProfilePrompt extends StatelessWidget {
  const _GuestProfilePrompt({required this.accent, required this.muted});

  final Color accent;
  final Color muted;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          'Sign in to view your profile',
          style: GoogleFonts.manrope(fontSize: 14, color: muted),
        ),
        const SizedBox(height: 16),
        TextButton(
          onPressed: () => Navigator.of(context).push(
            MaterialPageRoute(builder: (_) => const LoginScreen()),
          ),
          child: Text('SIGN IN', style: GoogleFonts.manrope(color: accent, letterSpacing: 1.2)),
        ),
      ],
    );
  }
}
