import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'order_history_screen.dart';

class ReturnConfirmScreen extends StatelessWidget {
  const ReturnConfirmScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF131313),
      appBar: AppBar(
        backgroundColor: const Color(0xFF131313),
        foregroundColor: const Color(0xFFE5E2E1),
        title: Text('Confirm Return', style: GoogleFonts.notoSerif()),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Review & confirm', style: GoogleFonts.notoSerif(fontSize: 22, color: const Color(0xFFE5E2E1))),
            const SizedBox(height: 16),
            Text(
              'Return summary:\n- 2 items\n- Refund to original payment method\n- Processing 5–10 business days',
              style: GoogleFonts.manrope(fontSize: 14, height: 20 / 14, color: const Color(0xFF9A8F80)),
            ),
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
                onPressed: () {
                  Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (_) => const OrderHistoryScreen()),
                    (route) => false,
                  );
                },
                child: Text('CONFIRM RETURN', style: GoogleFonts.manrope(letterSpacing: 1.2)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

