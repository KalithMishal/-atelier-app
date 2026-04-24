import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

Future<void> showGiftNoteSheet(BuildContext context) {
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (ctx) {
      return Padding(
        padding: EdgeInsets.only(bottom: MediaQuery.of(ctx).viewInsets.bottom),
        child: Container(
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
              Text('Gift Note', style: GoogleFonts.notoSerif(fontSize: 20, color: const Color(0xFFE5E2E1))),
              const SizedBox(height: 16),
              TextField(
                maxLines: 4,
                style: GoogleFonts.manrope(color: const Color(0xFFE5E2E1)),
                decoration: InputDecoration(
                  hintText: 'Your personal message...',
                  hintStyle: GoogleFonts.manrope(color: const Color(0xFF9A8F80)),
                  filled: true,
                  fillColor: const Color(0xFF1C1B1B),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: Color.fromRGBO(78, 70, 57, 0.2)),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: Color.fromRGBO(78, 70, 57, 0.2)),
                  ),
                ),
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
                  onPressed: () => Navigator.of(ctx).pop(),
                  child: Text('SAVE NOTE', style: GoogleFonts.manrope(letterSpacing: 1.2)),
                ),
              ),
            ],
          ),
        ),
      );
    },
  );
}

