import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'return_reason_screen.dart';

class ReturnSelectScreen extends StatelessWidget {
  const ReturnSelectScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF131313),
      appBar: AppBar(
        backgroundColor: const Color(0xFF131313),
        foregroundColor: const Color(0xFFE5E2E1),
        title: Text('Return & Refund', style: GoogleFonts.notoSerif()),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Select items to return', style: GoogleFonts.notoSerif(fontSize: 22, color: const Color(0xFFE5E2E1))),
            const SizedBox(height: 16),
            _itemTile('Classic White Poplin Shirt', 'Qty 1'),
            const SizedBox(height: 12),
            _itemTile('Tailored Wool Trousers', 'Qty 1'),
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
                  Navigator.of(context).push(MaterialPageRoute(builder: (_) => const ReturnReasonScreen()));
                },
                child: Text('CONTINUE', style: GoogleFonts.manrope(letterSpacing: 1.2)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _itemTile(String title, String meta) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1C1B1B),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color.fromRGBO(78, 70, 57, 0.2)),
      ),
      child: Row(
        children: [
          Expanded(child: Text(title, style: GoogleFonts.manrope(fontSize: 14, color: const Color(0xFFE5E2E1)))),
          Text(meta, style: GoogleFonts.manrope(fontSize: 12, color: const Color(0xFF9A8F80))),
        ],
      ),
    );
  }
}

