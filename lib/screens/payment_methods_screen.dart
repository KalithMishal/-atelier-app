import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class PaymentMethodsScreen extends StatefulWidget {
  const PaymentMethodsScreen({super.key});

  @override
  State<PaymentMethodsScreen> createState() => _PaymentMethodsScreenState();
}

class _PaymentMethodsScreenState extends State<PaymentMethodsScreen> {
  static const _bg = Color(0xFF080808);
  static const _surface = Color(0xFF2A2420);
  static const _text = Color(0xFFF5F0E8);
  static const _muted = Color(0xFFD0C5B2);
  static const _luxGold = Color(0xFFB8963E);

  int _selected = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bg,
      body: SafeArea(
        bottom: false,
        child: Stack(
          children: [
            SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(24, 96, 24, 32),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'SAVED CARDS',
                    style: GoogleFonts.poppins(
                      fontSize: 12,
                      height: 16 / 12,
                      letterSpacing: 2.4,
                      color: _muted.withValues(alpha: 0.85),
                    ),
                  ),
                  const SizedBox(height: 18),
                  _SavedCard(
                    name: 'Atelier Black',
                    last4: '4242',
                    expiry: '12/25',
                    selected: _selected == 0,
                    onTap: () => setState(() => _selected = 0),
                  ),
                  const SizedBox(height: 18),
                  _SavedCard(
                    name: 'Visa',
                    last4: '8821',
                    expiry: '08/26',
                    selected: _selected == 1,
                    onTap: () => setState(() => _selected = 1),
                  ),
                  const SizedBox(height: 20),
                  Center(
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.swipe_left_rounded, size: 16, color: _muted.withValues(alpha: 0.7)),
                        const SizedBox(width: 10),
                        Text(
                          'SWIPE LEFT TO DELETE',
                          style: GoogleFonts.poppins(
                            fontSize: 10,
                            height: 16 / 10,
                            letterSpacing: 2.0,
                            color: _muted.withValues(alpha: 0.7),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 30),
                  Text(
                    'OTHER METHODS',
                    style: GoogleFonts.poppins(
                      fontSize: 12,
                      height: 16 / 12,
                      letterSpacing: 2.4,
                      color: _muted.withValues(alpha: 0.85),
                    ),
                  ),
                  const SizedBox(height: 14),
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: _surface,
                      borderRadius: BorderRadius.circular(22),
                      border: Border.all(color: const Color.fromRGBO(208, 197, 178, 0.12)),
                      boxShadow: const [
                        BoxShadow(color: Color.fromRGBO(0, 0, 0, 0.35), blurRadius: 40, offset: Offset(0, 20)),
                      ],
                    ),
                    child: Column(
                      children: const [
                        _OtherMethodRow(icon: Icons.apple_rounded, label: 'Apple Pay'),
                        _DividerLine(),
                        _OtherMethodRow(icon: Icons.qr_code_2_rounded, label: 'PayNow'),
                      ],
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
                child: Container(
                  height: 64,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  color: const Color.fromRGBO(8, 8, 8, 0.85),
                  child: Row(
                    children: [
                      IconButton(
                        onPressed: () => Navigator.of(context).maybePop(),
                        icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 18, color: _luxGold),
                      ),
                      Expanded(
                        child: Center(
                          child: Text(
                            'PAYMENT METHODS',
                            style: GoogleFonts.bodoniModa(
                              fontSize: 18,
                              height: 24 / 18,
                              letterSpacing: 4.2,
                              color: _text,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 40),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SavedCard extends StatelessWidget {
  const _SavedCard({
    required this.name,
    required this.last4,
    required this.expiry,
    required this.selected,
    required this.onTap,
  });

  final String name;
  final String last4;
  final String expiry;
  final bool selected;
  final VoidCallback onTap;

  static const _surface = Color(0xFF2A2420);
  static const _text = Color(0xFFF5F0E8);
  static const _muted = Color(0xFFD0C5B2);
  static const _luxGold = Color(0xFFB8963E);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.fromLTRB(22, 22, 22, 22),
        decoration: BoxDecoration(
          color: _surface,
          borderRadius: BorderRadius.circular(28),
          border: Border.all(color: selected ? const Color.fromRGBO(184, 150, 62, 0.45) : const Color.fromRGBO(208, 197, 178, 0.10)),
          boxShadow: const [BoxShadow(color: Color.fromRGBO(0, 0, 0, 0.35), blurRadius: 40, offset: Offset(0, 20))],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    name,
                    style: GoogleFonts.cormorantGaramond(
                      fontSize: 26,
                      height: 30 / 26,
                      fontStyle: FontStyle.italic,
                      color: name == 'Atelier Black' ? _luxGold : _text.withValues(alpha: 0.85),
                    ),
                  ),
                ),
                Container(
                  width: 26,
                  height: 26,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: _muted.withValues(alpha: 0.45)),
                    color: selected ? const Color.fromRGBO(184, 150, 62, 0.15) : Colors.transparent,
                  ),
                  alignment: Alignment.center,
                  child: selected ? const Icon(Icons.check_rounded, size: 16, color: _muted) : null,
                ),
              ],
            ),
            const SizedBox(height: 18),
            Row(
              children: [
                Text(
                  '****  $last4',
                  style: GoogleFonts.poppins(fontSize: 14, height: 20 / 14, letterSpacing: 6, color: _text),
                ),
                const Spacer(),
                Text(
                  expiry,
                  style: GoogleFonts.poppins(fontSize: 12, height: 16 / 12, letterSpacing: 0.6, color: _text.withValues(alpha: 0.85)),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _OtherMethodRow extends StatelessWidget {
  const _OtherMethodRow({required this.icon, required this.label});
  final IconData icon;
  final String label;

  static const _text = Color(0xFFF5F0E8);
  static const _muted = Color(0xFFD0C5B2);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {},
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 18),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: const Color.fromRGBO(0, 0, 0, 0.15),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: const Color.fromRGBO(208, 197, 178, 0.10)),
              ),
              alignment: Alignment.center,
              child: Icon(icon, size: 20, color: _muted),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Text(
                label,
                style: GoogleFonts.poppins(fontSize: 14, height: 20 / 14, letterSpacing: 0.35, color: _text),
              ),
            ),
            Icon(Icons.chevron_right_rounded, size: 20, color: _muted.withValues(alpha: 0.8)),
          ],
        ),
      ),
    );
  }
}

class _DividerLine extends StatelessWidget {
  const _DividerLine();
  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerRight,
      child: Container(
        height: 1,
        width: 302,
        color: const Color.fromRGBO(8, 8, 8, 0.5),
      ),
    );
  }
}
