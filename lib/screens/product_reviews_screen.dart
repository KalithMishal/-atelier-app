import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';

class ProductReviewsScreen extends StatefulWidget {
  const ProductReviewsScreen({super.key});

  @override
  State<ProductReviewsScreen> createState() => _ProductReviewsScreenState();
}

class _ProductReviewsScreenState extends State<ProductReviewsScreen> {
  int _activeFilter = 0;
  static const double _phoneWidth = 390;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF131313),
      body: SafeArea(
        bottom: false,
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: _phoneWidth),
            child: Stack(
              children: [
                Column(
                  children: [
                    const _TopAppBar(),
                    Expanded(
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.fromLTRB(24, 32, 24, 140),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Client Reviews',
                              style: GoogleFonts.notoSerif(
                                fontSize: 36,
                                height: 40 / 36,
                                letterSpacing: 0.9,
                                color: const Color(0xFFE5E2E1),
                              ),
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'THE SIGNATURE COLLECTION',
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 14,
                                height: 20 / 14,
                                letterSpacing: 0.7,
                                color: const Color(0xFFD0C5B2),
                              ),
                            ),
                            const SizedBox(height: 24),
                            const _RatingSummaryCard(),
                            const SizedBox(height: 32),
                            _FilterRow(
                              active: _activeFilter,
                              onTap: (i) => setState(() => _activeFilter = i),
                            ),
                            const SizedBox(height: 32),
                            const _ReviewCardOne(),
                            const SizedBox(height: 32),
                            const _ReviewCardTwo(),
                            const SizedBox(height: 32),
                            const _Pager(),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                const Positioned(
                  left: 0,
                  right: 0,
                  bottom: 0,
                  child: _StickyShare(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _TopAppBar extends StatelessWidget {
  const _TopAppBar();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color.fromRGBO(0, 0, 0, 0.8),
      height: 64,
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Row(
        children: [
          IconButton(
            onPressed: () => Navigator.of(context).maybePop(),
            icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 18, color: Color(0xFFF5F0E8)),
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints.tightFor(width: 32, height: 32),
          ),
          const Spacer(),
          Text(
            'ATELIER',
            style: GoogleFonts.libreBaskerville(
              fontSize: 24,
              letterSpacing: 7.2,
              color: const Color(0xFFF5F0E8),
            ),
          ),
          const Spacer(),
          IconButton(
            onPressed: () => Navigator.of(context).maybePop(),
            icon: const Icon(Icons.shopping_bag_outlined, size: 20, color: Color(0xFFF5F0E8)),
          ),
        ],
      ),
    );
  }
}

class _RatingSummaryCard extends StatelessWidget {
  const _RatingSummaryCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: const Color(0xFF2A2420),
        borderRadius: BorderRadius.circular(48),
        boxShadow: const [BoxShadow(color: Color.fromRGBO(184, 150, 62, 0.04), blurRadius: 40, offset: Offset(0, 20))],
      ),
      child: Column(
        children: [
          Text(
            '4.8',
            style: GoogleFonts.notoSerif(
              fontSize: 72,
              height: 72 / 72,
              color: const Color(0xFFB8963E),
            ),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              for (int i = 0; i < 4; i++)
                Padding(
                  padding: const EdgeInsets.only(right: 4),
                  child: SvgPicture.asset(
                    'assets/images/icon_star_full_small.svg',
                    width: 16.67,
                    height: 15.83,
                    colorFilter: const ColorFilter.mode(Color(0xFFB8963E), BlendMode.srcIn),
                  ),
                ),
              SvgPicture.asset(
                'assets/images/icon_star_half_small.svg',
                width: 16.67,
                height: 15.83,
                colorFilter: const ColorFilter.mode(Color(0xFFB8963E), BlendMode.srcIn),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            'Based on 124 reviews',
            style: GoogleFonts.plusJakartaSans(fontSize: 14, height: 20 / 14, color: const Color(0xFFD0C5B2)),
          ),
          const SizedBox(height: 32),
          Container(height: 1, color: const Color.fromRGBO(77, 70, 55, 0.3)),
          const SizedBox(height: 24),
          const _RatingBarRow(label: '5 Stars', value: 105, fill: 0.85),
          const SizedBox(height: 12),
          const _RatingBarRow(label: '4 Stars', value: 12, fill: 0.10),
          const SizedBox(height: 12),
          const _RatingBarRow(label: '3 Stars', value: 4, fill: 0.03),
          const SizedBox(height: 12),
          const _RatingBarRow(label: '2 Stars', value: 2, fill: 0.01),
          const SizedBox(height: 12),
          const _RatingBarRow(label: '1 Star', value: 1, fill: 0.01),
        ],
      ),
    );
  }
}

