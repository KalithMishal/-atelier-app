import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';

class SizeGuideScreen extends StatefulWidget {
  const SizeGuideScreen({super.key});

  @override
  State<SizeGuideScreen> createState() => _SizeGuideScreenState();
}

class _SizeGuideScreenState extends State<SizeGuideScreen> {
  int _tab = 0; // women
  int _unit = 0; // cm

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0E0E0E),
      body: Stack(
        children: [
          Positioned.fill(
            child: Center(
              child: Opacity(
                opacity: 0.5,
                child: Text(
                  'BACKGROUND CONTENT',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 14,
                    height: 20 / 14,
                    letterSpacing: 1.4,
                    color: const Color(0xFFD0C5B2),
                  ),
                ),
              ),
            ),
          ),
          Positioned.fill(
            child: Container(color: const Color.fromRGBO(0, 0, 0, 0.6)),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: SafeArea(
              top: false,
              child: ClipRRect(
                borderRadius: const BorderRadius.only(topLeft: Radius.circular(48), topRight: Radius.circular(48)),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 2, sigmaY: 2),
                  child: Container(
                    width: double.infinity,
                    decoration: const BoxDecoration(
                      color: Color(0xFF2A2420),
                      boxShadow: [BoxShadow(color: Color.fromRGBO(184, 150, 62, 0.1), blurRadius: 60, offset: Offset(0, -20))],
                    ),
                    child: _Sheet(
                      tab: _tab,
                      onTab: (i) => setState(() => _tab = i),
                      unit: _unit,
                      onUnit: (i) => setState(() => _unit = i),
                      onClose: () => Navigator.of(context).maybePop(),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _Sheet extends StatelessWidget {
  const _Sheet({required this.tab, required this.onTab, required this.unit, required this.onUnit, required this.onClose});

  final int tab;
  final ValueChanged<int> onTab;
  final int unit;
  final ValueChanged<int> onUnit;
  final VoidCallback onClose;

  @override
  Widget build(BuildContext context) {
    final titleStyle = GoogleFonts.notoSerif(
      fontSize: 30,
      height: 36 / 30,
      letterSpacing: 0.75,
      color: const Color(0xFFE5E2E1),
    );

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const SizedBox(height: 16),
        Container(width: 48, height: 4, decoration: BoxDecoration(color: const Color.fromRGBO(232, 194, 101, 0.4), borderRadius: BorderRadius.circular(9999))),
        Padding(
          padding: const EdgeInsets.fromLTRB(24, 8, 24, 16),
          child: Row(
            children: [
              Text('Size Guide', style: titleStyle),
              const Spacer(),
              IconButton(
                onPressed: onClose,
                icon: SvgPicture.asset(
                  'assets/images/icon_close_x.svg',
                  width: 13.3,
                  height: 13.3,
                  colorFilter: const ColorFilter.mode(Color(0xFFE5E2E1), BlendMode.srcIn),
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.only(bottom: 40),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: _Tabs(tab: tab, onTab: onTab),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(24, 16, 24, 0),
                  child: Row(
                    children: [
                      Text('APPAREL', style: GoogleFonts.plusJakartaSans(fontSize: 12, height: 16 / 12, letterSpacing: 1.2, color: const Color(0xFFD0C5B2))),
                      const Spacer(),
                      _UnitToggle(unit: unit, onUnit: onUnit),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: _SizeTable(),
                ),
                const SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: _TipCard(),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _Tabs extends StatelessWidget {
  const _Tabs({required this.tab, required this.onTab});
  final int tab;
  final ValueChanged<int> onTab;

  @override
  Widget build(BuildContext context) {
    Widget item(String label, int i) {
      final selected = tab == i;
      return GestureDetector(
        onTap: () => onTab(i),
        child: Container(
          padding: EdgeInsets.only(left: i == 0 ? 0 : 32, bottom: 14),
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(color: selected ? const Color(0xFFE8C265) : Colors.transparent, width: 2),
            ),
          ),
          child: Text(
            label,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 12,
              height: 16 / 12,
              letterSpacing: 2.4,
              color: selected ? const Color(0xFFE8C265) : const Color(0xFFD0C5B2),
            ),
          ),
        ),
      );
    }

    return Container(
      decoration: const BoxDecoration(border: Border(bottom: BorderSide(color: Color.fromRGBO(77, 70, 55, 0.3), width: 1))),
      child: Row(
        children: [
          item('WOMEN', 0),
          item('MEN', 1),
          item('SHOES', 2),
        ],
      ),
    );
  }
}

class _UnitToggle extends StatelessWidget {
  const _UnitToggle({required this.unit, required this.onUnit});
  final int unit;
  final ValueChanged<int> onUnit;

  @override
  Widget build(BuildContext context) {
    Widget pill(String label, int i) {
      final selected = unit == i;
      return GestureDetector(
        onTap: () => onUnit(i),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
          decoration: BoxDecoration(
            color: selected ? const Color(0xFF131313) : Colors.transparent,
            borderRadius: BorderRadius.circular(9999),
            boxShadow: selected ? const [BoxShadow(color: Color.fromRGBO(0, 0, 0, 0.05), blurRadius: 2, offset: Offset(0, 1))] : null,
          ),
          child: Text(
            label,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 12,
              height: 16 / 12,
              letterSpacing: 1.2,
              color: selected ? const Color(0xFFE8C265) : const Color(0xFFD0C5B2),
            ),
          ),
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.all(5),
      decoration: BoxDecoration(
        color: const Color(0xFF2A2A2A),
        borderRadius: BorderRadius.circular(9999),
        border: Border.all(color: const Color.fromRGBO(77, 70, 55, 0.2)),
      ),
      child: Row(children: [pill('CM', 0), pill('IN', 1)]),
    );
  }
}

class _SizeTable extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    TextStyle header = GoogleFonts.plusJakartaSans(fontSize: 10, height: 20 / 10, letterSpacing: 1, color: const Color(0xFFE8C265));
    TextStyle cell = GoogleFonts.plusJakartaSans(fontSize: 14, height: 20 / 14, color: const Color(0xFFD0C5B2));
    TextStyle cellStrong = cell.copyWith(color: const Color(0xFFE5E2E1));

    Widget h(String t) => Padding(padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16), child: Text(t, style: header));
    Widget c(String t, {bool strong = false}) => Padding(padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16.5), child: Text(t, style: strong ? cellStrong : cell));

    Widget row({required String size, required String us, required String bust, required String waist, required String hip, required bool shaded}) {
      final bg = shaded ? const Color.fromRGBO(14, 14, 14, 0.3) : Colors.transparent;
      return Container(
        decoration: BoxDecoration(
          color: bg,
          border: const Border(top: BorderSide(color: Color.fromRGBO(77, 70, 55, 0.1), width: 1)),
        ),
        child: Row(
          children: [
            SizedBox(width: 64.97, child: c(size, strong: true)),
            SizedBox(width: 62.08, child: c(us)),
            SizedBox(width: 69.67, child: c(bust)),
            SizedBox(width: 75.61, child: c(waist)),
            SizedBox(width: 72.45, child: c(hip)),
          ],
        ),
      );
    }

    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF131313),
        borderRadius: BorderRadius.circular(32),
        border: Border.all(color: const Color.fromRGBO(77, 70, 55, 0.1)),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(32),
        child: Column(
          children: [
            Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(begin: Alignment.centerLeft, end: Alignment.centerRight, colors: [Color.fromRGBO(184, 150, 62, 0.2), Color.fromRGBO(184, 150, 62, 0.0)]),
                border: Border(bottom: BorderSide(color: Color.fromRGBO(77, 70, 55, 0.2), width: 1)),
              ),
              child: Row(
                children: [
                  SizedBox(width: 64.97, child: h('SIZE')),
                  SizedBox(width: 62.08, child: h('US')),
                  SizedBox(width: 69.67, child: h('BUST')),
                  SizedBox(width: 75.61, child: h('WAIST')),
                  SizedBox(width: 72.45, child: h('HIP')),
                ],
              ),
            ),
            row(size: 'XS', us: '0-\n2', bust: '80-\n84', waist: '60-\n64', hip: '88-\n92', shaded: false),
            row(size: 'S', us: '4-\n6', bust: '85-\n89', waist: '65-\n69', hip: '93-\n97', shaded: true),
            row(size: 'M', us: '8-\n10', bust: '90-\n94', waist: '70-\n74', hip: '98-\n102', shaded: false),
            row(size: 'L', us: '12-\n14', bust: '95-\n99', waist: '75-\n79', hip: '103-\n107', shaded: true),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }
}

class _TipCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Color(0xFF1C1B1B),
        borderRadius: BorderRadius.only(topLeft: Radius.circular(32), topRight: Radius.circular(32), bottomRight: Radius.circular(32)),
        border: Border(left: BorderSide(color: Color(0xFFE8C265), width: 2)),
      ),
      padding: const EdgeInsets.fromLTRB(22, 20, 20, 20),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SvgPicture.asset('assets/images/icon_info.svg', width: 20, height: 22, colorFilter: const ColorFilter.mode(Color(0xFFE8C265), BlendMode.srcIn)),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Fit Recommendation', style: GoogleFonts.notoSerif(fontSize: 18, height: 28 / 18, color: const Color(0xFFE5E2E1))),
                const SizedBox(height: 8),
                Text(
                  'Our garments are tailored for a\nsculpted fit. If you are between sizes or\nprefer a more relaxed silhouette, we\nrecommend selecting one size up.',
                  style: GoogleFonts.notoSerif(fontSize: 14, height: 22.75 / 14, color: const Color(0xFFD0C5B2)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

