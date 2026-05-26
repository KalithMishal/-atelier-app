import '../dev/sample_products.dart';
import 'models/product.dart';
import 'models/product_color_variant.dart';

/// In-app catalogue used when Firestore is empty or seed has not run yet.
abstract final class LocalCatalogue {
  /// Product ids defined in [sampleProductDocs] — keep bundled heroes when merging Firestore.
  static Set<String> get seededProductIds =>
      {for (final d in sampleProductDocs) d['id'] as String};

  /// Legacy demo rows (often wrong image vs title) still sitting in Firestore — hide by exact name.
  static const Set<String> removedCatalogueProductNames = {
    'Gold Jewelry Selection',
    'Structured Calfskin Tote',
  };

  /// Bundled catalogue no longer includes these; drop matching Firestore docs on merge so stale
  /// products do not reappear (e.g. after removing a SKU from [sampleProductDocs]).
  static const Set<String> removedCatalogueProductIds = {
    'tom-david-oversized-tee-white',
    'nolimit-super-slim-casual-pant-beige',
    'nolimit-casual-trouser-steel',
    'odel-formal-trouser',
    'fashionbug-formel-trouser-su3139',
    'fashionbug-formel-trouser-s4u3087',
    'fossil-everett-quartz-steel-watch',
    'fossil-grant-chrono-leather-watch',
    'fossil-everett-chrono-steel-watch',
    'nolimit-fossil-machine-chrono-black-steel',
    'nolimit-deedat-hyper-slipper-gray',
    'nolimit-leather-belt',
    'pepper-cap',
    'shoes-lk-mens-lifestyle-84',
    'shoes-lk-mens-lifestyle-75',
    'shoes-lk-mens-slides-126',
    'odel-men-silk-tie',
    'nolimit-men-wallet',
    'signature-men-cufflinks',
    'kin-street-tee',
    'nolimit-joggers',
    'pepper-crew',
    'nolimit-trunks',
    'nolimit-swim-shorts',
    'odel-beach-shirt',
    'nolimit-men-swimming-goggles-black',
    'decathlon-men-surfing-uv-top-olaian',
    'next-men-wetsuit-long-sleeve',
    'cotton-men-oxford-shirt',
    'ekko-tailored-shirt',
    'nolimit-men-training-shorts',
    'kin-men-track-jacket',
    'cotton-men-hoodie',
    'nolimit-men-tank-2pack',
    'cotton-men-socks-5pack',
    'pepper-men-thermal-vest',
    'nolimit-men-rashguard',
    'odel-men-pool-slides',
    'cotton-men-linen-shorts',
    'odel-kandyan-saree',
    'nolimit-soft-silk-saree',
    'cotton-block-print-saree',
    'nolimit-w-pleated-saree',
    'odel-w-border-saree',
    'nolimit-womens-pattu-saree-green-gold',
    'nolimit-womens-georgette-saree-assorted',
    'nolimit-womens-batik-cotton-saree-assorted-a',
    'nolimit-womens-batik-cotton-saree-assorted-b',
    'nolimit-womens-batik-cotton-saree-assorted-c',
    // Women — removed subcategories (lingerie, nightwear, sportswear, women’s accessories)
    'nolimit-bralette-set',
    'odel-seamless-pack',
    'cotton-pyjama-set',
    'odel-nightdress',
    'nolimit-leggings',
    'kin-sports-top',
    'odel-scarf',
    'signature-clutch',
    'cotton-w-brief-pack',
    'signature-w-camisole',
    'pepper-w-lounge-bra',
    'nolimit-w-robe',
    'cotton-w-lounge-set',
    'odel-w-satin-robe',
    'nolimit-w-leggings',
    'kin-w-sports-bra',
    'cotton-w-zip-hoodie-w',
    'nolimit-w-tote-small',
    'odel-w-silk-scarf',
    'signature-w-bangle-set',
    // Women — removed Ethnic Wear & Swim & Beachwear tiles
    'cotton-ethnic-top',
    'nolimit-one-piece',
    'odel-cover-up',
    'nolimit-w-salwar-set',
    'odel-w-dupatta',
    'cotton-w-kurta',
    'nolimit-w-swim-cover',
    'cotton-w-onepiece',
    'odel-wide-brim-sun-hat',
    // Women — NOLIMIT casual catalogue heroes (removed)
    'nolimit-fiamaria-notch-neck-tunic-navy',
    'nolimit-fiamaria-notch-neck-tunic-beige',
    'nolimit-haj-modest-casual-dress-wine',
    'nolimit-offbeat-impressions-printed-dress-navy',
    // Women — Casual Wear (cleared seed grid)
    'cotton-wrap-dress',
    'odel-denim-jacket-w',
    'nolimit-casual-top',
    'nolimit-w-culottes',
    'cotton-w-knit-top',
    // Women — Casual Wear (NOLIMIT _next/image SKUs removed)
    'nolimit-fiamaria-notch-neck-casual-dress-navy',
    'nolimit-fiamaria-notch-neck-casual-dress-beige',
    'nolimit-modest-shirt-collar-printed-casual-dress-navy',
    'nolimit-deedat-womens-high-neck-tee-light-blue',
    'nolimit-floral-affair-w-printed-casual-dress-multi',
    // Kids — Boys (removed placeholder / wrong-hero SKUs)
    'nolimit-kids-tee',
    'nolimit-boys-shorts',
    'force-boys-sport-bottom-black',
    'odel-boys-shirt',
    'nolimit-boys-polo',
    'nolimit-kids-boys-pant-dusty-olive',
    'cotton-boys-shorts',
    // Kids — Girls (removed mismatched / placeholder-hero SKUs)
    'kin-kids-hoodie',
    'nolimit-girls-frock',
    'odel-girls-leggings',
    'nolimit-girls-skirt',
    'cotton-girls-cardigan',
    // Kids — Toys / bags / accessories / sport / footwear (removed bad Pexels heroes)
    'odel-plush-bear',
    'nolimit-blocks-set',
    'nolimit-school-bag',
    'odel-mini-backpack',
    'nolimit-kids-cap',
    'odel-kids-sunglasses',
    'nolimit-kids-tracksuit',
    'odel-sports-socks',
    'nolimit-school-shoes',
    'odel-kids-sandals',
    'nolimit-plush-bear',
    'odel-building-blocks',
    'cotton-puzzle-mat',
    'nolimit-kids-backpack-s',
    'odel-kids-backpack-m',
    'cotton-kids-gym-bag',
    'odel-kids-hair-clips',
    'cotton-kids-bow',
    'nolimit-kids-track-pants',
    'cotton-kids-tee-pack',
    'kin-kids-windbreaker',
    'nolimit-kids-runners',
    'odel-kids-boots',
    'cotton-kids-slippers',
    // Women — Casual / formal seed SKUs (removed wrong-hero / legacy demo)
    'nolimit-haj-modest-w-printed-casual-dress-beige',
    'signature-blouse',
    'odel-blazer-w',
    'cotton-pencil-skirt',
    'nolimit-w-pumps',
    'signature-w-silk-shell',
    'sample-gown',
    'sample-blouse',
    // Old USD accessories demos (wrong heroes / mismatched labels)
    'gold-jewelry-selection',
    'structured-calfskin-tote',
  };

