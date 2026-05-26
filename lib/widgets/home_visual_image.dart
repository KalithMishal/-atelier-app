import 'package:flutter/material.dart';

import '../config/atelier_home_config.dart';
import 'product_network_image.dart';

/// Shows a [HomeVisual] — local asset first (reliable), or network URL.
class HomeVisualImage extends StatelessWidget {
  const HomeVisualImage({
    super.key,
    required this.visual,
    this.fit = BoxFit.cover,
    this.width,
    this.height,
    this.fallbackAsset = 'assets/images/search_edit_quiet.png',
  });

  final HomeVisual visual;
  final BoxFit fit;
  final double? width;
  final double? height;
  final String fallbackAsset;

  /// Local bundle path from [HomeVisual.asset], or from [HomeVisual.network] when the URL is
  /// actually `assets/...` (must not go through [ProductNetworkImage] / network stack on web).
  String? _localAssetPath() {
    if (visual.isAsset) return visual.assetPath;
    final u = visual.networkUrl;
    if (u != null && u.isNotEmpty && u.startsWith('assets/')) return u;
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final localPath = _localAssetPath();
    if (localPath != null) {
      return Image.asset(
        localPath,
        fit: fit,
        width: width,
        height: height,
        errorBuilder: (context, error, stackTrace) => Image.asset(
          fallbackAsset,
          fit: fit,
          width: width,
          height: height,
          errorBuilder: (context, error, stackTrace) => const ColoredBox(color: Color(0xFF201F1F)),
        ),
      );
    }

    final url = visual.networkUrl;
    if (url == null || url.isEmpty) {
      return Image.asset(
        fallbackAsset,
        fit: fit,
        width: width,
        height: height,
        errorBuilder: (context, error, stackTrace) => const ColoredBox(color: Color(0xFF201F1F)),
      );
    }

    return ProductNetworkImage(
      imageUrl: url,
      fit: fit,
      width: width,
      height: height,
      fallbackAsset: fallbackAsset,
    );
  }
}
