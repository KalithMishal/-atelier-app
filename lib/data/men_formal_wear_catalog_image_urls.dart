/// Men’s **formal wear** catalogue heroes — wired in `lib/dev/sample_products.dart` via `catalogImageUrl`.
///
/// Indices 0–4: Fashion Bug shirts (`Referer: https://fashionbug.lk/`). Index 4 is also used for the
/// Signature blazer card. NOLIMIT formal shirt uses [list] index 0 (category hero).
const kMenFormalWearCategoryHero =
    'https://fashionbug.lk/cdn/shop/files/020160100180LGR_MensShirt_FashionBugSriLanka_2_c013f2de-b659-4ecb-b4b6-1797a6e37eec_785x.jpg?v=1775888701';

abstract final class MenFormalWearCatalogImageUrls {
  static const list = <String>[
    kMenFormalWearCategoryHero,
    'https://fashionbug.lk/cdn/shop/files/020160100180DBL_MensShirt_FashionBugSriLanka_3_785x.jpg?v=1775888568',
    'https://fashionbug.lk/cdn/shop/files/020160100092WT_785x.webp?v=1771491127',
    'https://fashionbug.lk/cdn/shop/files/020160100089DBL_785x.webp?v=1770442595',
    'https://fashionbug.lk/cdn/shop/files/0201618018BLUCHK_MensShirt_FashionBugSriLanka_785x.jpg?v=1762864053',
  ];
}
