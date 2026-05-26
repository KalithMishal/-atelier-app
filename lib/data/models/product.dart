import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'product_color_variant.dart';

class Product {
  const Product({
    required this.id,
    required this.name,
    required this.brand,
    required this.categoryId,
    required this.price,
    required this.currency,
    required this.imageUrls,
    required this.description,
    required this.isFeatured,
    this.subCategoryId,
    this.colorVariants = const [],
    this.retailerUrl,
  });

  final String id;
  final String name;
  final String brand;
  final String categoryId;
  final num price;
  final String currency;
  final List<String> imageUrls;
  final String description;
  final bool isFeatured;
  final String? subCategoryId;
  final List<ProductColorVariant> colorVariants;
  final String? retailerUrl;

  String get primaryImageUrl {
    final g = galleryForColor(0);
    return g.isNotEmpty ? g.first : '';
  }

  /// Product-level [imageUrls] first, then color-variant shots (deduped). Avoids
  /// mismatched hero vs thumbnails when Firestore has stale or wrong variant URLs.
  List<String> galleryForColor(int colorIndex) {
    final root = imageUrls;
    if (colorVariants.isEmpty) return List<String>.from(root);

    final idx = colorIndex.clamp(0, colorVariants.length - 1);
    final variant = colorVariants[idx].imageUrls;

    if (variant.isEmpty) return List<String>.from(root);
    if (root.isEmpty) return List<String>.from(variant);

    final seen = <String>{};
    final out = <String>[];
    for (final u in root) {
      if (u.isEmpty || seen.contains(u)) continue;
      seen.add(u);
      out.add(u);
    }
    for (final u in variant) {
      if (u.isEmpty || seen.contains(u)) continue;
      seen.add(u);
      out.add(u);
    }
    return out;
  }

  Color? colorAt(int index) {
    if (colorVariants.isEmpty || index < 0 || index >= colorVariants.length) return null;
    final hex = colorVariants[index].hex.replaceFirst('#', '');
    if (hex.length != 6) return null;
    final value = int.tryParse(hex, radix: 16);
    if (value == null) return null;
    return Color(0xFF000000 | value);
  }

  static num _readNum(dynamic value) {
    if (value == null) return 0;
    if (value is num) return value;
    if (value is String) return num.tryParse(value) ?? 0;
    return 0;
  }

  factory Product.fromDoc(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data() ?? const <String, dynamic>{};
    final colorsRaw = data['colors'];
    final variants = <ProductColorVariant>[];
    if (colorsRaw is Iterable) {
      for (final c in colorsRaw) {
        if (c is! Map) continue;
        final map = Map<String, dynamic>.from(c);
        variants.add(
          ProductColorVariant(
            name: (map['name'] ?? '').toString(),
            hex: (map['hex'] ?? '#111111').toString(),
            imageUrls: (map['imageUrls'] is Iterable)
                ? (map['imageUrls'] as Iterable).map((e) => e.toString()).where((u) => u.isNotEmpty).toList()
                : const <String>[],
          ),
        );
      }
    }

    final rootImages = (data['imageUrls'] is Iterable)
        ? (data['imageUrls'] as Iterable).map((e) => e.toString()).where((u) => u.isNotEmpty).toList()
        : const <String>[];

    return Product(
      id: doc.id,
      name: (data['name'] ?? '').toString(),
      brand: (data['brand'] ?? '').toString(),
      categoryId: (data['categoryId'] ?? '').toString(),
      price: _readNum(data['price']),
      currency: (data['currency'] ?? 'LKR').toString(),
      imageUrls: rootImages,
      description: (data['description'] ?? '').toString(),
      isFeatured: (data['isFeatured'] ?? false) == true,
      subCategoryId: data['subCategoryId']?.toString(),
      colorVariants: variants,
      retailerUrl: data['retailerUrl']?.toString(),
    );
  }
}
