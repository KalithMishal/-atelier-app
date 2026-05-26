import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import 'login_screen.dart';
import '../state/providers.dart';

Future<void> showSignOutSheet(BuildContext context, WidgetRef ref) {
  return showModalBottomSheet<void>(
    context: context,
    backgroundColor: Colors.transparent,
    isScrollControlled: true,
    builder: (ctx) {
      return Container(
        decoration: const BoxDecoration(
          color: Color(0xFF131313),
          borderRadius: BorderRadius.only(topLeft: Radius.circular(24), topRight: Radius.circular(24)),
        ),
        padding: const EdgeInsets.fromLTRB(24, 16, 24, 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(width: 48, height: 4, decoration: BoxDecoration(color: const Color(0xFF353534), borderRadius: BorderRadius.circular(999))),
            const SizedBox(height: 16),
            Text('Sign out?', style: GoogleFonts.notoSerif(fontSize: 20, color: const Color(0xFFE5E2E1))),
            const SizedBox(height: 8),
            Text(
              'You can sign back in anytime.',
              style: GoogleFonts.manrope(fontSize: 12, color: const Color(0xFF9A8F80)),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFE9C349),
                  foregroundColor: const Color(0xFF131313),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                onPressed: () async {
                  Navigator.of(ctx).pop();
                  await ref.read(authRepositoryProvider).signOut();
                  ref.read(checkoutDraftProvider.notifier).clear();
                  if (!context.mounted) return;
                  Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (_) => const LoginScreen()),
                    (route) => false,
                  );
                },
                child: Text('SIGN OUT', style: GoogleFonts.manrope(letterSpacing: 1.2)),
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                style: OutlinedButton.styleFrom(
                  foregroundColor: const Color(0xFFE5E2E1),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  side: const BorderSide(color: Color.fromRGBO(78, 70, 57, 0.3)),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                onPressed: () => Navigator.of(ctx).pop(),
                child: Text('STAY IN ATELIER', style: GoogleFonts.manrope(letterSpacing: 1.2)),
              ),
            ),
          ],
        ),
      );
    },
  );
}
