import 'package:flutter/material.dart';

import '../data/models/product.dart';
import '../screens/category_landing_screen.dart';

/// Firestore [Product.categoryId] values.
abstract final class ShopCategoryId {
  static const men = 'men';
  static const women = 'women';
  static const children = 'children';
  static const accessories = 'accessories';
}

/// Home grid chip index → category filter.
List<Product> filterProductsByChip(List<Product> products, int chipIndex) {
  switch (chipIndex) {
    case 0:
      return products;
    case 1:
      final featured = products.where((p) => p.isFeatured).toList();
      return featured.isNotEmpty ? featured : products;
    case 2:
      return products.where((p) => p.categoryId == ShopCategoryId.men).toList();
    case 3:
      return products.where((p) => p.categoryId == ShopCategoryId.women).toList();
    case 4:
      return products.where((p) => p.categoryId == ShopCategoryId.children).toList();
    case 5:
      return products.where((p) => p.categoryId == ShopCategoryId.accessories).toList();
    default:
      return products;
  }
}

String categoryLabel(String categoryId) => switch (categoryId) {
      ShopCategoryId.men => 'Men',
      ShopCategoryId.women => 'Women',
      ShopCategoryId.children => 'Kids',
      ShopCategoryId.accessories => 'Accessories',
      _ => 'Fashion',
    };

/// Opens Men / Women / Kids / Accessories landing with subcategory grid.
void openDepartmentLanding(BuildContext context, String departmentId) {
  Navigator.of(context).push(
    MaterialPageRoute(builder: (_) => CategoryLandingScreen(departmentId: departmentId)),
  );
}

bool _hasWord(String haystack, String word) =>
    RegExp(r'\b' + RegExp.escape(word) + r'\b', caseSensitive: false).hasMatch(haystack);

String? effectiveSubCategoryId(Product product) {
  final id = product.subCategoryId?.trim();
  if (id != null && id.isNotEmpty) {
    return id;
  }

  final n = '${product.name} ${product.description}'.toLowerCase();
  final cat = product.categoryId;

  if (cat == ShopCategoryId.men) {
    // Former sport / basics / swim tiles — fold heuristics into Casual Wear.
    if (RegExp(r'\btrunks?\b', caseSensitive: false).hasMatch(n) ||
        n.contains('innerwear') ||
        n.contains('underwear') ||
        n.contains('undershirt') ||
        RegExp(r'\bboxers?\b', caseSensitive: false).hasMatch(n) ||
        RegExp(r'\bbriefs?\b', caseSensitive: false).hasMatch(n) ||
        _hasWord(n, 'crew') ||
        n.contains('crew neck')) {
      return 'casual-wear';
    }
    if (n.contains('polo') || n.contains('chino') || n.contains('denim') || n.contains('linen') || n.contains('cargo')) {
      return 'casual-wear';
    }
    if (n.contains('formal') || n.contains('blazer') || n.contains('shirt') || n.contains('trouser')) {
      return 'formal-wear';
    }
    if (n.contains('jogger') || n.contains('training') || n.contains('sport')) return 'casual-wear';
    if (n.contains('swim') || n.contains('beach')) return 'casual-wear';
    if (n.contains('belt') || n.contains('cap')) return 'accessories';
  }
  if (cat == ShopCategoryId.women) {
    if (n.contains('saree')) return 'saree';
    // Removed tiles: ethnic-wear, swim-beachwear — fold matching copy into Casual Wear.
    if (n.contains('ethnic') || n.contains('swim') || n.contains('beach') || n.contains('kaftan')) {
      return 'casual-wear';
    }
    // Removed subcategories (lingerie, nightwear, sportswear, women’s accessories tile) —
    // fold legacy copy into Casual Wear so listings stay reachable.
    if (n.contains('pyjama') ||
        n.contains('night') ||
        n.contains('lingerie') ||
        n.contains('bralette') ||
        n.contains('brief') ||
        n.contains('legging') ||
        n.contains('sport') ||
        n.contains('scarf') ||
        n.contains('clutch')) {
      return 'casual-wear';
    }
    if (n.contains('blazer') || n.contains('blouse') || n.contains('skirt') || n.contains('formal')) {
      return 'formal-wear';
    }
    if (n.contains('dress') || n.contains('denim') || n.contains('top')) return 'casual-wear';
  }
  if (cat == ShopCategoryId.children) {
    if (n.contains('boy')) return 'boys';
    if (n.contains('girl') || n.contains('frock')) return 'girls';
    if (n.contains('toy') || n.contains('plush') || n.contains('block')) return 'toys';
    if (n.contains('backpack') || n.contains('back pack') || n.contains('daypack')) return 'back-packs';
    if (n.contains('sandal') || n.contains('shoe') || n.contains('footwear')) return 'footwear';
    if (n.contains('sock') || n.contains('track')) return 'sportswear';
    if (n.contains('cap') || n.contains('sunglass')) return 'accessories';
  }
  if (cat == ShopCategoryId.accessories) {
    if (n.contains('watch')) return 'watches';
    if (n.contains('belt')) return 'belts';
    if (n.contains('tote') || n.contains('bag') || n.contains('crossbody')) return 'bags';
    if (n.contains('chain') || n.contains('earring') || n.contains('jewelry')) return 'jewelry';
  }
  return null;
}

List<Product> filterProductsForListing(
  List<Product> products, {
  String? categoryId,
  String? subCategoryId,
}) {
  var list = products;
  if (categoryId != null && categoryId.isNotEmpty) {
    list = list.where((p) => p.categoryId == categoryId).toList();
  }
  if (subCategoryId != null && subCategoryId.isNotEmpty) {
    list = list.where((p) => effectiveSubCategoryId(p) == subCategoryId).toList();
  }
  return list;
}
