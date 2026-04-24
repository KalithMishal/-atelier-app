import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

Future<void> showFilterDrawerSheet(BuildContext context) {
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (ctx) {
      return Container(
        height: MediaQuery.of(ctx).size.height * 0.62,
        decoration: const BoxDecoration(
          color: Color(0xFF131313),
          borderRadius: BorderRadius.only(topLeft: Radius.circular(24), topRight: Radius.circular(24)),
        ),
        padding: const EdgeInsets.fromLTRB(24, 16, 24, 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 48,
                height: 4,
                decoration: BoxDecoration(color: const Color(0xFF353534), borderRadius: BorderRadius.circular(999)),
              ),
            ),
            const SizedBox(height: 16),
            Text('Filters', style: GoogleFonts.notoSerif(fontSize: 20, color: const Color(0xFFE5E2E1))),
            const SizedBox(height: 16),
            _chipRow('Category', const ['Women', 'Men', 'Accessories']),
            const SizedBox(height: 16),
            _chipRow('Sort', const ['Featured', 'Price ↑', 'Price ↓', 'Newest']),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFE9C349),
                  foregroundColor: const Color(0xFF131313),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                onPressed: () => Navigator.of(ctx).pop(),
                child: Text('APPLY', style: GoogleFonts.manrope(letterSpacing: 1.2)),
              ),
            ),
          ],
        ),
      );
    },
  );
}

Widget _chipRow(String label, List<String> items) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(label, style: GoogleFonts.manrope(fontSize: 12, letterSpacing: 1.2, color: const Color(0xFF9A8F80))),
      const SizedBox(height: 8),
      Wrap(
        spacing: 8,
        runSpacing: 8,
        children: items
            .map(
              (e) => Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: const Color(0xFF1C1B1B),
                  borderRadius: BorderRadius.circular(999),
                  border: Border.all(color: const Color.fromRGBO(78, 70, 57, 0.2)),
                ),
                child: Text(e, style: GoogleFonts.manrope(fontSize: 12, color: const Color(0xFFE5E2E1))),
              ),
            )
            .toList(),
      ),
    ],
  );
}

