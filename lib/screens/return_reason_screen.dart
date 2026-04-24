import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'return_confirm_screen.dart';

class ReturnReasonScreen extends StatefulWidget {
  const ReturnReasonScreen({super.key});

  @override
  State<ReturnReasonScreen> createState() => _ReturnReasonScreenState();
}

class _ReturnReasonScreenState extends State<ReturnReasonScreen> {
  int _selected = 0;

  @override
  Widget build(BuildContext context) {
    final reasons = const ['Wrong size', 'Not as expected', 'Damaged item', 'Changed mind'];
    return Scaffold(
      backgroundColor: const Color(0xFF131313),
      appBar: AppBar(
        backgroundColor: const Color(0xFF131313),
        foregroundColor: const Color(0xFFE5E2E1),
        title: Text('Return Reason', style: GoogleFonts.notoSerif()),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Why are you returning?', style: GoogleFonts.notoSerif(fontSize: 22, color: const Color(0xFFE5E2E1))),
            const SizedBox(height: 16),
            for (int i = 0; i < reasons.length; i++) ...[
              _radio(reasons[i], i),
              const SizedBox(height: 12),
            ],
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
                  Navigator.of(context).push(MaterialPageRoute(builder: (_) => const ReturnConfirmScreen()));
                },
                child: Text('CONTINUE', style: GoogleFonts.manrope(letterSpacing: 1.2)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _radio(String label, int idx) {
    final active = _selected == idx;
    return GestureDetector(
      onTap: () => setState(() => _selected = idx),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFF1C1B1B),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: active ? const Color(0xFFE9C349) : const Color.fromRGBO(78, 70, 57, 0.2)),
        ),
        child: Row(
          children: [
            Container(
              width: 18,
              height: 18,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: const Color(0xFFE9C349)),
              ),
              child: active ? Center(child: Container(width: 8, height: 8, decoration: const BoxDecoration(color: Color(0xFFE9C349), shape: BoxShape.circle))) : null,
            ),
            const SizedBox(width: 12),
            Text(label, style: GoogleFonts.manrope(fontSize: 14, color: const Color(0xFFE5E2E1))),
          ],
        ),
      ),
    );
  }
}

