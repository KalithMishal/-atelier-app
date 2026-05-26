import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';

import '../data/fashion_image_urls.dart';
import '../data/nolimit_cdn_product_image.dart';

/// Chrome-like UA — greencloudpos / NOLIMIT often 403 Dart’s default `Dart/<sdk>` client.
const _kProductImageUserAgent =
    'Mozilla/5.0 (Linux; Android 13; Mobile) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/121.0.0.0 Mobile Safari/537.36';

/// Product paths often contain `(1).jpg`. **Literal parentheses** break some mobile HTTP stacks
/// (and confuse Next’s optimizer) → decode/load failure → women’s slip-dress fallback.
String _encodeParensInFilename(String t) =>
    t.replaceAllMapped(RegExp(r'\((\d+)\)\.jpg'), (m) => '%28${m[1]}%29.jpg');

/// NOLIMIT `_next/image?url=…` — decode the inner CDN URL and load **origin** JPEG/WebP from
/// greencloudpos (with Referer). Skips the Next.js optimizer (AVIF + fragile query strings) and
/// fixes most “every tile shows the slip dress” failures for catalogue heroes.
String? _tryNolimitNextImageInnerUrl(String raw) {
  final u = Uri.tryParse(raw.trim());
  if (u == null) return null;
  if (!u.host.toLowerCase().endsWith('nolimit.lk')) return null;
  if (!u.path.contains('_next/image')) return null;
  final innerEncoded = u.queryParameters['url'];
  if (innerEncoded == null || innerEncoded.isEmpty) return null;
  try {
    final inner = Uri.decodeComponent(innerEncoded).trim();
    if (inner.startsWith('http')) return inner;
  } catch (_) {}
  return null;
}

/// Resolves NOLIMIT catalogue URLs for reliable loading on Android/iOS.
///
/// **AVIF:** `_next/image` varies on `Accept`; avif-first breaks many Flutter builds — see headers
/// below (JPEG/PNG preferred).
String _effectiveNetworkImageUrl(String raw) {
  final t = raw.trim();
  final inner = _tryNolimitNextImageInnerUrl(t);
  if (inner != null) {
    return _encodeParensInFilename(inner);
  }
  return _encodeParensInFilename(t);
}

/// Network product image with a local fallback when decode/load fails (common on web + some CDN URLs).
class ProductNetworkImage extends StatelessWidget {
  const ProductNetworkImage({
    super.key,
    required this.imageUrl,
    this.fit = BoxFit.cover,
    this.width,
    this.height,
    this.opacity = 1,
    this.fallbackAsset = 'assets/images/search_edit_quiet.png',
  });

  final String imageUrl;
  final BoxFit fit;
  final double? width;
  final double? height;
  final double opacity;
  final String fallbackAsset;

  static String fallbackAssetFor(String productId, String categoryId) {
    switch (productId) {
      case 'sample-gown':
        return 'assets/images/search_recent_gown.png';
      case 'sample-blouse':
        return 'assets/images/bag_item_shirt.png';
      case 'sample-trousers':
        return 'assets/images/search_edit_quiet.png';
      default:
        return fallbackForProduct(productId, categoryId);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (imageUrl.startsWith('assets/')) {
      return Image.asset(
        imageUrl,
        fit: fit,
        width: width,
        height: height,
        errorBuilder: (context, error, stackTrace) => _assetImage(),
      );
    }
    if (!imageUrl.startsWith('http')) {
      return _assetImage();
    }

    final resolvedUrl = _effectiveNetworkImageUrl(imageUrl);

    final headers = <String, String>{
      // Do not prefer AVIF — NOLIMIT `_next/image` then returns AVIF; Flutter often cannot decode
      // it on Android → errorWidget → women’s slip-dress placeholder for every tile.
      'Accept': 'image/jpeg,image/png,image/webp,image/apng,image/*,*/*;q=0.8',
      'User-Agent': _kProductImageUserAgent,
      'Accept-Language': 'en-US,en;q=0.9',
    };
    final lower = resolvedUrl.toLowerCase();
    if (nolimitCdnImageNeedsReferrer(resolvedUrl)) {
      headers['Referer'] = 'https://www.nolimit.lk/';
      headers['Origin'] = 'https://www.nolimit.lk';
    } else if (lower.contains('greencloudpos.com')) {
      headers['Referer'] = 'https://www.nolimit.lk/';
      headers['Origin'] = 'https://www.nolimit.lk';
    } else if (lower.contains('nolimit.lk')) {
      headers['Referer'] = 'https://www.nolimit.lk/';
      headers['Origin'] = 'https://www.nolimit.lk';
    } else if (lower.contains('emerald.lk')) {
      headers['Referer'] = 'https://emerald.lk/';
    } else if (lower.contains('fashionbug.lk')) {
      headers['Referer'] = 'https://fashionbug.lk/';
    } else if (lower.contains('shoes.lk')) {
      headers['Referer'] = 'https://shoes.lk/';
    } else if (lower.contains('nextluxury.com')) {
      headers['Referer'] = 'https://nextluxury.com/';
    } else if (lower.contains('mediadecathlon.com') || lower.contains('decathlon')) {
      headers['Referer'] = 'https://www.decathlon.com/';
    } else if (lower.contains('xcdn.next.co.uk') || lower.contains('next.co.uk')) {
      headers['Referer'] = 'https://www.next.co.uk/';
    }

    final loadingBox = Container(
      color: const Color(0xFF201F1F),
      alignment: Alignment.center,
      child: const SizedBox(
        width: 24,
        height: 24,
        child: CircularProgressIndicator(strokeWidth: 2, color: Color(0xFFB8963E)),
      ),
    );

    // Web + HtmlImage: CachedNetworkImage rejects custom httpHeaders; Image.network keeps Referer
    // hotlinks working for NOLIMIT / Emerald / greencloudpos.
    final Widget child = kIsWeb
        ? Image.network(
            resolvedUrl,
            fit: fit,
            width: width,
            height: height,
            headers: headers,
            loadingBuilder: (context, child, progress) {
              if (progress == null) return child;
              return loadingBox;
            },
            errorBuilder: (context, error, stackTrace) => _assetImage(),
          )
        : CachedNetworkImage(
            imageUrl: resolvedUrl,
            cacheKey: 'v7|$resolvedUrl',
            fit: fit,
            width: width,
            height: height,
            httpHeaders: headers,
            fadeInDuration: const Duration(milliseconds: 200),
            placeholder: (context, url) => loadingBox,
            errorWidget: (context, url, error) => _assetImage(),
          );

    if (opacity >= 1) return child;
    return Opacity(opacity: opacity, child: child);
  }

  Widget _assetImage() {
    return Image.asset(
      fallbackAsset,
      fit: fit,
      width: width,
      height: height,
      errorBuilder: (context, error, stackTrace) => const ColoredBox(color: Color(0xFF201F1F)),
    );
  }
}
