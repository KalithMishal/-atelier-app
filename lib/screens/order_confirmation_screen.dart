import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../utils/format.dart';
import 'home_screen.dart';
import 'track_order_screen.dart';

class OrderConfirmationScreen extends StatelessWidget {
  const OrderConfirmationScreen({
    super.key,
    required this.orderId,
    required this.total,
    required this.currency,
  });

  final String orderId;
  final num total;
  final String currency;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF131313),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              const Spacer(),
              Container(
                width: 72,
                height: 72,
                decoration: BoxDecoration(
                  color: const Color(0xFFE9C349).withValues(alpha: 0.15),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.check_rounded, size: 40, color: Color(0xFFE9C349)),
              ),
              const SizedBox(height: 28),
              Text(
                'Order Placed',
                style: GoogleFonts.notoSerif(fontSize: 32, color: const Color(0xFFE5E2E1)),
              ),
              const SizedBox(height: 12),
              Text(
                'Thank you for shopping with ATELIER.',
                textAlign: TextAlign.center,
                style: GoogleFonts.manrope(fontSize: 15, color: const Color(0xFFD1C5B4), height: 22 / 15),
              ),
              const SizedBox(height: 24),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: const Color(0xFF1C1B1B),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: const Color.fromRGBO(78, 70, 57, 0.35)),
                ),
                child: Column(
                  children: [
                    Text('ORDER #${orderId.substring(0, 8).toUpperCase()}', style: GoogleFonts.manrope(fontSize: 11, letterSpacing: 2, color: const Color(0xFF8A8278))),
                    const SizedBox(height: 8),
                    Text(formatMoney(total, currency: currency), style: GoogleFonts.notoSerif(fontSize: 28, color: const Color(0xFFE9C349))),
                    const SizedBox(height: 8),
                    Text('Cash on delivery · Colombo area', style: GoogleFonts.manrope(fontSize: 12, color: const Color(0xFFD1C5B4))),
                  ],
                ),
              ),
              const Spacer(),
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: () => Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (_) => TrackOrderScreen(orderId: orderId)),
                  ),
                  style: FilledButton.styleFrom(
                    backgroundColor: const Color(0xFFE9C349),
                    foregroundColor: const Color(0xFF2A2420),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: const Text('TRACK ORDER'),
                ),
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: () => Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (_) => const HomeScreen()),
                    (_) => false,
                  ),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: const Color(0xFFE5E2E1),
                    side: const BorderSide(color: Color.fromRGBO(78, 70, 57, 0.5)),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: const Text('CONTINUE SHOPPING'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
