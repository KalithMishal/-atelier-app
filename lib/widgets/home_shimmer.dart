import 'package:flutter/material.dart';

/// Lightweight skeleton placeholders while products load.
class HomeShimmerBox extends StatefulWidget {
  const HomeShimmerBox({super.key, required this.height, this.width, this.borderRadius = 12});

  final double height;
  final double? width;
  final double borderRadius;

  @override
  State<HomeShimmerBox> createState() => _HomeShimmerBoxState();
}

class _HomeShimmerBoxState extends State<HomeShimmerBox> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: const Duration(milliseconds: 1200))
      ..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (_, __) {
        final t = 0.35 + (_controller.value * 0.25);
        return Container(
          width: widget.width,
          height: widget.height,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(widget.borderRadius),
            gradient: LinearGradient(
              begin: Alignment(-1 + _controller.value * 2, 0),
              end: Alignment(1 + _controller.value * 2, 0),
              colors: [
                const Color(0xFF1C1B1B),
                Color.lerp(const Color(0xFF1C1B1B), const Color(0xFF2A2826), t)!,
                const Color(0xFF1C1B1B),
              ],
            ),
          ),
        );
      },
    );
  }
}

class HomeProductRowShimmer extends StatelessWidget {
  const HomeProductRowShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 280,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 2),
        itemCount: 4,
        separatorBuilder: (_, __) => const SizedBox(width: 12),
        itemBuilder: (_, __) => const SizedBox(
          width: 148,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(child: HomeShimmerBox(height: 200, borderRadius: 12)),
              SizedBox(height: 10),
              HomeShimmerBox(height: 10, width: 60, borderRadius: 4),
              SizedBox(height: 6),
              HomeShimmerBox(height: 12, width: 120, borderRadius: 4),
            ],
          ),
        ),
      ),
    );
  }
}

class HomeProductGridShimmer extends StatelessWidget {
  const HomeProductGridShimmer({super.key, this.crossAxisCount = 2});

  final int crossAxisCount;

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: crossAxisCount * 2,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        mainAxisSpacing: 16,
        crossAxisSpacing: 16,
        childAspectRatio: 0.62,
      ),
      itemBuilder: (_, __) => const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(child: HomeShimmerBox(height: 200, borderRadius: 12)),
          SizedBox(height: 10),
          HomeShimmerBox(height: 10, width: 50, borderRadius: 4),
          SizedBox(height: 6),
          HomeShimmerBox(height: 12, width: 100, borderRadius: 4),
        ],
      ),
    );
  }
}
