/// Hero image URLs for **Kids → Boys** (NOLIMIT / greencloudpos), wired in
/// `lib/dev/sample_products.dart` via [catalogImageUrl].
///
/// Prefer direct `cdn.greencloudpos.com` URLs — see `ProductNetworkImage` / women casual notes.
abstract final class KidsBoysCatalogImageUrls {
  static const list = <String>[
    // Bundled hero — some devices/blocks still fail greencloudpos hotlinks; the UI then showed
    // `search_edit_quiet.png` (dark green “board” placeholder). CDN mirror of this file:
    // https://cdn.greencloudpos.com/nolimit.lk/product/NOLIMITURBANWEARKidsBoysCrewNeckShortSleeveOversizedT-ShirtBrownBrown%C3%A2%E2%82%AC%C2%A22-3YRS-1-1775629331802-DSC04725.jpg?width=600
    'assets/images/kids_boys_oversized_tee_brown_category.jpg',
  ];
}