class _RatingBarRow extends StatelessWidget {
  const _RatingBarRow({required this.label, required this.value, required this.fill});

  final String label;
  final int value;
  final double fill;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(
          width: 64,
          child: Text(label, style: GoogleFonts.plusJakartaSans(fontSize: 14, height: 20 / 14, color: const Color(0xFFD0C5B2))),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(9999),
            child: Container(
              height: 4,
              color: const Color(0xFF353534),
              alignment: Alignment.centerLeft,
              child: FractionallySizedBox(
                widthFactor: fill,
                child: Container(color: const Color(0xFFB8963E)),
              ),
            ),
          ),
        ),
        const SizedBox(width: 16),
        SizedBox(
          width: 32,
          child: Text(
            '$value',
            textAlign: TextAlign.right,
            style: GoogleFonts.plusJakartaSans(fontSize: 14, height: 20 / 14, color: const Color(0xFFD0C5B2)),
          ),
        ),
      ],
    );
  }
}

class _FilterRow extends StatelessWidget {
  const _FilterRow({required this.active, required this.onTap});
  final int active;
  final ValueChanged<int> onTap;

  @override
  Widget build(BuildContext context) {
    final labels = const ['All Reviews', 'With Photos', '5 Stars', 'Recent'];
    return SizedBox(
      height: 54,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: labels.length,
        padding: EdgeInsets.zero,
        separatorBuilder: (context, index) => const SizedBox(width: 12),
        itemBuilder: (context, index) {
          final isActive = index == active;
          return GestureDetector(
            onTap: () => onTap(index),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 9),
              margin: const EdgeInsets.only(top: 8),
              decoration: BoxDecoration(
                color: isActive ? const Color(0xFFB8963E) : Colors.transparent,
                borderRadius: BorderRadius.circular(9999),
                border: isActive ? null : Border.all(color: const Color.fromRGBO(77, 70, 55, 0.4)),
              ),
              child: Text(
                labels[index],
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 14,
                  height: 20 / 14,
                  color: isActive ? const Color(0xFF2A2420) : const Color(0xFFD0C5B2),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class _ReviewHeader extends StatelessWidget {
  const _ReviewHeader({required this.initials, required this.name, required this.date});
  final String initials;
  final String name;
  final String date;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: const Color(0xFF201F1F),
                borderRadius: BorderRadius.circular(9999),
                border: Border.all(color: const Color.fromRGBO(184, 150, 62, 0.3)),
              ),
              alignment: Alignment.center,
              child: Text(
                initials,
                style: GoogleFonts.notoSerif(fontSize: 16, height: 24 / 16, color: const Color(0xFFB8963E)),
              ),
            ),
            const SizedBox(width: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name, style: GoogleFonts.plusJakartaSans(fontSize: 16, height: 24 / 16, color: const Color(0xFFE5E2E1))),
                const SizedBox(height: 2),
                Row(
                  children: [
                    SvgPicture.asset('assets/images/icon_verified.svg', width: 12.83, height: 12.25),
                    const SizedBox(width: 4),
                    Text(
                      'VERIFIED PURCHASE',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 10,
                        height: 15 / 10,
                        letterSpacing: 0.5,
                        color: const Color.fromRGBO(184, 150, 62, 0.8),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
        Text(
          date,
          style: GoogleFonts.plusJakartaSans(fontSize: 12, height: 16 / 12, color: const Color.fromRGBO(208, 197, 178, 0.6)),
        ),
      ],
    );
  }
}

class _StarsRow extends StatelessWidget {
  const _StarsRow({required this.full, required this.half});
  final int full;
  final bool half;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        for (int i = 0; i < full; i++)
          Padding(
            padding: const EdgeInsets.only(right: 2),
            child: SvgPicture.asset('assets/images/icon_review_star_full.svg', width: 11.34, height: 10.77),
          ),
        if (half) SvgPicture.asset('assets/images/icon_review_star_off.svg', width: 11.34, height: 10.77),
      ],
    );
  }
}

