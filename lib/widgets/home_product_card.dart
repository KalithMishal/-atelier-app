import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../config/atelier_home_config.dart';
import '../data/fashion_image_urls.dart';
import '../data/models/product.dart';
import '../screens/product_detail_screen.dart';
import '../utils/price_format.dart';
import 'home_visual_image.dart';

/// Product tile used on the home grid and horizontal rows.
class HomeProductCard extends StatelessWidget {
  const HomeProductCard({
    super.key,
    required this.product,
    required this.titleColor,
    required this.cardBg,
    this.width,
    this.compact = false,
  });

  final Product product;
  final Color titleColor;
  final Color cardBg;
  final double? width;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.of(context).push(
        MaterialPageRoute(builder: (_) => ProductDetailScreen(product: product)),
      ),
      child: SizedBox(
        width: width,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AspectRatio(
              aspectRatio: 3 / 4,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: ColoredBox(
                  color: cardBg,
                  child: product.primaryImageUrl.isEmpty
                      ? const SizedBox.expand()
                      : HomeVisualImage(
                          visual: product.primaryImageUrl.startsWith('assets/')
                              ? HomeVisual.asset(product.primaryImageUrl)
                              : HomeVisual.network(product.primaryImageUrl),
                          fit: BoxFit.cover,
                          fallbackAsset: fallbackForProduct(product.id, product.categoryId),
                        ),
                ),
              ),
            ),
            SizedBox(height: compact ? 8 : 10),
            Text(
              product.name,
              style: GoogleFonts.manrope(
                fontSize: compact ? 12 : 13,
                height: 1.25,
                color: titleColor,
                fontWeight: FontWeight.w500,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 4),
            Text(
              formatPrice(product.price, currency: product.currency),
              style: GoogleFonts.manrope(
                fontSize: compact ? 12 : 13,
                fontWeight: FontWeight.w700,
                color: titleColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
