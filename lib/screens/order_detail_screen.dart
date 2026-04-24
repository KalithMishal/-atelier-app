import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'product_reviews_screen.dart';
import 'return_select_screen.dart';

class OrderDetailScreen extends StatelessWidget {
  const OrderDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF131313),
      appBar: AppBar(
        backgroundColor: const Color(0xFF131313),
        foregroundColor: const Color(0xFFE5E2E1),
        title: Text('Order Detail', style: GoogleFonts.notoSerif()),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Order #AT-12040', style: GoogleFonts.notoSerif(fontSize: 22, color: const Color(0xFFE5E2E1))),
            const SizedBox(height: 8),
            Text('Status: Confirmed', style: GoogleFonts.manrope(fontSize: 14, color: const Color(0xFF9A8F80))),
            const SizedBox(height: 24),
            _action(
              label: 'TRACK MY PACKAGE →',
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Tracking state not implemented yet.')));
              },
            ),
            const SizedBox(height: 12),
            _action(
              label: 'REQUEST RETURN →',
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(builder: (_) => const ReturnSelectScreen()));
              },
            ),
            const SizedBox(height: 12),
            _action(
              label: 'WRITE A REVIEW ✦',
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(builder: (_) => const ProductReviewsScreen()));
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _action({required String label, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
        decoration: BoxDecoration(
          color: const Color(0xFF1C1B1B),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color.fromRGBO(78, 70, 57, 0.2)),
        ),
        child: Text(
          label,
          style: GoogleFonts.manrope(fontSize: 12, letterSpacing: 1.2, color: const Color(0xFFE9C349)),
        ),
      ),
    );
  }
}