class _ReviewCardOne extends StatelessWidget {
  const _ReviewCardOne();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(bottom: 32),
      decoration: const BoxDecoration(border: Border(bottom: BorderSide(color: Color.fromRGBO(77, 70, 55, 0.2), width: 1))),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _ReviewHeader(initials: 'EV', name: 'Eleanor V.', date: 'Oct 12, 2023'),
          const SizedBox(height: 16),
          const _StarsRow(full: 5, half: false),
          const SizedBox(height: 24),
          Text('Exquisite Craftsmanship', style: GoogleFonts.notoSerif(fontSize: 20, height: 28 / 20, color: const Color(0xFFE5E2E1))),
          const SizedBox(height: 16),
          Text(
            'The attention to detail is simply\nunparalleled. From the moment I\nunboxed it, the quality of the materials\nwas evident. It drapes beautifully and\nhas quickly become a staple piece in my\nwardrobe. The subtle gold accents catch\nthe light perfectly.',
            style: GoogleFonts.notoSerif(fontSize: 18, height: 29.25 / 18, color: const Color(0xFFD0C5B2)),
          ),
          const SizedBox(height: 8),
          Text('READ MORE', style: GoogleFonts.plusJakartaSans(fontSize: 14, height: 20 / 14, letterSpacing: 1.4, color: const Color(0xFFB8963E))),
          const SizedBox(height: 16),
          Row(
            children: [
              _PhotoThumb(asset: 'assets/images/rev_photo_1.png'),
              const SizedBox(width: 16),
              _PhotoThumb(asset: 'assets/images/rev_photo_2.png'),
            ],
          ),
        ],
      ),
    );
  }
}

class _PhotoThumb extends StatelessWidget {
  const _PhotoThumb({required this.asset});
  final String asset;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(32),
      child: Container(
        width: 96,
        height: 96,
        color: const Color(0xFF201F1F),
        child: Opacity(opacity: 0.8, child: Image.asset(asset, fit: BoxFit.cover)),
      ),
    );
  }
}

class _ReviewCardTwo extends StatelessWidget {
  const _ReviewCardTwo();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const _ReviewHeader(initials: 'JM', name: 'Julian M.', date: 'Sep 28, 2023'),
        const SizedBox(height: 16),
        const _StarsRow(full: 4, half: true),
        const SizedBox(height: 24),
        Text('A timeless investment', style: GoogleFonts.notoSerif(fontSize: 20, height: 28 / 20, color: const Color(0xFFE5E2E1))),
        const SizedBox(height: 16),
        Text(
          'Truly a beautiful piece. The silhouette is\nclassic yet modern. I only docked one\nstar because the sizing runs slightly\nsmall, but the exchange process was\nseamless and the customer service was\nimpeccable.',
          style: GoogleFonts.notoSerif(fontSize: 18, height: 29.25 / 18, color: const Color(0xFFD0C5B2)),
        ),
      ],
    );
  }
}

class _Pager extends StatelessWidget {
  const _Pager();

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SvgPicture.asset('assets/images/icon_pager_left.svg', width: 7.4, height: 12),
        const SizedBox(width: 32),
        Text('1 / 12', style: GoogleFonts.plusJakartaSans(fontSize: 14, height: 20 / 14, color: const Color(0xFFD0C5B2))),
        const SizedBox(width: 32),
        SvgPicture.asset('assets/images/icon_pager_right.svg', width: 7.4, height: 12),
      ],
    );
  }
}

class _StickyShare extends StatelessWidget {
  const _StickyShare();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(24, 24, 24, 100),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.bottomCenter,
          end: Alignment.topCenter,
          stops: [0.0, 0.55, 1.0],
          colors: [
            Color(0xFF131313),
            Color.fromRGBO(19, 19, 19, 0.9),
            Color.fromRGBO(19, 19, 19, 0.0),
          ],
        ),
      ),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          gradient: const LinearGradient(colors: [Color(0xFFB8963E), Color(0xFFC4A882)]),
          borderRadius: BorderRadius.circular(9999),
          boxShadow: const [BoxShadow(color: Color.fromRGBO(184, 150, 62, 0.2), blurRadius: 30, offset: Offset(0, 10))],
        ),
        alignment: Alignment.center,
        child: Text(
          'SHARE YOUR EXPERIENCE',
          style: GoogleFonts.plusJakartaSans(
            fontSize: 12,
            height: 16 / 12,
            letterSpacing: 2.4,
            color: const Color(0xFF2A2420),
          ),
        ),
      ),
    );
  }
}