  static bool shouldHideFromCatalogue(Product p) {
    if (removedCatalogueProductIds.contains(p.id)) return true;
    if (removedCatalogueProductNames.contains(p.name.trim())) return true;
    return false;
  }

  /// Always rebuilt from [sampleProductDocs] so image paths / SKUs never stay stale after hot
  /// reload (a cached list was forcing old `https://` heroes → broken tiles on web).
  static List<Product> get products => sampleProductDocs.map(productFromSeedMap).toList();

  static List<Product> featured() =>
      products.where((p) => p.isFeatured).toList();

  static Product? productById(String id) {
    for (final p in products) {
      if (p.id == id) return p;
    }
    return null;
  }
}

Product productFromSeedMap(Map<String, dynamic> doc) {
  final colorsRaw = doc['colors'];
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

  final rootImages = (doc['imageUrls'] is Iterable)
      ? (doc['imageUrls'] as Iterable).map((e) => e.toString()).where((u) => u.isNotEmpty).toList()
      : const <String>[];

  return Product(
    id: doc['id'] as String,
    name: (doc['name'] ?? '').toString(),
    brand: (doc['brand'] ?? '').toString(),
    categoryId: (doc['categoryId'] ?? '').toString(),
    price: (doc['price'] ?? 0) as num,
    currency: (doc['currency'] ?? 'LKR').toString(),
    imageUrls: rootImages,
    description: (doc['description'] ?? '').toString(),
    isFeatured: (doc['isFeatured'] ?? false) == true,
    subCategoryId: doc['subCategoryId']?.toString(),
    colorVariants: variants,
    retailerUrl: doc['retailerUrl']?.toString(),
  );
}
